# Pookiz Technical Interview Q&A Bank — Complete Edition

This document compiles 40+ high-frequency technical, system design, and architectural questions about Pookiz. Read this after studying each chapter. Every answer is tailored to your project experience.

---

## SECTION 1: Relational Database & Supabase Security

### Q1: What is Row Level Security (RLS) in PostgreSQL, and how does it differ from traditional API-level authorization?
**Answer:**
1. **Traditional API Authorization:** Access control resides in the backend application server (e.g., Express middleware checking user roles). The database user is a superuser with full access. If the developer forgets to add middleware to a new API endpoint, a data leak occurs.
2. **Row Level Security (RLS):** Authorization policies are defined directly on the database tables. Even if an API endpoint has no validation checks, the database engine itself blocks unauthorized queries.
Supabase decodes the user's JWT from HTTP headers and injects session variables (`auth.uid()`). PostgreSQL evaluates these variables directly inside table policies (`USING` and `WITH CHECK` clauses), ensuring that access rules cannot be bypassed.

### Q2: Walk me through the implementation of database triggers in Pookiz. Why use PL/pgSQL triggers instead of handling logic in the Next.js API server?
**Answer:**
We use PL/pgSQL triggers (like `on_auth_user_created` syncing `auth.users` to `public.profiles`, and auto-friendship acceptances) to enforce **data consistency and safety**:
- **Atomic Operations:** Triggers run inside the same database transaction as the original query. If the transaction fails, everything is rolled back automatically.
- **Bypassing RLS:** Triggers declared as `SECURITY DEFINER` run with superuser privileges, allowing them to perform actions that are normally blocked by standard user RLS policies.
- **DRY Principle:** Triggers run regardless of how a query is executed (via web client, admin portal, or direct SQL).

### Q3: Explain what MVCC is and how Postgres handles concurrent readers and writers.
**Answer:**
MVCC (Multi-Version Concurrency Control) is PostgreSQL's approach to handling concurrent access without locking. Each row stores `xmin` (the transaction that created it) and `xmax` (the transaction that deleted/updated it). When a read transaction runs, it takes a snapshot of active transactions and only sees rows where `xmin` is a committed transaction and `xmax` is either 0 (not deleted) or an uncommitted transaction.

This means **readers never block writers and writers never block readers**. If User A updates a profile while User B reads it simultaneously, User B reads the old version from the snapshot. User A's new version becomes visible only after their transaction commits. This is why Pookiz can handle hundreds of simultaneous users accessing and modifying data without deadlocks.

### Q4: What is the Write-Ahead Log (WAL) and how does Supabase Realtime use it?
**Answer:**
The WAL is a sequential log file where PostgreSQL writes every data modification before actually changing the data on disk. This guarantees durability — even if the server crashes mid-operation, PostgreSQL can replay the WAL to recover.

Supabase Realtime subscribes to the WAL using PostgreSQL's logical replication feature. When a new row is inserted into the `messages` table, Supabase's replication slot captures that insert event from the WAL, decodes it, and broadcasts it over WebSocket to all subscribed clients within milliseconds. This is how Pookiz delivers messages in real-time without polling — the database write itself triggers the notification.

### Q5: How do composite indexes work in PostgreSQL? Give a specific example from Pookiz.
**Answer:**
A composite index is a B-Tree index built on two or more columns together, sorted first by the first column, then by the second column within each first-column group.

In Pookiz, we have: `CREATE INDEX idx_messages_dm ON messages(sender_id, recipient_id, created_at DESC)`. This index is optimized for the query: `SELECT * FROM messages WHERE sender_id = X AND recipient_id = Y ORDER BY created_at DESC`. The planner can perform an index range scan using the equality on both IDs, then retrieve rows already in descending time order without a separate sort step.

However, this index would NOT help for `WHERE recipient_id = Y` alone (filtering only on the second column), because the index entries are scattered across different `sender_id` values. A separate index on `recipient_id` would be needed for that query pattern.

### Q6: What is a partial index and when would you use one?
**Answer:**
A partial index is a B-Tree index with a `WHERE` clause — it only indexes rows that match a condition. This makes the index smaller and faster because it excludes rows you never query through it.

Example in Pookiz:
```sql
CREATE INDEX idx_messages_unread ON messages(recipient_id, created_at)
WHERE read_at IS NULL;
```
This indexes only unread messages. When loading unread message count badges, this tiny index is scanned instead of the full messages table. As messages are read, they're removed from the index scope. This is far more efficient than a full index on all messages when 95% of messages are already read.

