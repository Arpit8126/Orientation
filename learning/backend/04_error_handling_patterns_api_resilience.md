# Backend Chapter 04: Error Handling — API Resilience & Graceful Failures

This chapter explains how to handle errors properly in Next.js APIs, how to show meaningful messages to users, and how to prevent your app from crashing when things go wrong.

---

## 1. Objective & Placement Value
- **Why this is asked:** "How does your app handle failures?" — Every interviewer asks this. A senior developer thinks about failure paths; a junior only thinks about the happy path.
- **Placement Value:** Error handling shows production maturity. Apps that crash on network errors or show raw database errors to users are amateur-level. Apps that recover gracefully are production-grade.

---

## 2. The Layman's Analogy

Imagine a **receptionist at a hospital**:

**Bad error handling (no receptionist):** A patient asks for a doctor who is not available. The entire hospital intercom crashes, the lights go out, and nobody knows what happened.

**Good error handling (good receptionist):** A patient asks for a doctor who is not available. The receptionist says: *"Dr. Sharma is not available right now. I can schedule you for tomorrow, or Dr. Gupta is available in 20 minutes."* The hospital keeps running.

Error handling = **when something goes wrong, respond intelligently instead of crashing**.

---

## 3. The Technical Specification

### A. Types of Errors You Will Encounter

| Error Type | Example | How to Handle |
| :--- | :--- | :--- |
| **Validation Error** | User sends empty username | Return 400 with clear message |
| **Authentication Error** | User is not logged in | Return 401, redirect to login |
| **Authorization Error** | User tries to edit someone else's profile | Return 403 Forbidden |
| **Not Found Error** | Quiz ID doesn't exist in database | Return 404 with message |
| **Database Error** | Supabase query fails | Return 500, log the error |
| **Network Error** | External API (LiveKit) is down | Retry with backoff, show degraded state |
| **Rate Limit Error** | User sends too many requests | Return 429 Too Many Requests |

---

### B. HTTP Status Codes (Must Know)

```
2xx — Success
  200 OK                    → Request succeeded, data returned
  201 Created               → Resource was created (POST that creates something)
  204 No Content            → Success but no data to return (DELETE)

4xx — Client Errors (user/request is wrong)
  400 Bad Request           → Missing or invalid parameters
  401 Unauthorized          → Not logged in
  403 Forbidden             → Logged in but not allowed
  404 Not Found             → Resource doesn't exist
  409 Conflict              → Duplicate (e.g., already friends)
  422 Unprocessable Entity  → Data is valid format but fails business logic
  429 Too Many Requests     → Rate limited

5xx — Server Errors (YOUR code is wrong)
  500 Internal Server Error → Something crashed on the server
  502 Bad Gateway           → Upstream service (Supabase, LiveKit) is down
  503 Service Unavailable   → Server is overloaded or in maintenance
```

---

### C. Basic Try-Catch in TypeScript

The most fundamental error handling pattern:

```typescript
// The TRY block: code that might fail
try {
  const result = await supabase.from("profiles").select("*").single();
  // if this fails, execution jumps to the catch block
  return result.data;
} catch (error) {
  // The CATCH block: handle the error
  console.error("Database query failed:", error);
  return null;
}
```

**With finally:**
```typescript
async function fetchUserProfile(id: string) {
  let connection;
  try {
    connection = await openConnection();
    const data = await connection.query(`SELECT * FROM profiles WHERE id = '${id}'`);
    return data;
  } catch (error) {
    console.error("Query failed:", error);
    throw error; // re-throw so the caller knows it failed
  } finally {
    // FINALLY always runs, whether it succeeded or failed
    // Use for cleanup: closing connections, logging end time, etc.
    await connection?.close();
  }
}
```

---

### D. A Well-Structured API Route with Error Handling

