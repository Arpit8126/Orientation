# Backend Chapter 03: Next.js API Architecture & Middleware Pipeline

This module covers Next.js App Router API design, request routing lifecycle, middleware cookie management, token verification, and serverless execution models.

---

## 1. Objective & Placement Value
- **Why this is asked:** In Serverless Node.js applications, request authorization and routing must run efficiently. Technical interviewers evaluate how you write middleware, manage HTTP cookies, implement session validation (`getUser` vs `getSession`), and design routes to avoid execution timeouts.
- **Placement Value:** Prepares you to write secure, scalable Next.js API architectures, configure server-side redirects, and implement offline-first error mitigations.

---

## 2. The Layman's Analogy
Think of Next.js middleware and route handlers as a **highly secure campus gate and reception desk**:
- **The Outer Gate (The Middleware):** When a student tries to enter the campus (request a page/API), they must pass the outer security gate. The guard (middleware) inspects their entry pass (cookies).
  - If the student is unauthenticated and tries to access the dorm rooms (protected profile page), the guard redirects them directly to the admissions building (login page).
  - If they are logged in and try to enter the admissions office, the guard directs them straight to the main courtyard (dashboard).
- **The Service Desk (The API Route):** If they pass the outer gate and ask for a service (e.g., leaving a group), they reach a specific clerk (API handler) who processes the request.

---

## 3. The Technical Specification

### A. Next.js App Router API Execution Model
Next.js App Router API endpoints run in Serverless environments (Node.js) or edge runtimes:
1. **Dynamic Scaling:** Routes are instantiated as individual functions on demand, scaling horizontally to zero when inactive, saving hosting resources.
2. **HTTP Verb Handler Mapping:** Requests are routed to matching exported functions based on the HTTP method:
   - `export async function GET(request: NextRequest)`
   - `export async function POST(request: NextRequest)`

### B. Middleware Session Lifecycle Management
Supabase SSR client stores session credentials inside cookies. Next.js middleware executes *before* routing completes, allowing it to modify headers and update session tokens:
- **`createServerClient` Context:** The middleware initializes a server client with a custom cookie getter and setter.
- **Cookie Synchronization:** When Supabase updates the user's session token (refreshing the token), the middleware writes the new token back to both the incoming request headers and the outgoing response headers. This keeps the client and server tokens synchronized.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the middleware session updater in [`d:\Pookiz\pookiz-app\src\lib\supabase\middleware.ts`](file:///d:/Pookiz/pookiz-app/src/lib/supabase/middleware.ts):

```typescript
export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )
```
- **Line 5-6:** Initiates the `updateSession` function and generates a baseline response using `NextResponse.next()`.
- **Line 8-11:** Instantiates the Supabase server client using the standard public URL and anonymous key.
- **Line 12-25:** Implements the cookie broker.
  - `getAll()` retrieves cookies from the client request.
  - `setAll()` updates expired or changed tokens. It writes the updated tokens to both the incoming request cookies (so subsequent server code reads the updated state) and the outgoing response cookies (so the client browser saves the new token).

```typescript
  let user = null
  let isNetError = false

  try {
    const {
      data: { user: fetchedUser },
      error: authError,
    } = await supabase.auth.getUser()

    if (authError && isNetworkError(authError)) {
      isNetError = true
    } else {
      user = fetchedUser
    }
  } catch (err) { ... }
```
- **Line 29-33:** Sets up placeholder variables for the user and error states.
- **Line 37-40:** Invokes `supabase.auth.getUser()`. This calls the Supabase authentication server to verify the JWT signature stored in the request cookies, preventing token tampering.
- **Line 42-46:** If the verification fails due to a network connection error, set the `isNetError` flag to prevent unauthorized redirects.

