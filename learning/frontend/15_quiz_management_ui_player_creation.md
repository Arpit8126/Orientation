# Frontend Chapter 15: Quiz Management — Complete UI Flow, Creation & Player

This module covers the complete quiz management system from the creator's perspective (building and publishing quizzes) and the student's perspective (taking a quiz, seeing results, and the AI generation pipeline UI).

---

## 1. Objective & Placement Value
- **Why this is asked:** Online examination and quiz platforms are a popular system design topic. Interviewers evaluate how you handle complex multi-step forms, dynamic question rendering, result calculation, access control (scope gates), and AI feature integration.
- **Placement Value:** Prepares you to design secure, multi-tenant assessment platforms with real-time AI integration.

---

## 2. The Layman's Analogy
Think of quiz management as a **university examination system**:
- **The Quiz Creator (Teacher's View):** A professor fills out an exam paper template. They set the title, choose difficulty, pick the scope (who can see it), and either type questions manually or hand the AI a textbook PDF and ask it to generate questions automatically.
- **The Quiz Store (Database):** The completed exam is sealed and locked in the registrar's filing cabinet (`quizzes` table).
- **The Student Dashboard:** A student walks into the exam hall, sees available exams, and checks if they are allowed to take it (scope: all / university / private).
- **The Quiz Player:** The student sits at the desk, reads questions one at a time, selects answers, and submits when done.
- **The Results Sheet:** After submission, the score is calculated instantly and displayed with explanations.

---

## 3. The Technical Specification

### A. Quiz Scope Access Control
Quizzes have three visibility levels enforced at the **API layer**:
| Scope | Who Can See It |
|---|---|
| `all` | Every authenticated Pookiz user |
| `university` | Only users who belong to the quiz creator's university |
| `private` | Only the creator themselves |

```typescript
// In GET /api/quizzes — filtering by scope
const { data: profile } = await supabase
  .from('profiles')
  .select('university_id')
  .eq('id', user.id)
  .single()

const { data: quizzes } = await supabase
  .from('quizzes')
  .select('id, title, description, difficulty, scope, start_time, end_time, creator_id')
  .or(`scope.eq.all,and(scope.eq.university,university_id.eq.${profile.university_id}),and(scope.eq.private,creator_id.eq.${user.id})`)
  .gte('end_time', new Date().toISOString())  // only show active quizzes
  .order('start_time', { ascending: true })
```
- The `.or()` filter implements scope visibility: `all` quizzes + university-scoped quizzes matching the user's university + private quizzes the user created.
- `end_time >= NOW()` ensures expired quizzes don't appear.

### B. The Question JSONB Format
Each quiz stores its questions in a `JSONB` array:
```json
{
  "questions": [
    {
      "id": 1,
      "type": "mcq",
      "question": "Which keyword is used to inherit a class in Java?",
      "code_snippet": "class Dog ___ Animal { ... }",
      "options": ["extends", "implements", "inherits", "super"],
      "correct_option_index": 0,
      "explanation": "The 'extends' keyword is used for class inheritance in Java.",
      "points": 2
    },
    {
      "id": 2,
      "type": "true_false",
      "question": "Java supports multiple inheritance through classes.",
      "options": ["True", "False"],
      "correct_option_index": 1,
      "explanation": "Java only supports multiple inheritance through interfaces, not classes.",
      "points": 1
    }
  ]
}
```
- `correct_option_index` and `explanation` are **stripped out** before sending to students.
- The API route sanitizes the JSONB payload: `questions.map(q => ({ ...q, correct_option_index: undefined, explanation: undefined }))`.

---

## 4. Line-by-Line Code Walkthrough

### A. The Quiz List Page (`/quizzes/page.tsx`)
```typescript
// Tabs: "Available", "My Quizzes", "Attempted"
const [activeTab, setActiveTab] = useState<'available' | 'mine' | 'attempted'>('available')

// Fetch all quizzes based on the active tab
useEffect(() => {
  const fetchQuizzes = async () => {
    const endpoint =
      activeTab === 'mine' ? '/api/quizzes?filter=mine' :
      activeTab === 'attempted' ? '/api/quizzes?filter=attempted' :
      '/api/quizzes'

    const res = await fetch(endpoint)
    const { quizzes } = await res.json()
    setQuizzes(quizzes)
  }

  fetchQuizzes()
}, [activeTab])
```

**Quiz Card renders:**
```
┌────────────────────────────────────────┐
│ [Difficulty Badge] [Scope Badge]       │
│                                        │
│ Quiz Title                             │
│ Description preview...                 │
│                                        │
│ 📅 Jan 15 - Jan 20   🎯 15 questions  │
│ 🔥 Hard              👤 Created by    │
│                                        │
│          [Start Quiz →]                │
└────────────────────────────────────────┘
```

### B. Starting a Quiz — Access Gate
```typescript
// In /api/quizzes/start/route.ts
export async function POST(request: Request) {
  const { quiz_id, password } = await request.json()

  // Load full quiz with questions
  const { data: quiz } = await supabase
    .from('quizzes')
    .select('*')
    .eq('id', quiz_id)
    .single()

  // Time window check
  const now = new Date()
  if (now < new Date(quiz.start_time) || now > new Date(quiz.end_time)) {
    return NextResponse.json({ error: 'Quiz is not currently active' }, { status: 400 })
  }

  // Password check for protected quizzes
  if (quiz.password_hash) {
    const isCorrect = await bcrypt.compare(password, quiz.password_hash)
    if (!isCorrect) {
      return NextResponse.json({ error: 'Incorrect password' }, { status: 401 })
    }
  }

  // Check if already attempted
  const { data: existing } = await supabase
    .from('quiz_attempts')
    .select('id')
    .eq('quiz_id', quiz_id)
    .eq('user_id', user.id)
    .single()

  if (existing) {
    return NextResponse.json({ error: 'You have already attempted this quiz' }, { status: 400 })
  }

  // Strip correct answers before sending to client
  const sanitizedQuestions = quiz.questions.map((q: any) => ({
    id: q.id,
    type: q.type,
    question: q.question,
    code_snippet: q.code_snippet || null,
    options: q.options,
    points: q.points,
    // correct_option_index and explanation are intentionally omitted
  }))

  return NextResponse.json({ quiz: { ...quiz, questions: sanitizedQuestions } })
}
```

### C. The Quiz Player — Single Page App State Machine
The quiz player (`/quizzes/[id]/page.tsx`) is the most complex component — a ~3000-line file managing:

**State Variables:**
```typescript
const [currentQuestion, setCurrentQuestion] = useState(0)  // index of displayed question
const [answers, setAnswers] = useState<(number | null)[]>([])  // user's selected option per question
const [quizStarted, setQuizStarted] = useState(false)  // true after fullscreen + agreement
const [timeLeft, setTimeLeft] = useState(quiz.duration_seconds)  // countdown timer
const [warningsCount, setWarningsCount] = useState(0)  // anti-cheat counter
const [isDisqualified, setIsDisqualified] = useState(false)  // disqualification flag
const [submitting, setSubmitting] = useState(false)  // prevents double-submit
const [showResults, setShowResults] = useState(false)  // toggles result view
```

**The Quiz State Machine:**
```
IDLE
  → User clicks "Start Quiz"
  → Fullscreen requested
STARTED
  → User answers questions
  → Timer counting down
  → Anti-cheat monitoring active
  → Progress auto-saved every 30 seconds
WARNING RECEIVED (tab switch / fullscreen exit)
  → warningsCount++
  → If warningsCount >= 3 → DISQUALIFIED
SUBMIT
  → User clicks "Submit" or timer hits 0
  → Sends answers to /api/quizzes/submit
  → Shows results page
DISQUALIFIED
  → Forced submission with current answers
  → is_disqualified = true in database
```

### D. Submitting the Quiz — `/api/quizzes/submit`
```typescript
export async function POST(request: Request) {
  const { quiz_id, answers, warnings_count, is_disqualified, student_details } = await request.json()

  // Load quiz with correct answers (server-side only)
  const { data: quiz } = await supabase
    .from('quizzes')
    .select('questions, required_inputs')
    .eq('id', quiz_id)
    .single()

  // Calculate score
  let score = 0
  let breakdown = []

  quiz.questions.forEach((question: any, idx: number) => {
    const userAnswer = answers[idx]
    const isCorrect = userAnswer === question.correct_option_index

    if (isCorrect) score += (question.points || 1)

    breakdown.push({
      question_id: question.id,
      user_answer: userAnswer,
      correct_answer: question.correct_option_index,
      explanation: question.explanation,
      is_correct: isCorrect,
      points_earned: isCorrect ? question.points : 0,
    })
  })

  // Save the attempt
  const { data: attempt, error } = await supabase
    .from('quiz_attempts')
    .insert({
      quiz_id,
      user_id: user.id,
      answers: answers,
      score,
      warnings_count: warnings_count || 0,
      is_disqualified: is_disqualified || false,
      student_details: student_details || {},
      completed_at: new Date().toISOString(),
    })
    .select()
    .single()

  if (error?.code === '23505') {  // unique constraint violation
    return NextResponse.json({ error: 'Already submitted' }, { status: 409 })
  }

  return NextResponse.json({ score, breakdown, attempt_id: attempt.id })
}
```
- Score is calculated **server-side** — client cannot send a pre-calculated score.
- The `breakdown` array includes correct answers and explanations for the results page.
- `23505` is PostgreSQL's error code for unique constraint violations — catches double-submit attempts.

### E. AI Quiz Generation UI Flow
```
User opens "AI Generate" tab in quiz creator
  → Selects subject + topic
  → Either:
     (A) Types a topic description → calls /api/quizzes/generate-ai
     (B) Uploads a PDF → calls /api/quizzes/generate-from-pdf

Both endpoints return:
  { questions: [...] }

Questions are loaded into the quiz editor form
  → User can edit, delete, or add questions
  → User sets title, scope, time window, difficulty
  → Clicks "Publish Quiz"
  → POST /api/quizzes → saves to database
```

---

## 5. Quiz Results Display
After submission, the results page shows:
```
╔══════════════════════════════════╗
║     Your Score: 8 / 15           ║
║     53% — Keep Practicing!       ║
╠══════════════════════════════════╣
║  Q1: What is polymorphism?       ║
║  ✅ Your answer: "Correct option"║
║  💡 Explanation: ...             ║
╠══════════════════════════════════╣
║  Q2: Which keyword...            ║
║  ❌ Your answer: "Wrong option"  ║
║  ✅ Correct: "extends"          ║
║  💡 Explanation: ...             ║
╚══════════════════════════════════╝
```
- Green ✅ for correct, Red ❌ for wrong.
- The explanation is shown for every question (correct or not) to maximize learning.
- Disqualified attempts show a red banner: "This attempt was flagged for violations."

---

## 6. Staff Engineer Viva Board

### Q1: How do you prevent students from inspecting network responses to get correct answers before submitting?
**Answer:**
*"The `/api/quizzes/start` route deliberately strips `correct_option_index` and `explanation` from the question objects before returning them to the client:
```typescript
const sanitized = quiz.questions.map(q => ({
  id: q.id, question: q.question, options: q.options
  // correct_option_index removed
}))
```
Even if a student opens Chrome DevTools and inspects the `/api/quizzes/start` network response, they will not find the correct answers because they were never sent. Answers are only loaded on the server side during the `/api/quizzes/submit` handler."*

### Q2: Walk me through the `23505` PostgreSQL error code and how it protects against double-submission.
**Answer:**
*"The `quiz_attempts` table has a `UNIQUE(quiz_id, user_id)` constraint. When a student submits their quiz:
1. The server calls `supabase.from('quiz_attempts').insert(...)`.
2. If the student already has a row for that `quiz_id + user_id`, PostgreSQL returns error code `23505` — unique constraint violation.
3. The API catches this specific error code and returns `409 Conflict` instead of `500 Internal Server Error`.
This protects against double-clicks, slow networks triggering duplicate requests, and deliberate manipulation attempts."*

### Q3: Why is the quiz player implemented as a client-side state machine rather than multiple pages?
**Answer:**
*"Using multiple pages (e.g., `/quizzes/[id]/question/1`, `question/2`, etc.) would cause full page reloads between questions. Each reload would:
1. Re-run the Next.js server, re-fetch session cookies, re-render layouts.
2. Lose in-memory state (selected answers, timer countdown, warning count).
3. Trigger new fullscreen requests (browsers only allow fullscreen on direct user interaction).

A client-side state machine keeps everything in React state — question navigation, timer, answers, and proctoring — without any page reloads, giving a seamless exam experience."*

### Q4: How does the timer countdown work and what happens when it reaches zero?
**Answer:**
*"The timer is implemented using a `setInterval` that decrements the `timeLeft` state every second:
```typescript
useEffect(() => {
  if (!quizStarted || showResults) return
  const interval = setInterval(() => {
    setTimeLeft(prev => {
      if (prev <= 1) {
        clearInterval(interval)
        handleAutoSubmit()  // force-submits with current answers
        return 0
      }
      return prev - 1
    })
  }, 1000)
  return () => clearInterval(interval)
}, [quizStarted, showResults])
```
When `timeLeft` hits 0, `handleAutoSubmit()` is called, which triggers the same submission flow as clicking the Submit button — with whatever answers the student has selected so far."*