---

## SECTION 2: Server Architecture & APIs

### Q7: How did you implement WebRTC calling, and what is the role of the LiveKit server in Pookiz?
**Answer:**
WebRTC enables direct, peer-to-peer (P2P) video and voice streaming. In Pookiz, the calling system is orchestrated as follows:
1. **The Signaling Server (LiveKit):** Peers cannot connect directly without exchanging media information (SDP) and connection candidates (ICE). We use LiveKit as the central signaling hub.
2. **Access Token API:** When User A calls User B, they make a request to `/api/livekit/token` on our Next.js API server to verify credentials and generate a signed access token.
3. **P2P Connection:** The client uses the token to join a room on the LiveKit server. LiveKit negotiates the WebRTC connection.
4. **SFU Fallback:** If a direct P2P connection is blocked by strict firewalls, LiveKit acts as an SFU (Selective Forwarding Unit), routing the media streams through its servers.

### Q8: Explain the difference between Next.js Server Components and Client Components.
**Answer:**
1. **React Server Components (RSC):**
   - Rendered on the server. Output is HTML sent to browser.
   - Zero client-side JavaScript bundle overhead.
   - Can access databases and secret keys safely.
2. **Client Components (`'use client'`):**
   - Hydrated and rendered in the browser.
   - Can use `useState`, `useEffect`, event listeners.
   - Cannot access server keys or direct DB connections.

In Pookiz, page layouts and data-fetching are Server Components. Interactive elements like the message input, emoji picker, and quiz timer are Client Components.

### Q9: What is the purpose of `middleware.ts` in Next.js and how does Pookiz use it?
**Answer:**
`middleware.ts` is a special Next.js file that runs on EVERY request BEFORE it reaches any route handler or page component. It runs at the Edge (closest server to the user) making it extremely fast.

In Pookiz, middleware serves two purposes:
1. **Auth Gate:** Checks if the user has a valid session cookie. If not, redirects unauthenticated users from protected routes (`/chat`, `/quiz`, `/profile`) to the login page.
2. **Session Refresh:** Calls `supabase.auth.getUser()` which automatically refreshes expired JWT tokens by rotating cookies, keeping the user logged in seamlessly.

This centralized approach means even if we add 20 new routes, they're automatically protected — we never need to add auth checks per-route.

### Q10: How does Google OAuth (PKCE flow) work in Pookiz?
**Answer:**
PKCE (Proof Key for Code Exchange) prevents authorization code interception:

1. The client generates a random `code_verifier` string and hashes it to create a `code_challenge`.
2. The client redirects to Google's OAuth URL, passing the `code_challenge`.
3. Google authenticates the user and redirects back with an `authorization_code`.
4. The client exchanges `authorization_code` + original `code_verifier` for a JWT access token.
5. Google verifies that `hash(code_verifier) === code_challenge` — proving the same client that initiated the request is completing it.

This prevents man-in-the-middle attacks where an attacker intercepts the authorization code — without the `code_verifier`, the code is useless.

### Q11: What is the difference between stateless and stateful authentication? Which does Supabase use?
**Answer:**
**Stateful (Sessions):** The server stores session data in memory or a database. Every request sends a session ID, the server looks it up, and retrieves the user's state. Problem: if the server crashes or scales to multiple instances, session data is lost or inconsistent.

**Stateless (JWT):** The server issues a self-contained token (JWT) signed with a private key. Every request sends the JWT, and the server verifies the signature and extracts user data from the token itself — no database lookup needed. Problem: tokens cannot be revoked before expiry.

Supabase uses **JWT-based stateless auth** with short-lived access tokens (1 hour) and long-lived refresh tokens stored in HTTP-only cookies. This scales horizontally — any server instance can verify a JWT without shared session storage.

### Q12: Explain how push notifications work in Pookiz end-to-end.
**Answer:**
1. **Subscription:** When a user logs in, the browser generates a unique `PushSubscription` object containing an endpoint URL and encryption keys (p256dh, auth). This is sent to our Next.js API and stored in the `push_subscriptions` table.
2. **Triggering:** When User B receives a message, our server (or a Supabase function) calls `webpush.sendNotification()` with User B's subscription object, a VAPID private key for authentication, and the notification payload.
3. **Delivery:** The push service (Google FCM for Chrome, Mozilla for Firefox) delivers the notification to the browser, even if Pookiz is not open.
4. **Display:** Our `service-worker.js` receives the `push` event and calls `self.registration.showNotification()` to display the notification.
5. **Click handler:** The service worker's `notificationclick` event navigates to the correct chat route when clicked.

