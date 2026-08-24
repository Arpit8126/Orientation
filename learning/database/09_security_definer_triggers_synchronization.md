# Database Chapter 09: Security Definer Triggers & System Automation

This module covers the execution of PL/pgSQL database triggers inside PostgreSQL, detailing the role-security mapping (`SECURITY DEFINER` vs `SECURITY INVOKER`), schema search paths, and security constraints like guest restrictions and verification triggers.

---

## 1. Objective & Placement Value
- **Why this is asked:** Automated business validation and schema-to-schema synchronization are key elements of secure distributed systems. Technical interviewers evaluate how you write triggers to validate fields, enforce strict constraints, handle guest session limits, and securely elevate privileges using `SECURITY DEFINER`.
- **Placement Value:** Demonstrates your capability to design high-integrity, automated database logic that prevents data bypass at the storage engine level.

---

## 2. The Layman's Analogy
Think of database triggers as **silent security proctors in a school building**:
- **Standard rules (Security Invoker):** If you ask a student proctor to open a locker, they can only open the ones they have the keys for. If they don't have the keys, they fail.
- **Master override (Security Definer):** A security proctor is given a master keycard. When a student requests to store a new handbook, the proctor uses the master keycard to open the master storage cabinet (e.g., profiles table) on their behalf, completing the action even though the student does not have direct keys.
- **Guest Checks (Restrictions trigger):** When a student tries to pin an announcement (send a message) or lock a room (block a user), the proctor checks their ID card. If the ID says "Guest - Email Unverified", the proctor blocks the action and throws a warning exception.

---

## 3. The Technical Specification

### A. Execution Privilege Models
Every trigger in PostgreSQL executes a stored function. The function's permission context is defined by its security modifier:
1. **`SECURITY INVOKER` (Default):** Runs the function using the privileges of the user who executed the query. If the user does not have direct table access under RLS, the trigger will fail.
2. **`SECURITY DEFINER`:** Runs the function using the privileges of the user who *defined* (created) the function (typically the database owner or superuser). This allows the function to read or write to tables that the current user cannot access directly.

### B. Search Path Hijack Vulnerability
Functions running under `SECURITY DEFINER` are vulnerable to schema path hijacking if the search path is not explicitly set:
- *The Attack:* If the function calls a simple table name like `profiles` without schema qualification, Postgres searches the active user's schema path. A malicious user could create a custom schema containing a modified `profiles` table to run malicious triggers.
- *The Hardening Fix:* Always append `SET search_path = public` to ensure PostgreSQL resolves table references strictly within the verified public schema, bypassing the caller's schema search settings.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the guest email verification trigger from [`d:\Pookiz\supabase\guest_restrictions_rls_trigger.sql`](file:///d:/Pookiz/supabase/guest_restrictions_rls_trigger.sql):

```sql
CREATE OR REPLACE FUNCTION public.check_message_sender_verified()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = NEW.sender_id AND is_email_verified = true
  ) THEN
    RAISE EXCEPTION 'Please verify your email by going in profile section first to send messages.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```
- **Line 9-10:** Declares the stored function `check_message_sender_verified` returning type `TRIGGER`.
- **Line 12-15:** Performs an existence check. It queries the `profiles` table looking for a row matching the message's `sender_id` (extracted from the `NEW` record structure) where the boolean `is_email_verified` is set to `true`.
- **Line 16:** If no verified profile is found, it raises an exception using `RAISE EXCEPTION`. This immediately aborts the insert query and rolls back the transaction.
- **Line 18:** If verified, returns the `NEW` row representation to allow the insert operation to proceed.
- **Line 20:** Sets the language to `plpgsql` and enables `SECURITY DEFINER` to allow the trigger to query the `profiles` table even if the user lacks select permissions.

```sql
DROP TRIGGER IF EXISTS on_message_insert_verify ON public.messages;
CREATE TRIGGER on_message_insert_verify
  BEFORE INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.check_message_sender_verified();
```
- **Line 22-26:** Creates the trigger `on_message_insert_verify`.
  - It runs `BEFORE INSERT` on `messages` to intercept and check the row before it is committed to the heap.
  - `FOR EACH ROW` ensures it evaluates every row in multi-row inserts.
  - It invokes `check_message_sender_verified()` to validate user permissions.

---

## 5. Edge Cases & Optimizations
- **Trigger Cascade Depth Limits:** If a trigger updates another table which in turn fires a trigger updating the first table, it can lead to infinite loops. PostgreSQL has a max recursion limit (`max_trigger_depth = 40` by default). We prevent loops by checking conditions before updates.
- **Verification Cache Optimization:** Querying `profiles` for every insert slows down message sending.
  - *Fix:* Ensure the `profiles` table is indexed on `id` (which is automatic as it's the primary key) so that `SELECT 1 FROM profiles` is a fast index lookup.

---

## 6. Staff Engineer Viva Board

### Q1: Why did you implement email verification checks as a database trigger instead of validating it on the Next.js API server?
**Answer:**
*"Relational security must be enforced on the database layer. If we only checked email verification inside the Next.js API server:
1. An attacker could bypass our server by connecting directly to the Supabase client API using their JWT token in a custom script.
2. They could send messages, block users, or report profiles, bypassing the email verification gate.
By using database-level `BEFORE INSERT` triggers, we ensure that no message, block, or report can ever reach disk unless the sender is verified, regardless of which client client was used."*

### Q2: What is the risk of using a `SECURITY DEFINER` trigger, and how did you secure it in Pookiz?
**Answer:**
*"The risk is privilege escalation. Because a `SECURITY DEFINER` function runs with superuser permissions, a malicious caller could exploit search path resolution to run arbitrary code. 

We secure this in Pookiz by:
1. Restricting function scope.
2. Explicitly setting the search path:
   ```sql
   SECURITY DEFINER SET search_path = public;
   ```
This forces PostgreSQL to search only within the secure `public` schema, preventing schema-hijacking attacks."*

### Q3: Explain why we use a `BEFORE` trigger for guest restriction checks instead of an `AFTER` trigger.
**Answer:**
*"We use a `BEFORE` trigger because guest restrictions are validation checks:
- **`BEFORE` triggers** execute before the row changes are written to disk. If the validation fails and raises an exception, the transaction is aborted immediately before any disk write operations take place.
- **`AFTER` triggers** run after data has been written to the disk heap. Raising an exception here still rolls back the transaction, but we have already paid the performance cost of writing to disk and generating log writes.
Using `BEFORE` triggers is the most performant way to reject invalid writes."*

### Q4: If a user updates their email address inside Supabase Auth, how do you keep their `is_email_verified` column synchronized in `public.profiles`?
**Answer:**
*"We handle this using a database trigger on the `auth.users` table:
1. We create a `SECURITY DEFINER` function that reads the `email_confirmed_at` column from `auth.users`.
2. If `email_confirmed_at` is populated, it updates the `is_email_verified` column to `true` in `public.profiles`.
3. We bind this function as an `AFTER UPDATE` trigger on the `auth.users` table, ensuring updates are automatically synced in a single transaction."*

### Q5: How would you disable triggers temporarily when running a database migration or batch import?
**Answer:**
*"To disable triggers temporarily (for example, during a bulk import where we want to skip validation checks to save time):
We can disable all triggers on a specific table inside a transaction:
```sql
ALTER TABLE public.messages DISABLE TRIGGER USER;
```
Once the import completes, we re-enable them:
```sql
ALTER TABLE public.messages ENABLE TRIGGER USER;
```
This must be run as a superuser (`postgres` role) and should be wrapped in a transaction block to ensure triggers are re-enabled if the import fails."*
