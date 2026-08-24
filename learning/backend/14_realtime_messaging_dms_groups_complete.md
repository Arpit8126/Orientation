# Backend Chapter 14: Real-Time Messaging — DMs, Group Chat & Message Lifecycle

This module covers the complete real-time messaging system in Pookiz — from sending a message to how it arrives on the recipient's screen in under a second, covering DMs, group chats, system notes, reactions, edits, and delete flows.

---

## 1. Objective & Placement Value
- **Why this is asked:** Real-time chat is the most technically complex and commonly asked system design topic. Interviewers evaluate message delivery guarantees, ordering, de-duplication, optimistic UI, attachment handling, and connection lifecycle management.
- **Placement Value:** Prepares you to design production-grade messaging systems, handle message state machines, and build resilient WebSocket architectures.

---

## 2. The Layman's Analogy
Think of the messaging system as a **campus inter-department mail system with an instant runner**:
- **The Mailbox (Database):** Every message is written in a physical log (`messages` table). This is the permanent, authoritative record.
- **The Instant Runner (Supabase Realtime):** The moment a message is written in the log, a runner sprints to everyone in that conversation and hands them an instant copy.
- **The Delivery Receipt (Optimistic UI):** Before the runner even confirms delivery, you already put the message in your "sent" tray (optimistic state update). The receipt arrives a moment later.
- **Message Editing (Correction Note):** If you made a typo, you send a correction note. The runner replaces the original message on everyone's copy.
- **Message Deletion (Redaction):** You can retract a message. The runner marks it as "redacted" on everyone's copy, but the original log entry is preserved for moderation.

---

## 3. The Technical Specification

### A. Message Data Flow
```
[Sender types message] → Presses Enter
→ [DMChat.tsx / GroupChat.tsx]
  → Adds message to local state optimistically (shows immediately)
  → Calls Supabase INSERT directly on the `messages` table:
     supabase.from('messages').insert({ conversation_id, sender_id, message_text })
→ [PostgreSQL WAL]
  → INSERT is written to the Write-Ahead Log
→ [Supabase Realtime Broker]
  → Decodes the WAL event, matches it to active subscribers
  → Broadcasts the INSERT payload via WebSocket
→ [Recipient's Browser]
  → useRealtime hook callback fires with the new message payload
  → Appends the new MessageBubble to their chat window
  → Plays the notification_sound.wav if window is not focused
```

### B. Message Table Schema (Key Columns)
```sql
CREATE TABLE public.messages (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,  -- for DMs
  group_id      UUID REFERENCES groups(id) ON DELETE CASCADE,           -- for Groups
  sender_id     UUID REFERENCES profiles(id) ON DELETE SET NULL,
  message_text  TEXT,
  media_url     TEXT,
  reply_to_id   UUID REFERENCES messages(id) ON DELETE SET NULL,        -- threaded reply
  is_deleted    BOOLEAN DEFAULT false,
  edited_at     TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);
```
- Either `conversation_id` (DM) or `group_id` (Group) is populated per message — never both.
- `reply_to_id` allows one level of message quoting (replying to a specific message).
- `is_deleted = true` soft-deletes the message; the text is replaced with "Message deleted" in the UI.

### C. Conversation vs. Group Architecture
| Concept | DM (Direct Message) | Group Chat |
|---|---|---|
| Container | `conversations` table | `groups` table |
| Members | `conversation_participants` | `group_members` |
| Messages | `messages.conversation_id` | `messages.group_id` |
| Access | Both users must be in `conversation_participants` | User must be in `group_members` |
| Max size | 2 users | Unlimited |
| System notes | No | Yes (`__SYSTEM_NOTE__:` prefix) |

---

## 4. Line-by-Line Code Walkthrough

