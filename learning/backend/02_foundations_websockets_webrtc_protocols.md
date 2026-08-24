# Backend Chapter 02: Foundations of WebSockets & WebRTC P2P Protocols

This module covers the core fundamentals of real-time web communication, detailing WebSockets framing, WebRTC peer-to-peer connections, NAT traversal, and signaling mechanisms.

---

## 1. Objective & Placement Value
- **Why this is asked:** Real-time applications (such as chat networks and live calling rooms) require low-latency communication. Interviewers test on WebSockets, WebRTC P2P streams, NAT traversal (STUN/TURN), and signaling protocols to evaluate your real-time systems design skills.
- **Placement Value:** Prepares you to design low-latency messaging engines, audio/video streaming pipelines, and live signaling architectures.

---

## 2. The Layman's Analogy
Think of real-time communication as **establishing connection lines in a campus dorm**:
- **HTTP (Mail Letters):** You send a letter to the front office asking if you have messages. The office writes a response and mails it back. This takes time, and you must write a new letter every time.
- **WebSockets (The Intercom):** You run a dedicated wire from your room straight to the front desk. Once connected, you can talk back and forth instantly without writing letters.
- **WebRTC (Window-to-Window Cable):** If you want to video call a friend in the opposite dorm, you don't run cables through the front desk. Instead, you get their room number from the front desk (**signaling**), find a clear line of sight, and run a cable directly from your window to their window (**P2P**).
- **STUN/TURN (The Navigator & Relay):** 
  - If you don't know your room's coordinates relative to the courtyard, you ask a surveyor (**STUN**) to calculate them.
  - If a tree blocks the line of sight between your windows, you run the cable to a central junction box on the roof (**TURN relay**) which forwards the signals.

---

## 3. The Technical Specification

### A. The WebSocket Protocol & Frame Structure
WebSockets provide full-duplex, stateful communication over a single TCP connection:
1. **HTTP Upgrade Handshake:** The client sends an HTTP GET request with upgrade headers:
   - `Connection: Upgrade`
   - `Upgrade: websocket`
   - `Sec-WebSocket-Key: <nonce>`