```typescript
// app/api/friends/request/route.ts
import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { z } from "zod"; // zod = validation library

// Step 1: Define expected request shape using Zod
const RequestBodySchema = z.object({
  recipientId: z.string().uuid("recipientId must be a valid UUID"),
});

export async function POST(request: NextRequest) {
  try {
    // Step 2: Parse and validate the request body
    let body;
    try {
      body = await request.json();
    } catch {
      return NextResponse.json(
        { error: "Invalid JSON in request body" },
        { status: 400 }
      );
    }

    // Step 3: Validate input schema
    const validation = RequestBodySchema.safeParse(body);
    if (!validation.success) {
      return NextResponse.json(
        { error: "Validation failed", details: validation.error.flatten() },
        { status: 400 }
      );
    }
    const { recipientId } = validation.data;

    // Step 4: Authenticate user
    const supabase = await createClient();
    const { data: { user }, error: authError } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        { error: "You must be logged in to send friend requests" },
        { status: 401 }
      );
    }

    // Step 5: Business logic validation
    if (user.id === recipientId) {
      return NextResponse.json(
        { error: "You cannot send a friend request to yourself" },
        { status: 400 }
      );
    }

    // Step 6: Check if already friends
    const { data: existingFriend } = await supabase
      .from("friends")
      .select("id, status")
      .or(`and(user_id_1.eq.${user.id},user_id_2.eq.${recipientId}),and(user_id_1.eq.${recipientId},user_id_2.eq.${user.id})`)
      .single();

    if (existingFriend) {
      const message = existingFriend.status === "accepted"
        ? "You are already friends"
        : "A friend request is already pending";
      return NextResponse.json({ error: message }, { status: 409 });
    }

    // Step 7: Perform the actual operation
    const { error: insertError } = await supabase
      .from("friends")
      .insert({ user_id_1: user.id, user_id_2: recipientId, status: "pending" });

    if (insertError) {
      // Log full error on server (don't expose internals to client)
      console.error("[API] Friend request insert failed:", insertError);
      return NextResponse.json(
        { error: "Failed to send friend request. Please try again." },
        { status: 500 }
      );
    }

    // Step 8: Return success
    return NextResponse.json(
      { message: "Friend request sent successfully" },
      { status: 201 }
    );

  } catch (unexpectedError) {
    // Step 9: Catch anything that wasn't handled above
    console.error("[API] Unexpected error in /api/friends/request:", unexpectedError);
    return NextResponse.json(
      { error: "An unexpected error occurred. Please try again." },
      { status: 500 }
    );
  }
}
```

---

### E. Input Validation with Zod

Zod is a library that validates data shapes at runtime:

```typescript
import { z } from "zod";

// Define what valid input looks like
const CreateQuizSchema = z.object({
  title: z.string()
    .min(3, "Title must be at least 3 characters")
    .max(100, "Title cannot exceed 100 characters"),

  questions: z.array(
    z.object({
      question: z.string().min(5, "Question is too short"),
      options: z.array(z.string()).length(4, "Must have exactly 4 options"),
      correct: z.number().int().min(0).max(3),
    })
  ).min(1, "At least one question required"),

  startTime: z.string().datetime("Must be a valid datetime"),
  endTime: z.string().datetime(),
});

// .safeParse returns { success: true, data: ... } or { success: false, error: ... }
// It does NOT throw an error — it returns the result
const result = CreateQuizSchema.safeParse(requestBody);

if (!result.success) {
  console.log(result.error.flatten());
  // Outputs structured errors:
  // {
  //   fieldErrors: {
  //     title: ["Title must be at least 3 characters"],
  //     questions: ["At least one question required"]
  //   }
  // }
}
```

---

### F. Error Handling on the Frontend

```typescript
// hooks/useFriendRequest.ts
import { useState } from "react";

export function useFriendRequest() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function sendRequest(recipientId: string) {
    setLoading(true);
    setError(null); // clear previous errors

    try {
      const response = await fetch("/api/friends/request", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ recipientId }),
      });

      const data = await response.json();

      if (!response.ok) {
        // The server returned a 4xx or 5xx status
        setError(data.error || "Something went wrong");
        return false;
      }

      return true; // success
    } catch (networkError) {
      // Network is completely down (no internet, DNS failure, etc.)
      setError("Cannot connect to server. Check your internet connection.");
      return false;
    } finally {
      setLoading(false);
    }
  }

  return { sendRequest, loading, error };
}
```

---

### G. Retry Logic with Exponential Backoff

When an external service fails temporarily, retry with increasing delays:

