# Database Chapter 12: System Design — Rate Limiting, Sharding, CDN & Scaling

This chapter explains large-scale system design concepts from scratch. These are the concepts asked in senior-level interviews when they say "Design Instagram" or "How would you scale Pookiz to 10 million users?"

---

## 1. Objective & Placement Value
- **Why this is asked:** System Design is asked in ALL mid-to-senior level interviews at product companies (Flipkart, Meesho, Swiggy, PhonePe, Google, etc.).
- **Placement Value:** This single topic is the difference between a ₹6LPA offer and a ₹25LPA offer. It shows architectural thinking — not just writing code, but designing systems that handle millions of users.

---

## 2. The Layman's Analogy

Think of **scaling a dhaba (small restaurant) into McDonald's**:

**The small dhaba (your app now):**
- 1 chef (1 server)
- 1 counter (1 database)
- Handles 50 customers/day

**The problem:** 50,000 customers show up one day. The chef burns out, the counter collapses.

**System design = planning your dhaba infrastructure for 50,000 customers:**
- Multiple chefs (horizontal scaling)
- Separate counters for different items (database sharding)
- Pre-cooked popular items ready at the counter (caching)
- Delivery workers at different locations (CDN)
- Security guard at the door who says "slow down, only 100 per minute" (rate limiting)

---

## 3. The Technical Specification

### A. The Three Laws of Scale

Before designing anything large, these three laws guide every decision:

1. **Premature optimization is the root of all evil** — Don't scale until you need to. Build simple first.
2. **Stateless > Stateful** — Servers that don't store user state are easier to scale (just add more servers).
3. **Cache everything you can** — The fastest operation is one that doesn't need to happen.

---

### B. Rate Limiting — The Security Guard

**Problem:** Without rate limiting, a user (or bot) can send 10,000 API requests per second, crashing your server.

**Rate limiting** = restricting how many requests a user/IP can make in a time window.

```
Standard user:   100 requests per minute
API consumers:   1000 requests per minute
Unauthenticated: 20 requests per minute
```

**Algorithms for rate limiting:**

**1. Fixed Window Counter (simplest):**
```
Window: 00:00 - 00:59 → User sends 100 requests → BLOCKED
Window: 01:00 - 01:59 → Counter resets → User can send 100 more
```
Problem: User can send 100 at 00:59 and 100 at 01:00 — 200 in 2 seconds, bypassing the "per minute" limit.

**2. Sliding Window (better):**
```
At any moment, look back 60 seconds
Count requests in that window
If > limit, block
```
This prevents the burst attack.

**3. Token Bucket (most common in practice):**
```
Imagine a bucket with tokens
Bucket holds max 100 tokens
Tokens refill at rate: 10 per second
Each request costs 1 token
If bucket is empty → request is rejected (429 Too Many Requests)
```

**Implementation in Next.js using Upstash Redis:**
```typescript
// lib/rate-limit.ts
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

// Create a rate limiter: 10 requests per 10 seconds
const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, "10 s"),
  analytics: true,
});

// In your API route:
export async function POST(request: NextRequest) {
  // Use the user's IP as the identifier
  const ip = request.ip ?? "anonymous";

  const { success, limit, remaining, reset } = await ratelimit.limit(ip);

  if (!success) {
    return NextResponse.json(
      { error: "Too many requests. Please slow down." },
      {
        status: 429,
        headers: {
          "X-RateLimit-Limit": limit.toString(),
          "X-RateLimit-Remaining": remaining.toString(),
          "X-RateLimit-Reset": new Date(reset).toISOString(),
        },
      }
    );
  }

  // Process the request...
}
```

---

### C. Horizontal vs Vertical Scaling

**Vertical Scaling (Scale Up) — Make your server bigger:**
```
Small server (2 CPU, 4GB RAM) → Big server (32 CPU, 128GB RAM)
```
- **Pros:** Simple, no architecture change
- **Cons:** Has a physical limit. Very expensive. Single point of failure.

**Horizontal Scaling (Scale Out) — Add more servers:**
```
1 server → 10 servers behind a load balancer
```
- **Pros:** Theoretically unlimited scale. If one server fails, others continue.
- **Cons:** Requires a load balancer. Stateful apps need session sharing.

**For Pookiz at 100K users:**
```
                    [Load Balancer]
                   /       |       \
         [Server 1]  [Server 2]  [Server 3]
                   \       |       /
              [Supabase Database]
```

