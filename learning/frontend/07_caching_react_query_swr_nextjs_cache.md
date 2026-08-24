# Frontend Chapter 07: Caching — SWR, React Query & Next.js Cache

This chapter explains data caching from scratch — what it is, why it matters, and how to avoid making unnecessary API calls in your React/Next.js app.

---

## 1. Objective & Placement Value
- **Why this is asked:** "How do you prevent redundant API calls?" and "How do you keep UI data fresh?" are very common in interviews. Caching is the difference between an app that loads in 100ms and one that loads in 3 seconds.
- **Placement Value:** Shows you optimize for real-world performance, not just correctness.

---

## 2. The Layman's Analogy

Think of a **library member checking out books**:

**Without caching:** Every time a student wants to read "Data Structures by Cormen", they go to the library (make an API call), wait for the librarian to find it (server processes query), read it, return it. Next time they want it, they repeat the whole process.

**With caching:** The first time they get the book, they make a **photocopy** and keep it at their desk. Next time they need it, they grab the photocopy instantly. If the book is updated (new edition), they check if their copy is still current. If not, they get a fresh copy.

Caching = storing data locally so you don't have to re-fetch it every time.

---

## 3. The Technical Specification

### A. Why Cache?

| Situation | Without Cache | With Cache |
| :--- | :--- | :--- |
| User navigates back to a page they visited | Full re-fetch (1-3 seconds) | Instant (data already in memory) |
| Multiple components need the same data | Each makes its own API call | One fetch, shared across all components |
| Network is slow/offline | App freezes waiting | Shows cached data immediately |
| Same data fetched in 100ms | 100 API calls per second | 1 real API call, 99 served from cache |

---

### B. SWR — Stale-While-Revalidate

**SWR** (by Vercel) is a React hook for data fetching with built-in caching. The name comes from a caching strategy:

- **Stale:** Show the old (cached) data immediately
- **While:** ...while simultaneously
- **Revalidate:** Fetching fresh data in the background

```
User visits page
       ↓
SWR checks: "Do I have cached data for this URL?"
       ↓
YES → Show cached data immediately (no loading spinner!)
    → Fetch fresh data in background
    → When fresh data arrives, update UI silently
       ↓
NO  → Show loading state
    → Fetch data
    → Cache it and show it
```

**Installing SWR:**
```bash
npm install swr
```

**Basic usage:**
```typescript
import useSWR from "swr";

// The "fetcher" function: how to actually fetch data
const fetcher = (url: string) => fetch(url).then((res) => res.json());

function UserProfile({ userId }: { userId: string }) {
  // useSWR(key, fetcher)
  // key = unique identifier for this data (usually the API URL)
  const { data, error, isLoading } = useSWR(
    `/api/users/${userId}`,  // the cache key
    fetcher                  // function that fetches data
  );

  if (isLoading) return <div>Loading profile...</div>;
  if (error) return <div>Failed to load profile</div>;

  return (
    <div>
      <h1>{data.username}</h1>
      <p>{data.bio}</p>
    </div>
  );
}
```

**What SWR does automatically:**
- Caches the response so the next component that calls `useSWR('/api/users/123')` gets instant data
- Re-fetches when the browser tab regains focus (user switches back to your app)
- Re-fetches at a regular interval if you configure `refreshInterval`
- Shares the same request if multiple components request the same key simultaneously

---

### C. SWR Advanced Patterns

**Conditional fetching:**
```typescript
// Only fetch if userId exists (not null/undefined)
const { data } = useSWR(
  userId ? `/api/users/${userId}` : null,  // null = don't fetch
  fetcher
);
```

**Dependent fetching (fetch B after A returns):**
```typescript
// First fetch the user
const { data: user } = useSWR("/api/auth/user", fetcher);

// Then fetch their profile only if user is available
const { data: profile } = useSWR(
  user?.id ? `/api/profiles/${user.id}` : null,
  fetcher
);
```

