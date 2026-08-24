# Tactical Guide: Complete Database Schema, DBMS Foundations, and Row Level Security (RLS)

This document is a comprehensive guide to the Pookiz database architecture, relational schema, Row Level Security (RLS) policies, and core Database Management System (DBMS) concepts. Use this guide to prepare for technical interviews and articulate the "What, Why, and How" of the Pookiz database system.

---

# SECTION 1: DBMS & SQL Core Interview Concepts

In database design and system architecture interviews, engineers are evaluated on how they ensure data safety, performance, and structure. Below are the key pillars of relational database theory, mapped directly to how they are implemented in Pookiz.

## 1. ACID Properties (Data Integrity)
ACID is a set of properties that guarantee database transactions are processed reliably:
*   **Atomicity ("All or Nothing"):** A transaction is a single logical unit of work. If any part of it fails, the entire transaction rolls back, leaving the database unchanged.
    *   *Pookiz Example:* When a user accepts a friend request, the system must update the request status and insert a bidirectional row into the `friends` table. If the update succeeds but the insertion fails, the database rolls back the status change, preventing a corrupt social graph state.
*   **Consistency (Rule Enforcement):** Transactions must transition the database from one valid state to another, maintaining all schema constraints (e.g., Foreign Keys, Check Constraints, Unique indexes).
    *   *Pookiz Example:* The constraint `no_self_friend` on the `friends` table (`CHECK (user_id_1 != user_id_2)`) prevents users from sending friend requests to themselves.
*   **Isolation (Concurrency Control):** Multiple transactions executing simultaneously must not interfere with each other. PostgreSQL uses Multi-Version Concurrency Control (MVCC) to ensure transactions run in isolation (typically using `Read Committed` isolation level by default).
    *   *Pookiz Example:* In the Quiz anti-cheat system, when a student triggers rapid visibility events, the database locks the current `quiz_attempts` row using `SELECT FOR UPDATE` to isolate writes and prevent race conditions.
*   **Durability (Persistence):** Once a transaction is committed, its effects are permanent, even in the event of a system crash. This is achieved by writing transaction logs to PostgreSQL's Write-Ahead Log (WAL) before writing to actual table blocks on disk.

## 2. Database Normalization & Denormalization
Normalization is the process of structuring a relational database to reduce data redundancy and improve data integrity:
*   **1NF (First Normal Form):** Every table cell must contain atomic (indivisible) values, and there must be no repeating groups.
    *   *Pookiz Alignment:* Separate rows are created for individual group members in `group_members`, rather than storing member lists in a comma-separated text string.
*   **2NF (Second Normal Form):** Must be in 1NF, and all non-key columns must depend on the entire primary key (no partial dependency).
    *   *Pookiz Alignment:* In the composite-key style tables, attributes depend fully on the primary key identifier.
*   **3NF (Third Normal Form):** Must be in 2NF, and there must be no transitive dependencies (non-key columns must depend only on the primary key, and nothing else).
    *   *Pookiz Alignment:* User profiles contain a foreign key reference `university_id` pointing to the `universities` table, rather than duplicating the university's logo URL and domain directly in the `profiles` table.
*   **Architectural Trade-off: JSONB for Quizzes (Intentional Denormalization)**
    *   *The Concept:* Normalizing quiz questions would require separate tables like `questions`, `options`, and `correct_answers`. 
    *   *The Decision:* Pookiz stores quiz questions inside a single `JSONB` column on the `quizzes` table. This allows dynamic question structures (e.g., code snippets, cloze tests, multiple choice) without complex schemas, trading strict database check constraints for fast query retrieval and flexible schema evolution checked at the application server layer.

## 3. Indexing Strategies (Latency Minimization)
Indexes are datastructures (primarily B-Trees in PostgreSQL) that speed up data retrieval at the cost of additional write overhead and disk space.
*   **B-Tree Indexes:** Best for equality (`=`) and range queries (`<`, `>`, `BETWEEN`). 
    *   *Implementation:* Created on `profiles(username)` to make user searches fast, and on `messages(created_at DESC)` to load chat histories instantly.
*   **Composite Indexes:** Multi-column indexes designed for queries filtering on multiple fields.
    *   *Implementation:* In the `messages` table, we use `idx_messages_dm(sender_id, recipient_id, created_at DESC)`. This allows the database to instantly query a private DM channel between two specific users and order the messages chronologically in a single index lookup.

## 4. Database Triggers & Functions (Automation & Security)
A trigger is a database procedure that automatically executes when a specified event (INSERT, UPDATE, DELETE) occurs on a table.
*   **Why use Triggers instead of API Logic?**
    1.  **Atomic Execution:** Triggers run inside the same database transaction. If the trigger fails, the query fails and rolls back.
    2.  **Bypassing Security Boundaries:** Triggers declared as `SECURITY DEFINER` execute with the privileges of the user who created them (the database owner/superuser) rather than the client making the request (`SECURITY INVOKER`). This allows public sign-ups to create a private profile row automatically, even when direct insert rights on `profiles` are restricted by RLS.

## 5. Row Level Security (RLS) Mechanics
RLS is an access control system built into PostgreSQL that restricts which rows a user can select, insert, update, or delete.
*   **JWT Context Integration:** Supabase decrypts the client's auth token and passes it to Postgres as session variables. The function `auth.uid()` retrieves the current user's UUID from this session.
*   **USING vs WITH CHECK Clauses:**
    *   `USING`: Evaluated on existing database rows. If a select query is executed, only rows where the `USING` clause evaluates to `true` are returned. If an update/delete is performed, only rows matching the `USING` filter can be modified.
    *   `WITH CHECK`: Evaluated on the *newly proposed* row content during INSERT or UPDATE. It ensures that users cannot write invalid data (e.g., attempting to create a message where `sender_id` does not match their own `auth.uid()`).

---

# SECTION 2: Table-by-Table Technical Specifications

Below is the complete catalog of the 31 tables in the Pookiz system database, structured by their functional domains.

## Domain A: Core Identity & Organization

### 1. `universities`
*   **What it performs & Why it is needed:** Represents the academic institutions supported by the network. It isolates student populations and manages branding and domains.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `name` | `text` | Unique, Not Null |
    | `domain` | `text` | Unique, Not Null |
    | `logo_url` | `text` | Nullable |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

### 2. `profiles`
*   **What it performs & Why it is needed:** Extends the core auth system to store user profile details, academic majors, onboarding states, call settings, and roles (e.g., teacher status).
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, References `auth.users(id) ON DELETE CASCADE` |
    | `username` | `text` | Unique, Not Null |
    | `bio` | `text` | Nullable, Default: `''` (Max 160 characters) |
    | `avatar_url` | `text` | Nullable |
    | `university_name` | `text` | Nullable, Default: `'GLA University'` |
    | `course` | `text` | Nullable |
    | `dob` | `date` | Nullable |
    | `city` | `text` | Nullable |
    | `is_banned` | `bool` | Nullable, Default: `false` |
    | `sethji` | `bool` | Nullable, Default: `false` (Super Admin role) |
    | `is_onboarded` | `bool` | Nullable, Default: `false` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | `updated_at` | `timestamptz` | Nullable, Default: `now()` |
    | `last_seen` | `timestamptz` | Nullable, Default: `now()` |
    | `full_name` | `text` | Nullable |
    | `year_of_study` | `text` | Nullable |
    | `is_email_verified` | `bool` | Nullable, Default: `false` |
    | `university_id` | `uuid` | Nullable, References `public.universities(id)` |
    | `is_testing_user` | `bool` | Nullable, Default: `false` |
    | `session_token` | `text` | Nullable |
    | `allow_calls` | `text` | Default: `'everyone'` |
    | `is_muted_ringtone` | `bool` | Default: `false` |
    | `active_chat_id` | `text` | Nullable |
    | `default_wallpaper` | `text` | Nullable |
    | `is_teacher` | `bool` | Nullable, Default: `false` |
    | `teacher_id_card_url` | `text` | Nullable |
    | `linkedin_url` | `text` | Nullable |

