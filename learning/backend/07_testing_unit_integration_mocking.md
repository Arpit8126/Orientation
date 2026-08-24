# Backend Chapter 07: Testing — Unit Tests, Integration Tests & Mocking

This chapter teaches testing from absolute scratch. You will understand what tests are, why they exist, how to write them, and how Pookiz would be tested.

---

## 1. Objective & Placement Value
- **Why this is asked:** "How do you make sure your code works?" is asked in every interview. Companies need developers who write reliable code that doesn't break other features. Testing knowledge separates junior from senior engineers.
- **Placement Value:** Knowing Jest, mocking, and integration testing signals you build production-ready code, not just working prototypes.

---

## 2. The Layman's Analogy

Imagine you build a **vending machine**. Before shipping it to customers, you test it:

- **Unit Test (Test one small part):** Insert a coin. Does the coin counter increase by 1? Test just the counter logic. Don't worry about whether the drink actually dispenses.

- **Integration Test (Test parts working together):** Insert a coin AND press a drink button. Does the drink come out AND the coin counter decrease AND the display update? Test the full flow.

- **End-to-End Test (Test as a real user):** Walk up to the machine like a customer, insert coins, press a button, catch the drink. Did everything work?

Tests are automated scripts that run these checks instantly every time you change code — catching breaks before users do.

---

## 3. The Technical Specification

### A. Why Write Tests?

**Without tests:**
- You change the login function → it accidentally breaks the friend request system → you don't know until a user reports it.

**With tests:**
- You change the login function → 47 tests run automatically → 3 tests fail → you fix the bug before it reaches production.

### B. Types of Tests

```
Unit Tests       → Test one function in isolation
Integration Tests → Test multiple parts together
End-to-End (E2E) → Test the full app like a real user (Playwright, Cypress)
```

In a Next.js + Supabase project, the most important are **unit** and **integration** tests.

### C. Testing Tools

| Tool | Purpose |
| :--- | :--- |
| **Jest** | The test runner — runs your test files |
| **@testing-library/react** | Tests React components |
| **Vitest** | Faster alternative to Jest (used in Vite projects) |
| **Playwright / Cypress** | E2E tests — controls a real browser |
| **MSW (Mock Service Worker)** | Intercepts API calls and returns fake data |

---

### D. Writing Your First Unit Test

A test file always ends in `.test.ts` or `.spec.ts`.

**The function we want to test:**
```typescript
// utils/score.ts
export function calculateScore(correct: number, total: number): number {
  if (total === 0) return 0;
  return Math.round((correct / total) * 100);
}
```

**The test file:**
```typescript
// utils/score.test.ts
import { calculateScore } from "./score";

// "describe" groups related tests together
describe("calculateScore", () => {

  // "it" or "test" defines one individual test
  it("returns the correct percentage", () => {
    // "expect(X).toBe(Y)" — the core assertion
    // "X is what you got, Y is what you expected"
    expect(calculateScore(8, 10)).toBe(80);
  });

  it("returns 0 when total is 0 (avoids divide-by-zero)", () => {
    expect(calculateScore(0, 0)).toBe(0);
  });

  it("returns 100 when all answers are correct", () => {
    expect(calculateScore(10, 10)).toBe(100);
  });

  it("rounds decimals correctly", () => {
    expect(calculateScore(1, 3)).toBe(33); // 33.33... rounded to 33
  });
});
```

**What each keyword means:**
- `describe("name", () => {...})` = a group/category of related tests
- `it("name", () => {...})` = one single test case
- `expect(value)` = "I expect this value to..."
- `.toBe(expected)` = "...to equal exactly this"

---

### E. Common Assertions (expect matchers)

```typescript
// Equality
expect(2 + 2).toBe(4);                    // exact equality
expect({ a: 1 }).toEqual({ a: 1 });       // deep equality (for objects)

// Truthiness
expect(user).toBeTruthy();                // not null, not undefined, not 0
expect(error).toBeFalsy();               // null, undefined, 0, ""
expect(user).toBeNull();                 // exactly null
expect(token).toBeDefined();            // not undefined

// Strings
expect(message).toContain("Hello");     // string contains this substring
expect(username).toMatch(/^[a-z]+$/);  // matches a regex pattern

// Numbers
expect(score).toBeGreaterThan(50);
expect(latency).toBeLessThanOrEqual(200);

// Arrays
expect(["a", "b", "c"]).toHaveLength(3);
expect(["a", "b", "c"]).toContain("b");

// Errors — test that a function THROWS an error
expect(() => divideByZero()).toThrow();
expect(() => divideByZero()).toThrow("Cannot divide by zero");
```

