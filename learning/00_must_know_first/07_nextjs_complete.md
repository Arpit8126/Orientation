# Next.js App Router — Complete Guide from Zero to Real World (Extended)

Next.js is a React framework for building full-stack web applications. It extends React by adding routing, optimization, data fetching, and rendering strategies out of the box.

---

## PART 1: Why Next.js?

In a standard React application:
1. **Client-Side Rendering (CSR)**: The browser downloads a minimal HTML file and a large JavaScript bundle. The browser then executes the JavaScript to build and render the page.
2. **Problems with CSR**:
   - Slow initial page load (white screen while JS downloads).
   - Poor SEO (search engine crawlers see empty HTML before JS runs).
   - Exposes database keys and API endpoints to client-side code.

Next.js solves this by running React on the **server** first. It pre-renders pages into HTML on the server and streams the complete HTML back to the browser. This results in:
- Fast initial page load (instant visual render).
- Excellent SEO (search engines read fully rendered HTML).
- Server-side security (direct database queries, secret keys remain on the server).

---

## PART 2: Routing in App Router

Next.js uses a **file-system based router** where folders define the URLs.

### Special File Names:
- `page.tsx`: The UI rendered for a specific route.
- `layout.tsx`: Reusable shell wrapper that wraps child routes. Persistent across navigation.
- `template.tsx`: Similar to layout, but recreates a fresh instance on navigation (resets state).
- `loading.tsx`: Loading fallback UI powered by React Suspense. Shown automatically during page load.
- `error.tsx`: Error fallback UI powered by React Error Boundaries.
- `not-found.tsx`: The 404 page for the current route folder.

### Route Structures:

```
src/app/
├── layout.tsx             ← Root layout (contains <html> and <body>)
├── page.tsx               ← Home route (/)
├── about/
│   └── page.tsx           ← About route (/about)
│
├── dashboard/
│   ├── layout.tsx         ← Dashboard-specific nested layout
│   ├── page.tsx           ← Dashboard home route (/dashboard)
│   └── settings/
│       └── page.tsx       ← Settings route (/dashboard/settings)
│
├── chat/
│   ├── [id]/
│   │   └── page.tsx       ← Dynamic route (/chat/123, /chat/abc)
│   └── page.tsx           ← Chat home (/chat)
│
├── docs/
│   ├── [...slug]/
│   │   └── page.tsx       ← Catch-all route (/docs/a, /docs/a/b/c)
│   └── [[...slug]]/
│       └── page.tsx       ← Optional catch-all (/docs, /docs/a)
│
├── (auth)/                ← Route Group (omitted from URL path)
│   ├── login/
│   │   └── page.tsx       ← Login route (/login, NOT /auth/login)
│   └── signup/
│       └── page.tsx       ← Signup route (/signup)
│
├── @modal/
│   └── (.)login/
│       └── page.tsx       ← Parallel & Intercepted Route (renders modal over page)
│
└── api/
    └── messages/
        └── route.ts       ← API Route Handler (/api/messages)
```

---

## PART 3: Advanced Routing (Dynamic, Catch-all, Parallel & Intercepted)

### 1. Dynamic Segments (`[id]`)
Passes parameters as route variables.

```tsx
// app/chat/[id]/page.tsx
type PageProps = {
  params: Promise<{ id: string }>;
};

export default async function ChatPage({ params }: PageProps) {
  const { id } = await params;
  return <h1>Chat Room: {id}</h1>;
}
```

### 2. Catch-all Routes (`[...slug]`)
Matches one or more folders. For example, `app/docs/[...slug]/page.tsx` matches `/docs/intro`, `/docs/install/windows`, etc. `params.slug` will be an array: `["install", "windows"]`.
* **Optional catch-all (`[[...slug]]`)**: Matches the route *without* parameters too (matches `/docs` directly, where `params.slug` is `undefined`).

### 3. Parallel Routes (`@folder`)
Allows you to render multiple pages simultaneously inside the same layout (great for dashboards or modals).

```tsx
// app/layout.tsx
// Renders page.tsx and @modal layout simultaneously
export default function Layout({
  children,
  modal
}: {
  children: React.ReactNode;
  modal: React.ReactNode;
}) {
  return (
    <html>
      <body>
        <div>{children}</div>
        <div>{modal}</div> {/* Render parallel segment */}
      </body>
    </html>
  );
}
```

### 4. Intercepted Routes (`(.)folder`)
Allows you to load a route inside the current layout while masking the URL.
- `(.)` matches segments at the **same level**.
- `(..)` matches segments **one level above**.
- `(..)(..)` matches segments **two levels above**.
- `(...)` matches segments from the **root app directory**.

*Use Case (The Photo Modal): When a user clicks a photo in a feed, we intercept the click and open the photo in a modal (`@modal/(.)photo/[id]`). The URL changes to `/photo/123`. But if the user shares that link or refreshes the page, they load the full photo page (`app/photo/[id]/page.tsx`) instead of the modal.*

---

## PART 4: Server Components (RSC) vs Client Components