### 3. `university_applications`
*   **What it performs & Why it is needed:** Records requests from other universities to set up networks on the Pookiz platform, enabling B2B scale.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `name` | `text` | Not Null |
    | `domain` | `text` | Not Null |
    | `contact_email` | `text` | Not Null |
    | `status` | `text` | Not Null, Default: `'pending'` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

### 4. `teacher_applications`
*   **What it performs & Why it is needed:** Tracks validation requests from users seeking verified teacher status. Teachers gain special access to create official academic quizzes.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `id_card_url` | `text` | Not Null |
    | `status` | `text` | Not Null, Default: `'pending'` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | `updated_at` | `timestamptz` | Nullable, Default: `now()` |

---

## Domain B: Group Chats & Collaborations

### 5. `groups`
*   **What it performs & Why it is needed:** Houses details about campus groups, study channels, and clubs, including access settings (public, university-only, password-locked).
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `name` | `text` | Not Null |
    | `bio` | `text` | Nullable, Default: `''` |
    | `description` | `text` | Nullable |
    | `creator_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE SET NULL` |
    | `privacy_type` | `text` | Not Null, Default: `'public'` CHECK in `'public'`, `'university_only'`, `'password_protected'` |
    | `password_hash` | `text` | Nullable |
    | `is_system_group` | `bool` | Nullable, Default: `false` |
    | `avatar_url` | `text` | Nullable |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | `updated_at` | `timestamptz` | Nullable, Default: `now()` |
    | `university_id` | `uuid` | Nullable, References `public.universities(id)` |
    | `theme` | `text` | Nullable |
    | `wallpaper_url` | `text` | Nullable |
    | `rules` | `text` | Nullable |
    | `font_theme` | `varchar` | Nullable |