---

## SECTION 3: High-Performance Frontend

### Q13: What is layout reflow, and how did you optimize scrolling performance on mobile?
**Answer:**
Layout Reflow is the process where the browser's layout engine recalculates the physical positions and sizes of all elements in the DOM tree after a change.

In Pookiz, hiding the mobile header originally used `marginTop: -72px` on scroll, which triggered full layout reflow on every scroll frame (~60 times per second) since all elements below shifted position. This dropped framerate to ~25 FPS.

**Fix:** Changed the header to `position: absolute` (removing it from document flow) and animated using `transform: translateY(-100%)`. Since `transform` is processed on the GPU compositor thread and bypasses layout calculations, the transition runs at 60 FPS regardless of document size.

### Q14: What is the Virtual DOM and how does React's reconciliation algorithm work?
**Answer:**
The Virtual DOM is a lightweight JavaScript object representation of the real DOM tree. React uses it to minimize expensive real DOM operations.

When state changes:
1. React creates a new Virtual DOM tree.
2. React's **Diffing Algorithm** (part of Fiber reconciliation) compares old vs new tree.
3. It identifies the minimum set of changes (insertions, deletions, updates).
4. Only those specific changes are applied to the real DOM.

React's key optimizations:
- **Same type components:** Reuse existing DOM node, update only changed props.
- **Different type components:** Destroy old subtree completely and mount new one.
- **List keys:** `key` prop tells React which item is which — so moving items in a list only repositions existing DOM nodes instead of re-rendering all of them.

### Q15: How does the auto-expanding textarea pattern work in React, and how does it prevent infinite render loops?
**Answer:**
1. When the user types, we reset the style height: `textarea.style.height = 'auto'`.
2. We then read `textarea.scrollHeight` — the height needed to fit all content.
3. We apply it directly: `textarea.style.height = '${textarea.scrollHeight}px'`.
4. This does NOT trigger an infinite render loop because we modify **inline DOM style directly** rather than updating React state, which would trigger a re-render.

Reading `scrollHeight` after writing `height: auto` forces a synchronous layout, giving the accurate natural height. This is intentional layout thrashing (read-after-write) — acceptable here because it happens once per keystroke, not in a loop.

### Q16: What is the React `useEffect` hook and what are its common mistakes?
**Answer:**
`useEffect` runs side effects after the component renders — things like data fetching, subscriptions, or DOM manipulations.

```typescript
useEffect(() => {
  // Effect code runs after render
  const subscription = channel.subscribe();

  // Cleanup function runs before next effect or component unmount
  return () => {
    subscription.unsubscribe();
  };
}, [dependency]); // Re-runs when "dependency" changes
```

**Common mistakes:**
1. **Missing dependency:** Effect uses a variable but doesn't list it in deps → uses stale value.
2. **Infinite loop:** Effect updates state → re-render → effect runs again → updates state → ...
   Fix: either add a condition, or use `useRef` instead of state.
3. **No cleanup:** Subscriptions or timers not cleaned up → memory leak and errors after component unmounts.
4. **Async function directly in useEffect:** `useEffect(async () => ...)` doesn't work as expected. Wrap async logic: `useEffect(() => { async function load() {...} load(); }, [])`.

### Q17: What is `useMemo` and `useCallback`? When should you use them?
**Answer:**
Both are React optimization hooks that cache values to prevent unnecessary recomputation.

**`useMemo`** — memoizes the RESULT of a calculation:
```typescript
// Recalculates only when quizAttempts or filters change
const filteredAttempts = useMemo(() => {
  return quizAttempts.filter(a => a.score > filters.minScore);
}, [quizAttempts, filters.minScore]);
```

**`useCallback`** — memoizes a FUNCTION reference:
```typescript
// Creates a new function reference only when userId changes
const sendMessage = useCallback((text: string) => {
  sendToAPI({ userId, text });
}, [userId]);
```