### A. Sending a Message — DMChat Component
```typescript
// In DMChat.tsx — the send message handler
const handleSendMessage = async () => {
  if (!messageText.trim() && !selectedFile) return

  const tempId = `temp-${Date.now()}`  // temporary ID for optimistic UI

  // 1. Optimistically add to local state IMMEDIATELY
  setMessages(prev => [...prev, {
    id: tempId,
    sender_id: currentUserId,
    message_text: messageText,
    created_at: new Date().toISOString(),
    isPending: true,  // shows a loading indicator on the bubble
  }])

  setMessageText('')  // clear input immediately for better UX

  try {
    let media_url = null

    // 2. Upload file if present
    if (selectedFile) {
      const path = `chat/${conversationId}/${Date.now()}_${selectedFile.name}`
      const { data } = await supabase.storage.from('chat-media').upload(path, selectedFile)
      media_url = supabase.storage.from('chat-media').getPublicUrl(data!.path).data.publicUrl
    }

    // 3. Insert message into database
    const { data: newMsg, error } = await supabase
      .from('messages')
      .insert({
        conversation_id: conversationId,
        sender_id: currentUserId,
        message_text: messageText.trim(),
        media_url,
        reply_to_id: replyingTo?.id || null,
      })
      .select('*, sender:profiles(id, username, avatar_url)')
      .single()

    if (error) throw error

    // 4. Replace optimistic bubble with confirmed message
    setMessages(prev => prev.map(m => m.id === tempId ? newMsg : m))

  } catch (err) {
    // 5. On failure: remove the optimistic bubble, show error toast
    setMessages(prev => prev.filter(m => m.id !== tempId))
    toast.error('Failed to send message. Please try again.')
  }
}
```
- **Step 1:** Adds a "pending" message to the local state immediately. The user sees the bubble appear right away.
- **Step 2:** If a file is attached, it is uploaded to Supabase Storage first.
- **Step 3:** Inserts the message row into the database with a join to fetch the sender profile in one query.
- **Step 4:** Replaces the temporary bubble with the confirmed database row (which has a real UUID).
- **Step 5:** If the insert fails, the optimistic bubble is removed and an error toast is shown.

### B. Receiving Messages via Real-Time Subscription
```typescript
// In DMChat.tsx — the real-time listener
useEffect(() => {
  const supabase = createClient()

  const channel = supabase
    .channel(`dm-${conversationId}`)
    .on('postgres_changes', {
      event: 'INSERT',
      schema: 'public',
      table: 'messages',
      filter: `conversation_id=eq.${conversationId}`,
    }, async (payload) => {
      // Only add messages from OTHER users (we already have our own via optimistic UI)
      if (payload.new.sender_id === currentUserId) return

      // Fetch the full message with author profile
      const { data: fullMsg } = await supabase
        .from('messages')
        .select('*, sender:profiles(id, username, avatar_url)')
        .eq('id', payload.new.id)
        .single()

      if (fullMsg) {
        setMessages(prev => [...prev, fullMsg])
        // Play notification sound if tab is not focused
        if (document.visibilityState === 'hidden') {
          new Audio('/notification_sound.wav').play().catch(() => {})
        }
      }
    })
    .subscribe()

  return () => supabase.removeChannel(channel)
}, [conversationId, currentUserId])
```
- The channel is filtered to `conversation_id=eq.<uuid>` — users only receive messages for the specific DM they have open.
- Messages from the current user are skipped because they were already added optimistically.
- After receiving the payload, a second query fetches the full message with profile join (the raw WAL event only contains the inserted columns).
- The notification sound is played if the browser tab is hidden.

### C. Message Edit API — `PATCH /api/messages/edit`
```typescript
export async function PATCH(request: Request) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  const { message_id, new_text } = await request.json()

  // Verify ownership — only the sender can edit their own messages
  const { data: message } = await supabase
    .from('messages')
    .select('sender_id, created_at')
    .eq('id', message_id)
    .single()

  if (!message || message.sender_id !== user.id) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }

  // Enforce edit window — only allow edits within 15 minutes of sending
  const sentAt = new Date(message.created_at).getTime()
  const now = Date.now()
  if (now - sentAt > 15 * 60 * 1000) {
    return NextResponse.json({ error: 'Edit window expired (15 minutes)' }, { status: 400 })
  }

  const { error } = await supabase
    .from('messages')
    .update({ message_text: new_text.trim(), edited_at: new Date().toISOString() })
    .eq('id', message_id)

  if (error) return NextResponse.json({ error: error.message }, { status: 500 })

  return NextResponse.json({ success: true })
}
```
- The `sender_id` check ensures users can only edit their own messages — never others'.
- The 15-minute edit window is enforced server-side; client-side time checks can be manipulated.
- `edited_at` is stamped so the UI can show an "(edited)" indicator below the bubble.

### D. System Notes in Group Chat
When events happen in a group (join, leave, name change), the system inserts a special message:
```typescript
// System note format — checked by MessageBubble.tsx for special rendering
await supabase.from('messages').insert({
  group_id,
  sender_id: user.id,
  message_text: `__SYSTEM_NOTE__:@${username} has joined the group`,
})
```
- The `__SYSTEM_NOTE__:` prefix is a convention checked in the frontend.
- `MessageBubble.tsx` detects this prefix and renders a centered, styled event notice instead of a normal chat bubble.

---

## 5. The MessageBubble Component

### A. Bubble Layout Logic
```
[MessageBubble.tsx] receives: message, currentUserId, onReply, onEdit, onDelete

┌─ Is sender_id === currentUserId?
│   YES → align-end (right side, colored bubble)
│   NO  → align-start (left side, gray bubble)
│
├─ Is message.is_deleted?
│   YES → render "Message deleted" in italic gray
│
├─ Does message.message_text start with __SYSTEM_NOTE__?
│   YES → render centered event notice (e.g. "John has left the group")
│
├─ Does message.media_url exist?
│   YES → render image preview with lightbox on click
│
└─ Does message.reply_to_id exist?
    YES → render quoted parent message above the bubble text
```

