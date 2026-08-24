# Database Chapter 02: Profiles Table & Schema Relations

This module details the relational schema layout of Pookiz, focusing on the central `profiles` table, foreign keys, cascade deletes, and structural integrity.

---

## 1. Objective & Placement Value
- **Why this is asked:** In complex relational databases, designing a secure, clean schema structure without orphaned records is a key systems architect skill. Technical interviewers look for correct application of foreign keys, delete actions, constraints, and composite tables.
- **Placement Value:** Demonstrates your capability to design high-integrity database systems that scale cleanly without data anomalies or orphan bloat.

---

## 2. The Layman's Analogy
Think of the Pookiz database as a **secure digital campus registry**.
- **Auth users cabinet (Protected):** The main login department holds student keys and credentials (email/password). This is a highly guarded cabinet.
- **Profiles desk (Public):** The student profiles desk holds public identity records (names, courses, bio, etc.).
- **The Linked Key:** The profiles desk references the exact student keys from the auth cabinet. If a student leaves the university (deleted from login cabinet), their profile card is instantly thrown into the paper shredder (**ON DELETE CASCADE**). This prevents having profile records of students who can no longer log in.

---

## 3. The Technical Specification

### A. The Separation of Auth and User Profiles
In modern SaaS architectures like Supabase, user management is split into two layers:
1. **`auth.users` Table (Isolated):** Managed directly by Supabase's authentication service. It contains sensitive credentials, email verification states, metadata, and JWT details. This table is not directly accessible by standard database users or clients for security reasons.
2. **`public.profiles` Table (Application Space):** Extends the auth table with application-specific attributes (username, bio, avatar, university name, teacher status). It links back to `auth.users` using a foreign key constraint.

```
┌─────────────────────────────────┐
│           auth.users            │
│  - id (UUID, PK)                │
│  - email (TEXT)                 │
│  - encrypted_password (TEXT)   │
└────────────────┬────────────────┘
                 │
                 │ references / cascade delete
                 ▼
┌─────────────────────────────────┐
│         public.profiles         │
│  - id (UUID, PK, FK)           │
│  - username (TEXT, Unique)      │
│  - bio (TEXT)                   │
│  - is_teacher (BOOLEAN)         │
└─────────────────────────────────┘
```

