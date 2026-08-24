# Backend Chapter 06: Email Verification Loop & Guest Gates

This module covers the database and API architecture of the email verification loop in Pookiz, detailing the OTP (One-Time Password) confirmation flow, RPC validation lookups, and client-side guest-browsing restrictions.

---

## 1. Objective & Placement Value
- **Why this is asked:** In modern social networks, spam and bot prevention are critical. Designing a multi-layered verification system that supports guest browsing while gating interactive features is a common requirement. Interviewers look for secure OTP management, verification status database synchronization, and robust API gating strategies.
- **Placement Value:** Prepares you to design secure verification pipelines, write high-performance database validation functions (RPCs), and implement clean, client-side permission gates.

---

## 2. The Layman's Analogy
Think of the email verification system as a **temporary guest pass system at a university library**:
- **Guest Browsing (Unverified):** You walk into the library. You don't have a verified student card, but you are allowed to browse the bookshelves, read books in the lounge, and look at the layout (read-only access).
- **Interactive Actions (Gated):** If you try to borrow a book (send a message), write on the bulletin board (post tea), or book a study room (create a group), the librarian asks to see a verified card.
- **The Verification Process:** 
  - You request a verified card by giving your email.
  - The university sends a sealed letter containing a secret, single-use 6-digit passcode (OTP) to your inbox.
  - You open the letter, read the passcode to the librarian, and once they confirm it, your status is updated from "Guest" to "Verified Student". The gate is unlocked.

---

## 3. The Technical Specification

### A. The Supabase OTP Verification Flow
1. **Request Verification:** The user inputs their email address. The application client calls the Supabase OTP request method:
   ```typescript
   await supabase.auth.signInWithOtp({ email })
   ```
2. **Token Dispatch:** Supabase Auth generates a random 6-digit OTP code, stores it with an expiration timestamp (e.g., 5 minutes), and sends it to the user's email.
3. **Token Verification:** The user enters the OTP in the UI. The application calls:
   ```typescript
   await supabase.auth.verifyOtp({ email, token, type: 'signup' })
   ```
4. **Session Activation:** Supabase validates the code. If correct, it returns a valid session JWT and marks the user's email as confirmed (`email_confirmed_at` is set) inside `auth.users`.

### B. Fast Email Existence Checks via RPC
Before sending verification codes or checking account registration, the application runs checks on email existence. Querying the sensitive `auth.users` table directly is restricted. To resolve this:
- We write a custom PostgreSQL stored function (RPC) named `get_user_by_email` running under `SECURITY DEFINER` privileges.
- The function checks if the email exists inside `auth.users` and returns a boolean value to the API route `/api/auth/verify-email`.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the verify-email API endpoint: [`d:\Pookiz\pookiz-app\src\app\api\auth\verify-email\route.ts`](file:///d:/Pookiz/pookiz-app/src/app/api/auth/verify-email/route.ts)

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createAdminClient } from '@/lib/supabase/admin';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const email = searchParams.get('email');

    if (!email) {
      return NextResponse.json({ error: 'Email parameter is required' }, { status: 400 });
    }
```
- **Line 4-7:** Exports the GET handler. Parses the query string to extract the `email` address parameter.
- **Line 9-11:** If the email is missing from the query, it returns an HTTP `400 Bad Request` status.

```typescript
    const admin = createAdminClient() as any;
    const targetEmail = email.trim().toLowerCase();
    
    // Perform O(1) server-side RPC lookup
    const { data, error } = await admin.rpc('get_user_by_email', { email_to_search: targetEmail });

    if (error) {
      console.error('Error executing RPC get_user_by_email:', error);
      return NextResponse.json({ error: error.message }, { status: 500 });
    }
