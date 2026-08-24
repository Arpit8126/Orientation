# Frontend Chapter 14: Pookiz Folder Structure & Special Files — Complete Map

This module is a complete reference for every folder and special file inside the `pookiz-app` project, explaining what lives where and why.

---

## 1. Objective & Placement Value
- **Why this is asked:** Any serious developer interview asks you to walk through a project's architecture. Interviewers evaluate whether you understand the *why* behind the file layout, not just the *what*.
- **Placement Value:** Demonstrates senior-level understanding of Next.js App Router conventions, separation of concerns, and production project organization.

---

## 2. The Layman's Analogy
Think of the project as a **well-organized university campus building**:
- **`/public`** = The reception lobby. Everything here is visible to *anyone* walking in — logos, icons, ringtones. No security checkpoint.
- **`/src/app`** = The classrooms and offices. Each folder inside is a different room (URL route).
- **`/src/components`** = The furniture and equipment factory. Reusable chairs, desks, and whiteboards that many rooms use.
- **`/src/lib`** = The engineering basement. The power systems (Supabase clients, formatters) that everything runs on.
- **`/src/hooks`** = The intercom system. Hooks allow rooms to listen and react to events happening elsewhere.
- **`/src/context`** = The campus-wide PA system. Broadcasts shared state to all rooms simultaneously.
- **`/src/types`** = The official campus rulebook. Defines the shape of every data object.
- **`/src/utils`** = The toolbox. Utility functions like feature flags and theme constants.
- **`/src/middleware.ts`** = The security guard at the entrance gate.

---

## 3. Complete Folder Map

