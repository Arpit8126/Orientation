# Tactical Guide: Presenting Pookiz and Quiz Management System as Two Separate Projects

This guide prepares you to explain two distinct projects during technical interviews. It isolates **Pookiz (a social media platform)** from the **Quiz Management System (an academic testing platform)** so you can showcase a wider range of software engineering skills, architectural decisions, and problem-solving abilities.

---

# PROJECT 1: Pookiz (Campus Social & Messaging Network)

## 1. The 60-Second Hook (Elevator Pitch)
> "Pookiz is a high-concurrency, real-time social and messaging network designed for college campus communities. Built on **Next.js (App Router)** and **Supabase (PostgreSQL)**, it bridges campus communication gaps by consolidating real-time messaging, group channels, peer-to-peer audio/video calling, and a secure, moderated anonymous feed called *Spill the Tea*. 
>
> My primary focus was on technical performance, real-time data consistency, and database-level security. I utilized Supabase Realtime to stream messaging updates directly to clients, designed custom PL/pgSQL database triggers to synchronize relationships atomically, and optimized mobile animations to run at a consistent 60 FPS by offloading layout-shifting calculations to the GPU."

## 2. Core Problems Solved
*   **Fragmented Campus Communication:** College students often rely on disjointed, generic channels (e.g., WhatsApp, Discord, Slack, emails) to coordinate. Pookiz aggregates study groups, friendships, calls, and campus gossip into a single, unified workspace authenticated specifically for the university.
*   **User Privacy vs. Campus Engagement:** Students want a way to ask sensitive questions or discuss campus-specific issues anonymously. The *Spill the Tea* feed provides an anonymous discussion space while maintaining strict DB-level security.
*   **Access Control Overhead:** Traditional social networks require complex custom backend middlewares to ensure that users only read messages in their groups or direct chats. Pookiz solves this by shifting access rules directly to the database.

## 3. Major Features & Technical Implementation

### A. Real-Time Chat & Direct Messaging (DMs)
*   **What it is:** Instant message delivery, typing indicators, and presence updates between users.
*   **Technical Implementation:** Powered by **Supabase Realtime**, which hooks into PostgreSQL’s Write-Ahead Log (WAL) to listen for database inserts/updates on chat tables. The Next.js frontend subscribes to these streams, bypassing the need for a dedicated Node.js WebSocket backend.

### B. Collaborative Campus Groups & Study Channels
*   **What it is:** Group chats, student clubs, and course-specific rooms where students can share resources and discuss projects.
*   **Technical Implementation:** Structured using a relational database schema mapping profiles to groups via a join table. Subscriptions update dynamically when new group messages are posted.

### C. Live Video and Audio Calling
*   **What it is:** High-performance video/voice calls within groups or DMs.
*   **Technical Implementation:** Built using **WebRTC** orchestrated via **LiveKit**. Next.js API routes act as the authentication server to issue secure, signed room tokens. When a call starts, the client connects to LiveKit, which acts as a Selective Forwarding Unit (SFU) to route media streams efficiently and handle strict firewall traversal.

### D. "Spill the Tea" (Anonymous Feed)
*   **What it is:** A community feed where students post and comment anonymously.
*   **Technical Implementation:** The schema handles posts (`tea`) and nested replies (`tea_comments`) with a self-referential `parent_id` column. User profiles are hidden from the frontend on these routes, but integrity is maintained through relational IDs on the backend.

### E. Interactive Friend Requests & Social Graph Sync
*   **What it is:** A system where users search, add friends, accept requests, and update their online status.
*   **Technical Implementation:** Implemented mutual friendship structures. Accepting a request triggers a database event that updates both parties' friend list synchronously.

## 4. Key Architectural Deep-Dives (Impress the Interviewer)

*   **Database-Level Security via Row Level Security (RLS):**
    *   *Concept:* Rather than coding access authorization inside Next.js API middleware, RLS policies are applied directly to the Postgres tables.
    *   *Implementation:* Using Supabase's authenticated session variables (`auth.uid()`), the database automatically blocks read/write actions on message tables unless the querying user is a participant in that specific conversation. This guarantees that data cannot leak, even if frontend routes are bypassed.
*   **PL/pgSQL Database Triggers:**
    *   *Concept:* Using database-level automation instead of API calls to keep tables in sync.
    *   *Implementation:* When a new user registers via Supabase Auth, a trigger automatically inserts a default profile row into the public profiles table. Similarly, when a friend request is approved, a database trigger automatically inserts the reciprocal row in the friendships table. This is transactional and rollback-safe, eliminating data desyncs.
*   **60 FPS Mobile Animation Optimization:**
    *   *Problem:* Animating the header's layout properties (like `margin-top: -72px`) on scroll forced the browser's layout engine to recalculate the positions of all DOM elements (layout reflow), dropping framerates on mobile to ~25 FPS.
    *   *Solution:* Migrated the header to absolute positioning and animated it using CSS transforms (`transform: translateY(-100%)`). Because CSS transforms are computed on the GPU (compositor thread) and do not trigger layout reflows, page scrolling remained locked at a buttery-smooth 60 FPS.

