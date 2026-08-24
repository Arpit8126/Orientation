# 📚 Pookiz Learning Guide — Master Index

This is the complete index of all learning documents for the Pookiz project. Use this as your starting point to navigate any topic.

---

## 🗂️ Folder Structure

```
learning/
├── 📄 README.md                         ← You are here (Master Index)
├── 📄 schema.txt                        ← Raw database schema (SQL dump)
│
├── 00_must_know_first/                  ← PREREQUISITES: HTML, CSS, JS, SQL, Git, React, Next.js, TS, Tailwind, Supabase, Backend, Frontend
├── backend/                             ← Server-side: APIs, auth, integrations, protocols
├── frontend/                            ← Client-side: UI, components, animations, SEO
├── database/                            ← PostgreSQL: schemas, RLS, indexes, system design
└── project_explanation_and_qa/          ← Interview prep, elevator pitch, Q&A, behavioral
```

---

## 🚨 00. Must Know First (Prerequisites)

These files cover the complete basic-to-advanced knowledge of core web languages, tools, frameworks, and APIs needed in the real world and before learning Pookiz.

| # | File | What It Covers |
|---|---|---|
| 01 | [01_html_complete.md](00_must_know_first/01_html_complete.md) | Complete HTML: elements, structure, inputs, semantic tags, forms, media, ARIA/accessibility, meta tags |
| 02 | [02_css_complete.md](00_must_know_first/02_css_complete.md) | Complete CSS: selectors, specificity, Box Model, Display, Position, Flexbox, Grid, animations, variables, media queries |
| 03 | [03_tailwindcss_complete.md](00_must_know_first/03_tailwindcss_complete.md) | Complete Tailwind CSS v4: utility classes, layouts, spacing, colors, sizing, flex/grid, responsive breakpoints, states, configuration |
| 04 | [04_javascript_complete.md](00_must_know_first/04_javascript_complete.md) | Complete JS: variables, data types, type coercion, operators, array/object methods, closures, `this`, Promises, DOM, events, event loop |
| 05 | [05_typescript_complete.md](00_must_know_first/05_typescript_complete.md) | Complete TypeScript: primitive types, interfaces vs types, optional/default parameters, union/intersection, generics, utility types, configs |
| 06 | [06_react_complete.md](00_must_know_first/06_react_complete.md) | Complete React: Components, JSX, props, state, keys, events, useRef, custom hooks, Context API, memoization, portals, error boundaries |
| 07 | [07_nextjs_complete.md](00_must_know_first/07_nextjs_complete.md) | Complete Next.js App Router: Routing, layouts, Server/Client components, data fetching/caching, Server Actions, API routes, middleware |
| 08 | [08_frontend_concepts_complete.md](00_must_know_first/08_frontend_concepts_complete.md) | Foundational Frontend: rendering engines, Reflow vs Repaint, packages & bundlers, local/global/server state, loading hints (preload/prefetch), Web Vitals, SEO, testing |
| 09 | [09_backend_concepts_complete.md](00_must_know_first/09_backend_concepts_complete.md) | Foundational Backend: Client-Server model, HTTP method structures, status codes, REST vs Graph/WS, Stateful/Stateless Auth, JWT, BCrypt, SQLi, Serverless |
| 10 | [10_database_and_sql_complete.md](00_must_know_first/10_database_and_sql_complete.md) | Database basics (RDBMS, keys, relations, ACID, normalization) and SQL (DDL, DML, joins, aggregates, CTEs, window functions, indexes) |
| 11 | [11_supabase_basics_complete.md](00_must_know_first/11_supabase_basics_complete.md) | Complete Supabase: Core services, SDK config, CRUD operations, Authentication methods, Storage uploads, Row Level Security (RLS) |
| 12 | [12_git_and_terminal_complete.md](00_must_know_first/12_git_and_terminal_complete.md) | Terminal navigation & commands, Git fundamentals (commit, push, checkout, stash, merge conflicts, rebase, cherry-pick, reflog) |

---

## 🔙 Backend Chapters