```
pookiz-app/
├── public/                          ← Static assets served publicly (no auth needed)
│   ├── pookiz-logo.png              ← App branding logo
│   ├── pookiz-favicon.png           ← Browser tab icon
│   ├── anonymous-logo.png           ← Default avatar for anonymous users
│   ├── welcome-logo.png             ← Onboarding screen logo
│   ├── manifest.json                ← PWA metadata (app name, icons, theme_color)
│   ├── sw.js                        ← Service Worker (push notifications + offline support)
│   ├── notification_sound.wav       ← Played when a message arrives
│   ├── ringtone_call.mp3            ← Played during incoming voice/video call
│   └── cartel_cypher_wallpaper.png  ← Chat background wallpaper (dark/light variants)
│
├── src/
│   ├── middleware.ts                 ← ★ Entry-point for ALL HTTP requests (auth gate)
│   │
│   ├── app/                         ← Next.js App Router: all pages & API routes
│   │   ├── layout.tsx               ← Root HTML shell: <html>, <body>, global font
│   │   ├── page.tsx                 ← Root "/" route (redirects to /home or /login)
│   │   ├── globals.css              ← Global CSS, Tailwind directives, custom keyframes
│   │   ├── icon.png                 ← Favicon used by Next.js metadata API
│   │   ├── robots.ts                ← SEO: generates /robots.txt dynamically
│   │   ├── sitemap.xml/             ← SEO: generates /sitemap.xml dynamically
│   │   │
│   │   ├── (auth)/                  ← Route group: auth pages (no main layout applied)
│   │   │   └── login/, register/    ← Login and registration pages
│   │   │
│   │   ├── auth/                    ← OAuth callback handler (not a UI page)
│   │   │   └── callback/route.ts    ← Exchanges Google OAuth code for session cookie
│   │   │
│   │   ├── onboarding/              ← Post-signup profile setup wizard
│   │   │
│   │   ├── home/                    ← Public landing page (shown to non-logged-in users)
│   │   │
│   │   ├── user/                    ← Public profile pages (/user/username)
│   │   │
│   │   ├── (main)/                  ← Route group: all protected pages (uses MainLayout)
│   │   │   ├── layout.tsx           ← Applies MainLayout (sidebar + nav) to all children
│   │   │   ├── loading.tsx          ← Suspense fallback for the entire (main) group
│   │   │   ├── dashboard/           ← Home feed page (/dashboard)
│   │   │   ├── tea/                 ← Spill the Tea feed (/tea) + post detail (/tea/[postId])
│   │   │   ├── quizzes/             ← Quiz list (/quizzes) + quiz player (/quizzes/[id])
│   │   │   ├── groups/              ← Discover groups page (/groups)
│   │   │   ├── joined-groups/       ← User's joined groups list
│   │   │   ├── friends/             ← Friends management page (/friends)
│   │   │   ├── profile/             ← Own profile page (/profile)
│   │   │   ├── notifications/       ← Notifications feed (/notifications)
│   │   │   ├── search/              ← User search page (/search)
│   │   │   └── calls/               ← Video/voice call room (/calls)
│   │   │
│   │   └── api/                     ← All backend API route handlers
│   │       ├── auth/                ← Auth helpers (token refresh etc.)
│   │       ├── tea/                 ← Posts: CRUD, comments, aura votes, polls, saves
│   │       ├── quizzes/             ← Quiz: list, submit, AI generate, PDF parse, progress
│   │       ├── chat/                ← Chat AI bot endpoint
│   │       ├── messages/            ← Message edit endpoint
│   │       ├── friends/             ← Friend requests: send, respond, remove
│   │       ├── groups/              ← Group: create, join, leave, delete, settings
│   │       ├── livekit/             ← LiveKit voice/video token generation
│   │       ├── blocks/              ← Block/unblock user
│   │       ├── feedback/            ← User feedback submission
│   │       ├── notification-prefs/  ← Notification preferences
│   │       ├── push/                ← Web push subscription management
│   │       ├── teachers/            ← Teacher verification endpoints
│   │       ├── universities/        ← University data endpoints
│   │       └── tea/[postId]/        ← Post-specific: comments, aura, poll, share, save
│   │
│   ├── components/                  ← Reusable UI building blocks
│   │   ├── MainLayout.tsx           ← ★ The entire sidebar + nav + chat panel shell
│   │   ├── ProfileCard.tsx          ← Rich user profile card (used in sidebar + profile page)
│   │   ├── LinkedInProfileSection.tsx ← LinkedIn-style work/education display
│   │   ├── OfflineScreen.tsx        ← Shown when device loses internet connection
│   │   │
│   │   ├── chat/                    ← All chat-related components
│   │   │   ├── ChatListSidebar.tsx  ← Left panel: list of DMs and group conversations
│   │   │   ├── DMChat.tsx           ← Direct message full chat window
│   │   │   ├── GroupChat.tsx        ← Group chat full chat window
│   │   │   ├── MessageBubble.tsx    ← Individual message bubble (text, image, reactions)
│   │   │   └── EmojiDrawer.tsx      ← Emoji picker panel
│   │   │
│   │   ├── tea/                     ← All Spill the Tea components
│   │   │   ├── TeaCard.tsx          ← Individual post card in the feed
│   │   │   ├── CreateTeaModal.tsx   ← Post creation modal (text + media + poll)
│   │   │   ├── TeaCommentDrawer.tsx ← Slide-out comments drawer
│   │   │   ├── TeaCommentsSection.tsx ← Comments list with threading
│   │   │   ├── TeaShareModal.tsx    ← Share a post to DM/group modal
│   │   │   ├── YourTeaSection.tsx   ← "Your Posts" section in profile
│   │   │   ├── AnonymousMaskAvatar.tsx ← Masked avatar for anonymous posts
│   │   │   └── GuestAuthPromptModal.tsx ← Prompts guests to login to interact
│   │   │
│   │   └── ui/                      ← Generic primitive components
│   │       ├── Button.tsx           ← Styled button with variants
│   │       ├── Input.tsx            ← Styled text input with validation states
│   │       ├── Modal.tsx            ← Generic overlay modal wrapper
│   │       ├── Dropdown.tsx         ← Dropdown menu with keyboard navigation
│   │       ├── Avatar.tsx           ← User avatar with fallback initials
│   │       ├── Badge.tsx            ← Small status badge component
│   │       ├── Toast.tsx            ← Toast notification system
│   │       ├── Card.tsx             ← Generic card container
│   │       ├── Spinner.tsx          ← Loading spinner
│   │       ├── LoadingOverlay.tsx   ← Full-screen loading overlay
│   │       ├── VerifiedBadge.tsx    ← Blue checkmark verified badge
│   │       └── index.ts             ← Re-exports all UI components cleanly
│   │
│   ├── hooks/                       ← Custom React hooks
│   │   ├── useRealtime.ts           ← Subscribe to Supabase real-time table events
│   │   ├── usePresence.tsx          ← Track online/offline status of users
│   │   └── useDebounce.ts           ← Debounce rapidly-changing values (search input)
│   │
│   ├── context/                     ← React Context providers (global state)
│   │   ├── ChatSidebarContext.tsx   ← Manages which chat is open, sidebar state
│   │   ├── CallContext.tsx          ← LiveKit voice/video call state machine
│   │   └── ChatDropContext.tsx      ← Drag-and-drop file sharing into chat state
│   │
│   ├── lib/                         ← Core library utilities
│   │   ├── supabase/
│   │   │   ├── client.ts            ← Browser-side Supabase client (used in components)
│   │   │   ├── server.ts            ← Server-side Supabase client (used in API routes)
│   │   │   ├── middleware.ts        ← updateSession() — cookie refresh logic
│   │   │   ├── admin.ts             ← Service-role admin client (bypasses RLS)
│   │   │   └── networkError.ts      ← Detects network vs auth errors
│   │   ├── constants.ts             ← App-wide constants (site URL, limits)
│   │   ├── formatting.ts            ← Date/time/number formatting functions
│   │   ├── utils.ts                 ← General helpers (class merging, etc.)
│   │   ├── push.ts                  ← Web Push notification sending logic
│   │   └── push-keys.json           ← VAPID public key for push subscriptions
│   │
│   ├── types/
│   │   └── database.ts              ← Auto-generated TypeScript types for all DB tables
│   │
│   ├── utils/
│   │   ├── featureFlags.ts          ← Runtime feature toggles (e.g. DISABLE_PROCTORING)
│   │   └── themeConstants.ts        ← Color palette, font, spacing design tokens
│   │
│   └── config/
│       └── emojis.ts                ← Full emoji list for the emoji picker
│
├── next.config.ts                   ← Next.js config: image domains, headers, rewrites
├── tsconfig.json                    ← TypeScript compiler config + path aliases (@/...)
├── package.json                     ← Dependencies list and npm scripts
├── postcss.config.mjs               ← PostCSS config (required by TailwindCSS)
├── eslint.config.mjs                ← ESLint linting rules
└── .env.local                       ← Secret environment variables (NOT committed to git)
```

