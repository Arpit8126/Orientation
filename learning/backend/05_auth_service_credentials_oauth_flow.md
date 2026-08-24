# Backend Chapter 05: Authentication Graph, Credentials & OAuth Loops

This module covers the architecture of Pookiz's authentication layer, detailing the credential auth loop, Google OAuth integration, PKCE code exchanges, and secure session management.

---

## 1. Objective & Placement Value
- **Why this is asked:** Secure authentication is the most critical pipeline of any web application. Interviewers evaluate your understanding of authentication flows, Google OAuth handshakes, PKCE (Proof Key for Code Exchange) code verifications, and JWT session handling.
- **Placement Value:** Prepares you to design and debug secure credential systems, federated logins, and secure token callback routes in modern web applications.

---

## 2. The Layman's Analogy
Think of the OAuth callback and registration loop as **registering for a student housing building**:
- **Credential Registration:** You sign up at the front desk with a username and password. The housing clerk registers your name, assigns you a room card, and hands you an access key (the JWT).
- **Google OAuth Login (The Partner Identity Card):** Instead of creating a new password, you present your official verified Google identity badge. 
  - The security system redirects you to the Google office across the street.
  - You verify your identity there.
  - The Google office hands you a single-use authorization voucher (**the code**).
  - You walk back to the student housing gate and hand the voucher to the clerk, who exchanges it for your housing key card (**exchanging code for session**).

---

## 3. The Technical Specification

### A. The PKCE (Proof Key for Code Exchange) Authorization Flow
When a user chooses to log in via Google OAuth:
1. **Redirect:** The client redirects the user to the Supabase OAuth authorization URI.
2. **Code Generation:** After the user authenticates with Google, Google redirects the user back to Pookiz's callback endpoint `/auth/callback?code=<authorization-code>`.
3. **Session Exchange:** The server-side API receives the code. It makes a secure back-channel HTTP request to the Supabase Auth server, passing the single-use code to exchange it for a cryptographically signed user session JWT.
4. **Cookie Storage:** The resulting session token is written to secure, HTTP-only request cookies, authorizing subsequent API calls.