| # | File | What It Covers |
|---|---|---|
| 01 | [01_foundations_network_handshakes_http_lifecycle.md](backend/01_foundations_network_handshakes_http_lifecycle.md) | HTTP, TCP handshakes, request/response lifecycle |
| 02 | [02_foundations_websockets_webrtc_protocols.md](backend/02_foundations_websockets_webrtc_protocols.md) | WebSocket protocol, WebRTC basics |
| 03 | [03_nextjs_api_architecture_execution_context.md](backend/03_nextjs_api_architecture_execution_context.md) | middleware.ts, Next.js API routes, serverless |
| 04 | [04_error_handling_patterns_api_resilience.md](backend/04_error_handling_patterns_api_resilience.md) | Error handling, Zod validation, HTTP status codes, retry logic |
| 05 | [05_auth_service_credentials_oauth_flow.md](backend/05_auth_service_credentials_oauth_flow.md) | Google OAuth, PKCE, JWT, session cookies |
| 06 | [06_email_verification_loop_under_the_hood.md](backend/06_email_verification_loop_under_the_hood.md) | Email OTP flow, verification loop |
| 07 | [07_testing_unit_integration_mocking.md](backend/07_testing_unit_integration_mocking.md) | Jest, unit tests, integration tests, mocking |
| 08 | [08_webrtc_voice_video_calling_sfu_servers.md](backend/08_webrtc_voice_video_calling_sfu_servers.md) | LiveKit SFU, voice/video calls |
| 09 | [09_chat_api_dms_groups_attachments.md](backend/09_chat_api_dms_groups_attachments.md) | Group join/leave API, system notes |
| 10 | [10_quiz_generation_pipelines_pdf_parsing.md](backend/10_quiz_generation_pipelines_pdf_parsing.md) | AI quiz generation, PDF parsing, Groq rate limits |
| 11 | [11_push_notifications_vapid_service_workers.md](backend/11_push_notifications_vapid_service_workers.md) | Web Push, VAPID keys, Service Worker |
| 12 | [12_websocket_realtime_logical_decoding_heartbeats.md](backend/12_websocket_realtime_logical_decoding_heartbeats.md) | Supabase Realtime, WAL, WebSocket lifecycle |
| **13** ⭐ | [**13_post_creation_comments_tea_api_complete.md**](backend/13_post_creation_comments_tea_api_complete.md) | **Post creation end-to-end, comments, aura votes** |
| **14** ⭐ | [**14_realtime_messaging_dms_groups_complete.md**](backend/14_realtime_messaging_dms_groups_complete.md) | **Full DM & group chat messaging lifecycle** |
| 15 | [15_cicd_deployment_github_actions_vercel.md](backend/15_cicd_deployment_github_actions_vercel.md) | GitHub Actions pipeline, Vercel deployment, secrets |

---

## 🖥️ Frontend Chapters

| # | File | What It Covers |
|---|---|---|
| 01 | [01_foundations_dom_reflow_repaint.md](frontend/01_foundations_dom_reflow_repaint.md) | Browser rendering, reflow vs repaint |
| 02 | [02_foundations_react_fiber_reconciliation.md](frontend/02_foundations_react_fiber_reconciliation.md) | React Fiber, virtual DOM, reconciliation |
| 03 | [03_nextjs_app_router_layouts_rendering_modes.md](frontend/03_nextjs_app_router_layouts_rendering_modes.md) | App Router, SSR vs CSR, layouts |
| 04 | [04_state_synchronization_context_hooks.md](frontend/04_state_synchronization_context_hooks.md) | Context API, state sync, custom hooks |
| 05 | [05_accessibility_aria_keyboard_nav.md](frontend/05_accessibility_aria_keyboard_nav.md) | ARIA, semantic HTML, keyboard navigation |
| 06 | [06_seo_metatags_og_sitemap.md](frontend/06_seo_metatags_og_sitemap.md) | SEO, Open Graph, sitemap, robots.txt, Next.js metadata |
| 07 | [07_caching_react_query_swr_nextjs_cache.md](frontend/07_caching_react_query_swr_nextjs_cache.md) | SWR, React Query, Next.js cache strategies |
| 08 | [08_realtime_presence_indicators_state.md](frontend/08_realtime_presence_indicators_state.md) | Online/offline indicators, usePresence hook |
| 09 | [09_chat_ui_scrolling_auto_expand_textareas.md](frontend/09_chat_ui_scrolling_auto_expand_textareas.md) | Chat scroll management, auto-growing inputs |
| 10 | [10_drag_and_drop_overlay_state_desktop.md](frontend/10_drag_and_drop_overlay_state_desktop.md) | Drag & drop file sharing to chat |
| 11 | [11_spill_the_tea_animations_reaction_bars.md](frontend/11_spill_the_tea_animations_reaction_bars.md) | Comment drawer, optimistic poll UI |
| 12 | [12_quiz_wizard_forms_cheat_prevention_windows.md](frontend/12_quiz_wizard_forms_cheat_prevention_windows.md) | Anti-cheat proctoring engine |
| 13 | [13_optimized_media_rendering_lightboxes_flicker_fixes.md](frontend/13_optimized_media_rendering_lightboxes_flicker_fixes.md) | Image optimization, lightbox, flicker fixes |
| **14** ⭐ | [**14_folder_structure_special_files_explained.md**](frontend/14_folder_structure_special_files_explained.md) | **Complete project folder map & special files** |
| **15** ⭐ | [**15_quiz_management_ui_player_creation.md**](frontend/15_quiz_management_ui_player_creation.md) | **Quiz player state machine, creation UI, results** |