### B. Message Reactions
```typescript
// In MessageBubble.tsx — adding a reaction
const handleReact = async (emoji: string) => {
  const existingReaction = reactions.find(
    r => r.user_id === currentUserId && r.emoji === emoji
  )

  if (existingReaction) {
    // Toggle off: remove the reaction
    await supabase.from('message_reactions')
      .delete()
      .eq('id', existingReaction.id)
  } else {
    // Add reaction
    await supabase.from('message_reactions')
      .insert({ message_id: message.id, user_id: currentUserId, emoji })
  }
}
```
- Reactions use an upsert-like toggle pattern: clicking an existing reaction removes it.
- The `message_reactions` table has `UNIQUE(message_id, user_id, emoji)` to prevent duplicates.

---

## 6. Edge Cases & Optimizations

- **Message Ordering Race Condition:** If two messages are sent within milliseconds of each other, their WAL events might arrive out of order.
  - *Fix:* Always sort the messages array by `created_at` timestamp after appending new messages. Never rely on insertion order.

- **Chat Scroll Position:** When a new message arrives, if the user has scrolled up to read old messages, automatically scrolling down to the new message is disruptive.
  - *Fix:* Only auto-scroll if the user is within ~100px of the bottom. Otherwise, show a "New message ↓" nudge button.

- **Duplicate Messages on Reconnect:** When the WebSocket reconnects, the client may miss some messages or receive duplicates from re-subscribing.
  - *Fix:* After reconnect, perform an HTTP fetch for messages after the last known `created_at` timestamp. Deduplicate using a `Set` of message IDs.

- **Large File Upload Blocking:** Uploading a 10MB video before sending blocks the whole send flow.
  - *Fix:* Show a progress bar, upload in the background, and allow typing the next message while the upload completes.

---

## 7. Staff Engineer Viva Board

### Q1: Walk me through the complete message delivery loop from "send" to "received".
**Answer:**
*"1. User presses Enter → the message is added to local React state optimistically (instant visual feedback).
2. We call `supabase.from('messages').insert(...)` to write the message to PostgreSQL.
3. PostgreSQL records the INSERT in the Write-Ahead Log (WAL).
4. Supabase Realtime's logical decoding daemon reads the WAL, formats the event as JSON.
5. The Realtime broker matches the event against active subscriptions with matching filters.
6. The recipient's browser receives the event via an open WebSocket connection.
7. The `useRealtime` hook callback fires, and the message is appended to the recipient's chat window — all within ~100–300ms of the original send."*

### Q2: Why do we skip processing real-time INSERT events for the current user's own messages?
**Answer:**
*"The sender already added their message to local state optimistically in Step 1 of the send flow. If we also processed the real-time INSERT event (which arrives a moment later), the sender would see a duplicate message bubble — their optimistic copy plus the confirmed database copy.

By skipping events where `payload.new.sender_id === currentUserId`, we prevent this duplicate. The sender's optimistic bubble is replaced by the confirmed message via the `setMessages` update in the `insert()` `.then()` handler."*

### Q3: Why is the message edit window enforced server-side?
**Answer:**
*"Client-side time checks can be trivially bypassed. An attacker could open the browser developer tools, manipulate the JavaScript, and bypass any client-side check like `if (minutesSinceSent < 15)`.

By checking the edit window server-side — loading the message's `created_at` from the database and calculating `Date.now() - sentAt` — we ensure that even if the client sends a manipulated PATCH request after 15 minutes, the server will reject it with a `400 Bad Request` response, protecting message immutability."*

### Q4: How does `__SYSTEM_NOTE__:` prevent message injection if anyone can send a message to the API?
**Answer:**
*"The current system uses a prefix convention for display purposes only. An attacker could theoretically send a message with the `__SYSTEM_NOTE__:@Admin has promoted you` prefix via a direct API call.

The secure fix is to add a server-side validation in the POST message handler that rejects any `message_text` starting with `__SYSTEM_NOTE__:` from regular users. System notes should only be inserted by server-side route handlers (not user-facing endpoints), and ideally this logic should run inside a `SECURITY DEFINER` database trigger to guarantee they cannot be faked."*

### Q5: What happens to messages if the conversation is deleted?
**Answer:**
*"The `messages` table has `conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE`. If a conversation row is deleted from the `conversations` table, PostgreSQL's cascading delete automatically purges all associated message rows from the `messages` table.

Similarly for groups: `group_id UUID REFERENCES groups(id) ON DELETE CASCADE` ensures all group messages are purged when the group is deleted. This prevents orphaned messages from accumulating in the database without a parent context."*
