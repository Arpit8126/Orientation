# Database Chapter 06: Notification Ledger & Real-Time Alert Indexes

This module covers the database architecture of the Notification system in Pookiz, detailing the alert schema, query optimizations, deep-link parameter routing, and transactional notification cleanup.

---

## 1. Objective & Placement Value
- **Why this is asked:** High-frequency messaging systems generate massive notification streams. Technical interviewers focus on efficient indexing for unread counts, horizontal scaling of notification logs, transactional messaging triggers, and how metadata handles deep-link routing.
- **Placement Value:** Demonstrates your capability to design high-throughput activity ledger layers and optimize database indexes for notification badges.

---

## 2. The Layman's Analogy
Think of the notification ledger as a **campus central mail cubby wall**:
- **Personal Mailboxes:** Each student has a private slot. If another student tags them or replies to their post, a notification card is dropped in their slot.
- **Broadcast Mail (Campus-wide newsletters):** If the dean wants to notify every student on campus, they don't print millions of letters. They stick a single master announcement card on the main bulletin board (**is_broadcast = true**).
- **The Red Badge (Unread counter):** Next to your mailbox slot, a red flag rises if there is unread mail. The mail clerk uses a special directory sheet (**the index**) to quickly check if you have any unread cards without sorting through all the letters.

---

## 3. The Technical Specification

### A. The Notifications Schema
Notifications inside Pookiz are registered in a central log table:
- **`recipient_id` (UUID FK, Nullable):** Points to the profile receiving the alert. Set to `NULL` for broadcast notifications.
- **`title` / `content` (TEXT):** Represents the notification headers.
- **`is_read` (BOOLEAN):** Tracks read state, defaulted to `false`.
- **`is_broadcast` (BOOLEAN):** If set to `true`, indicates a platform-wide alert.

```
                              ┌──────────────────┐
                              │  notifications   │
                              └────────┬─────────┘
            ┌──────────────────────────┼──────────────────────────┐
            ▼                          ▼                          ▼
   ┌──────────────────┐       ┌──────────────────┐       ┌──────────────────┐
   │   recipient_id   │       │     is_read      │       │   is_broadcast   │
   │  (Personal Slot) │       │ (Unread Tracker) │       │ (Campus-wide Map)│
   └──────────────────┘       └──────────────────┘       └──────────────────┘
```

### B. Deep-Link Payload Modeling
Notifications need to route users to specific app locations when clicked (e.g., navigating directly to a post's comment drawer or a user's profile card).
In advanced versions of the notification system:
- A nullable **`url`** or **`metadata`** JSONB column stores deep-linking parameters:
  - For post alerts: `{"type": "tea_post", "post_id": "post-uuid"}`
  - For social alerts: `{"type": "profile", "user_id": "user-uuid"}`
The client reads these parameters and routes the user to the correct view.

---

## 4. Line-by-Line Code Walkthrough
Let's inspect the notification schema setup from [`d:\Pookiz\supabase\migration.sql`](file:///d:/Pookiz/supabase/migration.sql):

```sql
-- NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_broadcast BOOLEAN DEFAULT false,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);
```
- **Line 105-113:** Defines the notifications ledger.
  - `recipient_id` references `profiles(id) ON DELETE CASCADE`. If a profile is deleted, its notifications are cleaned up.
  - `is_read` defaults to `false`, representing the initial unread state.

```sql
CREATE INDEX IF NOT EXISTS idx_notif_recipient ON public.notifications(recipient_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notif_broadcast ON public.notifications(is_broadcast, created_at DESC);
```
- **Line 135:** Creates a composite index on `(recipient_id, is_read)`. This index is optimized for queries looking for unread notifications for a specific user:
  ```sql
  SELECT COUNT(*) FROM notifications WHERE recipient_id = :user_id AND is_read = false;
  ```
- **Line 136:** Creates an index on `(is_broadcast, created_at DESC)` to fetch campus-wide announcements sorted by recency.

---

## 5. Edge Cases & Optimizations
- **Write Hotspots and Write Lock Cascades:** High-activity platforms generate high volumes of notification writes, causing write bottlenecks in the database.
  - *Fix:* Queue notification writes in an in-memory queue (like Redis) and batch-insert them into the database, rather than writing to disk for every single user interaction.
- **Index Selectivity Degradation:** As users accumulate read notifications, the `is_read` boolean column becomes less selective (e.g., 99% of rows are `true`).
  - *Optimization:* Create a **Partial Index** to index only unread notifications, reducing index size:
    ```sql
    CREATE INDEX idx_unread_notifications 
    ON public.notifications(recipient_id) 
    WHERE (is_read = false);
    ```

---

## 6. Staff Engineer Viva Board

### Q1: What is a Partial Index, and how would it optimize the notification unread badge query in Pookiz?
**Answer:**
*"A **Partial Index** is an index built over a subset of a table defined by a conditional filter expression:
```sql
CREATE INDEX idx_unread_notifications 
ON public.notifications(recipient_id) 
WHERE (is_read = false);
```
Normally, a composite index on `(recipient_id, is_read)` indexes every single notification row. In a production system, 99% of notifications are read. Indexing them is a waste of disk space and slows down inserts.

By creating a partial index filtered with `WHERE (is_read = false)`, we only index unread notifications. This keeps the index small and fast, optimizing the unread count queries while reducing write overhead."*

### Q2: Why did we define `recipient_id` as nullable in the `notifications` table?
**Answer:**
*"We defined `recipient_id` as nullable to support **broadcast notifications** (campus-wide announcements). 
- If a notification is directed to a specific user (e.g., a friend request or comment reply), `recipient_id` holds their profile UUID.
- If a notification is an announcement for all students, `recipient_id` is set to `NULL` and `is_broadcast` is set to `true`. 
This allows us to support both notification models in a single table layout without duplicating columns."*

### Q3: How does the index `idx_notif_broadcast` on `(is_broadcast, created_at DESC)` optimize loading the campus notifications feed?
**Answer:**
*"When a user opens their notifications page, the application loads their personal notifications AND campus-wide announcements:
```sql
SELECT * FROM notifications 
WHERE recipient_id = :user_id OR is_broadcast = true 
ORDER BY created_at DESC;
```
Without the index `(is_broadcast, created_at DESC)`, PostgreSQL would have to perform a full table scan to locate broadcast records and sort them by date in memory. 

The index pre-sorts broadcast records on disk. This allows the query optimizer to locate the newest announcements instantly using an index scan, reducing query times."*

### Q4: Explain the difference between logical delete cascades and database triggers for notification cleanups.
**Answer:**
*"- **Logical Delete Cascades (`ON DELETE CASCADE`):** Executed by the database engine based on table references. If a user deletes their profile, the database automatically deletes all rows in `notifications` where `recipient_id` matches. This is fast and handled internally.
- **Database Triggers:** Custom PL/pgSQL code that executes when an event occurs. We use triggers when the cleanup logic is more complex than a simple row deletion (e.g., checking constraints, updating cached values, or sending log updates to other tables)."*

### Q5: How would you scale the notifications system to support push queues for millions of events?
**Answer:**
*"To scale notifications to millions of events:
1. **Decouple Database Writes:** Instead of writing to the database directly inside API routes, we send events to a fast message broker (like **RabbitMQ** or **Apache Kafka**).
2. **Worker Pool:** A pool of background worker processes consumes events from the queue, handles the database writes in batches, and triggers push notifications.
3. **Write Batching:** Workers aggregate inserts and run them inside a single transaction to reduce WAL write overhead and prevent database locks."*