**Optimistic updates (update UI before server confirms):**
```typescript
import useSWR, { mutate } from "swr";

function FriendButton({ friendId }: { friendId: string }) {
  const { data: friendshipStatus } = useSWR(
    `/api/friends/status/${friendId}`,
    fetcher
  );

  async function addFriend() {
    // OPTIMISTIC: Update UI immediately, before API responds
    mutate(
      `/api/friends/status/${friendId}`,
      { status: "pending" },  // new local value
      false                   // false = don't re-fetch yet
    );

    // Send actual API request
    const success = await sendFriendRequest(friendId);

    if (!success) {
      // Roll back if it failed
      mutate(`/api/friends/status/${friendId}`);
    }
  }

  return (
    <button onClick={addFriend}>
      {friendshipStatus?.status === "pending" ? "Request Sent" : "Add Friend"}
    </button>
  );
}
```

---

### D. React Query (TanStack Query) — More Powerful Alternative

**React Query** (now called TanStack Query) is more feature-rich than SWR. It is the industry standard for complex data fetching:

```bash
npm install @tanstack/react-query
```

**Setup (wrap your app once):**
```typescript
// app/layout.tsx
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,   // data is "fresh" for 5 minutes
      gcTime: 10 * 60 * 1000,     // remove from cache after 10 minutes of inactivity
    },
  },
});

export default function RootLayout({ children }) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
}
```

**Fetching with `useQuery`:**
```typescript
import { useQuery } from "@tanstack/react-query";

function QuizList() {
  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ["quizzes", "public"],   // cache key (array, uniquely identifies this query)
    queryFn: () => fetch("/api/quizzes").then(r => r.json()),
    staleTime: 2 * 60 * 1000,         // fresh for 2 minutes
  });

  if (isLoading) return <QuizSkeleton />;
  if (isError) return <button onClick={() => refetch()}>Retry</button>;

  return <QuizGrid quizzes={data} />;
}
```

**Mutations (creating/updating data):**
```typescript
import { useMutation, useQueryClient } from "@tanstack/react-query";

function CreateQuizForm() {
  const queryClient = useQueryClient();

  const createMutation = useMutation({
    mutationFn: (newQuiz) =>
      fetch("/api/quizzes", {
        method: "POST",
        body: JSON.stringify(newQuiz),
      }).then(r => r.json()),

    onSuccess: () => {
      // After creating a quiz, invalidate the quiz list cache
      // This triggers a re-fetch of the quiz list
      queryClient.invalidateQueries({ queryKey: ["quizzes"] });
    },

    onError: (error) => {
      toast.error("Failed to create quiz: " + error.message);
    },
  });

  return (
    <button
      onClick={() => createMutation.mutate({ title: "New Quiz", questions: [] })}
      disabled={createMutation.isPending}
    >
      {createMutation.isPending ? "Creating..." : "Create Quiz"}
    </button>
  );
}
```

---

### E. Next.js Built-In Cache (Server-Side)

Next.js App Router has its own server-side caching for Server Components:

```typescript
// app/quiz/page.tsx — Server Component (default)

// Option 1: Cache forever (until manually revalidated)
// Good for: data that rarely changes (university list, categories)
const data = await fetch("https://api.example.com/data", {
  cache: "force-cache",
});

// Option 2: Revalidate every N seconds (ISR — Incremental Static Regeneration)
// Good for: data that changes occasionally (quiz list)
const data = await fetch("/api/quizzes", {
  next: { revalidate: 60 }, // re-fetch max once per 60 seconds
});

// Option 3: Never cache (always fresh)
// Good for: user-specific data (profile, messages)
const data = await fetch("/api/my-profile", {
  cache: "no-store",
});
```

**Route segment config (applies to the whole page):**
```typescript
// Makes the entire page dynamic (no caching)
export const dynamic = "force-dynamic";

// OR: Revalidate the page every 30 seconds
export const revalidate = 30;
```

---

### F. When to Use What

