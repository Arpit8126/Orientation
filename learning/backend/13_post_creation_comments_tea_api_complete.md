# Backend Chapter 13: Post Creation, Comments & The Complete Tea API

This module covers the full lifecycle of Pookiz's "Spill the Tea" feature — from creating a post on the frontend, to the API route that saves it, to how comments are nested, threaded, and displayed in real time.

---

## 1. Objective & Placement Value
- **Why this is asked:** Social media content pipelines are among the most commonly system-designed features in interviews. Interviewers evaluate how you handle media uploads, content moderation, nested comment trees, optimistic UI, and real-time content delivery.
- **Placement Value:** Prepares you to design end-to-end content creation pipelines with file uploads, validation, permission checks, and live comment feeds.

---

## 2. The Layman's Analogy
Think of the Tea feature as a **campus gossip billboard**:
- **Post Creation:** You walk up to the board with a sticky note (text + optional photo). The receptionist stamps it with your name (or hides your name if anonymous) and pins it to the board.
- **The Feed:** Everyone walking past sees the board and the latest sticky notes.
- **Comments:** You can write a reply on a smaller sticky note and pin it below the original. If you want to reply to someone else's reply, you draw an arrow from your note to theirs (parent_id = threaded reply).
- **Aura Votes:** Next to each note, you can stick a blue (+1) or red (-1) vote token. The database ensures you only have one token per note at a time.

---

## 3. The Technical Specification

### A. The Post Creation Flow (End-to-End)
```
[User] → Opens CreateTeaModal → Fills content + optional image
       → Clicks "Spill It" button
       → [Frontend] uploads image to Supabase Storage if present
       → [Frontend] calls POST /api/tea with { content, media_url, is_anonymous, poll_options }
       → [API Route] verifies auth, validates content, inserts into tea_posts table
       → [Frontend] optimistically adds post to feed, shows success toast
       → [Supabase Realtime] broadcasts INSERT event to all subscribers
       → All other users in the feed receive the new post live
```

### B. Comment System Architecture
Comments are stored in the `tea_comments` table with a `parent_id` self-reference for threading:
```
Post (tea_posts)
  └── Comment A (parent_id = null) ← top-level comment
       └── Reply B (parent_id = A.id) ← nested reply
            └── Reply C (parent_id = B.id) ← deep reply (UI flattens beyond level 2)
  └── Comment D (parent_id = null) ← another top-level comment
```

### C. Real-Time Comment Delivery
When a comment is submitted:
1. It is inserted into `tea_comments` via the `/api/tea/[postId]/comments` route.
2. Supabase's logical replication captures the INSERT event from the WAL.
3. All users with the comment drawer open for that post receive the new comment via their WebSocket subscription.
4. The comment is appended to the list immediately without requiring a page refresh.

---

## 4. Line-by-Line Code Walkthrough

### A. The Post Creation API Route — `POST /api/tea`
Let's analyze [`d:\Pookiz\pookiz-app\src\app\api\tea\route.ts`](file:///d:/Pookiz/pookiz-app/src/app/api/tea/route.ts):

```typescript
export async function POST(request: Request) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }
```
- Initializes the server-side Supabase client and reads the user session from cookies.
- If no session exists, rejects the request with `401 Unauthorized`.

```typescript
  const body = await request.json()
  const { content, media_url, is_anonymous, poll_options } = body

  if (!content || content.trim().length === 0) {
    return NextResponse.json({ error: 'Content cannot be empty' }, { status: 400 })
  }

  if (content.length > 500) {
    return NextResponse.json({ error: 'Content exceeds 500 characters' }, { status: 400 })
  }
```
- Extracts the post body from the request JSON.
- Validates that `content` is present and within character limits.
- These server-side validations are critical — client-side validation can be bypassed.

```typescript
  const { data: post, error } = await supabase
    .from('tea_posts')
    .insert({
      author_id: user.id,
      content: content.trim(),
      media_url: media_url || null,
      is_anonymous: is_anonymous ?? true,
    })
    .select()
    .single()

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json({ post }, { status: 201 })
}
```
- Inserts the new post into `tea_posts`. The `author_id` is taken from the **verified session** — never from the request body, preventing impersonation.
- `is_anonymous` defaults to `true` — privacy is the default.
- Returns `201 Created` with the new post object on success.

