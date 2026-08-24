# Database Chapter 11: Messaging Schema — Conversations, Messages & Reactions

This module covers the complete database schema for Pookiz's real-time messaging system, including DM conversations, group messaging, message threading, reactions, and the RLS policies that enforce privacy.

---

## 1. Objective & Placement Value
- **Why this is asked:** Designing messaging schemas is one of the top system design interview topics. Interviewers evaluate normalization decisions, indexing for chronological reads, handling soft deletes, and enforcing privacy via RLS policies.
- **Placement Value:** Prepares you to architect scalable chat systems on relational databases and articulate the trade-offs between normalization and query performance.

---

## 2. The Layman's Analogy
Think of the messaging schema as a **campus courier service**:
- **`conversations`** = The mail routing slip — identifies the two people in a DM exchange.
- **`conversation_participants`** = The authorized recipient list — only people on this list can read the mail.
- **`groups` / `group_members`** = The department bulletin board and its subscriber list.
- **`messages`** = Individual mail letters — each belongs to either a DM route or a board.
- **`message_reactions`** = The sticky "reaction" stamps that recipients paste on a letter.

---

## 3. The Complete Messaging Schema

### A. Conversations Table (DM Container)
```sql
CREATE TABLE public.conversations (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```
A `conversation` is a container entity — it has no user data itself. It is simply the "channel" that two users share.

### B. Conversation Participants (DM Access Control)
```sql
CREATE TABLE public.conversation_participants (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  user_id         UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  joined_at       TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(conversation_id, user_id)
);
```
- Each DM has exactly **two rows** in `conversation_participants` — one for each participant.
- `UNIQUE(conversation_id, user_id)` prevents a user from being added twice.
- RLS policies check `conversation_participants` before allowing any `messages` read/write.

**Creating a new DM conversation:**
```sql
-- Step 1: Create the conversation
INSERT INTO conversations DEFAULT VALUES RETURNING id;

-- Step 2: Add both participants
INSERT INTO conversation_participants (conversation_id, user_id)
VALUES (:conv_id, :user_a_id), (:conv_id, :user_b_id);
```

### C. Messages Table
```sql
CREATE TABLE public.messages (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,  -- DM
  group_id        UUID REFERENCES groups(id) ON DELETE CASCADE,          -- Group
  sender_id       UUID REFERENCES profiles(id) ON DELETE SET NULL,
  message_text    TEXT,
  media_url       TEXT,
  reply_to_id     UUID REFERENCES messages(id) ON DELETE SET NULL,
  is_deleted      BOOLEAN DEFAULT false,
  edited_at       TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT NOW(),

  -- Enforce: each message belongs to EITHER a DM OR a group, never both
  CONSTRAINT exactly_one_target CHECK (
    (conversation_id IS NOT NULL AND group_id IS NULL)
    OR
    (conversation_id IS NULL AND group_id IS NOT NULL)
  )
);
```
- The `CHECK` constraint enforces that a message cannot belong to both a conversation and a group simultaneously.
- `ON DELETE SET NULL` for `sender_id` means if a user deletes their account, their messages remain (attributed to a null sender) — preserving conversation history.
- `ON DELETE SET NULL` for `reply_to_id` means if the quoted message is deleted, the reply quote becomes null (not cascade-deleted).

### D. Message Reactions Table
```sql
CREATE TABLE public.message_reactions (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
  user_id    UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  emoji      TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(message_id, user_id, emoji)
);
```
- `UNIQUE(message_id, user_id, emoji)` prevents a user from reacting with the same emoji twice on the same message.
- Multiple different emojis from the same user on the same message are allowed.
- Reactions are purged when the message is deleted (`ON DELETE CASCADE`).

---

## 4. Critical Indexes for Chat Performance

### A. Chronological Message Reads
```sql
-- The most common query: "Get the last N messages in this conversation"
CREATE INDEX idx_messages_conversation_created
  ON messages(conversation_id, created_at DESC)
  WHERE conversation_id IS NOT NULL;

CREATE INDEX idx_messages_group_created
  ON messages(group_id, created_at DESC)
  WHERE group_id IS NOT NULL;
```
- Composite indexes on `(conversation_id, created_at)` allow PostgreSQL to perform **Index Scans** instead of full table scans when fetching messages.
- `WHERE conversation_id IS NOT NULL` is a **partial index** — it indexes only DM messages, keeping the index smaller and faster.

### B. Checking DM Existence
```sql
-- "Do users A and B already have a conversation?"
CREATE INDEX idx_conv_participants_user
  ON conversation_participants(user_id, conversation_id);
```
This index supports the query that checks before creating a duplicate DM:
```sql
SELECT cp1.conversation_id
FROM conversation_participants cp1
JOIN conversation_participants cp2
  ON cp1.conversation_id = cp2.conversation_id
WHERE cp1.user_id = :user_a AND cp2.user_id = :user_b
LIMIT 1;
```

---

## 5. RLS Policies for Messages