**When to use:** Only when you can measure a performance problem. Premature memoization adds complexity without benefit — `useMemo` and `useCallback` themselves have overhead. Use when: a component re-renders frequently, a calculation is expensive (>1ms), or a callback is passed to a memoized child component (`React.memo`).

---

## SECTION 4: TypeScript

### Q18: What is a TypeScript generic? Give a practical example from Pookiz.
**Answer:**
A generic is a type parameter — a placeholder replaced with a real type when called.

In Pookiz:
```typescript
type ApiResponse<T> = {
  data: T | null;
  error: string | null;
};

// For a profile query — T becomes Profile
const result: ApiResponse<Profile> = await fetchProfile(id);
// result.data is Profile | null

// For a quiz list query — T becomes Quiz[]
const quizResult: ApiResponse<Quiz[]> = await fetchQuizzes();
// quizResult.data is Quiz[] | null
```

One type definition works for all API responses without duplication.

### Q19: What is the difference between `type` and `interface` in TypeScript?
**Answer:**
- **`interface`** is specifically for describing object shapes. It supports declaration merging and `extends`.
- **`type`** can describe any type — objects, unions, primitives, tuples.

```typescript
// Only type can do this:
type Status = "pending" | "accepted"; // union
type StringOrNumber = string | number;
type ID = string; // alias for primitive

// Both can describe objects:
interface User { id: string; name: string; }
type User = { id: string; name: string; }

// Interface can extend:
interface Student extends User { university: string; }

// Type uses intersection:
type Student = User & { university: string; };
```

**My rule:** Use `type` for most things. Use `interface` when extending third-party types.

### Q20: What are TypeScript utility types? Name and explain five.
**Answer:**
- **`Partial<T>`** — all fields optional. Use for update functions.
- **`Required<T>`** — all fields required (reverse of Partial).
- **`Pick<T, Keys>`** — extract specific fields: `Pick<User, 'id' | 'username'>`.
- **`Omit<T, Keys>`** — remove specific fields: `Omit<User, 'passwordHash'>`.
- **`Record<K, V>`** — object with key type K and value type V: `Record<string, number>`.
- **`ReturnType<T>`** — gets return type of a function.
- **`Awaited<T>`** — unwraps a Promise: `Awaited<Promise<string>> = string`.

---

## SECTION 5: Testing

### Q21: What is the testing pyramid? How does it apply to Pookiz?
**Answer:**
The testing pyramid prioritizes: many unit tests (fast, isolated) → fewer integration tests → very few E2E tests (slow, complex).

In Pookiz:
- **Unit tests:** Score calculation, input validation functions, date formatting utilities (~40 tests, run in <5 seconds)
- **Integration tests:** API routes — friend request, quiz submission, message sending (~15 tests, run in ~30 seconds)
- **E2E tests:** Full user flows — login, send a message, submit a quiz (~5 tests, run in ~2 minutes)

I run unit + integration on every push, E2E only before major releases.

### Q22: What is the difference between mocking, stubbing, and spying?
**Answer:**
All three replace real dependencies in tests, but with different levels of control:

- **Mock:** A complete fake replacement. You control what it does and can assert how it was called. `jest.fn()` creates mocks.
- **Stub:** Returns a fixed, preset response. Less powerful than a mock — doesn't verify behavior.
- **Spy:** Wraps the REAL implementation and records calls. The real code runs, but you can verify it was called with the right arguments.

In Jest, `jest.spyOn(object, 'method')` creates a spy. `jest.fn()` creates a full mock.

### Q23: How do you test an asynchronous function that makes a database call?
**Answer:**
```typescript
// 1. Mock the database module
jest.mock("@/lib/supabase/server");
import { createClient } from "@/lib/supabase/server";

// 2. Set up mock behavior
const mockFrom = jest.fn();
const mockSelect = jest.fn();
const mockEq = jest.fn();
const mockSingle = jest.fn();

(createClient as jest.Mock).mockResolvedValue({
  from: mockFrom.mockReturnValue({
    select: mockSelect.mockReturnValue({
      eq: mockEq.mockReturnValue({
        single: mockSingle
      })
    })
  })
});

// 3. Test
it("returns user profile", async () => {
  mockSingle.mockResolvedValue({
    data: { id: "123", username: "arpit" },
    error: null
  });

  const profile = await getUserProfile("123");
  expect(profile.username).toBe("arpit");
});
```

---

## SECTION 6: CI/CD & DevOps