| Scenario | Use |
| :--- | :--- |
| Server Component data fetching | Next.js `fetch()` with cache options |
| Client-side data that changes rarely | SWR with long `refreshInterval` |
| Complex client-side data with mutations | React Query |
| Real-time data (messages, presence) | Supabase Realtime (no cache needed) |
| User-specific data (profile, settings) | `cache: "no-store"` + SWR on client |
| Shared data (quiz list, university list) | `revalidate: 60` on server + React Query on client |

---

## 4. Edge Cases & Best Practices

- **Cache keys must be unique per data set.** If two different queries use the same key, SWR/React Query thinks they're the same data. Include filter parameters in the key:
  ```typescript
  useQuery({ queryKey: ["quizzes", { scope: "university", page: 2 }] })
  ```

- **Always handle loading and error states.** Never assume data is available. Always show skeletons or spinners while loading and error messages on failure.

- **Invalidate caches after mutations.** After creating or deleting a quiz, call `queryClient.invalidateQueries(['quizzes'])` so the list re-fetches fresh data.

- **Don't cache sensitive data aggressively.** Messages and private profile data should have short `staleTime` (or no caching) to prevent showing stale private information.

---

## 5. Staff Engineer Viva Board

### Q1: What is Stale-While-Revalidate and why is it better than loading spinners?
**Answer:**
*"Stale-While-Revalidate (SWR) is a caching strategy where you immediately serve cached (possibly stale) data while simultaneously re-fetching fresh data in the background. When the fresh data arrives, the UI updates silently.*

*It is better than loading spinners because users see content instantly instead of waiting. This improves perceived performance significantly — the app feels fast even if the data is a few seconds old. For most use cases (quiz list, profile data, feed posts), showing 30-second-old data instantly is much better than making the user wait 1–2 seconds for a spinner to resolve.*

*SWR is ideal for read-heavy data that changes infrequently. For real-time data (chat messages, live scores), Supabase Realtime subscriptions are more appropriate."*

### Q2: What is a React Query `queryKey` and why does its structure matter?
**Answer:**
*"A `queryKey` is a unique identifier that React Query uses to cache and look up query results. It is typically an array.*

*Its structure matters because React Query uses it hierarchically:*
```typescript
['quizzes']                                    // all quizzes
['quizzes', { scope: 'university' }]           // filtered subset
['quizzes', 'abc-123']                         // specific quiz
```

*When you call `invalidateQueries({ queryKey: ['quizzes'] })`, it invalidates ALL queries whose key STARTS WITH `['quizzes']` — including filtered and specific queries. This means creating a new quiz automatically refreshes all quiz list variants without needing to specify each one.*

*Good key design separates entity type, filters, and IDs hierarchically to enable both specific and bulk cache invalidations."*

### Q3: What is the difference between SWR and React Query?
**Answer:**
*"Both are data fetching libraries with caching, but:*

*- **SWR:** Simpler, smaller (~4KB), by Vercel. Great for straightforward GET requests. Mutations are manual.*
*- **React Query:** More powerful, larger (~12KB). Has built-in mutation support (`useMutation`), automatic re-fetching after mutations, pagination helpers, infinite queries, and devtools. Better for complex apps with heavy CRUD operations.*

*I use SWR for simple data fetching in small components and React Query for complex pages (quiz management) that require mutations, cache invalidation, and optimistic updates."*

### Q4: What is the difference between `staleTime` and `gcTime` in React Query?
**Answer:**
*"`staleTime` defines how long data is considered 'fresh'. During this period, React Query will NOT re-fetch — it returns cached data immediately. After `staleTime` expires, the data is 'stale' and React Query will re-fetch in the background the next time the query is used.*

*`gcTime` (garbage collection time, previously `cacheTime`) defines how long unused data stays in memory cache after all components using it unmount. If you navigate away from a page, the data stays cached for `gcTime` so re-navigating is instant. After `gcTime`, the data is purged from memory.*

*Example: `staleTime: 60000, gcTime: 300000` — fresh for 1 minute, cached in memory for 5 minutes after the component unmounts."*