---

# PROJECT 2: Quiz Management System (Academic Testing Platform)

## 1. The 60-Second Hook (Elevator Pitch)
> "The Quiz Management System is a robust academic evaluation platform designed to create, deliver, and grade online exams securely. Built using **Next.js** and **PostgreSQL**, the application supports dynamic quiz creation, automated scoring, and real-time student tracking.
>
> To support diverse quiz formats without database schema bloat, I modeled question banks using **PostgreSQL JSONB columns**, parsing dynamic schemas at the application layer. The primary technical hurdle I solved was designing an anti-cheat engine that tracks client-side tab switching and window focus changes, logging violations atomically on the server via transaction-locked APIs to handle potential network latency and out-of-order warning events."

## 2. Core Problems Solved
*   **Exam Integrity & Remote Cheating:** Instructors need verification that students are not switching tabs, searching for answers, or exiting the exam window during a test.
*   **Rigid Database Schemas for Dynamic Content:** Quizzes require different question structures (multiple choice, fill-in-the-blank, true/false, coding questions). Creating a database table for every question type creates design bloat and complex SQL joins.
*   **Server-Side Security during Submissions:** Preventing students from altering their scores or manipulating test questions prior to final grading.

## 3. Major Features & Technical Implementation

### A. Dynamic Quiz Builder & Questions Repository
*   **What it is:** An interface allowing teachers to write questions, set timers, set point weights, and publish quizzes.
*   **Technical Implementation:** Quizzes are represented dynamically on Next.js frontend pages. The questions are structured as flexible schemas parsed by the server.

### B. Anti-Cheat Monitoring & Tab-Tracking Protocol
*   **What it is:** A system that detects if a student leaves the quiz tab or opens another window, warning them and logging the event for the instructor.
*   **Technical Implementation:** Utilizes the browser's **Page Visibility API** (listening to `visibilitychange` events) and the window **Focus/Blur API** (listening to `blur` and `focus` events) on the frontend. When focus is lost, a silent warning packet is dispatched to the backend.

### C. Live Attempt Runner & Auto-Save
*   **What it is:** A student-facing testing interface showing one question at a time with a countdown timer.
*   **Technical Implementation:** Built with React state tracking and local-storage syncing. If a student accidentally refreshes or loses connection, their current state is immediately recovered.

### D. Automated Grading Engine & Analytics Dashboard
*   **What it is:** Instantly calculates the score of a quiz upon submission and displays a performance breakdown to both students and teachers.
*   **Technical Implementation:** Completed responses are sent to a secure Next.js API route. The server compares the submitted answers against the database answer key, updates the database, and returns the analytics report.

## 4. Key Architectural Deep-Dives (Impress the Interviewer)

*   **JSONB Document Columns vs. Relational Tables:**
    *   *Decision:* Instead of creating individual tables for `multiple_choice_questions`, `text_questions`, and `order_questions`, the system stores the questions list as a `JSONB` array within the `quizzes` table.
    *   *Trade-off:* This allowed the system to support any quiz format dynamically. To maintain integrity, validation checks are performed on the Next.js API server prior to database writes, keeping database schemas lightweight while ensuring structured formatting.
*   **Mitigating Network Latency in Anti-Cheat Event Sequences:**
    *   *Problem:* If a student switched tabs rapidly, high-frequency focus/blur warning packets could arrive at the backend out-of-order or duplicate due to network latency, creating duplicate logs or incorrect warning counts.
    *   *Solution:* Designed a client-side event sequence indexing system. Each warning packet is sent with an incremental index (e.g., `sequence_id`). The Postgres database endpoint uses transaction locks (`SELECT FOR UPDATE` on the attempt record) to process warning writes atomically, rejecting duplicates and writing warnings in chronological sequence order.

---

# How to Present Both Projects in an Interview (The Interview Strategy)

When an interviewer asks you to **"Walk me through your projects,"** use this transition strategy:

1.  **Introduce your portfolio context:**
    > *"I have two key projects that highlight different aspects of my full-stack engineering skills. The first is **Pookiz**, a highly interactive, real-time social media platform designed for college campuses. The second is a **Quiz Management System**, which is an academic platform focused on dynamic data modeling and client-state security tracking."*
2.  **Explain Pookiz first:** Discuss the real-time elements, database security (RLS, Triggers), and frontend animation performance.
3.  **Transition to the Quiz Management System:**
    > *"While Pookiz allowed me to solve challenges surrounding real-time messaging, WebRTC calling, and UI rendering performance, the Quiz Management System presented a different set of challenges. It required me to handle dynamic schema design using PostgreSQL JSONB and build a highly secure, transaction-locked anti-cheat tracking system."*
4.  **Conclude on your versatility:**
    > *"Together, these projects demonstrate my ability to build both highly-engaging real-time consumer apps (Pookiz) and secure, data-driven utility systems (Quiz Management System)."*