### B. The Comments API Route — `POST /api/tea/[postId]/comments`
```typescript
export async function POST(request: Request, { params }: { params: { postId: string } }) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { content, parent_id } = await request.json()

  if (!content?.trim()) {
    return NextResponse.json({ error: 'Comment cannot be empty' }, { status: 400 })
  }
```
- The `[postId]` folder makes `params.postId` available as a dynamic URL segment.
- Extracts `content` and the optional `parent_id` (which comment this is replying to).

```typescript
  // Verify the post exists before inserting a comment
  const { data: post } = await supabase
    .from('tea_posts')
    .select('id')
    .eq('id', params.postId)
    .single()

  if (!post) return NextResponse.json({ error: 'Post not found' }, { status: 404 })

  const { data: comment, error } = await supabase
    .from('tea_comments')
    .insert({
      post_id: params.postId,
      author_id: user.id,
      content: content.trim(),
      parent_id: parent_id || null,   // null = top-level; UUID = nested reply
    })
    .select('*, author:profiles(id, username, avatar_url)')
    .single()

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  return NextResponse.json({ comment }, { status: 201 })
}
```
- Verifies the parent post exists before inserting. This prevents orphaned comments.
- `parent_id: null` creates a top-level comment; `parent_id: <uuid>` creates a nested reply.
- The `.select('*, author:profiles(...)')` join fetches the author's profile in the same query, avoiding a second round-trip.

### C. Fetching Comments with Threading — `GET /api/tea/[postId]/comments`
```typescript
export async function GET(request: Request, { params }: { params: { postId: string } }) {
  const supabase = await createClient()

  const { data: comments, error } = await supabase
    .from('tea_comments')
    .select(`
      *,
      author:profiles(id, username, avatar_url, is_anonymous_default)
    `)
    .eq('post_id', params.postId)
    .order('created_at', { ascending: true })

  // Build threaded tree structure in JavaScript
  const topLevel = comments?.filter(c => !c.parent_id) ?? []
  const replies = comments?.filter(c => c.parent_id) ?? []

  const threaded = topLevel.map(comment => ({
    ...comment,
    replies: replies.filter(r => r.parent_id === comment.id)
  }))

  return NextResponse.json({ comments: threaded })
}
```
- Fetches all comments for the post in a single query, ordered by creation time.
- Performs **client-side tree assembly** in JavaScript (grouping replies under their parent) rather than using expensive recursive SQL CTEs.
- Returns a clean `{ comment, replies: [] }` tree structure to the frontend.

---

## 5. The CreateTeaModal — Frontend Post Creation

### A. Image Upload to Supabase Storage
```typescript
// In CreateTeaModal.tsx
const handleSubmit = async () => {
  let media_url = null

  if (selectedImage) {
    const filePath = `tea/${user.id}/${Date.now()}_${selectedImage.name}`
    const { data, error } = await supabase.storage
      .from('tea-media')
      .upload(filePath, selectedImage, { upsert: false })

    if (error) {
      setError('Image upload failed. Please try again.')
      return
    }

    const { data: { publicUrl } } = supabase.storage
      .from('tea-media')
      .getPublicUrl(data.path)

    media_url = publicUrl
  }

  // Then POST to the API
  const response = await fetch('/api/tea', {
    method: 'POST',
    body: JSON.stringify({ content, media_url, is_anonymous }),
  })
}
```
- Images are uploaded **directly to Supabase Storage** from the browser before the API call.
- The file path includes `user.id` and a timestamp to ensure uniqueness and prevent collisions.
- After upload, the public URL is included in the API request body.

### B. Poll Options Creation
```typescript
// Poll options are passed alongside the post content
const pollOptions = ['Spill More 🫖', 'Too Hot 🔥', 'Cap / Fake 🧢', '💀 Dead']

await fetch('/api/tea', {
  method: 'POST',
  body: JSON.stringify({
    content,
    is_anonymous,
    poll_options: pollOptions  // stored in the post, drives the reaction bar
  }),
})
```
- Poll reactions (`spill_more`, `too_hot`, `cap_fake`, `dead`) are fixed options defined in the UI.
- Votes are tracked in the `tea_poll_votes` table with `UNIQUE(post_id, user_id)` to prevent double-voting.

