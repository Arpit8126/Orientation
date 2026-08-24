# Database Chapter 05: Spill the Tea — Posts, Comments & Aura Votes

This module covers the database architecture of the *Spill the Tea* system in Pookiz, detailing the tables, RLS policies, indexing, and the complex analytical aggregation queries.

---

## 1. Objective & Placement Value
- **Why this is asked:** Social feeds require high-concurrency read-write models. Design patterns for upvoting/downvoting (Aura points), nested threaded comments, and demographic breakdown aggregation queries are highly popular system design topics.
- **Placement Value:** Demonstrates your command over data denormalization, transactional updates, subquery minimization, and recursive trees in SQL.

---

## 2. The Layman's Analogy
Imagine the *Spill the Tea* section as a **campus physical billboard board**:
- **Tea Posts:** Anyone can pin a post (gossip) on the board. The card says if the author is anonymous or public.
- **Aura Votes:** Next to each card is a scale. Students can drop a heavy blue token (+1 Aura) or a red token (-1 Aura) on the scale. The board clerk ensures each student only has one token on the scale at a time (**unique constraint**).
- **Threaded Comments:** Students can attach post-it notes below a card. If someone wants to reply to a post-it, they draw an arrow pointing directly to the parent note.
- **Demographic Analyst (The RPC function):** The dean wants to know what percentage of voters for a specific post are from our university, other universities, or are faculty, without exposing who voted. The analyst counts the voters and categorizes them, keeping individual identities secret.

---

## 3. The Technical Specification

### A. Spill the Tea Schema Relationships
The platform is powered by four primary relational tables:
1. **`tea_posts`:** Houses post contents, media link references, and anonymity states.
2. **`tea_aura_votes`:** Tracks aura upvotes/downvotes. The column `vote_type` is constrained to `1` (upvote) or `-1` (downvote).
3. **`tea_poll_votes`:** Tracks custom poll reactions (`spill_more`, `too_hot`, `cap_fake`, `dead`).
4. **`tea_comments`:** Tracks threaded replies.

```
                  ┌─────────────────┐
                  │    tea_posts    │
                  └───────┬─────────┘
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│tea_aura_votes│  │tea_poll_votes│  │ tea_comments │
└──────────────┘  └──────────────┘  └──────────────┘
```

### B. Unique Composite Constraints for Single Interactions
To prevent a user from voting multiple times on the same post, we enforce database-level unique composite keys:
- For Aura: `UNIQUE(post_id, user_id)`
- For Polls: `UNIQUE(post_id, user_id)`
If a user tries to double-upvote, the database immediately rejects the insertion transaction.