### Q24: What happens when you push code to GitHub in Pookiz's deployment pipeline?
**Answer:**
1. GitHub Actions workflow triggers automatically.
2. A Ubuntu VM is provisioned with Node.js.
3. `npm ci` installs exact dependencies from `package-lock.json`.
4. `tsc --noEmit` runs TypeScript type checking.
5. `npm run lint` runs ESLint checks.
6. `npm test` runs all test files.
7. `npm run build` compiles the Next.js app (verifies it builds successfully).
8. If all steps pass, Vercel detects the push and builds + deploys to production automatically.
9. If any step fails, the pipeline stops, deployment is prevented, and I receive a GitHub notification.

### Q25: What is the difference between `npm install` and `npm ci`?
**Answer:**
`npm install` reads `package.json`, resolves versions, and may update `package-lock.json`. Used during development.

`npm ci` reads `package-lock.json` exactly, installs exact versions, never modifies the lock file, and deletes `node_modules` first. Used in CI pipelines for deterministic, reproducible builds — ensures the production build uses exactly the same package versions as tested locally.

---

## SECTION 7: Error Handling

### Q26: What is the difference between a 401 and 403 HTTP status code?
**Answer:**
- **401 Unauthorized:** The user is NOT authenticated. We don't know who they are. The server is saying "I need credentials before I can respond." Action: redirect to login.
- **403 Forbidden:** The user IS authenticated, but they don't have permission. The server knows who you are and is saying "I know who you are, but you're not allowed to do this." Action: show "Access Denied."

In Pookiz: Accessing `/chat` without being logged in → 401. Being logged in but trying to join a private group you weren't invited to → 403.

### Q27: Why should server-side error details never be sent to the client?
**Answer:**
Raw error messages like `duplicate key value violates unique constraint "friends_user_id_1_user_id_2_key"` reveal:
1. Your database schema structure (table and column names)
2. Your constraint naming conventions
3. Which operations are failing and why

This information helps attackers map your database structure, identify potential SQL injection points, and understand your business logic. The rule: **log everything on the server, send generic messages to the client.**

---

## SECTION 8: System Design

### Q28: How would you scale Pookiz from 1,000 to 1,000,000 concurrent users?
**Answer:**
**At 1,000 users (today):** Single Supabase instance is fine. Vercel auto-scales serverless functions.

**At 10,000 users:** Add Supabase read replicas for read traffic. Implement Redis caching for frequently accessed data (quiz lists, university data). Add rate limiting.

**At 100,000 users:** Horizontal scaling of Next.js behind a load balancer with sticky sessions (WebSocket connections). Move from Supabase Realtime to dedicated Redis Pub/Sub for message broadcasting. Add a CDN (already have Vercel Edge). Database connection pooling with PgBouncer.

**At 1,000,000 users:** Database sharding by university_id. Separate services for different domains (messaging service, notification service, quiz service). Event-driven architecture with Kafka for message queues. Global multi-region deployment.

### Q29: What is a CDN and what content should be cached there?
**Answer:**
A CDN (Content Delivery Network) is a geographically distributed network of servers. When a user requests content, it is served from the nearest CDN node, reducing latency.

**Cache on CDN:**
- Static assets: JS bundles, CSS, fonts, icons (immutable — cache forever with content hash in filename)
- Profile photos, quiz images (cache for days, bust cache on update)
- SSG pages — pre-rendered quiz landing pages

**Don't cache on CDN:**
- API responses (dynamic, user-specific)
- Pages requiring authentication
- Real-time data

Vercel's Edge Network automatically caches Pookiz's static assets and SSG pages globally, serving Indian users from Mumbai/Singapore nodes instead of US origin servers.

### Q30: What is database connection pooling and why is it needed?
**Answer:**
PostgreSQL handles connections by spawning a dedicated OS process per connection. At 100 connections, this is 100 processes using hundreds of MB of RAM. Opening and closing connections per request adds 5–20ms latency.

Connection pooling maintains a pool of persistent connections that are reused across requests. PgBouncer is the standard tool — it sits between the application and PostgreSQL, managing a pool of 20-50 persistent DB connections while handling thousands of concurrent app connections.

Supabase uses PgBouncer in Transaction mode by default for the anonymous key, and Session mode for authenticated connections. In Next.js serverless functions (which run per-request), direct PostgreSQL connections would exhaust the connection limit. The pooler keeps connection count bounded.

