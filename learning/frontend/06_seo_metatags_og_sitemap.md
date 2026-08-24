# Frontend Chapter 06: SEO — Meta Tags, Open Graph & Sitemap

This chapter explains Search Engine Optimization from scratch — how search engines find your site, how to make it rank higher, and how social media shows rich previews of your links.

---

## 1. Objective & Placement Value
- **Why this is asked:** Any frontend/full-stack role asks "How would you improve SEO for this app?" Interviewers at product companies need to know you understand discoverability.
- **Placement Value:** Shows you build complete, production-quality features — not just functional code but also searchable, shareable, and indexable code.

---

## 2. The Layman's Analogy

Think of the **internet as a massive library**, and **Google as a librarian** who organizes it:

- When you build a website without SEO, you add a book to the library with **no title, no cover, no author name, no category label**. The librarian has no idea what it is, puts it in a random corner, and nobody ever finds it.

- When you add SEO: you give the book a clear title, description, author, and put it in the right category shelf. The librarian indexes it properly, and when someone asks for "university social media app", your book comes up.

**Open Graph** = the book's cover art that shows up when you share the link on WhatsApp/LinkedIn.

**Sitemap** = a directory listing of all your books, given directly to the librarian so they know every page exists.

---

## 3. The Technical Specification

### A. How Search Engines Work

```
1. Crawling   → Google's bots visit your website and read HTML
2. Indexing   → Google stores what it found in its database
3. Ranking    → When someone searches, Google ranks pages by relevance

Your job: Help crawlers understand your content quickly and clearly.
```

---

### B. The HTML `<head>` — Where SEO Lives

```html
<head>
  <!-- 1. TITLE TAG — shown in browser tab and Google search results -->
  <title>Pookiz — Campus Social Network for GLA University</title>

  <!-- 2. META DESCRIPTION — shown under title in Google results -->
  <meta
    name="description"
    content="Pookiz is a real-time campus social network for university students. Chat, create study groups, and connect with classmates."
  />

  <!-- 3. CANONICAL — tells Google which URL is the "official" version -->
  <!-- Prevents duplicate content penalty when same page has multiple URLs -->
  <link rel="canonical" href="https://pookiz.vercel.app/" />

  <!-- 4. ROBOTS — controls how search engines crawl this page -->
  <meta name="robots" content="index, follow" />
  <!--
    index = include this page in search results
    follow = follow links on this page to discover more pages
    noindex = do NOT include in search results (for private pages)
    nofollow = do NOT follow links (for user-generated content)
  -->

  <!-- 5. VIEWPORT — essential for mobile SEO -->
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- 6. CHARSET — tells browser how to read text characters -->
  <meta charset="UTF-8" />
</head>
```

---

### C. Open Graph (OG) Tags — Social Media Previews

When you share `https://pookiz.vercel.app` on WhatsApp, LinkedIn, or Twitter, they show a "card" with an image, title, and description. This is controlled by **Open Graph tags**:

```html
<head>
  <!-- Open Graph: Basic -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://pookiz.vercel.app/" />
  <meta property="og:title" content="Pookiz — Campus Social Network" />
  <meta property="og:description" content="Real-time messaging, groups, and anonymous posts for university students." />
  <meta property="og:image" content="https://pookiz.vercel.app/og-image.png" />
  <!-- og:image should be 1200x630px for best display -->

  <!-- Twitter Card (same idea, different format for Twitter/X) -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="Pookiz — Campus Social Network" />
  <meta name="twitter:description" content="Real-time campus social network." />
  <meta name="twitter:image" content="https://pookiz.vercel.app/og-image.png" />
</head>
```

---

### D. SEO in Next.js App Router — The `metadata` Object

Next.js App Router has a built-in, clean way to manage all these meta tags:

```typescript
// app/layout.tsx (applies to entire app)
import { Metadata } from "next";

export const metadata: Metadata = {
  title: {
    default: "Pookiz",
    // Dynamic pages use: title.template
    // "Chat | Pookiz", "Quiz | Pookiz"
    template: "%s | Pookiz",
  },
  description: "Campus social network for university students. Real-time messaging, groups, and anonymous posts.",
  keywords: ["campus", "social network", "university", "students", "messaging"],
  authors: [{ name: "Arpit Pandey" }],

  // Open Graph
  openGraph: {
    type: "website",
    url: "https://pookiz.vercel.app",
    title: "Pookiz — Campus Social Network",
    description: "Real-time campus social network for university students.",
    images: [
      {
        url: "https://pookiz.vercel.app/og-image.png",
        width: 1200,
        height: 630,
        alt: "Pookiz Campus Social Network",
      },
    ],
  },

  // Twitter/X
  twitter: {
    card: "summary_large_image",
    title: "Pookiz",
    description: "Campus social network for university students.",
    images: ["https://pookiz.vercel.app/og-image.png"],
  },

  // Robots
  robots: {
    index: true,
    follow: true,
  },

  // Canonical URL
  alternates: {
    canonical: "https://pookiz.vercel.app",
  },
};
```

**Dynamic metadata for specific pages:**

```typescript
// app/quiz/[id]/page.tsx
import { Metadata } from "next";

// This function runs on the server for every quiz page
export async function generateMetadata(
  { params }: { params: { id: string } }
): Promise<Metadata> {
  // Fetch quiz details from database
  const quiz = await getQuiz(params.id);

  return {
    title: quiz.title, // becomes "Data Structures Quiz | Pookiz"
    description: `Take the ${quiz.title} quiz. ${quiz.totalQuestions} questions. Created by ${quiz.creatorName}.`,
    openGraph: {
      title: quiz.title,
      description: `Quiz with ${quiz.totalQuestions} questions`,
    },
  };
}

export default function QuizPage({ params }: { params: { id: string } }) {
  return <div>...</div>;
}
```

---

### E. Sitemap — Telling Google About All Your Pages

A sitemap is an XML file that lists all pages on your website. You submit it to Google Search Console so Google knows every page without having to discover them by crawling links.

**In Next.js, create `app/sitemap.ts`:**

```typescript
// app/sitemap.ts
import { MetadataRoute } from "next";

// This file auto-generates /sitemap.xml
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  // Fetch dynamic pages from database
  const quizzes = await getAllPublicQuizzes();

  // Static pages
  const staticPages: MetadataRoute.Sitemap = [
    {
      url: "https://pookiz.vercel.app",
      lastModified: new Date(),
      changeFrequency: "daily",  // how often does this page change?
      priority: 1.0,             // importance: 0.0 to 1.0
    },
    {
      url: "https://pookiz.vercel.app/login",
      lastModified: new Date(),
      changeFrequency: "monthly",
      priority: 0.8,
    },
  ];

  // Dynamic pages from database
  const quizPages: MetadataRoute.Sitemap = quizzes.map((quiz) => ({
    url: `https://pookiz.vercel.app/quiz/${quiz.id}`,
    lastModified: new Date(quiz.updatedAt),
    changeFrequency: "weekly",
    priority: 0.6,
  }));

  return [...staticPages, ...quizPages];
}
```

This generates XML like:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://pookiz.vercel.app</loc>
    <lastmod>2026-07-29</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
  ...
</urlset>
```

---

### F. Robots.txt — What NOT to Index

A `robots.txt` file tells search bots which pages to skip:

```typescript
// app/robots.ts
import { MetadataRoute } from "next";

export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: "*",                          // applies to all bots
      allow: "/",                              // crawl everything
      disallow: [
        "/api/",                              // don't index API routes
        "/chat/",                             // private chat pages
        "/settings",                          // private settings page
        "/_next/",                            // Next.js internal files
      ],
    },
    sitemap: "https://pookiz.vercel.app/sitemap.xml",
  };
}
```

---

### G. Structured Data (JSON-LD) — Rich Snippets

Structured data tells Google exactly what your content is, enabling **rich results** in search:

```typescript
// components/QuizStructuredData.tsx
export function QuizStructuredData({ quiz }) {
  const structuredData = {
    "@context": "https://schema.org",
    "@type": "Quiz",
    "name": quiz.title,
    "description": quiz.description,
    "author": {
      "@type": "Person",
      "name": quiz.creatorName,
    },
    "dateCreated": quiz.createdAt,
    "educationalLevel": quiz.difficulty,
  };

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
    />
  );
}
```