### 6. `group_members`
*   **What it performs & Why it is needed:** Join table mapping profiles to groups. Defines roles (admin, coadmin, mod, member) to handle group operations.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `group_id` | `uuid` | References `public.groups(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `role` | `text` | Not Null, Default: `'member'` CHECK in `'member'`, `'mod'`, `'coadmin'`, `'admin'` |
    | `is_group_banned` | `bool` | Nullable, Default: `false` |
    | `joined_at` | `timestamptz` | Nullable, Default: `now()` |
    | *Constraint* | `UNIQUE(group_id, user_id)` | Prevents duplicate user memberships in a single group |

### 7. `group_bans`
*   **What it performs & Why it is needed:** Keeps records of users banned from specific groups, preventing them from rejoining.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `group_id` | `uuid` | References `public.groups(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `banned_by` | `uuid` | Nullable, References `public.profiles(id) ON DELETE SET NULL` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

### 8. `group_logs`
*   **What it performs & Why it is needed:** Implements a security audit trail logging actions performed by moderators and admins in groups.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `group_id` | `uuid` | Nullable, References `public.groups(id) ON DELETE CASCADE` |
    | `action_performer_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE SET NULL` |
    | `target_user_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE SET NULL` |
    | `action_type` | `varchar` | Not Null |
    | `deleted_message_text` | `text` | Nullable |
    | `created_at` | `timestamptz` | Default: `now()` |

---

## Domain C: Real-Time Communication

### 9. `messages`
*   **What it performs & Why it is needed:** Central table storing chat history for both Direct Messages (recipient-focused) and Group Chats.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `sender_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `recipient_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE CASCADE` |
    | `group_id` | `uuid` | Nullable, References `public.groups(id) ON DELETE CASCADE` |
    | `message_text` | `text` | Not Null (Max length 1000) |
    | `is_anonymous` | `bool` | Nullable, Default: `false` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | `media_url` | `text` | Nullable |
    | `read_at` | `timestamptz` | Nullable |
    | *Constraint* | `CHECK ((recipient_id IS NOT NULL AND group_id IS NULL) OR (recipient_id IS NULL AND group_id IS NOT NULL))` | Message must target exactly one recipient OR one group |

### 10. `message_reactions`
*   **What it performs & Why it is needed:** Allows users to react to chat messages with emojis.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `message_id` | `uuid` | References `public.messages(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `emoji` | `text` | Not Null |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

### 11. `pinned_messages`
*   **What it performs & Why it is needed:** Tracks messages pinned in a chat or group.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `message_id` | `uuid` | Unique, References `public.messages(id) ON DELETE CASCADE` |
    | `group_id` | `uuid` | Nullable, References `public.groups(id) ON DELETE CASCADE` |
    | `pinned_by` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `created_at` | `timestamptz` | Default: `now()` |

### 12. `chat_clears`
*   **What it performs & Why it is needed:** Records when a user clears a chat, ensuring the client hides messages sent before that timestamp.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `friend_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE CASCADE` |
    | `group_id` | `uuid` | Nullable, References `public.groups(id) ON DELETE CASCADE` |
    | `cleared_at` | `timestamptz` | Default: `now()` |

### 13. `deleted_messages`
*   **What it performs & Why it is needed:** Tracks messages deleted by an individual user so that deleted posts are only hidden locally from their UI, matching modern privacy controls.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `message_id` | `uuid` | References `public.messages(id) ON DELETE CASCADE` |
    | `created_at` | `timestamptz` | Default: `now()` |

### 14. `user_chat_settings`
*   **What it performs & Why it is needed:** Saves personalized configurations like wallpaper URLs and themes for individual chats.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `chat_type` | `text` | Not Null CHECK in `'dm'`, `'group'` |
    | `chat_id` | `uuid` | Not Null |
    | `theme` | `text` | Nullable |
    | `wallpaper_url` | `text` | Nullable |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

---

## Domain D: Social Relations & Safety

### 15. `friends`
*   **What it performs & Why it is needed:** Manages friend connections. Stores statuses (`pending`, `accepted`) and chat customization states.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id_1` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `user_id_2` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `status` | `text` | Default: `'pending'` CHECK in `'pending'`, `'accepted'` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | `theme` | `text` | Nullable |
    | *Constraint* | `CHECK (user_id_1 != user_id_2)` | Users cannot friend themselves |
    | *Constraint* | `UNIQUE(user_id_1, user_id_2)` | Prevents duplicate connection records |

### 16. `blocks`
*   **What it performs & Why it is needed:** Enforces safety. If User A blocks User B, the database limits communication and UI updates between them.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `blocker_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `blocked_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | *Constraint* | `CHECK (blocker_id != blocked_id)` | Users cannot block themselves |
    | *Constraint* | `UNIQUE(blocker_id, blocked_id)` | Prevents duplicate block records |

### 17. `follows`
*   **What it performs & Why it is needed:** Allows users to subscribe to updates from other students (e.g. non-mutual social connections).
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `follower_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `following_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `created_at` | `timestamptz` | Default: `now()` |

### 18. `reports`
*   **What it performs & Why it is needed:** Allows users to flag abusive behavior or content to the platform administrators.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `reporter_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `reported_user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `reason` | `text` | Not Null |
    | `status` | `text` | Default: `'pending'` CHECK in `'pending'`, `'approved'`, `'rejected'` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

---

## Domain E: Push & Notification Ledger

### 19. `notifications`
*   **What it performs & Why it is needed:** Stores notifications sent to users, supporting read-state updates and broad campus announcements.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `recipient_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE CASCADE` |
    | `title` | `text` | Not Null |
    | `content` | `text` | Not Null |
    | `is_broadcast` | `bool` | Nullable, Default: `false` |
    | `is_read` | `bool` | Nullable, Default: `false` |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

### 20. `push_subscriptions`
*   **What it performs & Why it is needed:** Stores WebPush subscription credentials for device notification delivery.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `subscription` | `jsonb` | Not Null (Vapid details object) |
    | `created_at` | `timestamptz` | Default: `now()` |

### 21. `notification_preferences`
*   **What it performs & Why it is needed:** Customizes alerting configurations, allowing users to mute specific rooms or toggle device and browser updates.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `context_type` | `text` | Not Null |
    | `context_id` | `text` | Not Null |
    | `mute_website` | `bool` | Default: `false` |
    | `mute_device` | `bool` | Default: `false` |
    | `updated_at` | `timestamptz` | Default: `now()` |
    | `notify_all_messages` | `bool` | Default: `true` |
    | `notify_all_messages_website` | `bool` | Default: `true` |

---

## Domain F: Academic Evaluation & Quizzes

### 22. `quizzes`
*   **What it performs & Why it is needed:** Hosts online exam metadata, timings, scoring keys, and questions (denormalized JSONB questions array).
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `title` | `text` | Not Null |
    | `description` | `text` | Nullable |
    | `creator_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE CASCADE` |
    | `is_teacher_quiz` | `bool` | Nullable, Default: `false` |
    | `scope` | `text` | Default: `'all'` CHECK in `'all'`, `'university'`, `'private'` |
    | `university_id` | `uuid` | Nullable, References `public.universities(id)` |
    | `difficulty` | `text` | Nullable |
    | `required_inputs` | `jsonb` | Nullable |
    | `password_hash` | `text` | Nullable |
    | `questions` | `jsonb` | Not Null (Array of question objects) |
    | `start_time` | `timestamptz` | Not Null |
    | `end_time` | `timestamptz` | Not Null |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |
    | `per_question_time_limit` | `int4` | Nullable |
    | `time_limit` | `int4` | Nullable |

### 23. `quiz_attempts`
*   **What it performs & Why it is needed:** Tracks user exam responses, grades, timer timestamps, and integrity warnings.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `quiz_id` | `uuid` | References `public.quizzes(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `answers` | `jsonb` | Not Null (User responses map) |
    | `student_details` | `jsonb` | Nullable |
    | `score` | `int4` | Not Null, Default: `0` |
    | `warnings_count` | `int4` | Nullable, Default: `0` |
    | `is_disqualified` | `bool` | Nullable, Default: `false` |
    | `started_at` | `timestamptz` | Nullable, Default: `now()` |
    | `completed_at` | `timestamptz` | Nullable |

---

## Domain G: Live Calling

### 24. `active_calls`
*   **What it performs & Why it is needed:** Maintains dynamic state about running WebRTC call sessions on the campus network.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `room_name` | `text` | Unique, Not Null |
    | `group_id` | `uuid` | Nullable, References `public.groups(id) ON DELETE CASCADE` |
    | `creator_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `call_type` | `text` | Default: `'audio'` |
    | `created_at` | `timestamptz` | Default: `now()` |
    | `ended_at` | `timestamptz` | Nullable |

---

## Domain H: Spill the Tea (Anonymous Feed)

### 25. `tea_posts`
*   **What it performs & Why it is needed:** Holds posts written on the anonymous university gossip board.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `author_id` | `uuid` | Nullable, References `public.profiles(id) ON DELETE SET NULL` |
    | `content` | `text` | Not Null |
    | `media_url` | `text` | Nullable |
    | `is_anonymous` | `bool` | Default: `true` |
    | `created_at` | `timestamptz` | Default: `now()` |
    | `updated_at` | `timestamptz` | Default: `now()` |

### 26. `tea_aura_votes`
*   **What it performs & Why it is needed:** Logs up/down voting actions on posts (represented as "aura points" in the system).
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `post_id` | `uuid` | References `public.tea_posts(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `vote_type` | `int4` | Not Null (e.g. 1 or -1) |
    | `created_at` | `timestamptz` | Default: `now()` |

### 27. `tea_poll_votes`
*   **What it performs & Why it is needed:** Supports vote tracking on interactive polls embedded in posts.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `post_id` | `uuid` | References `public.tea_posts(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `reaction_type` | `text` | Not Null |
    | `created_at` | `timestamptz` | Default: `now()` |

### 28. `tea_comments`
*   **What it performs & Why it is needed:** Stores replies to posts, supporting nested conversations via parent references.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `post_id` | `uuid` | References `public.tea_posts(id) ON DELETE CASCADE` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `comment_text` | `text` | Not Null |
    | `created_at` | `timestamptz` | Default: `now()` |
    | `is_pinned` | `bool` | Default: `false` |
    | `parent_id` | `uuid` | Nullable, References `public.tea_comments(id) ON DELETE CASCADE` |

### 29. `tea_saved_posts`
*   **What it performs & Why it is needed:** Allows users to bookmark anonymous posts to read later.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `post_id` | `uuid` | References `public.tea_posts(id) ON DELETE CASCADE` |
    | `created_at` | `timestamptz` | Default: `now()` |

### 30. `tea_seen_posts`
*   **What it performs & Why it is needed:** Tracks viewed posts to prevent showing repetitive posts in the feed runner.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `post_id` | `uuid` | References `public.tea_posts(id) ON DELETE CASCADE` |
    | `created_at` | `timestamptz` | Default: `now()` |

---

## Domain I: Feedback

### 31. `feedbacks`
*   **What it performs & Why it is needed:** Records bug reports and suggestions submitted by users to improve platform features.
*   **Schema Details:**
    | Column Name | Data Type | Constraints |
    | :--- | :--- | :--- |
    | `id` | `uuid` | Primary Key, Default: `uuid_generate_v4()` |
    | `user_id` | `uuid` | References `public.profiles(id) ON DELETE CASCADE` |
    | `content` | `text` | Not Null |
    | `created_at` | `timestamptz` | Nullable, Default: `now()` |

---

# SECTION 3: Unified SQL DDL Script

Below is the complete, copy-pasteable PostgreSQL DDL query script. It creates all 31 tables in the exact order of dependency to prevent relational constraint execution errors.

```sql
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==========================================
-- 1. UNIVERSITIES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.universities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  domain TEXT UNIQUE NOT NULL,
  logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 2. PROFILES TABLE (References Auth & Universities)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY, -- Bound to auth.users id
  username TEXT UNIQUE NOT NULL,
  bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160),
  avatar_url TEXT DEFAULT '',
  university_name TEXT DEFAULT 'GLA University',
  course TEXT DEFAULT '',
  dob DATE,
  city TEXT DEFAULT '',
  is_banned BOOLEAN DEFAULT false,
  sethji BOOLEAN DEFAULT false,
  is_onboarded BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  last_seen TIMESTAMPTZ DEFAULT now(),
  full_name TEXT,
  year_of_study TEXT,
  is_email_verified BOOLEAN DEFAULT false,
  university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
  is_testing_user BOOLEAN DEFAULT false,
  session_token TEXT,
  allow_calls TEXT DEFAULT 'everyone',
  is_muted_ringtone BOOLEAN DEFAULT false,
  active_chat_id TEXT,
  default_wallpaper TEXT,
  is_teacher BOOLEAN DEFAULT false,
  teacher_id_card_url TEXT,
  linkedin_url TEXT
);

-- ==========================================
-- 3. UNIVERSITY APPLICATIONS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.university_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  domain TEXT NOT NULL,
  contact_email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 4. TEACHER APPLICATIONS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.teacher_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  id_card_url TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 5. GROUPS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160),
  description TEXT DEFAULT '',
  creator_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  privacy_type TEXT NOT NULL DEFAULT 'public' CHECK (privacy_type IN ('public', 'university_only', 'password_protected')),
  password_hash TEXT,
  is_system_group BOOLEAN DEFAULT false,
  avatar_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
  theme TEXT,
  wallpaper_url TEXT,
  rules TEXT,
  font_theme VARCHAR(50)
);

