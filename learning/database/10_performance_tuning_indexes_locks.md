# Database Chapter 10: Performance Tuning, Indexes & Lock Contention

This module covers database optimization techniques in PostgreSQL, detailing indexing strategies, table lock types, transaction isolation levels, and vacuum engine optimization.

---

## 1. Objective & Placement Value
- **Why this is asked:** High-performance database operations are critical to scaling high-throughput social applications. Interviewers test on how to optimize queries, analyze execution plans, resolve transaction locks, and manage vacuum operations.
- **Placement Value:** Equips you to diagnose and resolve performance bottlenecks in production databases.

---

## 2. The Layman's Analogy
Think of database optimization as **managing a busy university bookstore**:
- **Index Optimization:** Instead of searching every shelf for a book, you keep a catalog index.
- **Table Locks:** If someone is updating a shelf's inventory (writing), they block others from browsing it (reading). If you lock the entire store (table-level lock) instead of a single shelf (row-level lock), customers will form a long line outside, causing delays.
- **Vacuuming:** When a book is sold (deleted), rather than reorganizing the shelves immediately, the clerk leaves the space empty. Periodically, a cleaning crew (**the Vacuum process**) cleans up the empty spaces so new books can fit there.

---

## 3. The Technical Specification

### A. Query Plan Operations in PostgreSQL
When PostgreSQL receives a query, the planner creates a plan consisting of specific operations:
1. **Sequential Scan (Seq Scan):** Scans the entire table heap page-by-page. Highly inefficient for large tables.
2. **Index Scan:** Traverses the B-Tree index to retrieve Tuple IDs (TIDs), and then loads the corresponding pages from the heap.
3. **Index Only Scan:** If the query selects only columns that are part of the index, the planner reads data directly from the index nodes, bypassing heap reads.
4. **Bitmap Index Scan:** Used when a query filters on multiple columns or returns many rows. It reads the index, builds a bitmap of matching heap pages in memory, and then loads the pages in sequential disk order, minimizing disk head movement.

### B. Table-Level and Row-Level Locks
Concurrency control requires locking to maintain data consistency:
- **Shared Locks (`AccessShareLock`):** Acquired by read queries (`SELECT`). Multiple transactions can hold shared locks simultaneously.
- **Exclusive Locks (`RowExclusiveLock`, `AccessExclusiveLock`):** Acquired by write queries (`INSERT`, `UPDATE`, `DELETE`) or structural operations (`ALTER TABLE`). Prevent other transactions from modifying or reading the target rows or tables.
- **Lock Contention:** Occurs when a transaction blocks others (e.g., a long-running update holding a write lock), causing queue backlogs and timeouts.