### A. DM Message Read Policy
```sql
CREATE POLICY "Users can read messages in their conversations"
  ON messages FOR SELECT
  USING (
    conversation_id IN (
      SELECT conversation_id
      FROM conversation_participants
      WHERE user_id = auth.uid()
    )
  );
```
- Users can only read messages where they are a participant in the conversation.
- This is enforced at the database layer — even if a client sends a direct API query, they cannot read another user's DMs.

### B. Group Message Read Policy
```sql
CREATE POLICY "Users can read messages in their groups"
  ON messages FOR SELECT
  USING (
    group_id IN (
      SELECT group_id
      FROM group_members
      WHERE user_id = auth.uid()
    )
  );
```

### C. Message Insert Policy
```sql
CREATE POLICY "Authenticated users can send messages"
  ON messages FOR INSERT
  WITH CHECK (
    sender_id = auth.uid()
    AND (
      -- Must be a participant in the conversation
      conversation_id IN (SELECT conversation_id FROM conversation_participants WHERE user_id = auth.uid())
      OR
      -- Must be a member of the group
      group_id IN (SELECT group_id FROM group_members WHERE user_id = auth.uid())
    )
  );
```
- The `sender_id = auth.uid()` check prevents users from sending messages as other users.

### D. Message Delete Policy (Soft Delete)
```sql
CREATE POLICY "Users can soft-delete their own messages"
  ON messages FOR UPDATE
  USING (sender_id = auth.uid())
  WITH CHECK (is_deleted = true);  -- can only set is_deleted, not modify other fields
```
- Users cannot hard-delete messages (DELETE is not permitted by RLS).
- They can only UPDATE their own messages to set `is_deleted = true`.

---

## 6. Staff Engineer Viva Board

### Q1: Why is the conversations table a separate entity with no user data? Why not just store both user IDs in the messages table?
**Answer:**
*"If we stored both user IDs directly in the messages table (e.g., `user_a_id`, `user_b_id`), every query for 'my conversations' would require:
```sql
SELECT * FROM messages WHERE user_a_id = :me OR user_b_id = :me
```
This is an expensive full-scan that doesn't scale.

By creating a separate `conversations` table and `conversation_participants` table:
1. We can query 'my conversations' using the indexed `conversation_participants` table: `SELECT conversation_id FROM conversation_participants WHERE user_id = :me`.
2. The message table schema is symmetric — it only has `conversation_id`, not biased toward `user_a` or `user_b`.
3. The design naturally extends to group chats (many participants) without schema changes."*

### Q2: Explain the `CHECK` constraint on the messages table that prevents a message from belonging to both a DM and a group.
**Answer:**
*"Without the constraint, a developer could accidentally (or maliciously) insert a message with both `conversation_id` and `group_id` set. This would create an inconsistent record that appears in two different contexts.

The CHECK constraint:
```sql
CONSTRAINT exactly_one_target CHECK (
  (conversation_id IS NOT NULL AND group_id IS NULL)
  OR
  (conversation_id IS NULL AND group_id IS NOT NULL)
)
```
enforces that exactly one of the two foreign keys is non-null, preventing ambiguous message records. The database engine validates this on every INSERT and UPDATE."*

### Q3: Why is a partial index used on the messages table?
**Answer:**
*"A partial index only includes rows matching a WHERE condition:
```sql
CREATE INDEX idx_messages_conversation_created
  ON messages(conversation_id, created_at DESC)
  WHERE conversation_id IS NOT NULL;
```
Since DM messages have `group_id = NULL` and group messages have `conversation_id = NULL`, a full index on `(conversation_id, created_at)` would include many null-valued rows (group messages), wasting index space.

The `WHERE conversation_id IS NOT NULL` clause creates a smaller index that only contains DM messages, making it faster to scan and smaller to store."*

### Q4: How would you implement "last message preview" in the chat list sidebar efficiently?
**Answer:**
*"A naive approach would be:
```sql
-- BAD: N+1 query per conversation
SELECT * FROM messages WHERE conversation_id = :id ORDER BY created_at DESC LIMIT 1
```
A scalable approach uses a **lateral join** (correlated subquery):
```sql
SELECT c.id, lm.message_text, lm.created_at
FROM conversations c
JOIN conversation_participants cp ON cp.conversation_id = c.id AND cp.user_id = :me
LEFT JOIN LATERAL (
  SELECT message_text, created_at
  FROM messages
  WHERE conversation_id = c.id
  ORDER BY created_at DESC
  LIMIT 1
) lm ON true
ORDER BY lm.created_at DESC NULLS LAST;
```
This fetches all conversations and their last messages in a single query using the index efficiently."*

### Q5: How does Supabase Realtime enforce RLS on WebSocket subscriptions for messages?
**Answer:**
*"When a client subscribes to real-time updates:
```typescript
supabase.channel('dm').on('postgres_changes', { table: 'messages', filter: `conversation_id=eq.${id}` }, cb)
```
Supabase's Realtime server evaluates the RLS SELECT policy for the `messages` table using the subscriber's JWT. If the policy returns `false` for a row (e.g., the user is not a participant in that conversation), the Realtime server **drops the event** before sending it to the client.

This means even if a malicious client subscribes to a `conversation_id` they don't belong to, they will receive no events — the RLS gate is enforced at the Realtime broker level, not just at the API level."*