-- ==========================================
-- 6. GROUP MEMBERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.group_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('member', 'mod', 'coadmin', 'admin')),
  is_group_banned BOOLEAN DEFAULT false,
  joined_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(group_id, user_id)
);

-- ==========================================
-- 7. GROUP BANS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.group_bans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  banned_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 8. GROUP LOGS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.group_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  action_performer_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  target_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  action_type VARCHAR(100) NOT NULL,
  deleted_message_text TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 9. MESSAGES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL CHECK (char_length(message_text) <= 2000),
  is_anonymous BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  media_url TEXT,
  read_at TIMESTAMPTZ,
  CONSTRAINT message_target CHECK (
    (recipient_id IS NOT NULL AND group_id IS NULL) OR
    (recipient_id IS NULL AND group_id IS NOT NULL)
  )
);

-- ==========================================
-- 10. MESSAGE REACTIONS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.message_reactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  emoji TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 11. PINNED MESSAGES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.pinned_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_id UUID UNIQUE NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  pinned_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 12. CHAT CLEARS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.chat_clears (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  friend_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  cleared_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 13. DELETED MESSAGES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.deleted_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 14. USER CHAT SETTINGS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.user_chat_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  chat_type TEXT NOT NULL CHECK (chat_type IN ('dm', 'group')),
  chat_id UUID NOT NULL,
  theme TEXT,
  wallpaper_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 15. FRIENDS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.friends (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id_1 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  user_id_2 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted')),
  created_at TIMESTAMPTZ DEFAULT now(),
  theme TEXT,
  CONSTRAINT no_self_friend CHECK (user_id_1 != user_id_2),
  UNIQUE(user_id_1, user_id_2)
);

-- ==========================================
-- 16. BLOCKS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.blocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  blocker_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  blocked_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT no_self_block CHECK (blocker_id != blocked_id),
  UNIQUE(blocker_id, blocked_id)
);

-- ==========================================
-- 17. FOLLOWS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 18. REPORTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reported_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 19. NOTIFICATIONS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_broadcast BOOLEAN DEFAULT false,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 20. PUSH SUBSCRIPTIONS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.push_subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  subscription JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 21. NOTIFICATION PREFERENCES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.notification_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  context_type TEXT NOT NULL,
  context_id TEXT NOT NULL,
  mute_website BOOLEAN DEFAULT false,
  mute_device BOOLEAN DEFAULT false,
  updated_at TIMESTAMPTZ DEFAULT now(),
  notify_all_messages BOOLEAN DEFAULT true,
  notify_all_messages_website BOOLEAN DEFAULT true
);

-- ==========================================
-- 22. QUIZZES TABLE (JSONB questions array structure)
-- ==========================================
CREATE TABLE IF NOT EXISTS public.quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  creator_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  is_teacher_quiz BOOLEAN DEFAULT false,
  scope TEXT NOT NULL DEFAULT 'all' CHECK (scope IN ('all', 'university', 'private')),
  university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
  difficulty TEXT,
  required_inputs JSONB,
  password_hash TEXT,
  questions JSONB NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  per_question_time_limit INT4,
  time_limit INT4
);

-- ==========================================
-- 23. QUIZ ATTEMPTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  answers JSONB NOT NULL,
  student_details JSONB,
  score INT4 NOT NULL DEFAULT 0,
  warnings_count INT4 DEFAULT 0,
  is_disqualified BOOLEAN DEFAULT false,
  started_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ
);

-- ==========================================
-- 24. ACTIVE CALLS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.active_calls (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  room_name TEXT UNIQUE NOT NULL,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  call_type TEXT DEFAULT 'audio',
  created_at TIMESTAMPTZ DEFAULT now(),
  ended_at TIMESTAMPTZ
);

-- ==========================================
-- 25. TEA POSTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tea_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  media_url TEXT,
  is_anonymous BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 26. TEA AURA VOTES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tea_aura_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  vote_type INT4 NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 27. TEA POLL VOTES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tea_poll_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reaction_type TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 28. TEA COMMENTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tea_comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  comment_text TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  is_pinned BOOLEAN DEFAULT false,
  parent_id UUID REFERENCES public.tea_comments(id) ON DELETE CASCADE
);

-- ==========================================
-- 29. TEA SAVED POSTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tea_saved_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 30. TEA SEEN POSTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.tea_seen_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ==========================================
-- 31. FEEDBACKS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS public.feedbacks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

---

# SECTION 3.5: Line-by-Line Query Explanations

This section explains **every clause** of each `CREATE TABLE` query in the DDL script above. Read this after reviewing the schema tables so you understand exactly what each SQL keyword does and *why* it was written that way.

---

## Preliminary Extensions

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
```

*   **`CREATE EXTENSION IF NOT EXISTS`**: Loads a PostgreSQL plugin into the current database. `IF NOT EXISTS` prevents an error if the extension is already installed.
*   **`"uuid-ossp"`**: Provides the `uuid_generate_v4()` function which generates a random, globally-unique 128-bit UUID (Universally Unique Identifier). Every table's primary key uses this.
*   **`"pgcrypto"`**: Provides cryptographic functions including `crypt()` and `gen_salt()` used to hash passwords (e.g., for group passwords and quiz passwords). Without this, those functions would not be available.

---

## Table 1: `universities`

```sql
CREATE TABLE IF NOT EXISTS public.universities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  domain TEXT UNIQUE NOT NULL,
  logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `CREATE TABLE IF NOT EXISTS` | Creates the table only if it does not already exist. Safe to run multiple times without error. |
