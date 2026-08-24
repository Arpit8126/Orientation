# Backend Chapter 15: CI/CD — Automated Deployment with GitHub Actions & Vercel

This chapter explains CI/CD from scratch — what it is, why it matters, and exactly how Pookiz is deployed automatically every time you push code.

---

## 1. Objective & Placement Value
- **Why this is asked:** "How does your code go from your laptop to production?" is asked in senior-level interviews. Understanding CI/CD shows you think about the full engineering lifecycle, not just writing code.
- **Placement Value:** Demonstrates production mindset. Any company using cloud deployment (which is all of them) expects you to know this.

---

## 2. The Layman's Analogy

Think of publishing a book:

**Without CI/CD:** Every time you finish writing a chapter, you manually:
1. Print the whole book
2. Proofread it yourself
3. Fix mistakes you catch
4. Mail it to the bookstore
5. Hope you didn't miss anything

**With CI/CD:** You type a chapter, hit Save, and a robot:
1. Automatically proofreads the entire book (runs tests)
2. Checks formatting (linting)
3. If everything passes, prints and mails it to the bookstore (deploys to production)
4. If something fails, stops and emails you the error

CI/CD = **Continuous Integration + Continuous Deployment** = automated quality check → automated shipping.

---

## 3. The Technical Specification

### A. Key Terms

| Term | Plain English |
| :--- | :--- |
| **CI (Continuous Integration)** | Every code push automatically runs tests and checks |
| **CD (Continuous Deployment)** | After CI passes, automatically deploy to production |
| **Pipeline** | A series of automated steps that run in order |
| **GitHub Actions** | GitHub's built-in CI/CD tool — free for public repos |
| **Workflow** | A CI/CD configuration file (`.yml` format) |
| **Runner** | A temporary virtual machine that runs your pipeline steps |
| **Environment Variable** | A secret value (like API keys) stored securely, not in code |

---

### B. How Pookiz Deployment Works

```
You push code to GitHub
       ↓
GitHub Actions triggers automatically
       ↓
┌─────────────────────────────────┐
│  CI Pipeline runs:              │
│  1. Install dependencies        │
│  2. Run TypeScript type check   │
│  3. Run linting (ESLint)        │
│  4. Run unit tests (Jest)       │
│  5. Build the Next.js app       │
└─────────────────────────────────┘
       ↓ (if all pass)
Vercel automatically deploys the new build
       ↓
Your changes are LIVE at pookiz.vercel.app
```

---

### C. GitHub Actions Workflow File

GitHub Actions workflows are stored in `.github/workflows/` inside your repository. They are written in **YAML** format.

**What YAML looks like:**
```yaml
# Lines starting with # are comments
name: This is a key-value pair
value: This is the value

# A list uses dashes
steps:
  - first item
  - second item

# Nested objects use indentation
job:
  name: build
  runs-on: ubuntu-latest
```

**A complete CI workflow for Pookiz:**
```yaml
# .github/workflows/ci.yml

# Name of this workflow (shown in GitHub UI)
name: CI — Type Check, Lint & Test

# When should this run?
on:
  push:
    branches: [main, develop]   # runs when code is pushed to main or develop
  pull_request:
    branches: [main]            # runs when someone opens a PR targeting main

# Jobs are the actual work
jobs:
  build-and-test:               # job name (can be anything)
    runs-on: ubuntu-latest      # run on a Linux virtual machine

    steps:
      # Step 1: Download your code onto the VM
      - name: Checkout code
        uses: actions/checkout@v4

      # Step 2: Set up Node.js
      - name: Setup Node.js 20
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"          # cache node_modules for speed

      # Step 3: Install all dependencies from package.json
      - name: Install dependencies
        run: npm ci              # ci = clean install (faster and more strict than npm install)

      # Step 4: TypeScript type checking (finds type errors)
      - name: TypeScript check
        run: npx tsc --noEmit   # --noEmit = check types but don't output JS files

      # Step 5: ESLint (finds code style errors)
      - name: Lint
        run: npm run lint

      # Step 6: Run tests
      - name: Run tests
        run: npm test
        env:
          # Inject environment variables from GitHub Secrets
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}

      # Step 7: Build the Next.js app (verifies it compiles)
      - name: Build
        run: npm run build
```

---

### D. Environment Variables & GitHub Secrets

**The problem:** Your code needs API keys (Supabase URL, LiveKit key, etc.) but you NEVER put API keys in code or in GitHub.

**The solution:** GitHub Secrets — encrypted variables stored in GitHub that are injected into the pipeline at runtime.

**How to set up GitHub Secrets:**
1. Go to your GitHub repo → Settings → Secrets and Variables → Actions
2. Click "New repository secret"
3. Name: `NEXT_PUBLIC_SUPABASE_URL`, Value: `https://your-project.supabase.co`
4. Repeat for all your environment variables

**In your workflow file, reference them:**
```yaml
env:
  NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
```
The `${{ secrets.NAME }}` syntax tells GitHub Actions to pull the value from your secrets, not from code.

---

### E. How Vercel Handles Deployment

Vercel is connected to your GitHub repo. Here's what happens automatically:

```
Push to main branch
       ↓
Vercel detects the push
       ↓
Vercel runs: npm run build
       ↓
If build succeeds → deploys to production URL (pookiz.vercel.app)
If build fails → sends you an email with the error
       ↓
Push to any OTHER branch (e.g., feature/new-quiz)
       ↓
Vercel creates a PREVIEW URL (feature-new-quiz.vercel.app)
You can test the feature in isolation before merging to main
```