### B. Foreign Key Delete Cascades & Integrity Constraints
Relational databases enforce constraints to prevent data inconsistencies:
- **`ON DELETE CASCADE`:** If a parent row is deleted, the database automatically deletes all dependent child rows. This is used for tight entity couplings (e.g., deleting a profile deletes their group memberships).
- **`ON DELETE SET NULL`:** If a parent row is deleted, the database sets the foreign key field in child rows to `NULL`. This is used for historical preservation (e.g., deleting an author profile sets the `author_id` in `tea_posts` to `NULL`, retaining the post as anonymous).
- **`ON DELETE RESTRICT` / `NO ACTION` (Default):** Prevents the parent row from being deleted if any referencing child rows exist.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the profile table creation and references inside [`d:\Pookiz\supabase\migration.sql`](file:///d:/Pookiz/supabase/migration.sql):

```sql
-- PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160),
  avatar_url TEXT DEFAULT '',
  university_name TEXT DEFAULT 'GLA University',
  course TEXT DEFAULT '',
  dob DATE,
  city TEXT DEFAULT '',
  is_banned BOOLEAN DEFAULT false,
  sethji BOOLEAN DEFAULT false,
  is_onboarded BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```
- **Line 17:** Declares the primary key `id` as type `UUID`. It references `auth.users(id)` with `ON DELETE CASCADE`. This ensures that when an account is deleted from Supabase Auth, its corresponding profile is automatically removed.
- **Line 18:** Declares `username` as `TEXT UNIQUE NOT NULL`. This prevents duplicate usernames at the database engine level, avoiding race conditions.
- **Line 19:** Sets a default empty string for the `bio` column to avoid dealing with null states in frontend code, and applies a `CHECK` constraint:
  ```sql
  CHECK (char_length(bio) <= 160)
  ```
  This is a database-level validation enforcing that the bio text never exceeds 160 characters.
- **Line 26:** The `sethji` column is a boolean flag (renamed from `is_global_admin`) representing administrative permissions.
- **Line 28-29:** Defines `created_at` and `updated_at` timestamps defaulted to the current database time (`now()`), which provides reliable audit metrics.

---

## 5. Edge Cases & Optimizations
- **Nullable Foreign Keys in Code Blocks:** When a relation is deleted and `ON DELETE SET NULL` is executed, the column value becomes `NULL`. Frontend types must explicitly mark these fields as optional (e.g., `author_id: string | null`) to prevent runtime crashes (like calling `profile.username` on a null object).
- **Cascade Deletion Lock Escalation:** Performing a cascade delete on a parent row with millions of child rows (e.g., a highly active profile with thousands of messages) requires PostgreSQL to lock all affected tables. This can escalate to a exclusive table-level lock, blocking concurrent inserts.
  - *Fix:* In high-throughput tables, use a background task worker or trigger soft-deletes (`is_active = false`) to mark records for deletion, and clean up actual rows asynchronously during low-traffic periods.

---

## 6. Staff Engineer Viva Board

### Q1: Why did you separate user credentials from user profiles in Pookiz?
**Answer:**
*"We separated user credentials (`auth.users`) from user profiles (`public.profiles`) to implement a secure, segmented access control architecture. The `auth.users` table contains sensitive credentials, password hashes, and security logs. Keeping it isolated in a protected schema prevented it from being exposed to the public internet. 

The `public.profiles` table contains public-facing application states (usernames, bios, avatars). This allows us to safely open read permissions to the client side via RLS policies without exposing sensitive authentication columns."*

### Q2: What would happen if a user tried to sign up with a username that is already taken, and how does the database handle it?
**Answer:**
*"The database enforces unique usernames via the `username TEXT UNIQUE NOT NULL` constraint. When a duplicate username insert is attempted:
1. The PostgreSQL engine detects a conflict in the unique index of the `username` column.
2. It rejects the write transaction, rolling back any changes.
3. The engine throws a unique constraint violation error (`code 23505`).
Our Next.js API server captures this exception, maps it to a readable error message (e.g., 'Username is already taken'), and returns an HTTP 409 Conflict status to the user."*

### Q3: Walk me through the implementation of your cascade deletion logic in Pookiz. What is the benefit?
**Answer:**
*"In Pookiz, the cascade deletion strategy is implemented on all tightly coupled user relations:
- `group_members` references `profiles(id) ON DELETE CASCADE`.
- `friends` references `profiles(id) ON DELETE CASCADE`.
- `quiz_attempts` references `profiles(id) ON DELETE CASCADE`.

The benefit is that it ensures relational data integrity. If a user deletes their account, all their memberships, friendships, and quiz scores are automatically removed by the database engine in a single atomic transaction. This prevents orphaned records from cluttering our database."*

### Q4: Explain the purpose of CHECK constraints. Why place validation in the database when we already validate data in the frontend?
**Answer:**
*"Frontend validation is for user experience, providing immediate feedback. However, it cannot be trusted for security because clients can bypass the frontend client by sending API requests directly using curl or postman.

Database check constraints (like `CHECK (char_length(bio) <= 160)`) act as the final, absolute line of defense. They guarantee that no matter how data is written to the database (whether via APIs, scripts, or manual database connections), it must conform to the defined rules, preventing data corruption and buffer overflows."*

### Q5: How do you handle updating the `updated_at` column automatically when a profile is changed in PostgreSQL?
**Answer:**
*"PostgreSQL does not automatically update timestamps on row updates. To do this, we use a database trigger.
First, we define a reusable trigger function:
```sql
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```
Then, we attach the trigger to the target table:
```sql
CREATE TRIGGER update_profiles_modtime
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_modified_column();
```
This ensures the `updated_at` timestamp is updated in a single transaction before the row is written to disk."*