---

## 4. Special Files Explained in Detail

### A. `src/middleware.ts` — The Security Gate
```typescript
import { updateSession } from '@/lib/supabase/middleware'

export async function middleware(request: NextRequest) {
  return await updateSession(request)  // refreshes session cookie + redirects
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico|manifest\\.json|sw\\.js|...).*)']
}
```
- Runs **before every request** reaches any page or API route.
- Calls `updateSession()` from `lib/supabase/middleware.ts` to refresh JWT tokens.
- The `config.matcher` tells Next.js which paths to run middleware on — it **skips** static files (images, CSS, JS, SW, manifest) to avoid unnecessary overhead.
- This is where login redirects happen for unauthenticated users.

### B. `src/lib/supabase/client.ts` — Browser Client
```typescript
createBrowserClient(SUPABASE_URL, SUPABASE_ANON_KEY)
```
- Used inside **React components and hooks** (client-side code).
- Runs in the browser. Has access to the user's session cookies automatically.
- Used for real-time subscriptions, auth sign-in/out calls.

### C. `src/lib/supabase/server.ts` — Server Client
```typescript
createServerClient(SUPABASE_URL, SUPABASE_ANON_KEY, { cookies: cookieStore })
```
- Used inside **API routes and Server Components**.
- Reads session cookies from the incoming HTTP request to identify the user.
- Has RLS enforcement — the user can only see what the database policies allow.

### D. `src/lib/supabase/admin.ts` — Admin Client
```typescript
createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)
```
- Uses the **service role key**, which bypasses RLS entirely.
- Used only on secure server routes where admin-level database access is needed (e.g., creating user records during onboarding).
- **Never used on the client side** — exposing the service role key is a critical security vulnerability.

### E. `public/sw.js` — Service Worker
- A JavaScript file that runs in the browser **outside of the React app**, in a separate worker thread.
- Listens for Web Push notifications from the server.
- Displays system notification popups even when the app tab is closed.
- Registered by the app on load using `navigator.serviceWorker.register('/sw.js')`.