### B. Secure Environment-Aware Redirects
In serverless deployments (like Vercel), requests often pass through reverse proxies. This makes reading `request.url` unreliable because the protocol or host might represent the proxy instead of the client-facing server. Pookiz solves this by checking headers:
- `x-forwarded-host`: Identifies the client-facing host header.
- Environment check (`process.env.NODE_ENV === "development"`): Dictates redirect paths (e.g., using local origin `localhost:3000` vs. production domains).

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the authorization callback route in [`D:\Pookiz\pookiz-app\src\app\auth\callback\route.ts`](file:///D:/Pookiz/pookiz-app/src/app/auth/callback/route.ts):

```typescript
import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url);
  const code = searchParams.get("code");
  const next = searchParams.get("next") ?? "/onboarding";
```
- **Line 4-5:** Exports the GET handler. Parses the request URL to extract query parameters and origin metadata.
- **Line 6-7:** Extracts the `code` parameter (sent by Google/Supabase Auth) and the `next` destination parameter (defaulting to `/onboarding`).

```typescript
  if (code) {
    const supabase = await createClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
```
- **Line 9-11:** If the authorization code is present, it initializes the Supabase server client and calls `exchangeCodeForSession(code)`. This exchanges the single-use code for a valid user session, storing the resulting session cookies.

```typescript
    if (!error) {
      const forwardedHost = request.headers.get("x-forwarded-host");
      const isLocalEnv = process.env.NODE_ENV === "development";

      if (isLocalEnv) {
        return NextResponse.redirect(`${origin}${next}`);
      } else if (forwardedHost) {
        return NextResponse.redirect(`https://${forwardedHost}${next}`);
      } else {
        return NextResponse.redirect(`${origin}${next}`);
      }
    }
  }

  return NextResponse.redirect(`${origin}/login?error=auth_callback_error`);
}
```
- **Line 14-15:** Reads proxy headers and detects the current environment state.
- **Line 17-23:** Routes the user:
  - If in development, redirect to the local origin.
  - If behind a proxy in production, redirect using the `x-forwarded-host` header value.
  - Otherwise, fallback to the request origin.
- **Line 27:** If the code is missing or exchange fails, redirect the user back to the login page with an error parameter.

---

## 5. Edge Cases & Optimizations
- **Session Hijacking / CSRF Attacks:** If the authorization code is intercepted, it could be used to hijack a user session.
  - *Fix:* Supabase Auth implements PKCE. The client generates a cryptographically random verifier (`code_verifier`) and sends its hash (`code_challenge`) during the login redirect. The auth server verifies that the code verifier matches the challenge before exchanging the code, preventing interception attacks.
- **Redirect Loops on Exchanged Codes:** If the user refreshes the callback page, the code will have already been used, returning an error.
  - *Fix:* The handler redirects the user to the dashboard or login page immediately, preventing them from staying on the callback page.

---

## 6. Staff Engineer Viva Board

### Q1: What is the PKCE flow in OAuth 2.0, and why is it preferred over the standard Implicit flow for single-page applications?
**Answer:**
*"The **Implicit flow** returns the access token directly in the browser URL hash after login, exposing it to browser history, extensions, or cross-site scripting (XSS) attacks. 

The **PKCE (Proof Key for Code Exchange) flow** solves this by separating the credentials check from the token delivery:
1. The client generates a secret `code_verifier` and a hash `code_challenge`.
2. It sends the challenge during login. Supabase Auth stores it.
3. After login, the client receives a temporary `authorization code` (not the token).
4. The callback endpoint sends this code along with the original `code_verifier` to the auth server.
5. The server verifies the verifier against the challenge. If they match, it returns the session token.
This prevents interception attacks because the authorization code is useless without the client-side code verifier."*

### Q2: Why must we check `x-forwarded-host` when generating redirects in Next.js serverless API routes?
**Answer:**
*"Serverless environments (like Vercel) deploy routing instances behind reverse proxies and load balancers. 
- When an HTTP request reaches Next.js, `request.url` points to the internal serverless host rather than the public domain name.
- Redirecting using `request.url` would route the user to the internal host, causing connection errors.
The `x-forwarded-host` header stores the original client host header. Reading this header allows the server to build the correct redirect path, keeping the user on the public domain."*

### Q3: What is the difference between Cookie-based auth sessions and LocalStorage-based auth sessions?
**Answer:**
*"- **LocalStorage Session Storage:** Tokens are read and sent in HTTP headers via Javascript. They are vulnerable to XSS attacks (malicious scripts can read local storage data).
- **Cookie-based Session Storage:** Tokens are written directly by the server using `HttpOnly` and `Secure` flags. The browser automatically includes cookies in requests. Since the cookies are `HttpOnly`, they cannot be read by client-side Javascript, protecting them from XSS attacks."*

### Q4: Explain the difference between access tokens and refresh tokens.
**Answer:**
*"- **Access Token (JWT):** A short-lived token (usually valid for 1 hour) containing user scopes and permissions. It is sent with every request to authorize access. It cannot be revoked easily, which is why it has a short lifespan.
- **Refresh Token (Opaque String):** A long-lived token stored in the database. When the access token expires, the client sends the refresh token to the auth server to obtain a new access token. If a session is compromised, the refresh token can be revoked, instantly invalidating the session."*

### Q5: What is a CSRF (Cross-Site Request Forgery) attack, and how do cookies protect against them?
**Answer:**
*"A **CSRF attack** occurs when a malicious site forces a user's browser to perform an action on a target site where the user is authenticated (e.g., submitting a post request while logged in). Since browsers automatically include cookies in requests, the target site accepts the request.

We protect against this using **SameSite Cookie Attributes**:
- `SameSite=Strict`: Prevents the browser from sending cookies on cross-site requests.
- `SameSite=Lax` (Default): Allows cookies only for safe top-level navigations (like clicking a link), blocking them for cross-site form submissions or API requests."*