Next.js App Router introduces Server Components by default. This is a crucial concept.

| Feature | Server Components (Default) | Client Components (`'use client'`) |
|---|---|---|
| **Where it runs** | Runs **only on the server**. | Runs on server (pre-render) and **hydrates on client**. |
| **JS bundle size** | Zero javascript sent to browser. | JS is compiled and sent to browser. |
| **Interactivity** | Cannot use hooks (`useState`, `useEffect`) or click handlers. | Can use state, hooks, event listeners (`onClick`). |
| **Data Fetching** | Can query databases directly, read server files, secure API calls. | Must fetch via HTTP requests (`fetch('/api/...')`). |
| **Security** | Safe to use private API keys and environment variables. | Cannot expose private keys (only `NEXT_PUBLIC_` keys). |

### Nesting Rules:
- You **cannot** import a Server Component directly into a Client Component.
- Instead, pass Server Components as **children** or **props** to Client Components:
  ```tsx
  // ClientComponent.tsx ('use client')
  export default function ClientLayout({ children }: { children: React.ReactNode }) {
    return <div className="interactive-shell">{children}</div>;
  }

  // page.tsx (Server Component)
  import ClientLayout from "./ClientComponent";
  import ServerDataWidget from "./ServerComponent";

  export default function Page() {
    return (
      <ClientLayout>
        <ServerDataWidget /> {/* Passed as children */}
      </ClientLayout>
    );
  }
  ```

---

## PART 5: Data Fetching, Caching and Revalidation

Next.js extends the native Web `fetch` API to allow caching and revalidating request states on the server.

### 1. Caching Strategies:
- **Force Cache (Default)**: Cache data forever.
  ```javascript
  fetch("https://api.example.com/data", { cache: "force-cache" });
  ```
- **No Store (Dynamic)**: Fetch fresh data on every single request (no caching).
  ```javascript
  fetch("https://api.example.com/data", { cache: "no-store" });
  ```
- **Time-based Revalidation**: Cache data for a specific duration (in seconds).
  ```javascript
  fetch("https://api.example.com/data", { next: { revalidate: 3600 } }); // Cache for 1 hour
  ```

### 2. On-Demand Revalidation:
You can manually clear caches on-demand when a mutation occurs using `revalidatePath` or `revalidateTag` inside Server Actions.

```typescript
// app/actions.ts
'use server';

import { revalidatePath, revalidateTag } from "next/cache";

export async function addComment(commentData: any) {
  await saveToDb(commentData);

  // Clear cache for this page path and force reload fresh data
  revalidatePath("/chat");
}
```

---

## PART 6: Server Actions

Server Actions are asynchronous functions that run on the server. They can be called directly from Client or Server Components, eliminating the need to write manual API routes.

```tsx
// app/posts/CreatePostForm.tsx (Client Component)
'use client';

import { createPostAction } from "./actions";

export default function CreatePostForm() {
  return (
    <form action={createPostAction}>
      <input type="text" name="title" required placeholder="Post Title" />
      <textarea name="content" required placeholder="Write post content..." />
      <button type="submit">Create Post</button>
    </form>
  );
}
```

```typescript
// app/posts/actions.ts (Server Action file)
'use server';

import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";

export async function createPostAction(formData: FormData) {
  const title = formData.get("title") as string;
  const content = formData.get("content") as string;

  // Insert into DB directly
  await db.insert({ title, content });

  // Revalidate page cache
  revalidatePath("/posts");

  // Redirect user
  redirect("/posts");
}
```

---

## PART 7: Route Handlers (API Endpoints)

If you need to expose endpoints for external services, mobile apps, or webhooks, use Route Handlers (`route.ts`).

```typescript
// app/api/messages/route.ts
import { NextResponse } from "next/server";

// Handle GET requests
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const limit = searchParams.get("limit") || "10";

  const data = await db.fetchMessages({ limit: parseInt(limit) });
  
  return NextResponse.json(data);
}

// Handle POST requests
export async function POST(request: Request) {
  try {
    const body = await request.json(); // parse JSON body
    const newMessage = await db.saveMessage(body);

    return NextResponse.json(newMessage, { status: 201 });
  } catch (error) {
    return NextResponse.json({ error: "Invalid payload" }, { status: 400 });
  }
}
```

---

## PART 8: The 4 Core Rendering Strategies

Next.js allows you to control how each page is rendered on the server:

1. **SSG (Static Site Generation)**: Pages are pre-rendered into HTML at **build time**. These pages are completely static and served instantly via CDNs (best performance, e.g., blog pages, docs).
2. **SSR (Server-Side Rendering)**: Pages are rendered into HTML on the server for **every single request** (best for user-specific dashboard pages).
3. **ISR (Incremental Static Regeneration)**: Allows you to update static pages in the background *after* building, without rebuilding the whole site.
   ```typescript
   export const revalidate = 60; // Revalidate page every 60 seconds
   ```