---

### F. Mocking — Faking Dependencies

The hardest concept in testing: **mocking**.

**The problem:** Your function calls the database. You don't want real database calls in tests (slow, unreliable, modifies real data).

**The solution:** Replace the real database call with a **fake (mock)** that returns controlled data.

```typescript
// The function we want to test:
// api/friends/send-request.ts
import { supabase } from "@/lib/supabase/client";

export async function sendFriendRequest(
  senderId: string,
  recipientId: string
): Promise<{ success: boolean; error?: string }> {
  const { error } = await supabase.from("friends").insert({
    user_id_1: senderId,
    user_id_2: recipientId,
    status: "pending",
  });

  if (error) return { success: false, error: error.message };
  return { success: true };
}
```

**The test with mocking:**
```typescript
// api/friends/send-request.test.ts

// Step 1: Tell Jest to replace the supabase module with a fake
jest.mock("@/lib/supabase/client");

import { supabase } from "@/lib/supabase/client";
import { sendFriendRequest } from "./send-request";

// Step 2: Create a mock supabase that we control
const mockInsert = jest.fn();
const mockFrom = jest.fn(() => ({ insert: mockInsert }));
(supabase.from as jest.Mock) = mockFrom;

describe("sendFriendRequest", () => {
  beforeEach(() => {
    // Reset mock before each test so tests don't affect each other
    jest.clearAllMocks();
  });

  it("returns success when insert works", async () => {
    // Make the mock return a successful result (no error)
    mockInsert.mockResolvedValue({ error: null });

    const result = await sendFriendRequest("user-1", "user-2");

    expect(result.success).toBe(true);
    expect(result.error).toBeUndefined();
  });

  it("returns error when database fails", async () => {
    // Make the mock return a failure
    mockInsert.mockResolvedValue({
      error: { message: "duplicate key violation" },
    });

    const result = await sendFriendRequest("user-1", "user-2");

    expect(result.success).toBe(false);
    expect(result.error).toBe("duplicate key violation");
  });
});
```

**What the mock does:**
- `jest.mock(...)` = "replace the real module with a fake"
- `jest.fn()` = create a fake function that does nothing by default
- `.mockResolvedValue(...)` = "when this fake function is called, return this value"
- `beforeEach(() => {...})` = run this before EVERY test in this file

---

### G. Testing React Components

```typescript
// components/UserBadge.tsx
export function UserBadge({ username, isVerified }: { username: string; isVerified: boolean }) {
  return (
    <div>
      <span>{username}</span>
      {isVerified && <span data-testid="verified-badge">✓ Verified</span>}
    </div>
  );
}
```

```typescript
// components/UserBadge.test.tsx
import { render, screen } from "@testing-library/react";
import { UserBadge } from "./UserBadge";

describe("UserBadge", () => {
  it("renders the username", () => {
    render(<UserBadge username="arpit" isVerified={false} />);

    // screen.getByText: find an element by its text content
    expect(screen.getByText("arpit")).toBeInTheDocument();
  });

  it("shows verified badge when isVerified is true", () => {
    render(<UserBadge username="arpit" isVerified={true} />);

    // getByTestId: find by data-testid attribute
    expect(screen.getByTestId("verified-badge")).toBeInTheDocument();
  });

  it("hides verified badge when isVerified is false", () => {
    render(<UserBadge username="arpit" isVerified={false} />);

    // queryByTestId returns null if not found (getByTestId would throw)
    expect(screen.queryByTestId("verified-badge")).not.toBeInTheDocument();
  });
});
```

---

### H. Setup: How to Run Tests

```bash
# Install Jest and testing library
npm install --save-dev jest @testing-library/react @testing-library/jest-dom

# Run all tests once
npx jest

# Run tests in watch mode (re-runs when you save a file)
npx jest --watch

# Run only tests matching a file name pattern
npx jest score.test

# See which lines of code are covered by tests
npx jest --coverage
```

**In `package.json` — add to `scripts`:**
```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

---

## 4. Line-by-Line Code Walkthrough — Integration Test for a Quiz API

```typescript
// app/api/quiz/submit/route.test.ts
import { POST } from "./route"; // the actual API route handler
import { NextRequest } from "next/server";

// Mock Supabase to avoid real database calls
jest.mock("@/lib/supabase/server");

