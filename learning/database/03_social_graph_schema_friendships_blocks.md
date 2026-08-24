# Database Chapter 03: Social Graph & Friendship Follow Automations

This module explores the design of Pookiz's social graph database layer, detailing the `friends`, `follows`, and `blocks` schemas, Row Level Security guidelines, and the PL/pgSQL triggers that synchronize social interactions.

---

## 1. Objective & Placement Value
- **Why this is asked:** Social networks rely heavily on graph relationships. In an interview, you must demonstrate how to efficiently model bidirectional relationships (like friendships), directional links (like followers), and blocking lists while ensuring database integrity and preventing race conditions or duplicate rows.
- **Placement Value:** Validates systems design fluency for large social graphs. Prepares you to build scalable follow/feed architectures.

---

## 2. The Layman's Analogy
Think of the campus social network as a **physical student directory board**:
- **Friend requests (A handshake invitation):** When you ask someone to be your friend, you write down both names on a card and mark the status as "pending". They must sign it to change the status to "accepted".
- **Auto-Following (Synchronized newsletter subscriptions):** In the physical world, when two people accept a friendship handshake, they also want to automatically subscribe to each other's updates (blogs/stories). Rather than making them sign separate subscription forms, the directory board has a magic clerk (**the trigger**) who instantly creates reciprocal subscription cards (**follows**) for both users the second the friendship card is signed.
- **Blocking (The invisible screen):** If you write down a block card against another student, the campus post office automatically intercepts any letters between you, and you both disappear from each other's campus directories.

---

## 3. The Technical Specification

### A. Friendship and Follower Relationship Modeling
- **Friendships (Bidirectional, Symmectric):** Modeled in a single row inside the `friends` table where `user_id_1` and `user_id_2` represent the two users. To enforce consistency:
  - Enforce `user_id_1 < user_id_2` in client queries (or sorting) to prevent duplicate inverse relationships (e.g., storing both `(A, B)` and `(B, A)` as separate pending entries).
  - Use composite unique constraints: `UNIQUE(user_id_1, user_id_2)`.
- **Followers (Directional, Asymmetric):** Modeled in the `follows` table. If User A follows User B, we insert a single row: `follower_id = A, following_id = B`. 

### B. Auto-Follow Logic using Database Triggers
Rather than managing follow states through multiple API calls on the server (which could fail mid-execution and leave states inconsistent), Pookiz handles this on the database layer:
1. When a friendship record status updates to `accepted`, a database trigger fires.
2. The trigger automatically inserts two reciprocal rows into the `follows` table:
   - `(user_id_1, user_id_2)`
   - `(user_id_2, user_id_1)`
