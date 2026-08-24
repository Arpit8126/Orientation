# Backend Chapter 09: Chat API — Groups, DMs & Messaging Actions

This module covers the design and execution of Pookiz's messaging API routes, detailing group management, direct messaging validation, system note updates, and multi-tenant security verification.

---

## 1. Objective & Placement Value
- **Why this is asked:** High-performance messaging engines require robust transactional APIs. Interviewers evaluate how you implement group lifecycle events (joins, leaves, kicks), send system messages, prevent unauthorized access to private chats, and enforce boundary constraints.
- **Placement Value:** Prepares you to design enterprise-grade collaboration features and secure API architectures for high-concurrency real-time networks.

---

## 2. The Layman's Analogy
Think of the group leave API as **exiting a student club meeting room**:
- **Authentication Check:** Before you walk out, the club supervisor checks your student ID card (verifies the user session). Guests who are not registered cannot be in the room anyway.
- **System Check:** If the room is a mandatory university lecture (system group), the supervisor blocks you from leaving.
- **The System Note:** Before you walk out, the supervisor writes on the blackboard: *"__SYSTEM_NOTE__: @Student has left the room."* This informs everyone inside that you have departed.
- **The Cleanup:** Finally, the secretary erases your name from the active member register (deletes row from `group_members`).

---

## 3. The Technical Specification

### A. Group Operations API Design
Group conversations inside Pookiz are controlled via specific REST API endpoints. Let's analyze the group leave operation:
1. **User Identity Resolution:** The endpoint fetches the active user session from cookies. If missing, it immediately rejects the request with HTTP `401 Unauthorized`.
2. **Entity Validation:** The API queries the `groups` table to verify the target group exists and checks the `is_system_group` flag. Users are blocked from leaving system groups (which represent automatic university-level spaces).
3. **Transaction Execution:** To ensure consistency, the leave process runs two database writes:
   - **System Notification:** Inserts a message in the `messages` table with a custom header prefix `__SYSTEM_NOTE__` notifying members that the user left.
   - **Membership Purging:** Deletes the user's row from the `group_members` table, terminating their RLS access to the group.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the group leave endpoint: [`d:\Pookiz\pookiz-app\src\app\api\groups\leave\route.ts`](file:///d:/Pookiz/pookiz-app/src/app/api/groups/leave/route.ts)

```typescript
import { createClient } from "@/lib/supabase/server";
import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
```
- **Line 4-7:** Exports the POST handler. Initializes the Supabase client and loads the current authenticated user details.
- **Line 9-11:** If the user session is missing, returns status `401` (Unauthorized) to block the action.

```typescript
    const body = await request.json();
    const { group_id } = body;

    if (!group_id) {
      return NextResponse.json({ error: "Group ID required" }, { status: 400 });
    }

    // Get group info
    const { data: group, error: groupErr } = await supabase
      .from("groups")
      .select("*")
      .eq("id", group_id)
      .single();

    if (groupErr || !group) {
      return NextResponse.json({ error: "Group not found" }, { status: 404 });
    }
```
- **Line 13-18:** Parses the request body as JSON, extracts `group_id`, and verifies it is present, returning status `400` if missing.
- **Line 21-25:** Queries the `groups` table for the matching group record.
- **Line 27-29:** If a database error occurs or the group does not exist, returns status `404` (Not Found).

```typescript
    if (group.is_system_group) {
      return NextResponse.json({ error: "You cannot leave a system group" }, { status: 400 });
    }

    // Fetch profile to get username
    const { data: profile } = await supabase
      .from("profiles")
      .select("username")
      .eq("id", user.id)
      .single();

    const username = profile?.username || "A user";
```
- **Line 31-33:** Checks if `is_system_group` is `true`. If so, returns status `400 Bad Request` to prevent leaving mandatory groups.
- **Line 36-40:** Queries the `profiles` table to retrieve the user's username.
- **Line 42:** Fallback to a default name if the username lookup fails.