describe("POST /api/quiz/submit", () => {
  it("calculates score correctly and saves to database", async () => {
    // Step 1: Create a fake HTTP request
    const requestBody = {
      quizId: "quiz-123",
      answers: { "q0": 0, "q1": 2, "q2": 1 },
    };

    const request = new NextRequest("http://localhost/api/quiz/submit", {
      method: "POST",
      body: JSON.stringify(requestBody),
      headers: { "Content-Type": "application/json" },
    });

    // Step 2: Call the handler directly
    const response = await POST(request);
    const data = await response.json();

    // Step 3: Assert the response
    expect(response.status).toBe(200);
    expect(data.score).toBeGreaterThanOrEqual(0);
    expect(data.score).toBeLessThanOrEqual(100);
  });
});
```

---

## 5. Edge Cases & Best Practices

- **Test behaviour, not implementation:** Test what a function does (output), not how it does it (internal steps). If you change the implementation but the output stays the same, tests should still pass.

- **One assertion per test (ideally):** Each `it()` block should test one specific thing. This makes failing tests more informative.

- **Use `beforeEach` to reset state:** Always clean up mocks between tests to prevent test pollution.

- **Don't test third-party libraries:** Don't test that Supabase works — trust that Supabase is tested by Supabase. Only test YOUR logic.

- **Aim for 70%+ code coverage:** Not 100% — that wastes time. Focus on critical paths: authentication, score calculation, permission checks.

---

## 6. Staff Engineer Viva Board

### Q1: What is the difference between unit tests and integration tests?
**Answer:**
*"A **unit test** isolates a single function or module and tests it alone — all dependencies are mocked. It is fast (milliseconds) and tests edge cases precisely.*

*An **integration test** tests multiple units working together with real dependencies (or semi-real mocked versions). For example, testing that an API route reads the request body correctly, calls the database, and returns the right HTTP response.*

*In Pookiz, I use unit tests for pure utility functions like score calculation and input validation, and integration tests for API routes to test the request→database→response pipeline."*

### Q2: What is mocking and why is it necessary?
**Answer:**
*"Mocking means replacing a real dependency (like a database connection or an external API) with a controlled fake during tests. It is necessary because:*
*1. Real dependencies are slow (a database query takes milliseconds; a test suite with 200 tests can't afford real DB calls).*
*2. Real dependencies can fail (network down, database unreachable) — tests must be deterministic.*
*3. Real dependencies modify real data — test inserts should not pollute production tables.*

*With mocks, I control exactly what the dependency returns — success, failure, empty results — and test how my code handles each case."*

### Q3: What is `jest.fn()` and what can you do with it?
**Answer:**
*"`jest.fn()` creates a mock function — a fake function that does nothing but records when it was called, what arguments it received, and what it returned.*

*You can configure it:*
*- `.mockReturnValue(x)` — always returns x synchronously*
*- `.mockResolvedValue(x)` — returns a Promise that resolves to x (for async functions)*
*- `.mockRejectedValue(err)` — returns a Promise that rejects (simulates a failure)*

*You can inspect it:*
*- `expect(mockFn).toHaveBeenCalled()` — was it called at all?*
*- `expect(mockFn).toHaveBeenCalledWith(arg1, arg2)` — was it called with the right arguments?*
*- `expect(mockFn).toHaveBeenCalledTimes(3)` — was it called exactly 3 times?"*

### Q4: What is code coverage and what percentage should you aim for?
**Answer:**
*"Code coverage measures what percentage of your source code lines are executed by your test suite. It is reported in four dimensions:*
*- **Statement coverage:** Are all code statements executed?*
*- **Branch coverage:** Are all if/else branches covered?*
*- **Function coverage:** Are all functions called?*
*- **Line coverage:** Are all lines executed?*

*I aim for 70–80% in business-critical code (auth, payment, quiz grading) and don't obsess over 100%. Testing trivial getters and setters wastes time. The most valuable coverage is in edge cases: null checks, error paths, boundary conditions."*

### Q5: What is the testing pyramid?
**Answer:**
*"The testing pyramid is a strategy for how many of each test type to write:*

```
         /\
        /E2E\         ← Fewest (slow, expensive, brittle)
       /------\
      /  Integr. \    ← Medium number
     /------------\
    /  Unit Tests  \  ← Most (fast, isolated, reliable)
   /______________\
```

*Write many fast unit tests, fewer integration tests, and very few E2E tests. This gives maximum confidence with minimum test execution time.*

*In Pookiz, I have: 40+ unit tests for utility functions, 15 integration tests for critical API routes, and 3–4 E2E tests for the most important user flows (login, send message, submit quiz)."*
