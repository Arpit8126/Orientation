# Foundational Backend Concepts — Complete Guide from Zero to Real World

This guide covers core backend concepts, network communication, API architectures, authentication patterns, server structures, and security mechanisms.

---

## PART 1: The Client-Server Model

### 1. The Analogy (The Restaurant)
Imagine you go to a restaurant:
- **Client (You)**: The customer sitting at a table. You look at a menu and make a request to a waiter.
- **Server (The Waiter)**: Takes your order, goes to the kitchen, gets the food, and returns it to your table.
- **Backend/Database (The Kitchen)**: Where the chef works, reads recipes, gets ingredients from the fridge (Database), prepares the meal, and hands it back to the waiter.
- **API (The Menu/Order)**: The formatted list of choices you are allowed to make and how you communicate your order.

### 2. Network Foundations
Before two systems can communicate, they need to locate each other:
- **IP Address**: The physical mailing address of a computer on the internet (e.g., `192.168.1.1` or `76.76.21.21`).
- **DNS (Domain Name System)**: The phonebook of the internet. It translates human-readable domain names (like `pookiz.vercel.app`) into machine-readable IP addresses.
- **Port**: A sub-address inside a computer (like an apartment number in a building). Different services run on different ports (e.g., HTTP on port `80`, HTTPS on `443`, PostgreSQL on `5432`).

---

## PART 2: The HTTP Protocol (HyperText Transfer Protocol)

HTTP is the set of rules used for transferring files (text, images, query results) on the web.

```
       [HTTP REQUEST] (Method, Path, Headers, Body)
Client ──────────────────────────────────────────────> Server
       <──────────────────────────────────────────────
       [HTTP RESPONSE] (Status Code, Headers, Body)
```

### 1. HTTP Methods (Verbs)
Methods tell the server what action to perform on a resource:

| Method | SQL Equivalent | Purpose | Idempotent? |
|---|---|---|---|
| **`GET`** | `SELECT` | Retrieve data. Should not modify server state. | Yes |
| **`POST`** | `INSERT` | Create new data. | No |
| **`PUT`** | `UPDATE` | Replace an existing resource entirely. | Yes |
| **`PATCH`** | `UPDATE` | Partially update an existing resource. | No |
| **`DELETE`** | `DELETE` | Remove a resource. | Yes |

*Note on Idempotence: An operation is idempotent if running it multiple times yields the same result. Running `DELETE /users/1` three times still leaves user 1 deleted. Running `POST /users` three times creates three users.*

### 2. HTTP Request Anatomy
An HTTP request consists of:
- **Request Line**: Method, path, and HTTP version (e.g., `POST /api/messages HTTP/1.1`).
- **Headers**: Metadata (key-value pairs) about the request:
  - `Content-Type: application/json` (Tells the server we are sending JSON).
  - `Authorization: Bearer <token>` (Credentials).
  - `User-Agent: Chrome/120.0` (Tells the server which browser/client is calling).
- **Body**: The actual payload data being sent (usually JSON in modern APIs):
  ```json
  {
    "senderId": "user-abc",
    "text": "Hello World"
  }
  ```
- **Query Parameters**: Key-value pairs appended to the URL after a `?`:
  - `https://api.site.com/users?page=2&limit=10` (`page` and `limit` are parameters).

### 3. HTTP Response Anatomy
An HTTP response consists of:
- **Status Line**: HTTP version and Status Code (e.g., `HTTP/1.1 200 OK`).
- **Headers**: Metadata about the response:
  - `Content-Type: application/json` (Confirming returning data is JSON).
  - `Set-Cookie: session=123; HttpOnly` (Command telling browser to store a cookie).
- **Body**: The returned data (JSON, HTML file, raw image).

### 4. HTTP Status Codes

#### `1xx` — Informational (rarely seen in app code)
- `101 Switching Protocols` (Used when transitioning from HTTP to WebSockets).

#### `2xx` — Success
- **`200 OK`**: Query completed successfully.
- **`201 Created`**: Record inserted successfully.
- `204 No Content`: Successful request, but returning no data (common for DELETE).

