# Backend Chapter 08: Real-Time Voice, Video & Group Calling Architecture

This module covers the systems architecture of the LiveKit-based WebRTC real-time calling engine in Pookiz, detailing room authorization, connection flows, and multi-tenant security verification.

---

## 1. Objective & Placement Value
- **Why this is asked:** Building secure, low-latency group calling is a highly technical task. Interviewers look for robust access controls (making sure users cannot join random calls), token validation pipelines, WebRTC signaling configurations, and WebHook event triggers.
- **Placement Value:** Demonstrates your capability to design high-fidelity multimedia streaming architectures and integrate third-party SFUs safely.

---

## 2. The Layman's Analogy
Think of the group calling system as a **secure digital conference hall**:
- **The Room Name (Room ID):** A locked conference room. Rooms are named by type (e.g. `group_biology-club` or `dm_studentA_studentB`).
- **The Token Counter (LiveKit Access API):** To enter the conference room, you must present an entry pass (the token). You apply for this pass at the receptionist's desk (API endpoint).
- **The Gatekeeper (Authorization checks):** Before handing you the pass, the clerk checks the university files:
  - If it's a club room, they confirm you are a registered member of that club and are not suspended.
  - If it's a private room, they verify that you are one of the two students, that you are officially friends, and that neither student has blocked the other.
  - If everything is clear, they sign a pass (generates a JWT) allowing you to walk into the media room to join the call.

---

## 3. The Technical Specification

### A. LiveKit WebRTC Token Grant Flow
To establish a secure audio/video connection using LiveKit SFU:
1. **Request:** The client calls the `/api/livekit/token` API endpoint, passing `room` (e.g., `group_123`) and `username` as query parameters.
2. **Server-Side Room Authorization:** The API parses the room name to enforce authorization policies:
   - *Group Room:* Verifies the user is in the `group_members` table and not banned.
   - *DM Room:* Verifies the user's ID matches one of the two UUIDs in the room name, validates friendship status in the `friends` table, and checks the `blocks` table to ensure communication is not blocked.
3. **Token Sign:** If authorized, the server instantiates an `AccessToken` using `LIVEKIT_API_KEY` and `LIVEKIT_API_SECRET`.
4. **Grant Rules:** The token is granted capabilities:
   - `roomJoin`: Allows joining the room.
   - `room`: Enforces the specific room context.
   - `canPublish` / `canSubscribe`: Allows streaming audio/video.