```
- **Line 13:** Initializes the privileged Supabase client (`createAdminClient()`) to call RPC functions that access the isolated `auth` schema.
- **Line 14:** Normalizes the email address by trimming spaces and converting to lowercase to prevent casing mismatches.
- **Line 17:** Executes the database RPC `get_user_by_email`, passing the target email. This runs a fast index lookup in PostgreSQL.
- **Line 19-22:** If a database error occurs, it log-traces the error and returns an HTTP `500 Internal Server Error` response.

```typescript
    if (data && data.exists) {
      if (data.isTestingUser) {
        return NextResponse.json({ exists: true, isTestingUser: true }, { status: 200 });
      }
      return NextResponse.json({ exists: true });
    }

    return NextResponse.json({ exists: false });
  } catch (err: any) { ... }
}
```
- **Line 24-29:** If the email exists in the database:
  - If they are a whitelisted testing account (`isTestingUser: true`), return the testing indicator (allowing the client to bypass OTP checks for store testing).
  - Otherwise, return `{ exists: true }`.
- **Line 31:** If not found, return `{ exists: false }`.

---

## 5. Edge Cases & Optimizations
- **Rate-Limiting OTP Requests:** Malicious actors can call OTP endpoints repeatedly to spam user inboxes and exhaust email quotas.
  - *Fix:* Enable Supabase SMTP rate limits (e.g., maximum 1 email per minute per IP address) and enforce client-side resend delay countdowns.
- **RPC Search Selectivity:** If the email lookup performs a full sequential table scan on `auth.users`, it will degrade under load.
  - *Fix:* Ensure the `auth.users` table is indexed on the `email` column (which is default in Supabase Auth schemas) to keep lookups executing in $O(1)$ time.

---

## 6. Staff Engineer Viva Board

### Q1: Why can't we query the `auth.users` table directly inside our Next.js API routes or RLS policies?
**Answer:**
*"The `auth` schema inside Supabase is highly protected. It contains sensitive security assets like bcrypt password hashes, authentication tokens, and audit trails. 

If clients could query `auth.users` directly (even under RLS policies), it would increase the surface area for data leaks and brute-force queries. 
To secure this, Supabase blocks access to the `auth` schema from standard database roles. We must use an RPC function running under `SECURITY DEFINER` (admin role) that queries the table on our behalf and returns only public attributes, keeping credentials secure."*

### Q2: Walk me through how you bypass OTP email checks for testing accounts (e.g., Apple Store reviewers).
**Answer:**
*"Apple App Store reviewers often reject apps that require active OTP SMS/emails because they use automated test environments that cannot access external email accounts. 

To bypass this in Pookiz:
1. We write a custom database check inside our validation RPC `get_user_by_email`.
2. If the email belongs to a designated testing account, the API returns `isTestingUser: true`.
3. The client application checks this flag. If `true`, it bypasses the OTP input form and allows the tester to log in using a static test passcode, satisfying app store requirements."*

### Q3: What is an RPC in PostgreSQL, and why is it preferred over raw SQL execution for verification lookups?
**Answer:**
*"An **RPC (Remote Procedure Call)** is a stored database function written in PL/pgSQL that resides and executes directly on the database engine.

It is preferred over raw SQL execution because:
1. **Security:** Raw SQL queries sent from the client can be intercepted or manipulated (SQL injection). RPCs encapsulate the query logic securely behind a single function signature.
2. **Privilege Elevation:** RPCs can be declared as `SECURITY DEFINER` to access isolated tables that the client cannot query directly, maintaining strict database security.
3. **Performance:** Since the function is pre-compiled on the database engine, it avoids network round-trips for multi-step logic."*

### Q4: How does a user's verification state sync from `auth.users` to `public.profiles`?
**Answer:**
*"We handle this using a database trigger on the `auth.users` table:
1. We create a trigger function that runs `AFTER UPDATE` on `auth.users`.
2. The function checks if the `email_confirmed_at` column is populated.
3. If confirmed, it executes an update query:
   ```sql
   UPDATE public.profiles SET is_email_verified = true WHERE id = NEW.id;
   ```
This updates the profile's verification state automatically in a single transaction, keeping the two tables synchronized."*

### Q5: How would you prevent a guest user from sending messages if they modify client-side state variables to pretend they are verified?
**Answer:**
*"Client-side state modifications (e.g. changing variables in React DevTools) are easy for attackers to execute. Therefore, we must validate verification states on the server:
1. **API Validation:** Our Next.js route handlers verify the sender's state in the database before processing writes.
2. **Database Triggers:** We attach a `BEFORE INSERT` trigger to the `messages` table that checks the sender's profile state and throws an exception if `is_email_verified = false`.
This ensures malicious writes are rejected at the database level regardless of client-side modifications."*