---

## 6. Edge Cases & Optimizations

- **Media URL Dangling References:** If the post API call fails after the image was uploaded, the image stays in storage but has no associated post.
  - *Fix:* Use a cleanup job or mark the upload as "pending" and delete orphaned files after a timeout.

- **Comment Spam Prevention:** Without rate limiting, a user could flood the comments.
  - *Fix:* Use database rate-limiting triggers or add a server-side check: allow max 5 comments per user per post per minute.

- **Optimistic Comment Display:** Wait for the server response before showing the comment. If the network is slow, the UI feels laggy.
  - *Fix:* Implement optimistic UI — add the comment to the local state immediately with a `pending` flag, then confirm/remove it based on the API response.

---

## 7. Staff Engineer Viva Board

### Q1: Why is `author_id` read from the server session and not from the request body?
**Answer:**
*"If we read `author_id` from the request body (e.g., `{ author_id: '...', content: '...' }`), any user could send a crafted request pretending to be another user. Since the request body is fully controlled by the client, this would allow identity spoofing.

By reading `author_id` from `supabase.auth.getUser()`, we read the verified identity from the JWT stored in the HTTP-only cookie — a value that cannot be modified by the client. The session is cryptographically signed by the Supabase auth server, making impersonation impossible."*

### Q2: Explain how the `is_anonymous` flag works end-to-end. Can a user see who wrote an anonymous post?
**Answer:**
*"The `is_anonymous` column is stored in `tea_posts`. When the frontend queries the feed:
- If `is_anonymous = true`, the UI renders the `AnonymousMaskAvatar` component and hides the author's username.
- The `author_id` is still stored in the database (for moderation purposes), but the RLS SELECT policy on the API prevents clients from fetching the author's identity when the post is anonymous.

Admins with access to the Supabase dashboard can see the `author_id` directly, but normal users — even via API inspection — cannot resolve the author because the API join is conditionally applied."*

### Q3: What is the risk of building the comment tree with a recursive SQL CTE instead of assembling it in JavaScript?
**Answer:**
*"A recursive SQL CTE (Common Table Expression) traverses the `parent_id` tree inside the database:
```sql
WITH RECURSIVE comment_tree AS (
  SELECT * FROM tea_comments WHERE parent_id IS NULL
  UNION ALL
  SELECT c.* FROM tea_comments c JOIN comment_tree ct ON c.parent_id = ct.id
)
```
This is database-intensive — for deeply nested trees with thousands of comments, it performs many join passes.

Since Pookiz limits nesting to 2 levels, fetching all comments in a single flat query and assembling the tree in JavaScript is faster and simpler. The database handles one query; JavaScript handles the lightweight grouping operation in memory."*

### Q4: How does Supabase Storage RLS protect uploaded images?
**Answer:**
*"Supabase Storage has its own RLS policies defined per bucket. For the `tea-media` bucket:
- **INSERT:** Only authenticated users can upload — enforced by checking `auth.uid() IS NOT NULL`.
- **SELECT:** Public read is allowed so the post media loads without auth headers.
- **DELETE:** Only the file owner (matched via the path prefix containing their `user.id`) can delete their own files.

This prevents users from uploading to each other's paths or deleting other users' media."*

### Q5: How would you implement a soft-delete for tea posts?
**Answer:**
*"Instead of using `DELETE FROM tea_posts WHERE id = :id` (which permanently removes the row and cascades deletes to comments and votes), we implement a soft delete:
1. Add a `deleted_at TIMESTAMPTZ DEFAULT NULL` column to `tea_posts`.
2. On delete action, update the row: `UPDATE tea_posts SET deleted_at = NOW() WHERE id = :id AND author_id = :userId`.
3. All SELECT queries filter `WHERE deleted_at IS NULL` to exclude soft-deleted posts.
4. Comments and votes remain in the database, preserving engagement history for analytics.
5. A cron job can permanently purge rows where `deleted_at < NOW() - INTERVAL '30 days'`."*