#### `3xx` — Redirection
- `301 Moved Permanently`: URL has changed permanently. Browser caches the redirection.
- `302 Found` / `307 Temporary Redirect`: Temporary redirect.

#### `4xx` — Client Error (Your fault)
- **`400 Bad Request`**: Server can't understand the request (missing fields, invalid JSON).
- **`401 Unauthorized`**: You are not authenticated. Server doesn't know who you are.
- **`403 Forbidden`**: You are authenticated, but don't have permission to do this action.
- **`404 Not Found`**: Resource doesn't exist.
- `429 Too Many Requests`: Rate limit exceeded.

#### `5xx` — Server Error (Server's fault)
- **`500 Internal Server Error`**: The server crashed (uncaught exception in backend code).
- `502 Bad Gateway`: Proxy/load balancer couldn't reach the main server.
- `504 Gateway Timeout`: Server took too long to respond.

---

## PART 3: API Architectural Styles

An API (Application Programming Interface) defines how clients request data from the server.

### 1. REST (Representational State Transfer)
The most common web API style.
- Uses standard HTTP methods (`GET`, `POST`, etc.).
- Resource-oriented (URL paths represent nouns: `/api/users`, `/api/posts`).
- Stateless (each request must contain all info needed, server doesn't remember previous requests).
- Output is usually JSON.

### 2. GraphQL
Alternative developed by Meta.
- Client requests exactly the data it needs in a single request.
- Single endpoint (`/graphql` via `POST`).
- Prevents **Over-fetching** (getting columns you don't need) and **Under-fetching** (needing to make multiple requests to get relational data).

```graphql
# GraphQL query requesting only names of user's friends
query {
  user(id: "1") {
    name
    friends {
      name
    }
  }
}
```

### 3. WebSockets
Real-time, bidirectional protocol.
- Client initiates connection with an HTTP handshake, then upgrades to WebSocket.
- Establishes a persistent, open connection between client and server.
- Either side can send data at any time without headers overhead (used for chat messages, live notifications).

---

## PART 4: Authentication & Authorization

Authentication is proving **who** you are. Authorization is proving what you are **allowed to do**.

### 1. Stateful Authentication (Session-Based)
The traditional approach.

```
Client                             Server                           Database
  │  ── Login (user/pass) ─────────> │                                │
  │                                  │ ── Create Session ───────────> │
  │                                  │ <── Return Session ID ──────── │
  │  <── Set-Cookie (Session ID) ─── │                                │
  │                                  │                                │
  │  ── Request (with Cookie) ──────>│                                │
  │                                  │ ── Check Session ID ─────────> │
  │                                  │ <── Session Valid ─────────── │
  │  <── Return Data ─────────────── │                                │
```

- **How it works**: The server stores session records in memory/database. A `sessionId` cookie is sent to the client. On every request, the client sends the cookie, and the server queries the database to verify it.
- **Pros**: Easy to revoke sessions instantly.
- **Cons**: Difficult to scale horizontally. If you have 5 backend servers, they all must share a centralized session database (like Redis), otherwise Server B won't know you logged in on Server A.

### 2. Stateless Authentication (Token-Based / JWT)
Modern approach used by Supabase, Auth0, etc.

```
Client                             Server
  │  ── Login (user/pass) ─────────> │
  │                                  │ ── Generate JWT & Sign with Secret
  │  <── Return JWT Token ────────── │
  │                                  │
  │  ── Request (Auth: Bearer JWT) ─>│
  │                                  │ ── Verify Signature with Secret
  │  <── Return Data ─────────────── │    (No Database Lookup Needed!)
```

- **How it works**: The server creates a self-contained Token (JWT) containing user info, signs it with a secret key, and sends it to the client. The client sends this token in headers. The server verifies the signature using its secret key — if valid, the user is authenticated.
- **Pros**: Scales infinitely. Any server can verify the token without querying a database.
- **Cons**: Hard to revoke. Once a JWT is issued, it is valid until it expires. (Solved by using short-lived access tokens combined with long-lived refresh tokens).

#### Anatomy of a JWT:
A JWT contains 3 base64-encoded strings separated by dots:
1. **Header**: Contains token type and hashing algorithm (e.g., `{"alg": "HS256", "typ": "JWT"}`).
2. **Payload**: Data claims (e.g., `{"userId": "123", "role": "admin", "exp": 1700000000}`).
3. **Signature**: Cryptographic signature confirming the token has not been modified.
   `Signature = HMACSHA256(base64(Header) + "." + base64(Payload), SECRET_KEY)`

---

## PART 5: Backend Security Essentials

### 1. CORS (Cross-Origin Resource Sharing)
A browser-enforced security mechanism.
- By default, browsers prevent JavaScript on `domain-a.com` from fetching data from `domain-b.com` to prevent data theft.
- **The Solution**: The server at `domain-b.com` must send specific headers in responses telling the browser it is safe:
  - `Access-Control-Allow-Origin: https://domain-a.com` (allows this specific site).
  - `Access-Control-Allow-Methods: GET, POST`.

### 2. Password Hashing (Bcrypt)
Never store plain-text passwords in a database! If the database leaks, all user accounts are compromised.
- **Hashing**: A one-way mathematical function. You can convert "password123" to a hash, but you cannot mathematically convert the hash back to "password123".
- **Salt**: Random text appended to the password before hashing to prevent rainbow table attacks (pre-computed dictionary attacks).

```javascript
import bcrypt from "bcryptjs";

// Hashing on Sign Up:
const salt = await bcrypt.genSalt(10);
const passwordHash = await bcrypt.hash("userPassword123", salt);
// Store passwordHash in database

// Verifying on Login:
const isMatch = await bcrypt.compare("typedPassword123", passwordHash); // true/false
```

### 3. SQL Injection (SQLi)
An attack where malicious SQL statements are injected into entry fields for execution.

```sql
-- ❌ VULNERABLE CODE (String Interpolation)
SELECT * FROM users WHERE username = ' ' OR 1=1; --' AND password = '...';
-- If input is: ' OR 1=1; --
-- The query becomes: SELECT * FROM users WHERE username = '' OR 1=1; -- ...
-- 1=1 is always true, so it returns all users, logging the attacker in!
```

```sql
-- ✅ SECURE CODE (Parameterized Queries)
SELECT * FROM users WHERE username = $1;
-- The database treats the input strictly as a text value, not executable SQL.
```

### 4. Rate Limiting
Prevent users from crashing the server by spamming requests (Denial of Service - DoS).
- Tracks IP addresses and limits the number of requests per window (e.g., max 100 requests per 15 minutes).
- Returns status code `429 Too Many Requests` if exceeded.

---

## PART 6: Serverless Architecture

In traditional backend structures, a server (like an Express app) is running 24/7 on a virtual machine, waiting for requests.

In **Serverless (Function-as-a-Service - FaaS)**:
- Code is divided into small, independent functions (endpoints).
- The functions are **completely shut down** when not in use.
- When a request comes in, the cloud provider (Vercel, AWS) spins up a container, runs the function, sends the response, and destroys the container.
- **Cold Start**: The latency/delay (usually 200ms to 2s) when a serverless function runs for the first time in a while because it has to spin up the container environment from scratch.
- **Edge Functions**: Functions that run on servers physically closest to the user (CDN nodes), reducing cold starts and network latency.

---

## Summary: Backend Architecture Map

```
                    ┌──────────────────────────────┐
                    │      DNS / Load Balancer     │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │      Edge / CDN Cache        │
                    └──────────────┬───────────────┘
                                   │
              ┌────────────────────┴────────────────────┐
              │                                         │
    ┌─────────▼─────────┐                     ┌─────────▼─────────┐
    │ Serverless Route  │                     │ Serverless Route  │
    │  (/api/auth)      │                     │  (/api/messages)  │
    └─────────┬─────────┘                     └─────────┬─────────┘
              │                                         │
              └────────────────────┬────────────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │    PgBouncer (Conn Pooler)   │
                    └──────────────┬───────────────┘
                                   │
                    ┌──────────────▼───────────────┐
                    │      PostgreSQL DB (RLS)     │
                    └──────────────────────────────┘
```