### F. `public/manifest.json` — PWA Manifest
```json
{
  "name": "Pookiz",
  "short_name": "Pookiz",
  "start_url": "/dashboard",
  "display": "standalone",
  "theme_color": "#0f172a",
  "icons": [...]
}
```
- Makes Pookiz installable as a **Progressive Web App (PWA)** on mobile.
- When a user visits the site on mobile, the browser offers to "Add to Home Screen".
- `display: standalone` makes it look like a native app (no browser chrome).

### G. `src/types/database.ts` — TypeScript Database Types
- Auto-generated by Supabase CLI from the live database schema.
- Defines TypeScript interfaces for every table row: `Database['public']['Tables']['profiles']['Row']`.
- Prevents typos when writing database queries — TypeScript will flag invalid column names at compile time.

### H. `src/utils/featureFlags.ts` — Feature Toggles
```typescript
export const DISABLE_PROCTORING = process.env.NEXT_PUBLIC_DISABLE_PROCTORING === 'true'
```
- Allows turning features on/off via environment variables without code changes.
- `DISABLE_PROCTORING` is used during development to skip the anti-cheat system when testing quizzes.

---

## 5. Key Naming Conventions

| Convention | Example | Meaning |
|---|---|---|
| `(group)/` | `(main)/`, `(auth)/` | Route groups — groups pages for shared layouts WITHOUT affecting the URL |
| `[param]/` | `[postId]/`, `[id]/` | Dynamic route segments — the folder name becomes a URL parameter |
| `route.ts` | `api/tea/route.ts` | API endpoint handler — not a page, returns JSON responses |
| `page.tsx` | `dashboard/page.tsx` | UI page — renders HTML, maps directly to a URL |
| `layout.tsx` | `(main)/layout.tsx` | Shared layout wrapper — wraps all child `page.tsx` files in its group |
| `loading.tsx` | `(main)/loading.tsx` | React Suspense fallback — shown while the page is fetching data |

---

## 6. Staff Engineer Viva Board

### Q1: Why does the `(main)` folder use parentheses? What is a Route Group?
**Answer:**
*"In Next.js App Router, a folder wrapped in parentheses `()` creates a **Route Group**. This is a purely organizational concept that does not appear in the URL path.

For example, `(main)/dashboard/page.tsx` maps to `/dashboard`, not `/main/dashboard`. The parentheses tell Next.js to use that folder for shared layouts without adding the folder name to the URL structure. This lets us apply the `MainLayout` (with sidebar and nav) to all protected pages without changing the URL paths."*

### Q2: What is the difference between `client.ts`, `server.ts`, and `admin.ts` in the supabase lib?
**Answer:**
*"- **`client.ts`**: Uses `createBrowserClient`. Runs in the browser. Accesses session cookies automatically via the browser cookie store. Used in React components and hooks.
- **`server.ts`**: Uses `createServerClient`. Runs on the server. Manually reads session cookies from the incoming HTTP request. Used in API routes and Server Components. Has RLS enforcement.
- **`admin.ts`**: Uses the service role key. Bypasses all RLS policies. Should only ever be called from secure server-side code, never exposed to the browser."*

### Q3: Why must the Service Worker file (`sw.js`) live in `/public`?
**Answer:**
*"Service Workers can only intercept network requests within their **scope**. The scope of a service worker is defined by the folder it is served from.

If `sw.js` was served from `/src/` or any nested path, it could only intercept requests under that path. By placing it in `/public`, it is served at `/sw.js` (the root), giving it scope over the entire domain and allowing it to intercept all push notification messages for the app."*

### Q4: What is `tsconfig.json`'s `paths` configuration, and why does the project use `@/` imports?
**Answer:**
*"The `tsconfig.json` `paths` configuration creates import aliases. The `@/` alias maps to `src/`:
```json
{ \"paths\": { \"@/*\": [\"./src/*\"] } }
```
Instead of writing `../../../lib/supabase/client`, any file can write `@/lib/supabase/client`. This:
1. Eliminates fragile relative paths that break when files are moved.
2. Makes import statements readable and consistent across the entire codebase."*

### Q5: What is the purpose of `loading.tsx` in the (main) route group?
**Answer:**
*"`loading.tsx` is a Next.js App Router convention. When React navigates to a page that needs to fetch data (a Server Component), it automatically renders the nearest `loading.tsx` as a **Suspense fallback** while the page loads.

This gives users instant visual feedback (a loading skeleton or spinner) instead of staring at a blank white screen, significantly improving the perceived performance of data-heavy pages."*