---

## SECTION 9: Security

### Q31: How does Pookiz prevent SQL injection?
**Answer:**
Supabase's JavaScript client uses **parameterized queries** under the hood. When you write:
```typescript
supabase.from("profiles").select("*").eq("username", username)
```
The client generates a parameterized SQL query where `username` is passed as a parameter, not interpolated into the string. This means even if `username` contains `'; DROP TABLE profiles; --`, the database treats it as a literal string value, not executable SQL.

We never construct raw SQL strings with user input. When we do write raw SQL (in RPCs or migrations), we use `$1, $2` parameter placeholders: `SELECT * FROM profiles WHERE username = $1`.

### Q32: What is CORS and how does Next.js handle it?
**Answer:**
CORS (Cross-Origin Resource Sharing) is a browser security mechanism. By default, browsers block JavaScript on `domain-a.com` from making requests to `domain-b.com`. CORS headers tell the browser which origins are allowed.

In Pookiz, our API routes are on `pookiz.vercel.app` and the client is also on `pookiz.vercel.app` — same origin, so no CORS issues for the primary app. However, for any external clients or if we ever expose a public API, we'd add:
```typescript
// next.config.ts
async headers() {
  return [{
    source: "/api/:path*",
    headers: [
      { key: "Access-Control-Allow-Origin", value: "https://trusted-domain.com" },
      { key: "Access-Control-Allow-Methods", value: "GET,POST,PUT,DELETE" },
    ]
  }]
}
```

### Q33: What is a JWT and how does Supabase use it for authentication?
**Answer:**
A JWT (JSON Web Token) is a compact, URL-safe token with three parts separated by dots: `header.payload.signature`.

- **Header:** Algorithm used for signing (e.g., `HS256`)
- **Payload:** Claims — user data like `{ "sub": "user-uuid", "role": "authenticated", "email": "arpit@gla.ac.in" }`
- **Signature:** `HMACSHA256(base64(header) + "." + base64(payload), SECRET_KEY)`

Supabase issues a JWT on login. For every request, the client sends this JWT in the `Authorization` header. Supabase verifies the signature using its JWT secret — if it matches, the user is authenticated. No database lookup needed (stateless).

The JWT also contains `role: "authenticated"` and `sub: "user-uuid"` — Supabase's PostgreSQL injects these as session variables (`auth.uid()`, `auth.role()`) which RLS policies use directly.

---

## SECTION 10: Practical Debugging

### Q34: How would you debug a situation where real-time messages are not being delivered?
**Answer:**
Systematic approach:
1. **Check the Supabase subscription:** `console.log` the subscription status. Is it `SUBSCRIBED` or `CHANNEL_ERROR`?
2. **Check the channel name:** Is the subscriber listening to the same channel name as the broadcaster?
3. **Check RLS policies:** Are RLS policies blocking the subscriber from seeing new rows? Test by temporarily disabling RLS.
4. **Check the network:** Open Chrome DevTools → Network → WS tab. Is the WebSocket connection established? Are frames being received?
5. **Check filters:** If the subscription has filters (e.g., `eq('recipient_id', userId)`), verify the `userId` is correct and matches the actual inserted row.
6. **Check Supabase logs:** Supabase dashboard → Logs → Realtime shows dropped events and errors.

### Q35: A quiz page is loading slowly (3 seconds). How would you diagnose and fix it?
**Answer:**
1. **Open Chrome DevTools → Network tab.** Identify the slowest requests. Is it the API response? Static assets? Database query?
2. **If API is slow:** Add `console.time()` / `console.timeEnd()` around each database query. Identify the bottleneck query.
3. **Add `EXPLAIN ANALYZE`** to the slow query in Supabase SQL editor. Look for Sequential Scans on large tables.
4. **Add missing indexes:** If the query filters by `creator_id` and no index exists, `CREATE INDEX ON quizzes(creator_id)`.
5. **If it's N+1 queries:** Instead of fetching quiz then each question separately, fetch everything in one query using `select('*, quiz_attempts(*)')`.
6. **Add caching:** For quiz detail pages that don't change frequently, add `revalidate: 60` on the server fetch.
7. **Use `next/dynamic`** to lazy-load heavy client components (quiz player, charts) instead of including them in the initial bundle.

---

## SECTION 11: Architecture Decisions

