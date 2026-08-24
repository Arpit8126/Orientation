# Database Chapter 07: Quiz Management — Attempts & Anti-Cheat Ledger

This module covers the database architecture of the Quiz Management platform in Pookiz, detailing the schemas for quizzes, attempts, JSONB options, and the anti-cheat verification system.

---

## 1. Objective & Placement Value
- **Why this is asked:** Interactive quiz systems and online examination environments require dynamic document layouts (to support varying question types) and strict security constraints. Interviewers evaluate how you design database tables with JSONB components, enforce single-attempt validation, and implement audit logs for anti-cheat tracking.
- **Placement Value:** Demonstrates your expertise in document-relational hybrid schemas, data validation, and building secure tracking solutions.

---

## 2. The Layman's Analogy
Imagine the Quiz system as a **secure campus examination hall**:
- **The Quiz Booklet (quizzes table):** A master booklet containing questions. Since different quizzes have different formats (Multiple Choice, Fill-in-the-blanks), the booklet is a binders box (**JSONB**) where we can slide in any type of question sheet.
- **The Answer Sheet (quiz_attempts table):** When a student starts a quiz, they get a single, personalized answer sheet. The desk clerk registers their name on the sheet. To prevent cheating, the sheet is stamped so the student can submit it only once (**unique constraint**).
- **The Integrity Proctor (anti-cheat warnings):** A proctor stands behind the student. If the student looks away from their desk (switches browser tabs), the proctor stamps the sheet with a warning counter. If they exceed the warning limit, the sheet is marked as "disqualified".

---

## 3. The Technical Specification

### A. Quiz and Attempt Relational Schemas
The system is built on two primary relational tables:
1. **`quizzes`:** Represents the master quiz definition:
   - `questions` (JSONB): A flexible JSON array representing the questions list, options, and explanations.
   - `scope` (TEXT): Restricts accessibility to `all`, `university`, or `private` scopes.
   - `password_hash` (TEXT): Encrypted password for password-protected exams.
2. **`quiz_attempts`:** Tracks examinee submissions:
   - `answers` (JSONB): A JSON array of the student's selected options.
   - `score` (INTEGER): Calculated total points.
   - `warnings_count` (INTEGER): Anti-cheat warning violations.
   - `is_disqualified` (BOOLEAN): Hard gate flag representing test invalidation.

```
┌─────────────────────────────────┐
│            quizzes              │
│  - id (UUID, PK)                │
│  - questions (JSONB)            │
│  - scope (TEXT)                 │
└────────────────┬────────────────┘
                 │
                 │ references / cascade delete
                 ▼
┌─────────────────────────────────┐
│          quiz_attempts          │
│  - id (UUID, PK)                │
│  - quiz_id (UUID, FK)           │
│  - user_id (UUID, FK)           │
│  - answers (JSONB)              │
│  - warnings_count (INTEGER)     │
└─────────────────────────────────┘
```