```typescript
    // Insert system note message that the user left
    await supabase
      .from("messages")
      .insert({
        group_id,
        sender_id: user.id,
        message_text: `__SYSTEM_NOTE__:@${username} has left the group`,
      });

    // Delete membership
    const { error: leaveErr } = await supabase
      .from("group_members")
      .delete()
      .eq("group_id", group_id)
      .eq("user_id", user.id);

    if (leaveErr) {
      return NextResponse.json({ error: leaveErr.message }, { status: 500 });
    }

    return NextResponse.json({ success: true }, { status: 200 });
  } catch (error: any) { ... }
}
```
- **Line 45-51:** Inserts a system note message into the `messages` table. This triggers a realtime socket broadcast, displaying a notification bubble in active chat windows.
- **Line 54-58:** Deletes the user's row from the `group_members` table.
- **Line 60-64:** If the deletion fails, returns status `500`. If successful, returns status `200` with a success flag.

---

## 5. Edge Cases & Optimizations
- **Orphaned Group Chats:** If the last member of a group leaves, the group record remains in the database as an orphaned entity.
  - *Fix:* Check if the group membership count is 0 after deletion, and delete the group record if it is empty.
- **System Note Security Impersonation:** A user could try to send a fake system note message (e.g., `__SYSTEM_NOTE__:@username has been promoted to Admin`).
  - *Fix:* Enforce server-side checks or add database validation constraints to reject messages prefixed with `__SYSTEM_NOTE__` if they are inserted directly by clients.

---

## 6. Staff Engineer Viva Board

### Q1: What is a System Group in Pookiz, and why do we block users from leaving them on the API layer?
**Answer:**
*"A **System Group** represents a mandatory university-wide or course-wide communication space. 

We block users from leaving them because these groups are used by administrators to broadcast critical academic updates. Allowing users to leave would disrupt campus communications. 

We enforce this check on the server side (`group.is_system_group`) before running the delete transaction, preventing users from bypassing front-end UI locks."*

### Q2: Why do we fetch the username from the `profiles` table to send a system note instead of trusting the user's name provided in the request payload?
**Answer:**
*"Request payloads can be manipulated. If we read the username directly from the request body (e.g., `{ username: "admin" }`), an attacker could send a modified request payload to impersonate other users or administrators in system messages.

By loading the user's profile directly from the database using their verified session ID (`user.id`), we ensure that the system note displays their true username, preventing spoofing attacks."*

### Q3: Explain why the group leave operation is split into two writes, and how you would handle failures in the first write.
**Answer:**
*"The group leave operation performs two writes:
1. Inserting a system message into the `messages` table.
2. Deleting the membership row from `group_members`.

If the system message insert succeeds but the membership deletion fails:
- The user is still in the group, but a system message was sent saying they left.
To prevent this inconsistency, we should wrap these writes inside a single database **transaction**. If either write fails, the entire transaction is rolled back, preserving consistent state."*

### Q4: How does deleting a user from `group_members` revoke their access to that group's messages?
**Answer:**
*"Access is revoked via Row Level Security (RLS) policies on the `messages` table. 

The policy allows users to read a message only if they are a member of the corresponding group:
```sql
USING (EXISTS (
  SELECT 1 FROM group_members 
  WHERE group_id = messages.group_id AND user_id = auth.uid()
))
```
The moment the user's membership row is deleted from `group_members`, the subquery returns `false`. They lose access to the messages instantly, protecting the group's privacy."*

### Q5: What is the risk of using client-side SDKs to perform delete operations directly on the database instead of using secure server API endpoints?
**Answer:**
*"Using client-side SDKs directly to delete rows relies on client-side logic to enforce business rules. 
- An attacker can bypass the client and connect to the database directly using their JWT.
- If RLS policies allow delete operations based only on user ID, the attacker could delete their records directly, bypassing checks (like verifying if the group is a system group).
Routing modifications through server-side API routes allows us to validate business constraints before executing database writes, keeping data secure."*