```typescript
  if (isNetError) {
    return supabaseResponse
  }

  // ... (URL path classification logic) ...

  // Redirect unauthenticated users to login ONLY for auth-required pages
  if (!user && !isAuthPage && !isCallbackPage && !isPublicApi && !isPublicPage && isAuthRequiredPage) {
    const url = request.nextUrl.clone()
    const redirectTo = request.nextUrl.pathname + request.nextUrl.search
    url.pathname = '/login'
    url.searchParams.set('redirectTo', redirectTo)
    return NextResponse.redirect(url)
  }
```
- **Line 55-57:** If a network connection error is encountered, bypass redirects so that offline users are not redirected to the login page.
- **Line 84-90:** If the user is unauthenticated and tries to access a protected page (like `/profile`), it redirects them to `/login` and appends the original page URL in the `redirectTo` query parameter to allow redirecting them back on successful login.

---

## 5. Edge Cases & Optimizations
- **Session Revalidation Overhead:** Querying the Supabase auth server via `getUser()` on every request adds overhead.
  - *Fix:* Optimize the middleware matcher configuration (`config.matcher`) to exclude static assets (images, CSS, JS) and only run the middleware on document, layout, or API requests.
- **Vercel Cold Starts:** Serverless functions suffer from cold start latency when first invoked.
  - *Fix:* Keep dependencies light, configure Vercel region allocations close to the database, and use Edge runtimes for simple routing functions.

---

## 6. Staff Engineer Viva Board

### Q1: Why must we modify both the request and response cookies inside the middleware's `setAll` function?
**Answer:**
*"Next.js middleware runs before the request reaches the page routing or API handler:
1. **Request Cookies:** We update the request cookies so that the subsequent API route or Server Component executing on Vercel reads the updated token during the current execution cycle. If we only updated the response, the server component would read the expired token, causing authorization checks to fail.
2. **Response Cookies:** We update the response cookies so that Vercel returns the new cookies to the client browser, allowing it to save the updated session token."*

### Q2: What is the risk of using `supabase.auth.getSession()` inside the middleware?
**Answer:**
*"`getSession()` is insecure because it parses the session token directly from the local cookies without validating its cryptographic signature on the auth server. An attacker could forge a cookie with arbitrary user claims, and `getSession()` would accept it as valid, leading to unauthorized access.

`getUser()` calls the Supabase authentication server to verify the JWT signature. This is secure and must always be used for authentication inside APIs and middleware."*

### Q3: Explain why we check for network errors inside `updateSession` before redirecting unauthenticated users.
**Answer:**
*"If the database server is temporarily offline, or if the student's device loses network connection:
1. `supabase.auth.getUser()` will fail, returning a network connection error.
2. If we did not check for this error, the middleware would assume the user is unauthenticated (`user = null`) and redirect them to the login page.
3. This creates a bad user experience where users are logged out of the app when they are simply offline.
By checking for network errors and returning `NextResponse.next()`, we bypass redirects during offline states, allowing the app to handle connection states gracefully."*

### Q4: How does Next.js match requests to the middleware function?
**Answer:**
*"Next.js matches requests using the exported `config.matcher` array in `middleware.ts`. 

We configure this using a regex pattern:
```typescript
'/((?!_next/static|_next/image|favicon.ico|manifest\\.json|sw\\.js|.*\\.(?:svg|png|jpg|jpeg)$).*)'
```
This regex tells Next.js to ignore requests for static files (CSS, JS, images, icons, and assets) and only execute the middleware on API calls, page routes, and layout loads, reducing database overhead."*

### Q5: What is the difference between redirects (`NextResponse.redirect`) and rewrites (`NextResponse.rewrite`) in Next.js?
**Answer:**
*"- **`NextResponse.redirect` (CORS Redirect):** Sends an HTTP status code `307` or `308` redirect response back to the browser. The browser's URL bar changes to the new destination path, and the client initiates a new request.
- **`NextResponse.rewrite` (Internal Masking):** Resolves the target page on the server and returns it directly under the original URL. The browser's URL bar does not change. This is useful for user-friendly vanity URLs or A/B testing."*