| `public.universities` | Creates the table in the `public` schema (PostgreSQL's default schema). Fully qualified naming avoids ambiguity. |
| `id UUID PRIMARY KEY DEFAULT uuid_generate_v4()` | **`id`**: Column name. **`UUID`**: Data type, a 128-bit random identifier. **`PRIMARY KEY`**: Makes this column the unique row identifier — no two rows can have the same `id`, and it cannot be `NULL`. **`DEFAULT uuid_generate_v4()`**: If no `id` is provided during INSERT, PostgreSQL auto-generates a random UUID. |
| `name TEXT UNIQUE NOT NULL` | **`TEXT`**: Variable-length string with no size limit. **`UNIQUE`**: Enforces a constraint that no two universities can share the same name. **`NOT NULL`**: This field is mandatory — you cannot insert a university without a name. |
| `domain TEXT UNIQUE NOT NULL` | Same rules as `name`. Ensures each university maps to one email domain (e.g., `gla.ac.in`), used to validate student email addresses. |
| `logo_url TEXT` | Nullable (no `NOT NULL` = optional). Stores a URL string to the university's logo image. No size constraint because URLs can vary in length. |
| `created_at TIMESTAMPTZ DEFAULT now()` | **`TIMESTAMPTZ`**: Timestamp with timezone (stored in UTC internally). **`DEFAULT now()`**: Automatically records the exact moment the row is created. No manual insert needed. |

---

## Table 2: `profiles`

```sql
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160),
  ...
  university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
  ...
);
```

| Clause | Explanation |
| :--- | :--- |
| `id UUID PRIMARY KEY` | No `DEFAULT` here — the `id` is manually provided. It must exactly match the UUID from `auth.users(id)` (Supabase's authentication table), binding the profile to the authenticated user. |
| `username TEXT UNIQUE NOT NULL` | Every user must have a unique handle. The `UNIQUE` constraint creates a B-Tree index automatically, making `WHERE username = 'arpit'` queries fast. |
| `bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160)` | **`DEFAULT ''`**: New profiles start with an empty bio. **`CHECK (...)`**: A constraint that runs on every INSERT/UPDATE. `char_length(bio) <= 160` rejects bios longer than 160 characters — this validation happens at the database level, not just in the API. |
| `is_banned BOOLEAN DEFAULT false` | **`BOOLEAN`**: Stores `true` or `false`. **`DEFAULT false`**: All new users start as non-banned. This column is checked by the RLS policy to hide banned users. |
| `sethji BOOLEAN DEFAULT false` | Internal super-admin role flag. When `true`, the user can access admin-only policies (e.g., view all feedbacks). Named playfully per the codebase convention. |
| `is_onboarded BOOLEAN DEFAULT false` | Tracks whether the user has completed the profile setup wizard. The client reads this to redirect users to onboarding. |
| `last_seen TIMESTAMPTZ DEFAULT now()` | Updated via API calls to track online status. `TIMESTAMPTZ` stores timezone-aware timestamps, ensuring the value is correct for users across different regions. |
| `university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL` | **`REFERENCES public.universities(id)`**: Creates a **Foreign Key** — `university_id` in `profiles` must match a valid `id` in the `universities` table. **`ON DELETE SET NULL`**: If a university row is deleted, the `university_id` in all related profiles is set to `NULL` instead of deleting those profile rows. This prevents orphaned FK violations while preserving user records. |
| `allow_calls TEXT DEFAULT 'everyone'` | A soft enum stored as text. Possible values are `'everyone'`, `'friends'`, or `'nobody'`. The API enforces valid values since there's no CHECK constraint. |
| `session_token TEXT` | A unique token stamped on login, used to detect multi-device conflicts (single-session enforcement). |

---

## Table 3: `university_applications`

```sql
CREATE TABLE IF NOT EXISTS public.university_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  domain TEXT NOT NULL,
  contact_email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `status TEXT NOT NULL DEFAULT 'pending'` | Every new application starts with status `'pending'`. An admin dashboard later updates it to `'approved'` or `'rejected'`. `NOT NULL` ensures no row can exist with a missing status. Note: There is no `CHECK` constraint here — status values are validated at the application layer, allowing future statuses to be added without a schema migration. |
| All `NOT NULL` columns | `name`, `domain`, and `contact_email` are all mandatory. A university application is meaningless without contact information. |

---

## Table 4: `teacher_applications`

```sql
CREATE TABLE IF NOT EXISTS public.teacher_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  id_card_url TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE` | **`NOT NULL`**: Every application must belong to a real user. **`REFERENCES public.profiles(id)`**: Foreign key. **`ON DELETE CASCADE`**: If the profile is deleted, this application row is automatically deleted too. This is the right choice because a teacher application without an applicant is meaningless data. |
| `id_card_url TEXT NOT NULL` | The uploaded photo proof of teacher identity. Mandatory — no card URL means no application. |
| `updated_at TIMESTAMPTZ DEFAULT now()` | Updated programmatically via API when an admin approves or rejects. Tracks the last admin action timestamp. |

---

## Table 5: `groups`

```sql
CREATE TABLE IF NOT EXISTS public.groups (
  ...
  privacy_type TEXT NOT NULL DEFAULT 'public' CHECK (privacy_type IN ('public', 'university_only', 'password_protected')),
  creator_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  ...
);
```

| Clause | Explanation |
| :--- | :--- |
| `privacy_type TEXT NOT NULL DEFAULT 'public' CHECK (privacy_type IN ('public', 'university_only', 'password_protected'))` | **`CHECK (...IN(...))`**: This is an **enum-style constraint** using a check. The database will reject any INSERT or UPDATE that provides a `privacy_type` value outside the three listed options. This prevents invalid values even if someone sends a raw SQL query. |
| `creator_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL` | **`ON DELETE SET NULL`** is chosen here (not CASCADE) because if a group creator's account is deleted, the group should survive. The group's content and members remain; only the `creator_id` becomes `NULL`. |
| `is_system_group BOOLEAN DEFAULT false` | Flags special groups created by the platform itself (e.g., university-wide announcement channels), not by users. System groups cannot be deleted by regular users. |
| `password_hash TEXT` | Nullable. Only populated when `privacy_type = 'password_protected'`. Stores the bcrypt hash of the group's access password (using `pgcrypto`). Never stores the plain password. |

---

## Table 6: `group_members`

```sql
CREATE TABLE IF NOT EXISTS public.group_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('member', 'mod', 'coadmin', 'admin')),
  is_group_banned BOOLEAN DEFAULT false,
  joined_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(group_id, user_id)
);
```

| Clause | Explanation |
| :--- | :--- |
| `group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE` | **`ON DELETE CASCADE`**: If the group is deleted, ALL membership rows for that group are automatically deleted. A membership without a group is meaningless. |
| `role TEXT NOT NULL DEFAULT 'member' CHECK (role IN (...))` | Enforces the 4-tier permission hierarchy at the database level. Any attempt to insert `role = 'superuser'` would be rejected by the `CHECK` constraint. |
| `is_group_banned BOOLEAN DEFAULT false` | Allows group admins to ban a user without deleting their membership row. RLS policies check this flag to block access. |
| `UNIQUE(group_id, user_id)` | A **composite unique constraint**. Prevents a user from being a member of the same group twice. If you try to insert the same `(group_id, user_id)` pair twice, PostgreSQL raises a unique violation error. This creates a multi-column index automatically. |

---

## Table 7: `group_bans`

```sql
CREATE TABLE IF NOT EXISTS public.group_bans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  banned_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `banned_by UUID REFERENCES public.profiles(id) ON DELETE SET NULL` | **`ON DELETE SET NULL`**: If the admin who issued the ban deletes their account, the ban record is preserved (user stays banned) but the `banned_by` field becomes `NULL`. This maintains the safety restriction while acknowledging the admin no longer exists. |
| No `UNIQUE(group_id, user_id)` | Unlike `group_members`, a user could theoretically be re-banned after an unban. The history of bans is tracked separately. |

---

## Table 8: `group_logs`

```sql
CREATE TABLE IF NOT EXISTS public.group_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  action_performer_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  target_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  action_type VARCHAR(100) NOT NULL,
  deleted_message_text TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `action_type VARCHAR(100) NOT NULL` | **`VARCHAR(100)`**: Variable-length string with a maximum of 100 characters (more constrained than `TEXT`). Used for action labels like `'ban_user'`, `'delete_message'`, `'promote_to_mod'`. |
| `deleted_message_text TEXT` | Nullable. Stores the content of a deleted message for the admin audit log. This preserves evidence even after the original `messages` row is deleted via CASCADE. |
| Both FK references use `ON DELETE SET NULL` | If either the performer or target user deletes their account, the log entry survives for audit purposes — the UUIDs just become `NULL`. |

---

## Table 9: `messages`

```sql
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL CHECK (char_length(message_text) <= 2000),
  is_anonymous BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  media_url TEXT,
  read_at TIMESTAMPTZ,
  CONSTRAINT message_target CHECK (
    (recipient_id IS NOT NULL AND group_id IS NULL) OR
    (recipient_id IS NULL AND group_id IS NOT NULL)
  )
);
```

| Clause | Explanation |
| :--- | :--- |
| `recipient_id UUID` (nullable) + `group_id UUID` (nullable) | Both are nullable because a message is either a DM (has `recipient_id`) or a group message (has `group_id`). Neither can be `NOT NULL` at the column level because only one of them will be populated. |
| `CONSTRAINT message_target CHECK (...)` | This named constraint enforces mutual exclusivity. It says: "either `recipient_id` exists AND `group_id` is NULL, OR `group_id` exists AND `recipient_id` is NULL." A message cannot target both a person and a group simultaneously. A message without either target would also be rejected. `CONSTRAINT message_target` gives the constraint a name so the error message is descriptive. |
| `message_text TEXT NOT NULL CHECK (char_length(message_text) <= 2000)` | The 2000-character limit is enforced at the database — even if the API is bypassed. |
| `read_at TIMESTAMPTZ` | Nullable. Stays `NULL` until the recipient opens the message. When populated, shows the read receipt timestamp. |
| `sender_id ... ON DELETE CASCADE` | If the sender deletes their account, their messages are deleted too. This is a deliberate privacy-first design choice. |

---

## Table 10: `message_reactions`

```sql
CREATE TABLE IF NOT EXISTS public.message_reactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  emoji TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `message_id ... ON DELETE CASCADE` | When a message is deleted, all its reactions are automatically deleted too. Reactions without a message are meaningless orphaned rows. |
| `emoji TEXT NOT NULL` | Stores the emoji character (e.g., `'👍'`) or an emoji code as a string. `TEXT` handles Unicode characters natively in PostgreSQL. |