5. **Connection:** The client uses the signed token to connect to the LiveKit SFU via WebSockets, initiating WebRTC signaling.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the room authorization logic in [`d:\Pookiz\pookiz-app\src\app\api\livekit\token\route.ts`](file:///d:/Pookiz/pookiz-app/src/app/api/livekit/token/route.ts):

```typescript
export async function GET(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const room = request.nextUrl.searchParams.get('room')
  const username = request.nextUrl.searchParams.get('username')

  if (!room || !username) {
    return NextResponse.json({ error: 'room and username required' }, { status: 400 })
  }
```
- **Line 5-10:** Exports the GET handler, instantiates the Supabase client, and verifies that the client is logged in, returning status `401` if unauthorized.
- **Line 12-17:** Extracts and validates query parameters (`room` and `username`).

```typescript
  try {
    const parts = room.split('_')
    const prefix = parts[0]

    if (prefix === 'group' && parts[1]) {
      const groupId = parts[1]
      const { data: member, error: memberErr } = await supabase
        .from('group_members')
        .select('role, is_group_banned')
        .eq('group_id', groupId)
        .eq('user_id', user.id)
        .maybeSingle()

      if (memberErr || !member || member.is_group_banned) {
        return NextResponse.json({ error: 'Forbidden: You are not a member of this group space' }, { status: 403 })
      }
```
- **Line 21-22:** Splits the room ID by underscore to identify the conversation type (`group` vs `dm`).
- **Line 24-31:** If it is a group call, retrieves the user's membership details from the `group_members` table.
- **Line 33-35:** If they are not a member or are banned, blocks access and returns status `403` (Forbidden).

```typescript
    } else if (prefix === 'dm' && parts[1] && parts[2]) {
      const user1 = parts[1]
      const user2 = parts[2]

      if (user.id !== user1 && user.id !== user2) {
        return NextResponse.json({ error: 'Forbidden: Unauthorized to join this direct conversation call' }, { status: 403 })
      }

      const otherUserId = user.id === user1 ? user2 : user1
```
- **Line 36-38:** If it is a DM call, parses the two participant UUIDs from the room ID: `dm_<user1-uuid>_<user2-uuid>`.
- **Line 40-42:** Verifies that the caller's ID matches either `user1` or `user2`. If not, blocks access.
- **Line 44:** Identifies the other user's ID.

```typescript
      // Verify friendship status (accepted)
      const { data: friendship, error: friendErr } = await supabase
        .from('friends')
        .select('status')
        .or(`and(user_id_1.eq.${user.id},user_id_2.eq.${otherUserId}),and(user_id_2.eq.${user.id},user_id_1.eq.${otherUserId})`)
        .eq('status', 'accepted')
        .maybeSingle()

      if (friendErr || !friendship) {
        return NextResponse.json({ error: 'Forbidden: You must be friends with the user to call them' }, { status: 403 })
      }

      // Verify no block exists
      const { data: block } = await supabase
        .from('blocks')
        .select('id')
        .or(`and(blocker_id.eq.${user.id},blocked_id.eq.${otherUserId}),and(blocker_id.eq.${otherUserId},blocked_id.eq.${user.id})`)
        .maybeSingle()

      if (block) { ... }
```
- **Line 47-56:** Queries the `friends` table to verify the friendship is accepted, returning status `403` if they are not friends.
- **Line 59-67:** Queries the `blocks` table to verify that neither user has blocked the other, blocking the connection if a block exists.

---

## 5. Edge Cases & Optimizations
- **Room ID Hijacking:** If room IDs were simple incrementing integers (e.g. `room_1`, `room_2`), an attacker could iterate through room IDs and join random calls.
  - *Fix:* Enforce structured room IDs combining table names and random UUIDs (e.g. `group_3cf8-4d92...`), making room IDs unguessable.
- **Leaked Signaling Connections:** If a user closes the browser without clicking "Hang Up", their audio/video stream can remain active on the SFU for a short time, consuming bandwidth.
  - *Fix:* Configure LiveKit Webhook receivers (`/api/livekit/webhook`) to listen for `participant_disconnected` events and clean up call records in the database.

---

## 6. Staff Engineer Viva Board

### Q1: Why did we parse and check the room ID prefix (`group` vs `dm`) inside the token route instead of accepting any room parameter?
**Answer:**
*"Allowing the client to request tokens for arbitrary room names is a critical security vulnerability. 

If we did not check the room ID, an attacker could request a token for any room name (e.g., a private group call they don't belong to) and join the call. 

By splitting the room ID and validating memberships, friendships, and blocks against our PostgreSQL tables on the server side before signing the token, we guarantee that only authorized users can connect to the WebRTC streams."*

### Q2: What is an SFU (Selective Forwarding Unit), and why is it preferred over a Mesh network for multi-user calls?
**Answer:**
*"In a **Mesh network**, every call participant establishes a direct peer-to-peer connection with every other participant. If there are $N$ participants, each client must maintain $N-1$ upload streams and $N-1$ download streams. This scales at $O(N^2)$ connections. For a group of 5 users, each client uploads their video 4 times, which exhausts mobile bandwidth and CPU.

An **SFU** acts as a media router. Each client uploads their audio/video stream once to the SFU server. The SFU then duplicates and forwards that stream to the other $N-1$ participants. This scales at $O(N)$ connections, reducing upload bandwidth requirements and allowing low-latency group calls on mobile devices."*

### Q3: Explain how Webhooks (`/api/livekit/webhook`) are used to synchronize call state with the database.
**Answer:**
*"When a participant joins or leaves a call, the LiveKit server sends HTTP POST requests (Webhooks) containing event payloads (e.g., `room_finished`, `participant_joined`) to our `/api/livekit/webhook` endpoint.

To use this securely:
1. The route handler validates the request signature using the `WebhookReceiver` library and our LiveKit API keys to prevent fake events.
2. If verified, it parses the payload. For example, on a `room_finished` event, it updates the corresponding conversation status in PostgreSQL to indicate the call has ended, updating the UI for all users."*

### Q4: Why is LiveKit token generation done inside a GET route instead of POST? Is there a security difference here?
**Answer:**
*"GET requests are designed to retrieve data without modifying server state, which fits token generation (we are simply reading credentials and generating a signed token). 

In terms of security, as long as the route verifies the user's JWT session cookie on the server before generating the token, both GET and POST are secure. However, GET requests are vulnerable to caching by intermediate proxies. To prevent this, we configure our endpoint response headers to disable caching:
```typescript
'Cache-Control': 'no-store, max-age=0'
```
This ensures that the browser always requests a fresh token."*

### Q5: How would you implement screen sharing in Pookiz under the hood in WebRTC?
**Answer:**
*"Screen sharing is implemented on the browser layer using the Screen Capture API:
```javascript
const screenStream = await navigator.mediaDevices.getDisplayMedia({ video: true });
```
This returns a media stream containing the screen's video track. 
To integrate this with LiveKit, the client application calls:
```typescript
await room.localParticipant.publishTrack(screenStream.getVideoTracks()[0]);
```
This publishes the screen track to the LiveKit SFU, which routes the stream to all other room participants as a secondary video track."*
