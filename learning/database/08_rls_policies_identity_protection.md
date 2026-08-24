# Database Chapter 08: Row Level Security (RLS) & Multi-Tenant Isolation

This module covers the architecture of Row Level Security (RLS) in Supabase and PostgreSQL, detailing how Pookiz isolates user profiles, DMs, groups, and quiz structures from unauthorized access.

---

## 1. Objective & Placement Value
- **Why this is asked:** In BaaS (Backend-as-a-Service) architectures, clients communicate directly with the database. Understanding how to configure secure, performant RLS policies is critical to preventing data leaks. Interviewers evaluate how you design policies, handle context verification (`auth.uid()`), and avoid recursion loops.
- **Placement Value:** Demonstrates your expertise in database-level authorization models, multi-tenant isolation, and secure SaaS architectures.

---

## 2. The Layman's Analogy
Think of the database as a **university apartment complex**:
- **Without RLS:** All apartment doors (tables) are unlocked. Anyone who walks into the building can open any door and read or take folders (records).
- **With RLS:** Every apartment door has a smart card lock. 
  - To open the door to "Apartment 101" (User A's profile or DMs), you must swipe your student ID. The lock checks if your ID matches the owner ID of the apartment (`auth.uid() = owner_id`).
  - To open a "Common Study Room" door (Group messages), the lock queries a list to verify if you are registered as a member of that study group.
  - If you aren't on the list, the door remains locked.

---

## 3. The Technical Specification

### A. RLS Policy Mechanics in Supabase
When a client sends an API request to Supabase, the request contains a JWT (JSON Web Token) signed by Supabase Auth:
1. **Request Verification:** The database receives the query, decrypts the JWT, and extracts session parameters:
   - `auth.uid()`: User ID UUID.
   - `auth.role()`: Connection role (e.g., `authenticated` or `anon`).
2. **Query Modification:** The engine rewrites the query, dynamically appending the policy's SQL expressions as additional `WHERE` filters.
3. **Write Verification:** For write operations, the `WITH CHECK` clause verifies that the new data being written conforms to the policy.

### B. Core RLS Policies in Pookiz

#### 1. Profiles Table Policies
- **Read:** Active profiles are viewable by anyone. Banned profiles are hidden from everyone except the profile owner and administrators.
- **Write:** Users can only insert or update their own profile:
  ```sql
  CREATE POLICY "Users can update own profile" 
    ON public.profiles FOR UPDATE 
    USING (id = (SELECT auth.uid())) 
    WITH CHECK (id = (SELECT auth.uid()));
  ```

#### 2. Messages Table Policies
- **Read:** Users can read a message only if:
  - It is a group message and they are a member of that group.
  - It is a DM where they are either the sender or the recipient.
- **Write:** Users can insert a message only if they are the sender AND they are a member of the target group (or the target recipient exists).

```sql
CREATE POLICY "Users can view group messages they belong to" 
  ON public.messages FOR SELECT TO authenticated USING (
    (group_id IS NOT NULL AND EXISTS (
      SELECT 1 FROM public.group_members
      WHERE group_id = messages.group_id
      AND user_id = (SELECT auth.uid())
      AND is_group_banned = false
    ))
    OR (recipient_id IS NOT NULL AND (
      sender_id = (SELECT auth.uid()) OR recipient_id = (SELECT auth.uid())
    ))
  );
```

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the RLS policies inside [`d:\Pookiz\supabase\migration.sql`](file:///d:/Pookiz/supabase/migration.sql):

```sql
-- Profiles Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view non-banned profiles" ON public.profiles FOR SELECT USING (is_banned = false OR id = (SELECT auth.uid()));
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (id = (SELECT auth.uid())) WITH CHECK (id = (SELECT auth.uid()));
```
- **Line 143:** Enables RLS on the `profiles` table.
- **Line 144:** Allows anyone to view active profiles (`is_banned = false`). It includes `OR id = auth.uid()` so a banned user can still view their own profile.
- **Line 145:** Restricts updates to the matching owner. `WITH CHECK` prevents users from updating the `id` column to hijack another profile.

```sql
-- Group Members Security
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view group memberships" ON public.group_members FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can join groups" ON public.group_members FOR INSERT TO authenticated WITH CHECK (user_id = (SELECT auth.uid()));
```
- **Line 163-165:** Configures security for group memberships.
  - Any authenticated user can view memberships.
  - Users can insert memberships only for their own user ID (`user_id = auth.uid()`), preventing them from force-adding other users to groups.

---

## 5. Edge Cases & Optimizations
- **Recursive Subquery Overhead:** If a policy contains a subquery checking another table (e.g., `EXISTS (SELECT 1 FROM group_members WHERE group_id = messages.group_id AND user_id = auth.uid())`), PostgreSQL will evaluate this subquery for every matching row in the `messages` table. This can lead to severe query degradation.
  - *Optimization:* Index the columns referenced in subqueries, or write helper functions to cache lookup states.
- **Infinite Policy Recursion:** If Table A's policy queries Table B, and Table B's policy queries Table A, the query planner will enter an infinite recursion loop and fail.
  - *Fix:* Ensure policies point downwards in the relational hierarchy and avoid cyclical checks.

---

## 6. Staff Engineer Viva Board

### Q1: What is the security risk of using `auth.uid()` inside an RLS policy without enabling RLS on that table?
**Answer:**
*"If you define RLS policies (using `auth.uid()`) on a table but forget to run `ALTER TABLE target_table ENABLE ROW LEVEL SECURITY;`:
1. The table remains unprotected.
2. The RLS policies are ignored by the database engine.
3. Any client can connect and read, update, or delete any row in the table, bypassing all authorization checks.
Enabling RLS is a mandatory prerequisite for policies to take effect."*

### Q2: Explain the difference between the `USING` and `WITH CHECK` clauses in an RLS policy.
**Answer:**
*"- **`USING` clause:** Applies to read operations (`SELECT`, `DELETE`, `UPDATE` target selection). It defines which existing rows are visible or modifiable by the query.
- **`WITH CHECK` clause:** Applies to write operations (`INSERT`, `UPDATE` verification). It defines whether the new data being written conforms to the security rules.
For example, in an `UPDATE` policy, `USING` defines which rows you can attempt to modify, and `WITH CHECK` verifies that the modifications do not violate security rules (e.g., preventing you from changing the owner ID)."*

### Q3: How do you prevent infinite recursion loops when writing RLS policies in PostgreSQL?
**Answer:**
*"Infinite recursion occurs when two tables have policies referencing each other. For example, if Table A's select policy checks Table B, and Table B's select policy checks Table A. 

To prevent this:
1. We design a hierarchical query path (e.g., Table A queries Table B, but Table B resolves security using its own local columns).
2. We use security helper functions declared as `SECURITY DEFINER` to query tables directly, bypassing RLS checks during the evaluation."*

### Q4: How does Supabase handle RLS bypass for administrative tasks, and what are the security implications of exposing the service role key?
**Answer:**
*"Supabase provides a **service_role** key. When an API request connects using this key, it is authenticated with the `service_role` database role. 

This role is a superuser that bypasses RLS policies entirely, allowing unrestricted read/write access. Exposing this key to the client side would allow anyone to write scripts to modify, delete, or leak the entire database. This key must **never** be used on the client side and should reside strictly in secure server-side environments."*

### Q5: If a user is banned, how does the database enforce that their posts and profile become invisible to other users?
**Answer:**
*"We handle this directly in the RLS policies of our tables. 
- In the `profiles` table policy, we specify:
  ```sql
  USING (is_banned = false OR id = auth.uid())
  ```
  If a profile has `is_banned = true`, any query from other users will filter it out.
- In the `tea_posts` policy, we join the `profiles` table to check the author's ban status:
  ```sql
  USING (EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = tea_posts.author_id AND is_banned = false
  ))
  ```
This ensures the banned user's content instantly disappears from the application."*