```typescript
async function fetchWithRetry(
  url: string,
  maxRetries: number = 3
): Promise<Response> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(url);
      if (response.ok) return response;

      // Don't retry client errors (4xx) — the request itself is wrong
      if (response.status >= 400 && response.status < 500) {
        throw new Error(`Client error: ${response.status}`);
      }

      // Retry server errors (5xx) with exponential backoff
      if (attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000; // 2s, 4s, 8s
        console.log(`Attempt ${attempt} failed. Retrying in ${delay}ms...`);
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    } catch (error) {
      if (attempt === maxRetries) throw error;
    }
  }
  throw new Error("Max retries exceeded");
}
```

---

## 4. Edge Cases & Best Practices

- **Never expose raw database errors to the client.** Log `insertError` to your server logs, but return a generic "Please try again" message to the user. Raw errors like `duplicate key value violates unique constraint "friends_user_id_1_user_id_2_key"` confuse users and expose schema information.

- **Always validate input before touching the database.** Never trust user-provided data. Validate type, length, format, and business rules before any database operation.

- **Use structured error responses.** Always return JSON with a consistent format:
  ```json
  { "error": "Human readable message", "code": "FRIEND_ALREADY_EXISTS" }
  ```
  This lets the frontend show different UI states for different error codes.

- **Log errors with context.** Don't just `console.log(error)`. Log the route, user ID, and request data to make debugging faster.

---

## 5. Staff Engineer Viva Board

### Q1: What is the difference between a 401 and a 403 error?
**Answer:**
*"**401 Unauthorized** means the user is not authenticated — we don't know who they are. The correct action is to show a login screen. The name is misleading; it really means 'unauthenticated'.*

***403 Forbidden** means the user IS authenticated — we know who they are — but they are not allowed to perform this action. For example, a logged-in user trying to edit another user's profile. The correct action is to show an 'Access Denied' message, not a login screen.*

*In Pookiz: when no auth cookie is present → 401. When a user tries to access a group they were banned from → 403."*

### Q2: How do you prevent exposing sensitive database errors to end users?
**Answer:**
*"I use a two-layer error handling strategy:*

*1. **Server layer:** Catch all database errors in a try-catch block. Log the full error details (including the database error message and stack trace) to server-side monitoring (like Sentry or console logs visible only to the development team).*

*2. **Client layer:** Return a sanitized generic error message: `'Failed to process request. Please try again.'`. This message gives users actionable guidance without leaking schema names, query structures, or internal states.*

*The key principle: log everything, expose nothing."*

### Q3: What is input validation and why should it be done on the server, not just the client?
**Answer:**
*"Input validation verifies that user-provided data meets requirements before processing it.*

*Client-side validation (e.g., checking that a form field is not empty in React) is purely a UX improvement — it gives users instant feedback. But it cannot be trusted for security because users can bypass it by:*
*1. Disabling JavaScript in the browser*
*2. Sending raw HTTP requests with curl or Postman*
*3. Using browser DevTools to modify form data*

*Server-side validation is the security boundary. In Pookiz, I use Zod to validate all API request bodies on the server before any database operation — checking types, lengths, formats, and business rules. Client-side validation is then added on top purely for user experience."*

### Q4: What is exponential backoff and when would you use it?
**Answer:**
*"Exponential backoff is a retry strategy where each retry waits twice as long as the previous one: 1s, 2s, 4s, 8s, 16s.*

*It is used when calling external services that might temporarily fail — like Groq AI API for quiz generation or LiveKit token generation. If the service is overloaded, hammering it with immediate retries makes the overload worse. Exponential backoff gives the service time to recover while still retrying automatically.*

*In Pookiz, I apply this to the PDF-to-quiz AI pipeline: if Groq returns a 429 (rate limit), we wait and retry with backoff instead of failing immediately."*

### Q5: How do you handle errors differently in development vs production?
**Answer:**
*"In development (`NODE_ENV === 'development'`):*
*- Show detailed error stack traces in the response*
*- Log verbosely to the console*
*- Show error details in the UI for debugging*

*In production (`NODE_ENV === 'production'`):*
*- Log detailed errors to a monitoring service (Sentry, Datadog) but never in the response*
*- Return generic user-facing messages*
*- Alert the team on critical errors (5xx) via Slack notifications*

*In Next.js, I conditionally include error details:*
```typescript
const errorDetail = process.env.NODE_ENV === 'development'
  ? { detail: error.message }
  : {};

return NextResponse.json({ error: 'Server error', ...errorDetail }, { status: 500 });
```*"