### Q36: Why did you choose Supabase over Firebase or a custom Node.js backend?
**Answer:**
Three specific reasons:

1. **PostgreSQL + RLS:** Firebase uses NoSQL (Firestore) with client-side security rules that are complex and error-prone. Supabase's PostgreSQL with RLS enforces access rules at the database engine level — more reliable, more powerful for relational data like friendships and group memberships.

2. **Realtime via WAL:** Supabase Realtime uses PostgreSQL's built-in Write-Ahead Log for real-time subscriptions — no extra infrastructure. Firebase Realtime Database and Firestore also offer realtime, but with NoSQL which doesn't suit Pookiz's complex relational queries (e.g., "get all mutual friends of user A and user B").

3. **No custom backend needed:** Supabase provides Auth, Storage, Database, and Edge Functions out of the box. A custom Node.js + Express backend would require maintaining user management, JWT issuance, refresh rotation, and session management from scratch — weeks of work that Supabase handles automatically.

### Q37: Why did you use Next.js App Router instead of Pages Router?
**Answer:**
App Router (introduced in Next.js 13) provides three key advantages for Pookiz:

1. **React Server Components:** Data fetching in Server Components means sensitive queries (profile data, group settings) run on the server — no API route needed, no client-side secret exposure.

2. **Nested Layouts:** The sidebar and header are persistent layout components in `app/layout.tsx` that don't re-render on navigation — only the page content area changes. This provides app-like navigation performance.

3. **Route Groups:** I can group routes logically (auth routes, dashboard routes, quiz routes) without affecting the URL structure, keeping the codebase organized at scale.

Pages Router was not chosen because it uses client-side data fetching patterns that would expose more logic to the client and require additional API routes.

### Q38: What is the JSONB column type and why did you use it for quiz questions?
**Answer:**
JSONB is PostgreSQL's binary JSON storage. Unlike TEXT, it is parsed into binary format on insert, making field-level queries fast (e.g., `questions->>'correct'`).

I used JSONB for quiz questions because:
1. **Flexible schema:** Questions can have different structures (MCQ, fill-in-the-blank, coding) without requiring separate database tables for each type.
2. **No JOIN overhead:** All questions for a quiz are in one column — a single query retrieves the complete quiz without joins.
3. **Rich querying:** PostgreSQL can query into JSONB: `WHERE questions @> '[{"difficulty": "hard"}]'`.

Trade-off: JSONB cannot be normalized or have foreign key constraints. Answer key validation happens in the API layer before storage.

### Q39: How does the anti-cheat warning system work and how do you handle race conditions?
**Answer:**
**Detection:** The browser's `visibilitychange` event fires when a student switches tabs. The `blur` event fires when they click outside the browser window. Both trigger a silent API call with a `sequence_id` increment.

**Race condition problem:** If a student switches tabs 3 times in 100ms, three HTTP requests reach the server simultaneously. Each reads the current `warnings_count` as `2`, adds 1, and writes `3` — all three writes produce the same value instead of `3`, `4`, `5`.

**Solution:** PostgreSQL row lock with `SELECT FOR UPDATE` inside a transaction:
```sql
BEGIN;
SELECT warnings_count FROM quiz_attempts WHERE id = $1 FOR UPDATE;
-- Row is now locked — other transactions must wait
UPDATE quiz_attempts SET warnings_count = warnings_count + 1 WHERE id = $1;
COMMIT;
-- Lock released — next transaction can proceed
```
The `FOR UPDATE` lock ensures sequential processing of concurrent warning increments.

### Q40: If you were to rebuild Pookiz from scratch knowing what you know now, what would you do differently?
**Answer:**
Three things:

1. **Add testing from day one.** I built all features first and wrote no tests. Retroactively adding tests to existing complex code is much harder. I would write tests alongside features — especially for the score calculation and anti-cheat warning logic which are correctness-critical.

2. **Use React Query from the start instead of manual fetch + useState.** Throughout the codebase, I have dozens of components with `const [data, setData] = useState(null)` + `useEffect(() => { fetch(...) }, [])`. This is boilerplate that React Query eliminates. Switching now requires refactoring many components.

3. **Define TypeScript types centrally in a `types/` directory first.** Types evolved organically — `Profile` is defined differently in 3 places. A central `types/index.ts` with all domain types (`User`, `Message`, `Quiz`, `Group`) would be defined first, and all components would import from there. This prevents type drift as the app grows.
