# Backend Chapter 01: Foundations of Network Handshakes & HTTP Lifecycle

This module covers the core fundamentals of web networks, detailing DNS resolution, the TCP handshake, TLS security layers, HTTP protocol evolutions, and the request-response lifecycle.

---

## 1. Objective & Placement Value
- **Why this is asked:** Understanding how data travels across the internet is a fundamental computer science concept. Interviewers test on DNS lookups, TCP connection states, SSL/TLS handshake mechanisms, and HTTP protocol differences to evaluate your networking expertise.
- **Placement Value:** Prepares you for advanced questions on network troubleshooting, CDN edge delivery, connection latency optimization, and HTTP/2/3 systems design.

---

## 2. The Layman's Analogy
Think of sending an HTTP request as **ordering a book from a remote university library**:
- **DNS Lookup:** You look up the library's physical address in the campus phone book (DNS directory).
- **TCP Handshake:** You pick up the phone, call the front desk, and establish a clear voice line:
  - You say: *"Hello, can you hear me?"* (SYN)
  - The librarian says: *"Yes, I can hear you. Can you hear me?"* (SYN-ACK)
  - You say: *"Yes, I can hear you. Let's talk."* (ACK)
- **TLS Handshake:** Before speaking about private items, you verify the librarian's credentials and establish a secret, encrypted language (encryption keys) that other people in the room cannot understand.
- **HTTP Request:** You request the book (HTTP GET request), and the librarian reads the book pages to you (response body). Once done, you hang up the phone.

---

## 3. The Technical Specification

### A. The 5-Step HTTP Request Lifecycle
1. **DNS Resolution:** The client checks local cache (browser, OS, router). If missing, it queries recursive DNS servers to resolve the hostname (e.g., `pookiz.com`) into a public IP address.
2. **TCP Connection (SYN -> SYN-ACK -> ACK):** The client opens a TCP socket connection on port 80/443:
   - *SYN:* Client sends a segment with a random Sequence Number ($A$).
   - *SYN-ACK:* Server acknowledges by sending an Acknowledgment Number ($A+1$) and its own Sequence Number ($B$).
   - *ACK:* Client acknowledges by sending ($B+1$), completing the connection loop.
3. **TLS Encryption Negotiation:** The client and server run a TLS handshake:
   - *Client Hello:* Sends supported TLS versions and cipher suites.
   - *Server Hello:* Sends selected cipher, its public certificate, and a public key signature.
   - *Key Exchange:* Client verifies the certificate, computes a pre-master secret key, encrypts it using the server's public key, and sends it back. Both generate symmetric session keys.
4. **HTTP Request Routing:** The client transmits the HTTP payload. The server routes the request through Middlewares and forwards it to the route handler.
5. **Response Dispatch & Connection Lifecycle:** The server returns the serialized response headers and body. Under HTTP/1.1, the connection is kept alive for subsequent requests using the `Keep-Alive` header.

### B. HTTP/1.1 vs. HTTP/2 vs. HTTP/3
- **HTTP/1.1:** Serial request execution. Suffers from **Head-of-Line (HOL) Blocking**—if a request is slow, all subsequent requests behind it on the same TCP connection are blocked.
- **HTTP/2 (Multiplexed):** Introduces binary frames. Multiple requests and responses run concurrently over a single TCP connection, eliminating application-level HOL blocking. However, if a single TCP packet is lost, the entire TCP connection is paused by the OS kernel, creating network-level HOL blocking.
- **HTTP/3 (QUIC-based):** Replaces TCP with **QUIC** (built on top of UDP). Each request stream operates independently. If a packet in stream A is lost, only stream A is paused; stream B continues uninterrupted, resolving network-level HOL blocking.

---

## 4. Line-by-Line Code Walkthrough
Next.js handles API routing using standard Web Request/Response objects. Let's analyze how an API route reads incoming request headers and returns standard HTTP responses:

```typescript
import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

export async function POST(request: NextRequest) {
  // Reads incoming request metadata (headers, cookies)
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
```
- **Line 5:** The Next.js API server receives the HTTP request stream and encapsulates it in a `NextRequest` object.
- **Line 6:** The `createClient()` utility reads the `Cookie` header from the incoming request to verify user authentication.
- **Line 7:** `supabase.auth.getUser()` verifies the JWT signature on the auth server.