The load balancer distributes requests across servers using strategies:
- **Round Robin:** 1→2→3→1→2→3 (equal distribution)
- **Least Connections:** Send to server with fewest active connections
- **IP Hash:** Same user always goes to same server (sticky sessions for WebSockets)

---

### D. Database Scaling

**Read Replicas (for read-heavy apps):**
```
Write goes to: [Primary DB] (1 server)
Reads go to:  [Replica 1] [Replica 2] [Replica 3]
                (copies of primary, updated every millisecond)
```
90% of social app operations are reads (viewing posts, loading profiles). Replicas handle reads while the primary handles only writes.

In Supabase: automatic read replicas available in paid plans.

**Sharding (partitioning data across multiple databases):**
```
Without sharding: ALL 10 million users in 1 database → too large, too slow
With sharding by university_id:
  Shard 1: GLA University users
  Shard 2: VIT University users
  Shard 3: IIT Delhi users
```

A router function decides which shard to query:
```typescript
function getShard(universityId: string): Database {
  const shardNumber = hash(universityId) % NUMBER_OF_SHARDS;
  return shards[shardNumber];
}
```

**When to shard:** Usually > 50 million rows with performance problems. Premature sharding adds massive complexity.

---

### E. CDN — Content Delivery Network

**Problem:** Pookiz is hosted in the US. A student in Mathura, UP loads the app. Data travels: Mathura → US → Mathura. This adds ~200ms latency.

**CDN Solution:** A CDN (like Cloudflare, AWS CloudFront) has servers everywhere — Mumbai, Delhi, Singapore, London. When a student requests a static file (image, CSS, JS):

```
WITHOUT CDN:
Student (Mathura) → US Server (3000 km) → takes 150ms

WITH CDN:
Student (Mathura) → Mumbai CDN node (500 km) → takes 15ms
```

**What to put on CDN:**
- ✅ Images (profile photos, quiz images)
- ✅ CSS and JavaScript files
- ✅ Static HTML pages (quiz landing pages)
- ❌ API responses (dynamic data)
- ❌ Private user data

**Vercel's Edge Network** (what Pookiz uses) is already a CDN — your Next.js static files and SSG pages are cached globally at Vercel's edge nodes. No extra setup needed.

---

### F. Caching Layers

In a large system, caching exists at multiple levels:

```
Request Flow:
Browser → [Browser Cache] → CDN → [Edge Cache] → Server → [Redis Cache] → Database
                                                    ↑
                                             Check here first!
```

**Redis as a cache layer:**
```typescript
// Before querying database, check Redis cache
async function getQuiz(quizId: string) {
  const cacheKey = `quiz:${quizId}`;

  // Try cache first
  const cached = await redis.get(cacheKey);
  if (cached) return JSON.parse(cached);

  // Cache miss → query database
  const { data } = await supabase
    .from("quizzes")
    .select("*")
    .eq("id", quizId)
    .single();

  // Store in cache for 5 minutes
  await redis.setex(cacheKey, 300, JSON.stringify(data));

  return data;
}
```

---

### G. Message Queues — Handling Traffic Spikes

**Problem:** When 1000 students submit their quiz answers simultaneously, your database cannot handle 1000 simultaneous writes.

**Solution:** A message queue (like RabbitMQ, Redis Queue, or AWS SQS):
```
1000 students → [Message Queue] → workers process one by one → Database
```

```
BEFORE (without queue):
1000 concurrent writes → Database overloaded → errors → data loss

AFTER (with queue):
1000 submissions → Queue (stores them safely)
→ 10 workers each process 100 submissions → Database gets steady stream
```

---

## 4. System Design Interview Framework — "Design Twitter for Campuses"

When asked a system design question, follow this structure:

```
1. CLARIFY REQUIREMENTS (2 minutes)
   - How many users? (1000 students per university, 50 universities)
   - What are the core features? (post, comment, direct message, groups)
   - Read-heavy or write-heavy? (mostly reads — viewing posts)
   - What's the expected latency? (<200ms page load)

2. ESTIMATE SCALE (2 minutes)
   - Daily Active Users: 10,000
   - Messages per day: 100,000
   - Storage needed: 1TB/year (with media)

3. HIGH-LEVEL DESIGN (5 minutes)
   - Draw the main components: clients, load balancer, servers, database, cache, CDN
   - Show data flow: user sends message → API → DB → realtime → recipient

4. DEEP DIVE (10 minutes)
   - Pick the most complex component and explain in detail
   - Explain your database schema choices
   - Explain how you handle the bottleneck

5. SCALING (5 minutes)
   - What breaks first at 10x traffic?
   - How do you fix it?
```