### C. MVCC, Dead Tuples & The Vacuum Engine
Because PostgreSQL updates and deletes rows by creating new versions (MVCC), the old row versions (dead tuples) remain on disk:
- **Dead Tuples:** Occupy disk space and slow down sequential scans.
- **Auto-Vacuum:** A background daemon that scans tables, marks dead tuple space as reusable for future inserts, and updates table statistics for the query planner.
- **Vacuum Full:** Rewrites the entire table heap to disk, reclaiming physical disk space at the cost of acquiring an exclusive table lock that blocks all reads and writes.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze index strategies and execution optimization from [`d:\Pookiz\supabase\migration.sql`](file:///d:/Pookiz/supabase/migration.sql):

```sql
CREATE INDEX IF NOT EXISTS idx_messages_group ON public.messages(group_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_dm ON public.messages(sender_id, recipient_id, created_at DESC);
```
- **Line 125:** Creates a composite index on `(group_id, created_at DESC)`. This pre-sorts group messages on disk, allowing the query planner to retrieve them instantly in order without needing a separate sorting step in memory.
- **Line 128:** Creates a composite index on `(sender_id, recipient_id, created_at DESC)`. This enables fast index scans for private conversations between two users:
  ```sql
  SELECT * FROM messages 
  WHERE sender_id = :user_a AND recipient_id = :user_b 
  ORDER BY created_at DESC;
  ```

---

## 5. Edge Cases & Optimizations
- **Write Hotspots (WAL Serialization):** High-frequency message insertions create write bottlenecks in the database.
  - *Fix:* Ensure the database WAL is configured with group commits and use connection poolers.
- **Low selectivity indexes:** Indexing columns that have low selectivity (e.g., boolean flags like `is_banned` on a table where 99% of values are false) is inefficient. The query planner will default to a Sequential Scan because traversing the index tree adds unnecessary overhead when selecting almost all rows.
  - *Fix:* Avoid indexing low-selectivity columns, or use **Partial Indexes** (e.g., index only banned profiles).

---

## 6. Staff Engineer Viva Board

### Q1: What is Lock Contention, and how would you resolve a lock backlog in a production environment?
**Answer:**
*"Lock Contention occurs when multiple concurrent transactions wait for a resource locked by another transaction. For example, if a batch update holds an exclusive lock on the `profiles` table, all concurrent user updates are blocked.

To resolve this:
1. I query the `pg_locks` and `pg_stat_activity` system catalogs to identify the blocking transaction ID and its current query state.
2. I terminate the blocking query using `pg_cancel_backend(pid)` or `pg_terminate_backend(pid)` if it is stuck.
3. To prevent future contention, I break large updates into smaller batches, ensure queries use indexes to minimize lock times, and configure lock timeouts (`SET lock_timeout = '5s'`) to prevent queries from waiting indefinitely."*

### Q2: What is the difference between an Index Scan and a Bitmap Index Scan in PostgreSQL?
**Answer:**
*"- **Index Scan:** The database traverses the B-Tree to find a matching key, reads the TID (ItemPointer), and immediately performs a random I/O read on the heap disk page to load the row. This is highly efficient when returning a few rows.
- **Bitmap Index Scan:** If a query returns many rows, performing random I/O reads for every row is slow. Instead, the engine scans the index, builds a bitmap of matching heap page locations in memory, sorts the page list to match sequential disk order, and then reads the heap pages in sequence, converting random I/O into fast sequential I/O."*

### Q3: What is the purpose of the `VACUUM` process in PostgreSQL, and why is `VACUUM FULL` dangerous to run in production?
**Answer:**
*"`VACUUM` scans tables to locate dead tuples (old row versions left by MVCC updates/deletes) and marks their disk space as reusable for future inserts. It runs in the background without blocking reads or writes.

`VACUUM FULL` is dangerous because:
1. It creates a brand new copy of the table heap on disk, copying only live tuples.
2. It requires an exclusive lock (`AccessExclusiveLock`) on the table for the duration of the run.
3. This lock blocks all concurrent queries (both reads and writes), making the table completely unavailable to the application and causing service outages."*

### Q4: Explain the difference between `NULLS FIRST` and `NULLS LAST` in index ordering. Why does it matter for queries?
**Answer:**
*"By default, PostgreSQL sorts null values as larger than non-null values. In a descending index (`DESC`), nulls are sorted first. 

If your application queries:
```sql
SELECT * FROM tea_posts ORDER BY created_at DESC NULLS LAST;
```
but the index is built as `created_at DESC` (which defaults to `NULLS FIRST`), the query planner cannot use the index directly for sorting. It would have to perform a manual sort step in memory. To optimize, the index definition must match the query's null ordering."*

### Q5: How does the query planner choose between a Sequential Scan and an Index Scan?
**Answer:**
*"The query planner makes cost-based decisions using table statistics generated by `ANALYZE`:
1. It estimates the number of rows the query will return.
2. If the query is estimated to return a large percentage of the table's rows (usually > 15-20%), traversing the B-Tree index and performing random I/O reads on the heap becomes more expensive than reading the entire table heap sequentially.
3. In this case, the planner will choose a Sequential Scan over an Index Scan.
If table statistics are outdated, the planner may make incorrect decisions, which is why regular auto-vacuuming is critical."*