4. **PPR (Partial Prerendering)**: A newer hybrid strategy. It immediately sends a pre-rendered static HTML shell (containing page skeletons) and streams dynamic segments (like user profiles or real-time lists) inline as soon as they resolve.

---

## PART 9: Next.js Optimizations

### 1. Image Optimization (`next/image`)
Replaces standard `<img>` tags. It automatically:
- Prevents Cumulative Layout Shift (CLS) by requiring defined aspect ratios.
- Resizes images dynamically for different screen resolutions.
- Serves modern WebP or AVIF formats.
- Enables lazy loading by default.

```tsx
import Image from "next/image";

export default function Avatar() {
  return (
    <Image
      src="/avatar.png"
      alt="User Avatar"
      width={100}
      height={100}
      priority // Load immediately if visible above the fold
    />
  );
}
```

### 2. Font Optimization (`next/font`)
Downloads and hosts Google Fonts locally during the build process, preventing font-flicker (flash of unstyled text) and improving page loads.

```tsx
import { Outfit } from "next/font/google";
const outfit = Outfit({ subsets: ["latin"], weight: ["400", "700"] });
// Apply 'outfit.className' directly to your html/body tag
```

### 3. Metadata API (SEO)
Next.js provides a built-in Metadata API to export page-specific titles, descriptions, and OpenGraph social shares.

```tsx
// Static Metadata (exported in page.tsx or layout.tsx)
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Pookiz — Campus Social Network",
  description: "Connect with university classmates in real-time."
};

// Dynamic Metadata (based on parameters)
export async function generateMetadata({ params }: { params: { id: string } }): Promise<Metadata> {
  const { id } = params;
  const chatRoom = await db.getRoom(id);

  return {
    title: `Chat Room: ${chatRoom.name}`,
    description: `Join chat room conversation on Pookiz.`
  };
}
```

---

## PART 10: Navigation

In Next.js, always use the `<Link>` component for routing. It pre-fetches the page in the background, making transitions instant. Never use raw `<a>` tags (they cause full page reloads).

```tsx
import Link from "next/link";

export default function Navbar() {
  return (
    <nav>
      <Link href="/">Home</Link>
      <Link href="/about">About</Link>
      <Link href="/chat/123">Chat Room</Link>
    </nav>
  );
}
```

### Programmatic Navigation (inside Client Components):
Use the `useRouter` hook from `next/navigation` for navigation trigger logic.

```tsx
'use client';

import { useRouter } from "next/navigation";

export default function CheckoutButton() {
  const router = useRouter();

  function handlePurchase() {
    // Process payment...
    router.push("/success");
  }

  return <button onClick={handlePurchase}>Buy Now</button>;
}
```

---

## PART 11: Edge Middleware

Middleware runs on every request BEFORE it reaches any routing files, allowing you to intercept requests and rewrite or redirect them.

```typescript
// src/middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('session_token')?.value;

  // If trying to access dashboard and unauthenticated, redirect to login
  if (request.nextUrl.pathname.startsWith('/dashboard')) {
    if (!token) {
      return NextResponse.redirect(new URL('/login', request.url));
    }
  }

  return NextResponse.next(); // continue to page
}

// Limit middleware to run only on matching routes
export const config = {
  matcher: ['/dashboard/:path*', '/settings/:path*'],
};
```

---

## PART 12: Route Segment Configurations

You can control page features by exporting specific constants from any page file:

```typescript
// Force page to render dynamically on every request (no build-time caching)
export const dynamic = "force-dynamic"; // 'auto' | 'force-dynamic' | 'error' | 'force-static'

// Force route to run on Vercel's lightweight Edge runtime (for speed)
export const runtime = "edge"; // 'nodejs' | 'edge'

// Control data caching revalidation limit
export const revalidate = 60; // 60 seconds
```

---

## Summary: Next.js Cheat Sheet

| Task | Next.js API / File | Code Pattern |
|---|---|---|
| **Define Route** | `page.tsx` in a folder | `src/app/about/page.tsx` |
| **Share Layout** | `layout.tsx` in folder | `src/app/dashboard/layout.tsx` |
| **Client-side interactive**| `'use client'` directive | Put at the very top of file |
| **Server Fetch** | Standard `async/await` | `const data = await (await fetch(url)).json();` |
| **Manual Revalidate** | `revalidatePath(path)` | Call inside Server Action after mutation |
| **Create Form Action** | `use server` Server Actions | `<form action={serverAction}>` |
| **API Endpoint** | `route.ts` with HTTP verb fn | `export async function GET(req) { ... }` |
| **Catch-All Route** | `[...slug]` folder | `app/docs/[...slug]/page.tsx` |
| **Parallel Route** | `@folder` folder | `app/@modal/page.tsx` |
| **Intercept Route** | `(.)folder` folder | `app/@modal/(.)login/page.tsx` |
| **Image Optimization**| `<Image />` component | `<Image src="..." width={50} height={50} />` |
| **Dynamic SEO** | `generateMetadata()` export | `export async function generateMetadata(...)` |
| **Route Configuration**| Segment exports | `export const dynamic = 'force-dynamic';` |
```