---

## 🗃️ Database Chapters

| # | File | What It Covers |
|---|---|---|
| **00** 📄 | [**00_complete_schema_reference.md**](database/00_complete_schema_reference.md) | **Complete DB schema — read first as reference** |
| 01 | [01_foundations_postgres_internals.md](database/01_foundations_postgres_internals.md) | PostgreSQL internals, MVCC, WAL |
| 02 | [02_pookiz_schema_profiles_relations.md](database/02_pookiz_schema_profiles_relations.md) | Profiles table, user relations |
| 03 | [03_social_graph_schema_friendships_blocks.md](database/03_social_graph_schema_friendships_blocks.md) | Friends, blocks, social graph |
| 04 | [04_messaging_schema_dms_group_conversations.md](database/04_messaging_schema_dms_group_conversations.md) | DM conversations, group schema overview |
| 05 | [05_spill_the_tea_posts_comments_auras.md](database/05_spill_the_tea_posts_comments_auras.md) | Tea posts, comments, aura votes, analytics |
| 06 | [06_notification_ledger_indexes.md](database/06_notification_ledger_indexes.md) | Notifications table, read status, indexes |
| 07 | [07_quiz_management_attempts_warnings.md](database/07_quiz_management_attempts_warnings.md) | Quiz JSONB schema, attempts, anti-cheat |
| 08 | [08_rls_policies_identity_protection.md](database/08_rls_policies_identity_protection.md) | Row Level Security policies |
| 09 | [09_security_definer_triggers_synchronization.md](database/09_security_definer_triggers_synchronization.md) | SECURITY DEFINER, DB triggers |
| 10 | [10_performance_tuning_indexes_locks.md](database/10_performance_tuning_indexes_locks.md) | Index types, query tuning, locks |
| **11** ⭐ | [**11_messaging_schema_conversations_reactions_rls.md**](database/11_messaging_schema_conversations_reactions_rls.md) | **Full messaging schema, RLS, indexes** |
| **12** | [**12_system_design_rate_limiting_sharding_cdn.md**](database/12_system_design_rate_limiting_sharding_cdn.md) | System design, rate limiting, CDN, horizontal scaling |

---

## 💬 Project Explanation & Interview Q&A

| # | File | What It Covers |
|---|---|---|
| 01 | [01_project_elevator_pitch.md](project_explanation_and_qa/01_project_elevator_pitch.md) | 60-second pitch, feature highlights, interview strategy |
| 02 | [02_behavioral_hr_questions.md](project_explanation_and_qa/02_behavioral_hr_questions.md) | HR/Behavioral questions with full STAR-format answers |
| 03 | [03_technical_interview_qa.md](project_explanation_and_qa/03_technical_interview_qa.md) | 40+ technical Q&As across all topics |

---

## 🗺️ Quick Feature → File Map

