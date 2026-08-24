# Supabase & RLS Basics — Complete Guide from Zero to Real World

Supabase is an open-source Backend-as-a-Service (BaaS) alternative to Firebase. It builds on top of PostgreSQL, providing a database, authentication APIs, real-time sync listeners, storage buckets, and serverless edge functions.

---

## PART 1: The Core Services

Instead of building a custom server with Express/Node to handle authentication, database tables, and image file storage, Supabase provides these services out of the box:

1. **Database**: A dedicated, fully managed PostgreSQL database instance.
2. **Auth**: Complete user authentication system (email/password, OTP code, Google OAuth).
3. **Storage**: Buckets to store media files (images, PDFs, videos) securely.
4. **Realtime**: Listen to database changes in real-time using WebSockets.

---

## PART 2: Client SDK Configuration

To use Supabase in your frontend or backend application, you install the client SDK:
`npm install @supabase/supabase-js`

```typescript
// src/lib/supabase.ts
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

// Create a single Supabase Client instance for standard operations
export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

---

## PART 3: Database Operations (CRUD)

Supabase provides a powerful, type-safe query builder that mimics standard SQL operations.

### 1. Retrieve Data (SELECT)
```typescript
// Fetch all columns from 'profiles' table
const { data, error } = await supabase
  .from("profiles")
  .select("*");

// Fetch specific columns with filters
const { data: users, error: err } = await supabase
  .from("profiles")
  .select("id, username, created_at")
  .eq("is_active", true)      // WHERE is_active = true
  .gt("age", 18)              // WHERE age > 18
  .order("created_at", { ascending: false }) // ORDER BY created_at DESC
  .limit(10);                 // LIMIT 10

// Fetch relationships (auto JOINs based on foreign keys)
const { data: posts } = await supabase
  .from("posts")
  .select(`
    id,
    title,
    profiles ( id, username ) /* Joins the profiles table automatically */
  `);
```

### 2. Insert Data (INSERT)
```typescript
const { data, error } = await supabase
  .from("profiles")
  .insert([
    { username: "arpit", email: "arpit@gla.ac.in", age: 21 }
  ])
  .select(); // Returns the newly inserted record
```

### 3. Update Data (UPDATE)
```typescript
const { data, error } = await supabase
  .from("profiles")
  .update({ age: 22 })
  .eq("id", "user-uuid-123") // Filter is required to target updates!
  .select();
```

### 4. Delete Data (DELETE)
```typescript
const { error } = await supabase
  .from("profiles")
  .delete()
  .eq("id", "user-uuid-123");
```

---

## PART 4: Authentication APIs

Supabase Auth issues JSON Web Tokens (JWT) to securely manage user authentication states.

```typescript
// 1. Sign Up (Email & Password)
const { data, error } = await supabase.auth.signUp({
  email: "student@gla.ac.in",
  password: "securepassword123",
});

// 2. Sign In (Email & Password)
const { data: session, error: signinError } = await supabase.auth.signInWithPassword({
  email: "student@gla.ac.in",
  password: "securepassword123",
});

// 3. OAuth Login (Google)
async function loginWithGoogle() {
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: "google",
    options: {
      redirectTo: "http://localhost:3000/auth/callback",
    },
  });
}

// 4. Get Current Logged-in User Session (Safe check)
const { data: { user }, error: userError } = await supabase.auth.getUser();
if (user) {
  console.log("Logged in user UUID:", user.id);
  console.log("Logged in user email:", user.email);
}

// 5. Sign Out
const { error: signoutError } = await supabase.auth.signOut();
```

---

## PART 5: Storage Buckets (File Uploads)

Store user avatars, chat attachments, or document files.

```typescript
async function uploadAvatar(file: File, userId: string) {
  // Upload file to the 'avatars' bucket
  const { data, error } = await supabase.storage
    .from("avatars")
    .upload(`${userId}/profile.jpg`, file, {
      cacheControl: "3600",
      upsert: true, // overwrite file if exists
    });

  if (error) {
    console.error("Upload failed:", error.message);
    return null;
  }

  // Get the public URL to save in the profiles table database
  const { data: { publicUrl } } = supabase.storage
    .from("avatars")
    .getPublicUrl(`${userId}/profile.jpg`);

  return publicUrl;
}
```

---

## PART 6: Row Level Security (RLS) & Policies

This is the most critical database security concept. Without RLS, if an attacker gets your `anon` key, they can run SQL queries via JavaScript inside the browser to read, update, or delete any record in your database.

### What is RLS?
Row Level Security is a PostgreSQL feature that evaluates access rules directly inside the database engine before executing queries.
- Even if a JavaScript request calls `supabase.from('messages').select('*')`, the database will automatically filter out any rows the requesting user is not authorized to read.

### Supabase Context Variables:
- **`auth.uid()`**: Returns the UUID of the user sending the JWT request header.
- **`auth.role()`**: Returns the user's role (usually `authenticated` or `anon`).

### Declaring Policies in SQL:

```sql
-- 1. Enable RLS on the table (all requests blocked by default until policies added)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 2. Create Read Policy: Allow anyone to view profiles
CREATE POLICY "Allow public read access"
ON profiles FOR SELECT
TO public
USING (true); -- true = always allow

-- 3. Create Update Policy: Allow users to update ONLY their own profile row
CREATE POLICY "Allow users to update own profile"
ON profiles FOR UPDATE
TO authenticated
USING (auth.uid() = id)     -- checks existing row ID matches user session UID
WITH CHECK (auth.uid() = id); -- checks new updated data ID matches user session UID

-- 4. Create Policy for Private Messages
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow users to read their own messages"
ON messages FOR SELECT
TO authenticated
USING (
  auth.uid() = sender_id OR 
  auth.uid() = recipient_id
);
-- Result: No user can query/read another user's DMs.
```

---

## Summary: Supabase API Cheat Sheet

| Operation | SDK Method | SQL / Equivalent Action |
|---|---|---|
| **Query Data** | `supabase.from('t').select('*')` | `SELECT * FROM t;` |
| **Filter Equal** | `.eq('column', value)` | `WHERE column = value` |
| **Filter Lists** | `.in('column', [val1, val2])` | `WHERE column IN (val1, val2)` |
| **Limit Rows** | `.limit(number)` | `LIMIT number` |
| **User SignUp** | `supabase.auth.signUp(...)` | Register user in `auth.users` |
| **Get Session User**| `supabase.auth.getUser()` | Verify JWT & return payload |
| **Sign Out** | `supabase.auth.signOut()` | Invalidate local session cookie |
| **Upload File** | `supabase.storage.from('b').upload(...)` | Save file payload in Bucket `b` |
| **Get Public URL** | `supabase.storage.from('b').getPublicUrl(p)` | Get direct link of path `p` in `b` |
| **Database Gate** | `ALTER TABLE t ENABLE RLS;` | Turn on Postgres RLS on table `t` |
| **Verify Request** | `auth.uid() = id` | Match row owner in SQL Policy |
```