```typescript
  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }
```
- **Line 9-11:** If the user is unauthenticated, the route handler returns a serialized JSON response with HTTP status code `401` (Unauthorized).

---

## 5. Edge Cases & Optimizations
- **DNS Resolution Latency:** High DNS resolution times add latency to initial requests.
  - *Fix:* Deploy applications using modern DNS providers (like Cloudflare/Route 53) that support Global Anycast routing, and configure long DNS TTL (Time To Live) durations.
- **TCP Slow Start:** TCP starts connections conservatively, sending a small number of packets before verifying receipt, which increases round-trips.
  - *Optimization:* Enable **TCP Fast Open (TFO)**, which allows the client to send request data inside the initial `SYN` packet during subsequent connections, saving one full network round-trip.

---

## 6. Staff Engineer Viva Board

### Q1: What is Head-of-Line (HOL) Blocking, and how does HTTP/2 solve it at the application layer?
**Answer:**
*"In **HTTP/1.1**, requests are executed sequentially over a TCP connection. If a client requests 3 images, the second and third requests must wait until the first image is fully downloaded. If the first image is large, it blocks all subsequent assets, causing Head-of-Line blocking.

**HTTP/2** solves this by introducing a binary framing layer. It splits requests and responses into independent binary frames and multiplexes them concurrently over a single TCP connection. The browser can interleave frames from multiple assets, allowing them to download in parallel and resolving application-layer HOL blocking."*

### Q2: How does HTTP/3 resolve network-level HOL blocking, and what is its relationship with UDP?
**Answer:**
*"While HTTP/2 solves HOL blocking at the application layer, it still runs over TCP. If a single packet is lost on the network, the operating system kernel pauses the entire TCP connection to wait for retransmission, blocking all multiplexed streams. This is network-level HOL blocking.

**HTTP/3** replaces TCP with **QUIC**, which runs on top of **UDP**. UDP does not enforce connection-level delivery guarantees. Instead, QUIC manages stream delivery in user space. Each stream is isolated. If a packet belonging to Stream A is lost, the kernel does not pause the connection; Stream B continues downloading, resolving network-level HOL blocking."*

### Q3: Walk me through the details of a TLS 1.3 Handshake. How does it optimize the handshake time compared to TLS 1.2?
**Answer:**
*"A **TLS 1.2 Handshake** requires two complete network round-trips (2-RTT) to establish a secure connection: client hello, key selection, certificate validation, key exchange, and finished signals.

A **TLS 1.3 Handshake** reduces this to **one round-trip (1-RTT)**:
1. **Client Hello:** The client sends its supported ciphers AND immediately guesses the server's key exchange algorithm, sending its public key share.
2. **Server Hello:** The server responds with its certificate, selected cipher, and its own public key share.
3. Both client and server calculate the symmetric session keys in one round-trip, immediately establishing secure communication. 
TLS 1.3 also supports **0-RTT (Zero Round-Trip Time)**, allowing clients to send encrypted data inside their initial connection request if they have connected to the server previously."*

### Q4: Explain the difference between DNS recursive resolvers and authoritative DNS servers.
**Answer:**
*"- **Recursive Resolver:** The server that receives DNS queries from the client (typically run by your ISP or Google DNS 8.8.8.8). It does not hold domain records. Instead, it queries other DNS servers to resolve the domain on the client's behalf.
- **Authoritative DNS Server:** The final destination DNS server that actually holds the IP records for a domain (e.g., Cloudflare DNS holding `pookiz.com`). It returns the IP address directly to the recursive resolver, which caches it and returns it to the client."*

### Q5: What is the purpose of the `Keep-Alive` header in HTTP/1.1? What happens if you do not use it?
**Answer:**
*"The `Keep-Alive` header instructs the server and client to keep the underlying TCP socket open after completing a request-response cycle. This allows subsequent requests to reuse the same TCP connection, avoiding the latency of the 3-Way Handshake and TLS setup.

If you do not use it (or set `Connection: close`), a new TCP connection must be established for every single asset (CSS, JS, images, API calls), significantly increasing page load times and server CPU usage due to repeated TLS handshakes."*