**Vercel environment variables:**
- Go to Vercel Dashboard → Project → Settings → Environment Variables
- Add `NEXT_PUBLIC_SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, etc.
- Vercel injects these during the build and at runtime

---

### F. Branch Strategy (How Teams Work)

```
main ──────────────────────────────────── (production — always stable)
  └── develop ───────────────────────── (staging — tested features)
        └── feature/quiz-timer ──────── (one developer's feature work)
        └── feature/new-profile-page ── (another developer's feature work)
        └── bugfix/message-scroll ───── (a bug fix)
```

**The workflow:**
1. You create a branch: `git checkout -b feature/quiz-timer`
2. You code your feature
3. You push and open a **Pull Request (PR)** to merge into `develop`
4. GitHub Actions runs CI on your PR
5. If CI passes and a teammate reviews, you merge
6. Once `develop` is stable, merge `develop` → `main` → auto-deploys to production

---

## 4. Line-by-Line Code Walkthrough — package.json Scripts

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "jest",
    "type-check": "tsc --noEmit"
  }
}
```

- `"dev": "next dev"` → Starts the development server on localhost:3000
- `"build": "next build"` → Compiles the app for production (this is what Vercel runs)
- `"start": "next start"` → Starts the compiled production app locally
- `"lint": "next lint"` → Runs ESLint to find code style issues
- `"test": "jest"` → Runs all test files
- `"type-check": "tsc --noEmit"` → Checks TypeScript types without outputting files

In GitHub Actions, you call these with `npm run build`, `npm run lint`, etc.

---

## 5. Edge Cases & Best Practices

- **Cache `node_modules`:** Use `cache: 'npm'` in your Node setup action. This avoids re-downloading all dependencies on every run, saving 1–2 minutes per build.

- **Fail fast:** Put the fastest checks first (linting takes 5 seconds) and slow checks last (build takes 2 minutes). If linting fails, stop immediately and don't waste time running tests.

- **Test environment variables:** If your tests need environment variables, add them to GitHub Secrets. Never hardcode API keys in workflow files.

- **Separate workflows for CI and CD:** Keep `ci.yml` (test on every push) separate from `deploy.yml` (deploy only on main branch push). This is cleaner and more maintainable.

- **Preview deployments:** Vercel's preview deployments are extremely useful — always share the preview URL with teammates for review before merging.

---

## 6. Staff Engineer Viva Board

### Q1: What is CI/CD and why does it matter?
**Answer:**
*"CI (Continuous Integration) is the practice of automatically running tests and quality checks every time code is pushed to a shared repository. CD (Continuous Deployment) extends this to automatically deploy code to production after CI passes.*

*It matters because: without CI/CD, integration bugs accumulate silently as multiple developers push code. With CI/CD, every change is validated immediately, and broken builds are caught before reaching users. It also removes the error-prone manual deployment process — 'works on my machine' failures disappear because deployment happens in a standardized environment."*

### Q2: What are GitHub Secrets and why are they used?
**Answer:**
*"GitHub Secrets are encrypted key-value pairs stored in GitHub at the repository or organization level. They are never visible after creation — not even to repository owners.*

*They are used to provide sensitive values (API keys, database passwords, JWT secrets) to GitHub Actions pipelines without hardcoding them in workflow files or source code. In the workflow file, secrets are referenced using `${{ secrets.SECRET_NAME }}` syntax, which GitHub resolves to the actual value at runtime.*

*In Pookiz, I store `NEXT_PUBLIC_SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, and `LIVEKIT_API_SECRET` as GitHub Secrets."*

### Q3: What is the difference between `npm install` and `npm ci`?
**Answer:**
*"`npm install` reads `package.json` and installs packages, potentially updating `package-lock.json` if versions change. It is used for development.*

*`npm ci` (Clean Install) reads `package-lock.json` exactly, installs exactly those versions, never modifies the lock file, and deletes `node_modules` before installing. It is faster and deterministic — guaranteed to install the same versions every time.*

*In CI pipelines, always use `npm ci` to ensure reproducible builds across all environments."*

### Q4: What is a deployment pipeline and how do you design one?
**Answer:**
*"A deployment pipeline is a series of automated steps that transform source code into a running production application. I design it following the 'fail fast' principle:*

*1. Fastest checks first: linting (5s) → type checking (10s) → unit tests (30s)*
*2. Integration tests (1-2 min)*
*3. Build (2-3 min) — verifies the app compiles correctly*
*4. Deploy to staging/preview*
*5. Smoke tests against the deployed preview*
*6. Deploy to production only if all steps pass*

*This means the cheapest failures are caught first, saving compute time and developer attention."*

### Q5: What is the difference between Continuous Deployment and Continuous Delivery?
**Answer:**
*"These are often confused:*

*- **Continuous Delivery:** After CI passes, the code is READY to deploy, but a human must press a button to approve the production deployment. The release is automated but gated.*

*- **Continuous Deployment:** After CI passes, the code AUTOMATICALLY deploys to production without human approval. Every passing commit goes to production.*

*For Pookiz, I use Continuous Deployment via Vercel — every merge to main automatically deploys. For enterprise fintech or healthcare systems, teams use Continuous Delivery because a human must approve production releases due to compliance requirements."*