3. If the friendship is deleted (unfriended), the trigger cleans up the follows by deleting both rows.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the database trigger logic from [`d:\Pookiz\supabase\spill_the_tea_follow_system.sql`](file:///d:/Pookiz/supabase/spill_the_tea_follow_system.sql):

```sql
CREATE OR REPLACE FUNCTION public.handle_follows_from_friendship()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
```
- **Line 77:** Creates or updates the PL/pgSQL function named `handle_follows_from_friendship`.
- **Line 78:** Declares this as a trigger function returning type `TRIGGER`.
- **Line 79:** Sets `SECURITY DEFINER` so the function executes with administrative privileges, bypassing RLS to insert follow rows regardless of user permissions.
- **Line 80:** Hardens the execution context by setting `search_path = public` to prevent schema hijack attacks.

```sql
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    IF NEW.status = 'accepted' THEN
      -- Insert reciprocal follows if they do not exist
      INSERT INTO public.follows (follower_id, following_id)
      VALUES (NEW.user_id_1, NEW.user_id_2)
      ON CONFLICT (follower_id, following_id) DO NOTHING;

      INSERT INTO public.follows (follower_id, following_id)
      VALUES (NEW.user_id_2, NEW.user_id_1)
      ON CONFLICT (follower_id, following_id) DO NOTHING;
    END IF;
    RETURN NEW;
```
- **Line 83:** Inspects the special variable `TG_OP` (Trigger Operation). If the database operation is an `INSERT` or `UPDATE` on `friends`:
- **Line 84:** Checks if the friendship status is now `accepted`.
- **Line 86-88:** Inserts the first follow link. `ON CONFLICT (follower_id, following_id) DO NOTHING` prevents transaction failure if the follow already exists.
- **Line 90-92:** Inserts the reciprocal follow link.
- **Line 94:** Returns the `NEW` record state to allow the write to proceed.

```sql
  ELSIF TG_OP = 'DELETE' THEN
    -- Clean up follows if friendship is deleted/unfriended
    DELETE FROM public.follows
    WHERE (follower_id = OLD.user_id_1 AND following_id = OLD.user_id_2)
       OR (follower_id = OLD.user_id_2 AND following_id = OLD.user_id_1);
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
```
- **Line 95:** If the trigger operation is a `DELETE` (unfriended):
- **Line 97-99:** Purges both matching follow records from the `follows` table to clean up the graph.
- **Line 100:** Returns the `OLD` record state to complete the delete transaction.

---

## 5. Edge Cases & Optimizations
- **Recursive Trigger Loops:** If Table A's insert trigger inserts into Table B, and Table B has an insert trigger that inserts back into Table A, you create an infinite loop. We prevent this by restricting the trigger on `friends` to write strictly to `follows`, which has no triggers pointing back to `friends`.
- **Duplicate Handshakes:** If user IDs are not sorted before insert, we could end up with `(UserA, UserB)` and `(UserB, UserA)` as two separate pending records. 
  - *Fix:* Ensure client queries or API routes sort IDs (e.g., `user_id_1 = Math.min(A, B)` and `user_id_2 = Math.max(A, B)`) before inserting friendship rows.

---

## 6. Staff Engineer Viva Board

### Q1: Why did you choose to implement the mutual follow logic as a database trigger rather than inside the Next.js API route?
**Answer:**
*"Relational integrity must be enforced on the database layer. If we handled the follow inserts inside the API route:
1. It would require three separate database requests over the network: updating the friendship status, inserting Follower A, and inserting Follower B.
2. If the API container crashed midway, or if a database connection error occurred during the second write, the friendship would be accepted but the users would not follow each other, leaving the system in an inconsistent state.
By handling this inside an atomic PL/pgSQL database trigger, we guarantee that all three database writes succeed together or roll back together, preventing data discrepancies."*

### Q2: What is the purpose of `ON CONFLICT (follower_id, following_id) DO NOTHING` inside the follow trigger?
**Answer:**
*"This handles situations where a user has already manually followed another user before sending a friend request. If User A already followed User B, and then their friendship is accepted, the trigger will attempt to insert `(UserA, UserB)` into the `follows` table. 

Because the `follows` table has a unique constraint on `(follower_id, following_id)`, the raw insert would fail with a unique constraint violation, rolling back the entire friendship transaction. Adding `ON CONFLICT ... DO NOTHING` allows the engine to skip the insert safely if it already exists, avoiding transaction failures."*

### Q3: How does the database handle blocking? Explain the query performance implications when filtering out blocked users' posts.
**Answer:**
*"The database houses a `blocks` table with `blocker_id` and `blocked_id` columns. To prevent blocked users' posts from displaying in the feed, we must filter them out in SQL queries:
```sql
SELECT * FROM tea_posts 
WHERE author_id NOT IN (
  SELECT blocked_id FROM blocks WHERE blocker_id = :current_user_id
)
```
The performance implication is that a subquery lookup is run. If a user blocks many profiles, the `NOT IN` subquery list grows. To optimize this:
1. We index the `blocker_id` column in the `blocks` table.
2. We rewrite the query to use a `LEFT JOIN` or `NOT EXISTS` check, which allows the optimizer to perform an index-nested loop instead of a full table scan."*

### Q4: Explain the difference between `NEW` and `OLD` records inside a PL/pgSQL trigger function.
**Answer:**
*"Inside a PL/pgSQL trigger function, `NEW` and `OLD` are special variables of type `RECORD`:
- `NEW` contains the updated state of the row for `INSERT` and `UPDATE` operations. For `DELETE` operations, `NEW` is null.
- `OLD` contains the previous state of the row before the query executed for `UPDATE` and `DELETE` operations. For `INSERT` operations, `OLD` is null.
We check these variables to inspect state changes (such as verifying if a status transitioned from 'pending' to 'accepted')."*

### Q5: What is the danger of using `AFTER` triggers versus `BEFORE` triggers, and when should you use each?
**Answer:**
*"The main difference is when they run relative to disk writes:
- **`BEFORE` triggers** run before the database writes the changes to disk. They can modify the `NEW` record inline. We use them for validation and setting default values. The danger is that if a `BEFORE` trigger performs heavy operations, it blocks the write lock, increasing transaction time.
- **`AFTER` triggers** run after the changes have been written to disk. They cannot modify the row. We use them for cascading writes to other tables. The danger is that if an `AFTER` trigger fails, the main transaction is still rolled back, meaning we paid the I/O cost of writing to disk only to discard it."*