---

## Table 11: `pinned_messages`

```sql
CREATE TABLE IF NOT EXISTS public.pinned_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_id UUID UNIQUE NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  pinned_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `message_id UUID UNIQUE NOT NULL` | `UNIQUE` here means: one message can only be pinned once. You cannot pin the same message twice in the same group. The `UNIQUE` constraint creates an index which also makes lookup by `message_id` fast. |

---

## Table 12: `chat_clears`

```sql
CREATE TABLE IF NOT EXISTS public.chat_clears (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  friend_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  cleared_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| Both `friend_id` and `group_id` nullable | Same design as `messages`: a clear targets either a DM (has `friend_id`) or a group chat (has `group_id`). The API validates that exactly one is provided; no database-level mutual exclusivity check is enforced here (unlike `messages`). |
| `cleared_at TIMESTAMPTZ DEFAULT now()` | The client reads this timestamp on load. Any message with `created_at < cleared_at` is hidden from the UI, creating the illusion of a cleared chat without actually deleting messages from the database. |

---

## Table 13: `deleted_messages`

```sql
CREATE TABLE IF NOT EXISTS public.deleted_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| Design Purpose | This is a **tombstone table**. Rather than actually deleting the message (which would affect all recipients), only a reference is stored. The client queries this table and hides messages whose IDs appear here for that specific `user_id`. Other users still see the message. |
| Both FKs use `ON DELETE CASCADE` | If the user account or the original message is deleted, the tombstone record is automatically cleaned up too. |

---

## Table 14: `user_chat_settings`

```sql
CREATE TABLE IF NOT EXISTS public.user_chat_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  chat_type TEXT NOT NULL CHECK (chat_type IN ('dm', 'group')),
  chat_id UUID NOT NULL,
  theme TEXT,
  wallpaper_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `chat_type TEXT NOT NULL CHECK (chat_type IN ('dm', 'group'))` | A two-value enum at the database level. Ensures the settings row is always associated with a known chat type. |
| `chat_id UUID NOT NULL` | Note there is **no FOREIGN KEY** on `chat_id`. This is intentional — `chat_id` could reference either a `friends.id` (for DMs) or a `groups.id` (for groups). PostgreSQL does not support polymorphic foreign keys, so validation is done in the application layer instead. |

---

## Table 15: `friends`

```sql
CREATE TABLE IF NOT EXISTS public.friends (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id_1 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  user_id_2 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted')),
  created_at TIMESTAMPTZ DEFAULT now(),
  theme TEXT,
  CONSTRAINT no_self_friend CHECK (user_id_1 != user_id_2),
  UNIQUE(user_id_1, user_id_2)
);
```

| Clause | Explanation |
| :--- | :--- |
| `user_id_1` and `user_id_2` both reference `profiles` | Two FK columns pointing to the same table. `user_id_1` is the request sender; `user_id_2` is the recipient. |
| `status TEXT NOT NULL DEFAULT 'pending' CHECK (...)` | Starts as `'pending'` (request sent, not yet accepted). Changes to `'accepted'` when `user_id_2` approves. The RLS policy on `UPDATE` ensures only `user_id_2` can perform this change. |
| `CONSTRAINT no_self_friend CHECK (user_id_1 != user_id_2)` | Named constraint: prevents a user from sending a friend request to themselves. The name `no_self_friend` appears in the database error message when violated. |
| `UNIQUE(user_id_1, user_id_2)` | Prevents duplicate connections. However, note that this does NOT prevent `(A, B)` and `(B, A)` — the application must normalize friend pairs before insertion (always storing `min(A,B)` as `user_id_1`). |

---

## Table 16: `blocks`

```sql
CREATE TABLE IF NOT EXISTS public.blocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  blocker_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  blocked_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT no_self_block CHECK (blocker_id != blocked_id),
  UNIQUE(blocker_id, blocked_id)
);
```

| Clause | Explanation |
| :--- | :--- |
| `CONSTRAINT no_self_block CHECK (blocker_id != blocked_id)` | Prevents blocking yourself. A self-block would be logically inconsistent. |
| `UNIQUE(blocker_id, blocked_id)` | User A can only block User B once. Prevents duplicate block entries. |

---

## Table 17: `follows`

```sql
CREATE TABLE IF NOT EXISTS public.follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| Simple design | No status column (unlike `friends`) — follows are immediate and unidirectional. If User A follows User B, that's it; no approval needed. |
| Both `ON DELETE CASCADE` | If either party deletes their account, the follow relationship is removed. |

---

## Table 18: `reports`

```sql
CREATE TABLE IF NOT EXISTS public.reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reported_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `reason TEXT NOT NULL` | The reporter must provide a reason. This is a required field to prevent spam or empty reports. |
| `status CHECK (status IN ('pending', 'approved', 'rejected'))` | Three-state workflow. Admins can `'approve'` (take action) or `'reject'` (dismiss). Default is `'pending'` for incoming reports awaiting review. |

---

## Table 19: `notifications`

```sql
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_broadcast BOOLEAN DEFAULT false,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `recipient_id UUID` (nullable) | When `recipient_id IS NULL` AND `is_broadcast = true`, this is a **platform-wide broadcast** to all users. When populated, it targets a specific user. |
| `is_read BOOLEAN DEFAULT false` | Tracks whether the user has seen the notification. Updated via API call when the user clicks on it. Default `false` = unread. |
| `is_broadcast BOOLEAN DEFAULT false` | Flag for campus-wide announcements. The client checks this: if `is_broadcast = true`, the notification is shown to all users regardless of `recipient_id`. |

---

## Table 20: `push_subscriptions`

```sql
CREATE TABLE IF NOT EXISTS public.push_subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  subscription JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| `subscription JSONB NOT NULL` | **`JSONB`**: Binary JSON storage. PostgreSQL stores this as parsed binary rather than raw text, making field queries faster (e.g., `subscription->>'endpoint'`). The Web Push API returns a JSON object with `endpoint`, `p256dh`, and `auth` keys — all stored in this single column. |

---

## Table 21: `notification_preferences`

```sql
CREATE TABLE IF NOT EXISTS public.notification_preferences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  context_type TEXT NOT NULL,
  context_id TEXT NOT NULL,
  mute_website BOOLEAN DEFAULT false,
  mute_device BOOLEAN DEFAULT false,
  updated_at TIMESTAMPTZ DEFAULT now(),
  notify_all_messages BOOLEAN DEFAULT true,
  notify_all_messages_website BOOLEAN DEFAULT true
);
```

| Clause | Explanation |
| :--- | :--- |
| `context_type TEXT NOT NULL` | A string like `'group'` or `'dm'` — identifies what kind of chat context this preference applies to. Stored as text (not FK) for the same polymorphic reason as `user_chat_settings.chat_id`. |
| `context_id TEXT NOT NULL` | The UUID of the group or DM, stored as text (not typed UUID) to match the polymorphic approach. |
| `mute_website` vs `mute_device` | Two separate mute flags: `mute_website` controls in-app sound/badge, while `mute_device` controls push notification delivery to the device. Users can mute one without the other. |

---

## Table 22: `quizzes`

```sql
CREATE TABLE IF NOT EXISTS public.quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ...
  scope TEXT NOT NULL DEFAULT 'all' CHECK (scope IN ('all', 'university', 'private')),
  questions JSONB NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  per_question_time_limit INT4,
  time_limit INT4
);
```

| Clause | Explanation |
| :--- | :--- |
| `questions JSONB NOT NULL` | **Intentional denormalization**. Stores all questions as a JSON array: `[{"question": "...", "options": ["A","B","C","D"], "correct": 2}]`. No separate `questions` table is needed. `NOT NULL` ensures you cannot create a quiz without questions. |
| `scope TEXT NOT NULL DEFAULT 'all' CHECK (scope IN (...))` | Controls quiz discovery. `'all'` = visible to all users. `'university'` = only visible to students of the creator's university. `'private'` = password protected. |
| `start_time TIMESTAMPTZ NOT NULL` / `end_time TIMESTAMPTZ NOT NULL` | Both are mandatory. The API rejects quiz access before `start_time` and after `end_time`. `NOT NULL` prevents quizzes with undefined time windows from being created. |
| `per_question_time_limit INT4` | **`INT4`**: 4-byte integer (supports values up to ~2.1 billion). Nullable — if provided, each question has its own countdown timer in seconds. |
| `time_limit INT4` | Nullable — overall quiz duration in minutes. Separate from per-question limits. If both are set, the front-end enforces whichever expires first. |

---

## Table 23: `quiz_attempts`

```sql
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  answers JSONB NOT NULL,
  student_details JSONB,
  score INT4 NOT NULL DEFAULT 0,
  warnings_count INT4 DEFAULT 0,
  is_disqualified BOOLEAN DEFAULT false,
  started_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ
);
```

| Clause | Explanation |
| :--- | :--- |
| `answers JSONB NOT NULL` | Stores the user's answer map: `{"q0": 2, "q1": 0, "q3": 1}` (question index → selected option index). Flexible enough to handle different question counts per quiz without schema changes. |
| `student_details JSONB` | Nullable. For quizzes requiring identity verification (`required_inputs` on quizzes table), stores user-provided details like roll number, section, etc. |
| `score INT4 NOT NULL DEFAULT 0` | `DEFAULT 0` ensures a score exists even for incomplete attempts. Grading logic updates this after submission. |
| `warnings_count INT4 DEFAULT 0` | Incremented every time the anti-cheat system detects a tab switch or window blur event. The proctor system uses `SELECT FOR UPDATE` to lock this row while incrementing. |
| `is_disqualified BOOLEAN DEFAULT false` | Set to `true` when warnings exceed the allowed threshold. Disqualified students' scores are excluded from leaderboards. |
| `completed_at TIMESTAMPTZ` | Nullable. Remains `NULL` for in-progress attempts. Set when the student submits. If `NULL` after `end_time`, the attempt is treated as abandoned. |

---

## Table 24: `active_calls`

```sql
CREATE TABLE IF NOT EXISTS public.active_calls (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  room_name TEXT UNIQUE NOT NULL,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  call_type TEXT DEFAULT 'audio',
  created_at TIMESTAMPTZ DEFAULT now(),
  ended_at TIMESTAMPTZ
);
```

| Clause | Explanation |
| :--- | :--- |
| `room_name TEXT UNIQUE NOT NULL` | WebRTC requires a unique room identifier to route participants. `UNIQUE` prevents two simultaneous active calls with the same room name. |
| `group_id` nullable | A call can be group-scoped (has `group_id`) or a standalone DM call (group_id is `NULL`). |
| `ended_at TIMESTAMPTZ` | Nullable. `NULL` = call is currently active. When the creator ends the call, this is populated. The client polls for this to detect call termination. |

---

## Tables 25–30: `tea_posts` Domain

These tables all follow the same FK + CASCADE pattern. Key explanations:

| Table | Key Design Decision |
| :--- | :--- |
| `tea_posts` | `author_id REFERENCES profiles(id) ON DELETE SET NULL` — not CASCADE. If a user deletes their account, their anonymous posts survive (with `author_id = NULL`), preserving campus discussion history. |
| `tea_aura_votes` | `vote_type INT4 NOT NULL` — stores `1` (upvote) or `-1` (downvote) as an integer, making SUM aggregation trivial: `SELECT SUM(vote_type) FROM tea_aura_votes WHERE post_id = ?`. |
| `tea_poll_votes` | `reaction_type TEXT NOT NULL` — stores the poll option string. Flexible for custom poll options without schema changes. |
| `tea_comments` | `parent_id UUID REFERENCES public.tea_comments(id) ON DELETE CASCADE` — **self-referential FK**. A comment can reference another comment in the same table, enabling nested reply threads. If a parent comment is deleted, all its child replies are cascade-deleted. |
| `tea_saved_posts` | Bookmark table. Simple join table — just `user_id` + `post_id` + timestamp. No extra data needed. |
| `tea_seen_posts` | Feed deduplication table. Queried to exclude already-seen posts from the next page of the infinite scroll feed. |

---

## Table 31: `feedbacks`

```sql
CREATE TABLE IF NOT EXISTS public.feedbacks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

| Clause | Explanation |
| :--- | :--- |
| Simplest table in the schema | Just three meaningful columns: who submitted it (`user_id`), what they wrote (`content`), and when (`created_at`). No status column — admins read directly from the database dashboard. |
| `ON DELETE CASCADE` | If a user deletes their account, their feedback is removed to honor privacy requests. |

---



This section details how Row Level Security secures client-to-database requests for all critical tables.

## 1. `messages` RLS Policies
*   **What it does & Why it is needed:** Controls message access. It isolates private direct messages from other users and prevents non-group members from reading or sending updates within closed rooms.
*   **How it works:**
    *   *Select:* When selecting a message, Postgres evaluates if it is a group message where the user belongs to `group_members`, or if it is a DM where the user's ID matches either `sender_id` or `recipient_id`.
    *   *Insert:* Verifies that `sender_id = auth.uid()` AND the user is a non-banned member of the target group.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Members can view messages in their groups/DMs" 
      ON public.messages FOR SELECT TO authenticated USING (
        (group_id IS NOT NULL AND EXISTS (
          SELECT 1 FROM public.group_members 
          WHERE group_id = messages.group_id 
          AND user_id = auth.uid() 
          AND is_group_banned = false
        ))
        OR (recipient_id = auth.uid() OR sender_id = auth.uid())
      );

    CREATE POLICY "Members can insert messages in active groups/DMs" 
      ON public.messages FOR INSERT TO authenticated WITH CHECK (
        sender_id = auth.uid() AND (
          (group_id IS NOT NULL AND EXISTS (
            SELECT 1 FROM public.group_members 
            WHERE group_id = messages.group_id 
            AND user_id = auth.uid() 
            AND is_group_banned = false
          ))
          OR recipient_id IS NOT NULL
        )
      );
    ```

## 2. `profiles` RLS Policies
*   **What it does & Why it is needed:** Public profiles must be readable, but banned accounts should be invisible. Users must also be blocked from editing other students' data.
*   **How it works:**
    *   *Select:* Returns profile row if `is_banned = false` OR if the requesting client is the owner of the profile (`id = auth.uid()`).
    *   *Update:* Matches `auth.uid() = id`.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Anyone can view non-banned profiles" 
      ON public.profiles FOR SELECT USING (is_banned = false OR id = auth.uid());

    CREATE POLICY "Users can update own profile" 
      ON public.profiles FOR UPDATE TO authenticated USING (id = auth.uid());

    CREATE POLICY "Users can insert own profile" 
      ON public.profiles FOR INSERT WITH CHECK (id = auth.uid());
    ```

## 3. `groups` RLS Policies
*   **What it does & Why it is needed:** Anyone can browse public channels, but only admins/moderators can edit settings.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Anyone can view public groups" 
      ON public.groups FOR SELECT USING (true);

    CREATE POLICY "Authenticated users can create groups" 
      ON public.groups FOR INSERT TO authenticated WITH CHECK (creator_id = auth.uid());

    CREATE POLICY "Group admins can update groups" 
      ON public.groups FOR UPDATE TO authenticated USING (
        creator_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.group_members
          WHERE group_id = groups.id 
          AND user_id = auth.uid() 
          AND role IN ('admin', 'coadmin', 'mod')
        )
      );
    ```

## 4. `group_members` RLS Policies
*   **What it does & Why it is needed:** Students can search for memberships to view who is in a class, and can join public rooms, but cannot add other users against their will.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Members can view group memberships" 
      ON public.group_members FOR SELECT TO authenticated USING (true);

    CREATE POLICY "Authenticated can join groups" 
      ON public.group_members FOR INSERT TO authenticated WITH CHECK (
        user_id = auth.uid() AND EXISTS (
          SELECT 1 FROM public.groups g 
          WHERE g.id = group_members.group_id 
          AND (g.privacy_type = 'public' OR (g.privacy_type = 'university_only' AND g.university_id = (
            SELECT university_id FROM public.profiles WHERE id = auth.uid()
          )))
        )
      );
    ```

## 5. `friends` RLS Policies
*   **What it does & Why it is needed:** Secures the social graph. Students must not be able to accept their own outgoing friend requests or view private chats unless they are friends.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.friends ENABLE ROW LEVEL SECURITY;

    CREATE POLICY "Users can view their friendships" 
      ON public.friends FOR SELECT TO authenticated USING (
        status = 'accepted' OR user_id_1 = auth.uid() OR user_id_2 = auth.uid()
      );

    CREATE POLICY "Users can send friend requests" 
      ON public.friends FOR INSERT TO authenticated WITH CHECK (user_id_1 = auth.uid());

    CREATE POLICY "Only recipients can accept friend requests" 
      ON public.friends FOR UPDATE TO authenticated USING (user_id_2 = auth.uid()) WITH CHECK (status = 'accepted');

    CREATE POLICY "Users can remove friendships" 
      ON public.friends FOR DELETE TO authenticated USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid());
    ```

## 6. `quizzes` & `quiz_attempts` RLS Policies
*   **What it does & Why it is needed:** Protects grading integrity. Students can view available quizzes and start attempts, but cannot view other students' answers. Creators (teachers) can view all attempts for grading.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
    ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;

    -- Quizzes
    CREATE POLICY "Discovery view for quizzes" 
      ON public.quizzes FOR SELECT TO authenticated USING (
        creator_id = auth.uid() OR scope = 'all' OR scope = 'university'
      );

    CREATE POLICY "Authenticated users can create quizzes" 
      ON public.quizzes FOR INSERT TO authenticated WITH CHECK (creator_id = auth.uid());

    -- Quiz Attempts
    CREATE POLICY "Authenticated users can log attempts" 
      ON public.quiz_attempts FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());

    CREATE POLICY "Users can view own attempts or creators can view quiz attempts" 
      ON public.quiz_attempts FOR SELECT TO authenticated USING (
        user_id = auth.uid() OR EXISTS (
          SELECT 1 FROM public.quizzes 
          WHERE quizzes.id = quiz_attempts.quiz_id 
          AND (quizzes.creator_id = auth.uid() OR quizzes.end_time < now())
        )
      );
    ```

## 7. `tea_posts` & `tea_comments` RLS Policies
*   **What it does & Why it is needed:** Ensures posts can be read by any logged-in student anonymously, while restrictively validating delete/insert events.
*   **SQL Definitions:**
    ```sql
    ALTER TABLE public.tea_posts ENABLE ROW LEVEL SECURITY;
    ALTER TABLE public.tea_comments ENABLE ROW LEVEL SECURITY;

    -- Posts
    CREATE POLICY "Public tea_posts read" 
      ON public.tea_posts FOR SELECT USING (true);

    CREATE POLICY "Auth tea_posts insert" 
      ON public.tea_posts FOR INSERT WITH CHECK (
        auth.role() = 'authenticated' AND author_id = auth.uid()
      );

    CREATE POLICY "Auth tea_posts delete" 
      ON public.tea_posts FOR DELETE USING (author_id = auth.uid());

    -- Comments
    CREATE POLICY "Public tea_comments read" 
      ON public.tea_comments FOR SELECT USING (true);

    CREATE POLICY "Auth tea_comments insert" 
      ON public.tea_comments FOR INSERT WITH CHECK (user_id = auth.uid());
    ```

---

# SECTION 5: Unified RLS Creation Script

This script enables RLS and configures security policies across all active tables in a single transaction.

```sql
-- Enable Row Level Security on all tables
ALTER TABLE public.universities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.university_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_bans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.group_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.message_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pinned_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_clears ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.deleted_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_chat_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.friends ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.active_calls ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_aura_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_poll_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_saved_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_seen_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feedbacks ENABLE ROW LEVEL SECURITY;

