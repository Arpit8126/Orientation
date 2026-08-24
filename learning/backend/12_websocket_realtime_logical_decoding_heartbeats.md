# Backend Chapter 12: WebSocket Realtime Streams & Database Replication

This module covers the execution of Supabase Realtime WebSockets in Pookiz, detailing logical database replication, WebSocket framing, heartbeat checks, and real-time state synchronization.

---

## 1. Objective & Placement Value
- **Why this is asked:** Real-time data synchronization is core to chat networks and live feeds. Technical interviewers evaluate your understanding of WebSocket connections, database WAL (Write-Ahead Log) logical replication systems, socket event loops, and handling connection drops.
- **Placement Value:** Prepares you to design scalable publish/subscribe brokers and build highly responsive, real-time state synchronization engines.

---

## 2. The Layman's Analogy
Think of the real-time WebSocket connection as a **persistent direct hotline between you and the campus records office**:
- **HTTP Polling (Asking repeatedly):** You run to the receptionist every 5 seconds to ask: *"Do I have mail?"*. This is slow, tires you out, and clutters the lobby.
- **Supabase Realtime (The Hotline):** You set up a direct telephone hotline (WebSocket connection).
- **Logical Decoding (The Wiretapper):** The records clerk has a wiretapper listening to the office's logbook writes (Postgres Write-Ahead Log).
- **The Event Push:** The moment a package is logged in the book, the wiretapper alerts the clerk, who immediately speaks into the hotline: *"Package received!"*. This updates your screen instantly.

---

## 3. The Technical Specification

### A. PostgreSQL WAL & Supabase Realtime logical decoding
Supabase Realtime leverages PostgreSQL's WAL logical replication system:
1. **Replication Slots:** Supabase creates a logical replication slot on the database server.
2. **Logical Decoding:** A daemon reads the binary WAL logs and decodes them into structured JSON events (e.g., inserts, updates, deletes).
3. **Phoenix Channels (WebSockets):** The real-time container (written in Elixir/Phoenix) broadcasts these events to active WebSocket connections matching the client filters (e.g. `table = messages`).

### B. WebSocket Lifecycle & Connection Management
WebSocket connections run over a stateful TCP connection:
- **Ping/Pong Heartbeats:** Every few seconds, the client sends a `Ping` packet. The server must immediately reply with `Pong` to verify the connection is active.
- **Auto-Reconnect:** If the heartbeat fails or the connection drops (due to network changes), the client client closes the socket, attempts to reconnect with exponential backoff, and re-subscribes to all active channels.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the client-side real-time listener hook in [`d:\Pookiz\pookiz-app\src\hooks\useRealtime.ts`](file:///d:/Pookiz/pookiz-app/src/hooks/useRealtime.ts) to see how it binds database events:

```typescript
import { useEffect } from 'react'
import { createClient } from '@/lib/supabase/client'

export function useRealtime(
  channelName: string,
  event: string,
  schema: string,
  table: string,
  filter: string,
  callback: (payload: any) => void
) {
  useEffect(() => {
    const supabase = createClient()
    
    const channel = supabase
      .channel(channelName)
      .on(
        'postgres_changes' as any,
        {
          event: event,
          schema: schema,
          table: table,
          filter: filter,
        },
        (payload) => {
          callback(payload)
        }
      )
      .subscribe()
```
- **Line 4-11:** Defines the custom `useRealtime` hook with dynamic subscription parameters.
- **Line 13:** Initializes the Supabase browser client.
- **Line 15-28:** Instantiates a new subscription channel and configures the listener:
  - It listens for `postgres_changes` events.
  - It applies filters to receive only updates matching the target table, schema, and query filters.
  - When an event matches, it fires the callback function.

```typescript
    return () => {
      supabase.removeChannel(channel)
    }
  }, [channelName, event, schema, table, filter, callback])
}
```
- **Line 31-33:** Defines the cleanup function. When the component unmounts or parameters change, it unsubscribes from the channel, closing the socket listener to prevent memory leaks.

---

## 5. Edge Cases & Optimizations
- **Browser Tab Backgrounding:** Modern browsers freeze JavaScript execution in background tabs to save battery. This can pause heartbeats, causing the WebSocket connection to drop.
  - *Fix:* Use the Page Visibility API to detect when the tab becomes active, and force a socket reconnect if it was disconnected.
- **Replication Egress Limits:** If client connections listen to entire tables (e.g., streaming all messages), it creates high egress traffic.
  - *Optimization:* Configure RLS policies to restrict real-time updates to only authorized rows, and use specific filters (e.g., `filter: 'group_id=eq.' + groupId`) to stream only relevant events.

---

## 6. Staff Engineer Viva Board

### Q1: Walk me through the execution loop of database logical replication. How does a write in PostgreSQL reach a client browser in real time?
**Answer:**
*"The real-time synchronization loop works as follows:
1. A transaction inserts a row into the `messages` table. This write is logged to PostgreSQL's Write-Ahead Log (WAL) on disk.
2. Supabase Realtime's logical decoding process reads this WAL stream, decodes the raw binary data, and formats it as a JSON payload.
3. The Realtime server matches the event against active client subscriptions.
4. If a client is subscribed with a matching filter (e.g. `table=messages`), the server pushes the JSON payload down the client's open WebSocket connection.
5. The client application receives the payload and updates its React state, rendering the new message bubble instantly."*

### Q2: Why is it critical to unsubscribe from channels inside the `useEffect` cleanup function?
**Answer:**
*"If we omit the cleanup function:
1. When a React component (like a chat window) unmounts and remounts, the old subscription channel remains open in the browser's memory.
2. Every remount creates a new subscription channel, multiplying connections.
3. This creates a **memory leak** where the client accumulates multiple active subscriptions to the same channel, causing excessive WebSocket traffic and duplicate events.
4. Eventually, the browser will exceed its WebSocket connection limit, and the client will exhaust system resources. `removeChannel` guarantees that outdated connections are closed."*

### Q3: How do you handle network drops and offline states in WebSocket connections?
**Answer:**
*"We handle network drops using:
1. **Heartbeat Pings:** The client sends ping frames to the server. If the server does not respond within a timeout window, the client closes the socket connection.
2. **Auto-Reconnection:** Once closed, the client client attempts to reconnect using exponential backoff (e.g., waiting 1s, then 2s, 4s, 8s...) to avoid overloading the server.
3. **State Resynchronization:** When the connection is re-established, the client queries the database via HTTP APIs to fetch any missed messages that occurred while offline, keeping the UI synchronized."*

### Q4: What is the purpose of RLS (Row Level Security) in Supabase Realtime subscriptions?
**Answer:**
*"RLS policies apply to real-time WebSocket subscriptions. 

If RLS is not enabled, any authenticated user could subscribe to the `messages` table and receive database insert events for *all* messages on the platform, causing a major data leak. 

With RLS enabled, the Supabase Realtime server reads the caller's JWT, evaluates the table's SELECT policy, and only broadcasts the database events for rows that the caller is authorized to see, protecting user privacy."*

### Q5: Why is logical replication better than HTTP polling for real-time chat applications?
**Answer:**
*"- **HTTP Polling:** The client makes repeated HTTP requests to the server to check for new messages. This consumes high server CPU, bandwidth, and database resources because it runs a full query lifecycle (TCP setup, auth, database connection) even when there is no new data.
- **Logical Replication:** Maintains a single, open WebSocket connection. The server only pushes data when a database write occurs. This reduces network overhead, cuts database query load, and achieves sub-second latency."*