2. **Upgrade Response:** The server responds with status `101 Switching Protocols`.
3. **Data Framing:** WebSockets communicate using lightweight binary/text frames:
   - **FIN Bit:** Indicates if this is the final fragment of a message.
   - **Opcode:** Defines frame type (e.g., `%x1` for text, `%x2` for binary, `%x8` for connection close, `%x9` for ping, `%xA` for pong).
   - **Payload Length:** Extends from 7 bits to 64 bits to support varying payload sizes.
   - **Masking Key:** All frames sent from the client to the server must be masked using a 32-bit key to prevent proxy cache poisoning.

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-------+-+-------------+-------------------------------+
|F|R|R|R| opcode|M|     len     |          masking key          |
|I|S|S|S| (4bit)|A|    (7bit)   |           (32bit)             |
|N|V|V|V|       |S|             |                               |
| |1|2|3|       |K|             |                               |
+-+-+-+-+-------+-+-------------+-------------------------------+
|                        payload data                           |
+---------------------------------------------------------------+
```

### B. WebRTC Architecture & P2P Traversal
WebRTC enables direct, peer-to-peer browser communication:
1. **Signaling:** Peers must exchange connection metadata before connecting. They use a signaling server to exchange:
   - **SDP (Session Description Protocol):** Text descriptors containing media capabilities, codecs, and parameters.
   - **ICE Candidates:** Network addresses (IP and port pairs) where a peer can be reached.
2. **NAT Traversal (STUN and TURN):**
   - **STUN (Session Traversal Utilities for NAT):** A server that returns the public IP address and port of a client behind a NAT router. STUN works for most home NAT configurations.
   - **TURN (Traversal Using Relays around NAT):** A fallback relay server used when symmetric NATs block direct P2P connections. The TURN server relays all UDP media traffic between peers, which requires high bandwidth.
3. **ICE (Interactive Connectivity Establishment):** A framework that tries STUN first, evaluates all candidate paths, selects the most efficient connection path, and falls back to TURN if no P2P path is available.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze how WebSockets and WebRTC are initialized. Below is the Next.js API endpoint used to generate credentials for joining a WebRTC call room:

```typescript
import { AccessToken } from 'livekit-server-sdk'
import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function GET(request: NextRequest) {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
```
- **Line 1:** Imports the `AccessToken` generator from LiveKit (the WebRTC signaling and SFU framework).
- **Line 6-7:** Instantiates the Supabase client and verifies the user's authentication state.

```typescript
  const room = request.nextUrl.searchParams.get('room')
  const username = user.email || 'Anonymous'

  if (!room) {
    return NextResponse.json({ error: 'Room parameter is required' }, { status: 400 })
  }

  const apiKey = process.env.LIVEKIT_API_KEY
  const apiSecret = process.env.LIVEKIT_API_SECRET
```
- **Line 9:** Retrieves the query parameter `room` (the calling room ID).
- **Line 11-13:** Validates that the `room` identifier is present, returning status `400` if missing.
- **Line 15-16:** Loads LiveKit API credentials from server environment variables.

```typescript
  const at = new AccessToken(apiKey, apiSecret, {
    identity: username,
    metadata: JSON.stringify({ user_id: user.id })
  })

  at.addGrant({ roomJoin: true, room: room, canPublish: true, canSubscribe: true })
  const token = await at.toJwt()

  return NextResponse.json({ token })
}
```
- **Line 18-21:** Instantiates a LiveKit token using the user's identity and custom metadata.
- **Line 23:** Grants the user permissions to join the room, publish audio/video, and subscribe to other streams.
- **Line 24-26:** Encrypts and serializes the token into a signed JWT and returns it to the client to authorize their WebRTC connection.

---

## 5. Edge Cases & Optimizations
- **WebSocket Connection Drops:** Client connections frequently drop due to bad networks.
  - *Fix:* Implement client-side automatic reconnection loops with exponential backoff and a ping-pong heartbeat check to detect dead sockets.
- **TURN Server Egress Costs:** Relay traffic consumes high bandwidth, making TURN servers expensive to run.
  - *Optimization:* Deploy STUN/TURN servers close to the user using geo-routing, configure strict ICE collection timeouts, and optimize video codecs (e.g., using VP8/VP9 or H.264) to minimize bitrate usage.

---

## 6. Staff Engineer Viva Board

### Q1: Why do WebSocket client frames require masking, while server frames do not?
**Answer:**
*"Client frames require masking to prevent **Cache Poisoning / Proxy Manipulation** attacks. 

If client frames were unmasked, a malicious website running inside a user's browser could send a WebSocket frame containing a fake HTTP request sequence to a proxy server (like Squid). The proxy might mistake the WebSocket payload for a valid HTTP request, cache the response, and serve it to subsequent users. Masking the payload using a random 32-bit key on the client side encrypts the data during transmission, preventing intermediate proxies from parsing it as HTTP. 

Server frames do not require masking because the client connects to the server directly, so there is no risk of caching or proxy manipulation on the client's end."*

### Q2: What is the difference between a Signaling Server and a media SFU (Selective Forwarding Unit) in WebRTC?
**Answer:**
*"- **Signaling Server:** A simple web server (typically WebSockets) used during connection setup to exchange SDP offers/answers and ICE candidates. Once the connection is established, the signaling server is out of the loop.
- **SFU (Selective Forwarding Unit):** A media server used during the call. In multi-user calls, peer-to-peer connection is inefficient because each user must upload their stream to every other participant, consuming high upload bandwidth ($O(N^2)$ connections). An SFU allows each peer to upload their stream once. The SFU then duplicates and forwards that stream to all other participants, optimizing bandwidth ($O(N)$ connections)."*

### Q3: How do WebRTC peers determine their public IP addresses when behind a Symmetric NAT, and why does STUN fail in this case?
**Answer:**
*"A **STUN** server allows a client behind a NAT router to discover its public IP and port. 
- In **Cone NAT** configurations, the router maps a client's internal IP/port to a public IP/port that remains consistent for all external destinations. Any external host can send packets back using this mapping. STUN works here.
- In **Symmetric NAT** configurations, the router assigns a unique public port mapping for each *different* external destination. When the client checks their address via a STUN server, the router creates a mapping for the STUN server. When the client tries to connect to a peer, the router creates a *different* port mapping, rendering the STUN candidate invalid. 
In this case, STUN lookup fails, and the peers must fall back to a **TURN** relay server to communicate."*

### Q4: Explain the differences between SDP (Session Description Protocol) and ICE Candidates.
**Answer:**
*"- **SDP (Session Description Protocol):** A text document containing media metadata. It lists the supported video/audio codecs (e.g., VP8, H.264, Opus), resolutions, frame rates, encryption algorithms, and media options. It acts as the media handshake.
- **ICE Candidates:** Text records containing network routing paths. They list available IP addresses (local LAN, public NAT mapped via STUN, and relay TURN addresses), protocols (UDP/TCP), and ports. They act as the routing handshake."*

### Q5: What is WebSockets Ping/Pong, and why is it necessary to maintain connections?
**Answer:**
*"WebSockets run over TCP, which does not have a native mechanism to quickly detect silent connection drops (e.g., when a mobile device goes through a tunnel). If a connection drops, the socket remains open on the server, wasting resources.

To solve this, we use **Ping/Pong heartbeats**:
1. The server sends a `Ping` frame (`opcode 0x9`) to the client periodically.
2. The client must immediately respond with a `Pong` frame (`opcode 0xA`).
3. If the server does not receive a Pong response within a timeout window (e.g., 30 seconds), it considers the connection dead, closes the socket, and cleans up resources."*