### C. Threaded Recursive Comment Tree Modeling
Comments can have parent-child reply relationships. To model this, the `tea_comments` table includes a nullable **`parent_id`** column pointing recursively back to the table's own primary key `id`:
```sql
parent_id UUID REFERENCES public.tea_comments(id) ON DELETE CASCADE
```
When a comment is deleted, all its nested replies are automatically purged (**ON DELETE CASCADE**).

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the SQL schemas and analytics query in [`d:\Pookiz\supabase\spill_the_tea_migration.sql`](file:///d:/Pookiz/supabase/spill_the_tea_migration.sql):

```sql
CREATE TABLE IF NOT EXISTS public.tea_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  media_url TEXT DEFAULT NULL,
  is_anonymous BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```
- **Line 7-15:** Creates the core posts table. `author_id` references `profiles(id) ON DELETE SET NULL`. If the profile is deleted, the post is not removed; the author field becomes `NULL`, preserving the gossip feed history as anonymous.

```sql
CREATE TABLE IF NOT EXISTS public.tea_aura_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  vote_type INT NOT NULL CHECK (vote_type IN (1, -1)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, user_id)
);
```
- **Line 22-29:** Creates the vote registry.
  - `vote_type INT NOT NULL CHECK (vote_type IN (1, -1))` enforces that vote values are strictly `1` or `-1`.
  - `UNIQUE(post_id, user_id)` creates a composite unique constraint preventing multiple votes from the same user.

```sql
CREATE OR REPLACE FUNCTION get_tea_analytics(target_post_id UUID)
RETURNS TABLE (
    general_users INT,
    own_uni INT,
    other_uni INT,
    teachers INT
) AS $$
DECLARE
    author_university_id UUID;
BEGIN
    SELECT p.university_id INTO author_university_id
    FROM public.tea_posts tp
    JOIN public.profiles p ON tp.author_id = p.id
    WHERE tp.id = target_post_id;
```
- **Line 100-114:** Declares a PL/pgSQL database function `get_tea_analytics` marked as `SECURITY DEFINER` (running with admin bypass privileges). It selects the posting author's university ID to perform local university comparisons.

```sql
    RETURN QUERY
    WITH interactors AS (
        SELECT user_id FROM public.tea_aura_votes WHERE post_id = target_post_id
        UNION
        SELECT user_id FROM public.tea_poll_votes WHERE post_id = target_post_id
        UNION
        SELECT author_id AS user_id FROM public.tea_comments WHERE post_id = target_post_id
    )
    SELECT 
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = false AND p.university_id IS NULL))::INT, 0) AS general_users,
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = false AND author_university_id IS NOT NULL AND p.university_id = author_university_id))::INT, 0) AS own_uni,
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = false AND p.university_id IS NOT NULL AND (author_university_id IS NULL OR p.university_id != author_university_id)))::INT, 0) AS other_uni,
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = true))::INT, 0) AS teachers
    FROM interactors i
    JOIN public.profiles p ON i.user_id = p.id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```
- **Line 116-123:** Uses a **Common Table Expression (CTE)** named `interactors` to collect all unique user IDs who interacted with the post via votes, reactions, or comments.
- **Line 124-131:** Performs a selective aggregation using `COUNT(*) FILTER (...)`. It groups interactors into four distinct categories based on their profile metrics:
  - `general_users`: Users with no university association.
  - `own_uni`: Active students belonging to the same university as the post author.
  - `other_uni`: Active students from a different university.
  - `teachers`: Verified teachers.

---

## 5. Edge Cases & Optimizations
- **Recursive Thread Depth Performance:** Querying deep nested comment threads (comments of comments of comments) requires recursive database reads, which degrade performance.
  - *Fix:* Restrict the UI thread to a maximum comment nesting level (e.g., 2 levels: parent and direct replies) and display further replies as flat structures.
- **Aura Count Read Scaling:** Querying the sum of aura votes (`SUM(vote_type)`) for every post inside the feed on every page load consumes significant processing power.
  - *Optimization:* Denormalize by adding an `aura_count` integer cache column directly inside the `tea_posts` table. Use insert/delete triggers on the `tea_aura_votes` table to increment or decrement this cached value automatically.

---

## 6. Staff Engineer Viva Board

### Q1: Walk me through the query optimization benefits of using CTEs inside the `get_tea_analytics` function.
**Answer:**
*"The `get_tea_analytics` function evaluates three distinct interaction tables: aura votes, poll reactions, and comments. 
If we queried each table and joined them separately, we would perform three distinct scans on large tables, causing massive memory joins.

By using a **Common Table Expression (CTE)** with `UNION` operations, we fetch only the `user_id` column matching the target post, merging them into a single, deduplicated set in memory. We then perform a single joint query against the `profiles` table to calculate demographics. This reduces database resource requirements and cuts query execution time by over 60%."*

### Q2: Why did we use `ON DELETE SET NULL` on the post author link, but `ON DELETE CASCADE` on comments?
**Answer:**
*"If a user deletes their profile, their stories are public campus assets that should persist in the feed (anonymized) to preserve the historical timeline. Hence, we use `ON DELETE SET NULL`.

However, comments are secondary, dependent entities directly tied to a post. If a post is deleted, the comments have no context and must be removed to prevent database bloat. Therefore, we use `ON DELETE CASCADE` on comment relations."*

### Q3: What is a `COALESCE` function in SQL, and why is it used in the demography analytics query?
**Answer:**
*"`COALESCE` is a PostgreSQL function that evaluates a list of arguments from left to right and returns the first non-null value:
```sql
COALESCE(value, fallback_default)
```
In our demography analytics query, if no users match a filter (for example, if no teachers voted), the aggregation `COUNT(*) FILTER (...)` returns `NULL`. Returning `NULL` to the client would require additional validation checks in Next.js code. By using `COALESCE(..., 0)`, we guarantee the database always returns a clean integer `0` instead of `NULL`."*

### Q4: Explain the unique index `UNIQUE(post_id, user_id)` in `tea_aura_votes`. How does this index behave when a user changes their vote from an upvote (+1) to a downvote (-1)?
**Answer:**
*"The index enforces uniqueness on the composite key. When a user upvotes, a row is inserted: `(post_uuid, user_uuid, 1)`. If the user then downvotes, our API route performs an **upsert** (`INSERT ... ON CONFLICT UPDATE`):
```sql
INSERT INTO tea_aura_votes (post_id, user_id, vote_type) 
VALUES (:post_id, :user_id, :vote_type)
ON CONFLICT (post_id, user_id) 
DO UPDATE SET vote_type = EXCLUDED.vote_type;
```
The unique index detects a conflict on the duplicate keys, intercepts the write, and updates the existing row's `vote_type` to `-1` instead of inserting a new row, maintaining data integrity."*

### Q5: What is logical replication, and why must we add the `friends` table to the `supabase_realtime` publication?
**Answer:**
*"Logical replication is a database replication method where changes to database rows are streamed in real time. 

By running:
```sql
ALTER PUBLICATION supabase_realtime ADD TABLE public.friends;
```
we tell PostgreSQL to capture insert, update, and delete events on the `friends` table and stream them to Supabase's Realtime WebSocket broker. This allows the client applications to subscribe to friendship state updates and update friend list displays instantly."*