| Feature | Key Learning Files |
|---|---|
| **Core HTML, CSS, JS** | 00_must_know_first |
| **React Core & Advanced** | 00_must_know_first / 06_react_complete.md |
| **Next.js App Router** | 00_must_know_first / 07_nextjs_complete.md |
| **TypeScript Syntax** | 00_must_know_first / 05_typescript_complete.md |
| **Tailwind CSS Utility Style**| 00_must_know_first / 03_tailwindcss_complete.md |
| **Foundational Backend** | 00_must_know_first / 09_backend_concepts_complete.md |
| **Foundational Frontend** | 00_must_know_first / 08_frontend_concepts_complete.md |
| **Supabase Core Client** | 00_must_know_first / 11_supabase_basics_complete.md |
| **SQL & Database Basics** | 00_must_know_first / 10_database_and_sql_complete.md |
| **Terminal & Git Operations**| 00_must_know_first / 12_git_and_terminal_complete.md |
| **Middleware & Auth Gate** | Backend 03, Backend 05 |
| **Google OAuth / Login** | Backend 05 |
| **Error Handling** | Backend 04 |
| **Testing** | Backend 07 |
| **CI/CD & Deployment** | Backend 15 |
| **Real-Time Messaging** | Backend 14, Database 11 |
| **Post Creation (Tea)** | Backend 13, Database 05 |
| **Comments & Threading** | Backend 13, Database 05 |
| **Aura Votes & Polls** | Database 05, Frontend 11 |
| **Quiz Management** | Frontend 15, Backend 10, Database 07 |
| **Anti-Cheat Proctoring** | Frontend 12 |
| **AI Quiz Generation** | Backend 10 |
| **Folder Structure** | Frontend 14 |
| **Special Files (sw.js, middleware.ts)** | Frontend 14 |
| **Voice/Video Calls** | Backend 08 |
| **Push Notifications** | Backend 11 |
| **Presence (Online/Offline)** | Frontend 08 |
| **WebSocket Realtime** | Backend 12 |
| **RLS Security** | Database 08 |
| **Performance & Indexes** | Database 10 |
| **Accessibility (a11y)** | Frontend 05 |
| **SEO & Open Graph** | Frontend 06 |
| **Caching (SWR / React Query)** | Frontend 07 |
| **System Design & Scaling** | Database 12 |
| **Behavioral Interview** | project_explanation_and_qa/02 |
| **Technical Interview Q&A (40+ Q)** | project_explanation_and_qa/03 |

---

## 📋 How Each Chapter Is Structured

Every chapter follows the same consistent format:

```
1. Objective & Placement Value   → Why this matters for interviews
2. The Layman's Analogy         → Explain it simply without jargon
3. The Technical Specification  → Deep technical details
4. Line-by-Line Code Walkthrough → Actual code from the project with explanation
5. Edge Cases & Optimizations   → What can go wrong and how to fix it
6. Staff Engineer Viva Board    → 5 interview Q&As with full answers
```

---

## 📚 Recommended Reading Order

### For someone starting from zero (no syntax knowledge):
1. **00_must_know_first/01_html_complete.md** → HTML Core
2. **00_must_know_first/02_css_complete.md** → CSS Layout & Styling
3. **00_must_know_first/03_tailwindcss_complete.md** → Utility-First Styling (Tailwind)
4. **00_must_know_first/04_javascript_complete.md** → JS Logic & Data
5. **00_must_know_first/05_typescript_complete.md** → Strongly Typed JS (TypeScript)
6. **00_must_know_first/06_react_complete.md** → React UI Components
7. **00_must_know_first/07_nextjs_complete.md** → Next.js App Router Framework
8. **00_must_know_first/08_frontend_concepts_complete.md** → Browser engines, Reflow/Repaint, build ecosystems, Web Vitals, SEO
9. **00_must_know_first/09_backend_concepts_complete.md** → Request/Response loops, Status Codes, REST APIs, Session vs Token Auth, API Security
10. **00_must_know_first/10_database_and_sql_complete.md** → Databases & SQL Queries
11. **00_must_know_first/11_supabase_basics_complete.md** → Backend Service Integration (Supabase)
12. **00_must_know_first/12_git_and_terminal_complete.md** → Command Line & Version Control
13. **Database 00** — Complete Schema Reference
14. Then continue in chapter order through the backend, frontend, and database folders.