### B. Anti-Cheat Integrity Counters
Online exams require mechanisms to discourage cheating. Pookiz implements client-side visibility monitoring integrated with database counters:
1. **Client Event Detection:** If the client page is hidden (user exits full-screen or switches tabs), a Next.js client-side hook fires an API request.
2. **Database Increment:** The API server increments the `warnings_count` column inside `quiz_attempts`.
3. **Disqualification Flag:** If the warnings exceed the allowed threshold, `is_disqualified` is set to `true`, instantly invalidating the attempt.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the schemas and constraints inside [`d:\Pookiz\supabase\quiz_system_migration.sql`](file:///d:/Pookiz/supabase/quiz_system_migration.sql):

```sql
CREATE TABLE IF NOT EXISTS public.quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  creator_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  is_teacher_quiz BOOLEAN DEFAULT false,
  scope TEXT NOT NULL DEFAULT 'all' CHECK (scope IN ('all', 'university', 'private')),
  university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
  difficulty TEXT DEFAULT 'easy' CHECK (difficulty IN ('easy', 'moderate', 'hard')),
  required_inputs JSONB DEFAULT '[]'::jsonb,
  password_hash TEXT,
  questions JSONB NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```
- **Line 25-40:** Creates the master quizzes table.
  - `title TEXT NOT NULL UNIQUE` prevents duplicate quiz names.
  - `scope TEXT ... CHECK (scope IN ('all', 'university', 'private'))` constrains the quiz scope.
  - `questions JSONB NOT NULL` holds the flexible array of quiz questions.

```sql
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  answers JSONB NOT NULL,
  student_details JSONB DEFAULT '{}'::jsonb,
  score INTEGER NOT NULL,
  warnings_count INTEGER DEFAULT 0,
  is_disqualified BOOLEAN DEFAULT false,
  started_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(quiz_id, user_id)
);
```
- **Line 45-56:** Creates the quiz attempts table.
  - `quiz_id` and `user_id` map the attempt to the quiz and student.
  - `warnings_count` tracks tab-switching violations.
  - `is_disqualified` is a boolean flag to invalidate attempts.
  - `UNIQUE(quiz_id, user_id)` forces a composite unique constraint, ensuring that each student can submit exactly one attempt per quiz.

---

## 5. Edge Cases & Optimizations
- **JSONB Payload Overhead:** The `questions` column contains all quiz options, text, and explanations. When querying a list of quizzes for general listing feeds, loading this massive JSONB payload for every row is a waste of egress bandwidth.
  - *Fix:* In select queries, fetch only summary columns, and omit the `questions` column until the user begins the attempt.
- **Race Condition on Attempt Check:** If a student opens the quiz page in two browser tabs, they could double-submit their answers.
  - *Fix:* The `UNIQUE(quiz_id, user_id)` constraint protects the database, ensuring the second write transaction is immediately rejected.

---

## 6. Staff Engineer Viva Board

### Q1: Why did you use `JSONB` for storing questions inside the `quizzes` table instead of using separate child tables like `questions` and `options`?
**Answer:**
*"We chose `JSONB` for the `questions` column to prioritize **schema flexibility and query efficiency**:
- *Flexibility:* Pookiz supports multiple quiz formats (e.g., MCQs, Fill-in-the-blanks, Cloze test formats). A traditional relational schema would require multiple tables with complex joins (`quiz_questions`, `quiz_question_options`, etc.), leading to join overhead.
- *Query Performance:* Using `JSONB` allows us to load the entire quiz layout in a single database lookup without performing recursive joins. This reduces database CPU load and memory joins."*

### Q2: What is the purpose of the `UNIQUE(quiz_id, user_id)` constraint inside `quiz_attempts`? How does this protect database integrity?
**Answer:**
*"The constraint `UNIQUE(quiz_id, user_id)` creates a composite unique index on the database level. 

If a student attempts to submit their answers twice (either through a race condition in the UI, double-clicking the submit button, or a malicious API attack), the database checks this unique index. Since a row matching that `(quiz_id, user_id)` already exists, the second transaction is immediately rejected with a unique constraint violation, preserving database integrity."*

### Q3: How did you implement the database checks to prevent students from reading the correct answers before completing the quiz?
**Answer:**
*"If the `questions` column (which contains the correct answer index keys) was directly queryable, a student could inspect the network response payload in the browser console and read the answers. 

To prevent this:
1. We restrict the `SELECT` policy on `quizzes` using RLS to only allow creators to see the full rows.
2. For students, we route the request through a secure Next.js API endpoint. The server client loads the quiz, strips out the correct answer keys and explanations from the `questions` JSONB payload, and returns the sanitized questions array to the client."*

### Q4: Explain the difference between `started_at` and `completed_at` timestamps in `quiz_attempts`. How can we use these columns to enforce test durations?
**Answer:**
*"`started_at` represents when the student began the attempt, and `completed_at` is set when they submit the test. 

To enforce test durations:
Inside the Next.js API submission handler, we load the quiz's `allowed_duration` (e.g., 30 minutes) and calculate the difference:
```typescript
const durationMs = completedAt.getTime() - startedAt.getTime();
if (durationMs > allowedDurationLimit) {
  // Flag attempt as late or disqualify
}
```
We also run database-level checks to verify that `completed_at >= started_at` using check constraints."*

### Q5: What is the risk of using a GIN index on `questions` inside the `quizzes` table, and when is it justified?
**Answer:**
*"A **GIN (Generalized Inverted Index)** allows us to perform fast search queries on nested JSON keys inside a `JSONB` column. 

The risk is that GIN indexes are very large and add significant write overhead, slowing down updates and inserts. A GIN index is only justified if our application frequently queries quizzes based on nested question parameters (e.g., 'find all quizzes containing the keyword X inside the options array'). Since Pookiz only loads the quiz as a single blob by its ID, a GIN index is unnecessary; a standard B-Tree index on `id` is sufficient."*