-- Apply basic Read access to all authenticated users for lookup directories
CREATE POLICY "Allow public read access to universities" ON public.universities FOR SELECT USING (true);
CREATE POLICY "Allow public read access to applications" ON public.university_applications FOR SELECT USING (true);
CREATE POLICY "Allow anyone to apply for university" ON public.university_applications FOR INSERT WITH CHECK (true);

-- Feedbacks RLS Policies
CREATE POLICY "Users can insert own feedback" ON public.feedbacks FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
CREATE POLICY "Users can view own feedback" ON public.feedbacks FOR SELECT TO authenticated USING (user_id = auth.uid());
CREATE POLICY "Admins can view all feedback" ON public.feedbacks FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND sethji = true)
);

-- Active Calls RLS Policies
CREATE POLICY "Anyone authenticated can view active calls" ON public.active_calls FOR SELECT TO authenticated USING (true);
CREATE POLICY "Anyone authenticated can insert active calls" ON public.active_calls FOR INSERT TO authenticated WITH CHECK (creator_id = auth.uid());
CREATE POLICY "Allow delete/update for creator or group staff" ON public.active_calls FOR ALL TO authenticated USING (
  creator_id = auth.uid() 
  OR EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND sethji = true)
  OR (group_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM public.group_members 
    WHERE group_id = active_calls.group_id 
    AND user_id = auth.uid() 
    AND role IN ('admin', 'coadmin', 'mod')
  ))
);