---

## 4. SEO Checklist for Pookiz

| Item | Status | How to Check |
| :--- | :--- | :--- |
| Unique title per page | ✅ | View source of each page |
| Meta descriptions | ✅ | View source |
| Open Graph image | ✅ | Share URL on LinkedIn |
| Sitemap exists | ✅ | Visit `/sitemap.xml` |
| Robots.txt exists | ✅ | Visit `/robots.txt` |
| HTTPS (SSL) | ✅ | Vercel auto-provides |
| Mobile responsive | ✅ | Chrome DevTools → Mobile |
| Page speed > 80 | 🔄 | Google PageSpeed Insights |
| Alt text on images | 🔄 | Lighthouse audit |
| Canonical tags | ✅ | View source |

---

## 5. Staff Engineer Viva Board

### Q1: What is the difference between SSR, SSG, and CSR from an SEO perspective?
**Answer:**
*"This is critical for SEO:*

*- **CSR (Client-Side Rendering):** The server sends an empty HTML shell. JavaScript runs in the browser, fetches data, and renders the page. Search engine bots often don't execute JavaScript well — they see an empty page. **Terrible for SEO.***

*- **SSR (Server-Side Rendering):** The server renders the full HTML with data on every request and sends it. Bots see complete content immediately. **Excellent for SEO**, but slower (server does work on every request).*

*- **SSG (Static Site Generation):** HTML is pre-rendered at build time. Bots and users receive the same fast, complete HTML. **Best for SEO**, ideal for pages that don't change often (marketing pages, quiz landing pages).*

*In Pookiz, I use SSR for quiz pages (dynamic content) and SSG for the home/landing page (static content). Private pages like chat are CSR — SEO doesn't matter there since they're behind authentication."*

### Q2: What is a canonical URL and when would you need one?
**Answer:**
*"A canonical URL tells search engines which version of a page is the 'official' one when the same content appears on multiple URLs.*

*For example, Pookiz quiz `quiz-123` might be accessible at:*
*- `https://pookiz.vercel.app/quiz/quiz-123`*
*- `https://pookiz.vercel.app/quiz/quiz-123?ref=homepage`*
*- `https://pookiz.vercel.app/quiz/quiz-123?share=whatsapp`*

*Without canonicalization, Google treats these as 3 different pages with duplicate content and penalizes all of them. Adding `<link rel='canonical' href='https://pookiz.vercel.app/quiz/quiz-123' />` on all three versions tells Google they are the same page — consolidating all ranking signals to the canonical URL."*

### Q3: What is an Open Graph image and what are the size requirements?
**Answer:**
*"An Open Graph image is the thumbnail displayed when you share a URL on social platforms (LinkedIn, WhatsApp, Twitter, Facebook). It is specified by `<meta property='og:image' content='URL' />`.*

*Size requirements:*
*- **Recommended:** 1200×630 pixels, PNG or JPEG*
*- **Minimum:** 600×315 pixels*
*- **File size:** Under 8MB*

*In Pookiz, I generate OG images dynamically for quiz pages using Next.js ImageResponse (`app/quiz/[id]/opengraph-image.tsx`), which renders a React component to a PNG image on the server — showing the quiz title, difficulty, and question count in the preview card."*

### Q4: What is a sitemap and how do you decide which pages to include?
**Answer:**
*"A sitemap is an XML file listing all URLs on your website that you want search engines to index. You submit it to Google Search Console.*

*Which pages to include:*
*- ✅ Public content pages: home, quiz landing pages, profile pages*
*- ✅ Pages you want ranked in search results*
*- ❌ Private pages (behind login): chat, settings, dashboard*
*- ❌ API routes: `/api/...`*
*- ❌ Duplicate or paginated variants (use canonical instead)*

*In Next.js, I generate the sitemap dynamically using `app/sitemap.ts`, querying the database for all public quizzes and combining them with static pages."*