---

## 5. Staff Engineer Viva Board

### Q1: What is the difference between horizontal and vertical scaling? When would you choose each?
**Answer:**
*"Vertical scaling means upgrading the existing server to a more powerful machine — more CPUs, more RAM. It's simple (no architecture change) but has a ceiling — the biggest server AWS offers is ~12TB RAM, after which you cannot go further. It's also a single point of failure.*

*Horizontal scaling means adding more servers and distributing load between them with a load balancer. It's theoretically unlimited but requires stateless server design — sessions and state must live in a shared store (Redis), not on individual servers.*

*For Pookiz in early stages: vertical scaling is fine — just upgrade the Supabase plan. At 100K+ concurrent users, switch to horizontal: multiple Next.js instances behind a load balancer with sticky sessions for WebSocket connections."*

### Q2: How does a CDN improve performance and what types of content should be cached there?
**Answer:**
*"A CDN (Content Delivery Network) is a global network of edge servers geographically distributed worldwide. When a user requests a file, the CDN serves it from the nearest edge node instead of the origin server, reducing latency from hundreds of milliseconds to tens.*

*Content to cache on CDN:*
*- Static assets: JS bundles, CSS files, fonts, icons (cache for months)*
*- Profile photos and quiz images (cache for days with cache-busting on update)*
*- Pre-rendered HTML pages (SSG quiz landing pages)*

*Content NOT to cache:*
*- API responses (dynamic, user-specific)*
*- Authenticated user data (private)*
*- Real-time data (messages, presence)*

*Vercel automatically distributes Next.js static assets and SSG pages via its global edge network, so Pookiz users in India get assets from Mumbai/Singapore nodes, not US servers."*

### Q3: What is database sharding and what are its trade-offs?
**Answer:**
*"Database sharding is partitioning data across multiple database instances, each holding a subset of the data. A routing layer determines which shard to query based on a shard key.*

*Trade-offs:*
*Benefits: Distributes write load across shards; each shard is smaller → faster queries; horizontal scaling for write-heavy apps.*
*Costs: Cross-shard queries become complex and slow; JOIN operations across shards are not natively supported; adding or removing shards requires re-balancing (re-sharding) which is extremely complex; transactions across shards require distributed transaction protocols (2PC).*

*I would not shard Pookiz until we hit 50+ million rows with measurable performance degradation. Before sharding, I'd exhaust simpler strategies: read replicas, indexing improvements, Redis caching, and vertical scaling."*

### Q4: What is rate limiting and what algorithm would you use for Pookiz's API?
**Answer:**
*"Rate limiting restricts how many requests a user or IP can make in a time window to prevent abuse, DoS attacks, and system overload.*

*For Pookiz, I'd use the **sliding window algorithm** with differentiated limits by user type:*
*- Unauthenticated requests: 20 per minute (strict — prevents scraping)*
*- Authenticated users: 100 requests per minute (normal usage)*
*- Quiz submission API: 1 per quiz per user (strict — prevent score manipulation)*
*- Friend request API: 20 per hour (prevent spam)*

*Implementation: Upstash Redis with the `@upstash/ratelimit` library. Redis is chosen because it is:*
*1. Shared across all server instances (unlike in-memory counters which are per-instance)*
*2. Atomic operations with `INCR` and `EXPIRE` prevent race conditions*
*3. Very fast (in-memory database) — rate limit check adds <5ms latency."*

### Q5: Explain the CAP theorem and how it applies to Pookiz.
**Answer:**
*"The CAP theorem states that in a distributed system, you can only guarantee TWO of these three properties simultaneously:*

*- **C (Consistency):** All nodes see the same data at the same time*
*- **A (Availability):** Every request receives a response (not necessarily the latest data)*
*- **P (Partition Tolerance):** System continues working even if network splits between nodes*

*Since network partitions are inevitable in distributed systems, you must always tolerate P. So the real choice is: **CP or AP**.*

*Pookiz's Supabase (PostgreSQL) is a **CP system**: it prioritizes data consistency over availability. During a network partition, it will reject writes to maintain consistency rather than allowing divergent data that would need complex reconciliation later.*

*For the chat feature specifically, this means: if two users both edit the same message simultaneously, only one write succeeds. This is the correct trade-off for a messaging app where data correctness is critical."*