-- Blocks RLS Policies
CREATE POLICY "Users can view their blocks" ON public.blocks FOR SELECT TO authenticated USING (blocker_id = auth.uid() OR blocked_id = auth.uid());
CREATE POLICY "Users can block others" ON public.blocks FOR INSERT TO authenticated WITH CHECK (blocker_id = auth.uid());
CREATE POLICY "Users can unblock" ON public.blocks FOR DELETE TO authenticated USING (blocker_id = auth.uid());

-- Follows RLS Policies
CREATE POLICY "Public follows read" ON public.follows FOR SELECT USING (true);
CREATE POLICY "Auth follows insert" ON public.follows FOR INSERT WITH CHECK (auth.uid() = follower_id);
CREATE POLICY "Auth follows delete" ON public.follows FOR DELETE USING (auth.uid() = follower_id);

-- Tea Post Helper votes
CREATE POLICY "Public tea_aura_votes read" ON public.tea_aura_votes FOR SELECT USING (true);
CREATE POLICY "Auth tea_aura_votes write" ON public.tea_aura_votes FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Public tea_poll_votes read" ON public.tea_poll_votes FOR SELECT USING (true);
CREATE POLICY "Auth tea_poll_votes write" ON public.tea_poll_votes FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Tea Saved/Seen
CREATE POLICY "Public tea_saved_posts read" ON public.tea_saved_posts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Auth tea_saved_posts write" ON public.tea_saved_posts FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Public tea_seen_posts read" ON public.tea_seen_posts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Auth tea_seen_posts write" ON public.tea_seen_posts FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
```
