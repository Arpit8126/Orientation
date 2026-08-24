# Frontend Chapter 12: Quiz Proctoring & Cheat Prevention Engine

This module covers the client-side implementation of Pookiz's anti-cheat quiz proctoring engine, detailing fullscreen monitoring, tab visibility tracking, and window focus hooks.

---

## 1. Objective & Placement Value
- **Why this is asked:** High-stakes testing platforms require absolute client integrity. Technical interviewers evaluate how you monitor browser states (tab switches, window focus loss, fullscreen status), enforce single-session consistency, and prevent bypass attempts at the DOM layer.
- **Placement Value:** Prepares you to design secure online assessment platforms, handle complex browser event loops, and implement robust proctoring solutions.

---

## 2. The Layman's Analogy
Think of the online proctoring engine as a **digital exam room supervisor**:
- **Entering the Room (Fullscreen Mode):** Before starting the exam, you must enter a private room and lock the door (go fullscreen). If you open the door (exit fullscreen), the supervisor issues a warning.
- **Looking Away (Tab Switching):** If you turn your head away to look at another desk (switch browser tabs), the supervisor registers a warning.
- **Talking to Someone (Focus Loss):** If you turn around to talk to someone entering the room (opening another app window), the supervisor registers a warning.
- **Three Strikes (Disqualification):** If you receive 3 warnings, the supervisor immediately snatches your paper, marks it "disqualified", and submits it as-is.

---

## 3. The Technical Specification

### A. Fullscreen and Page Visibility Monitoring
Pookiz hooks into native browser APIs to monitor user behavior during the quiz:
1. **Fullscreen Tracking (`fullscreenchange`):** Detects if the browser exits fullscreen mode. The application checks `document.fullscreenElement` to verify state.
2. **Page Visibility Tracking (`visibilitychange`):** Detects when the user minimizes the window or switches tabs. The browser fires this event and updates `document.visibilityState` to `'hidden'`.
3. **Window Focus Tracking (`blur` and `focus`):** Detects when the browser window loses focus (e.g., the user opens another application over the browser).

### B. Procurement Warning Debouncing & Re-entry Loops
To prevent false positives (such as double-counting a single tab exit during transition frames):
- The trigger helper checks a cooldown timer (`now - lastWarningTime < 2000`) before incrementing warnings.
- The re-entry helper executes multiple delayed attempts (`setTimeout` loop) to re-engage fullscreen mode, overriding browser state locks.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the proctoring event listeners in [`d:\Pookiz\pookiz-app\src\app\(main)\quizzes\[id]\page.tsx`](file:///d:/Pookiz/pookiz-app/src/app/%28main%29/quizzes/%5Bid%5D/page.tsx):

```typescript
  // Fullscreen Exit Event detection + instant auto-reentry
  useEffect(() => {
    if (DISABLE_PROCTORING) return
    const handleFullscreenChange = () => {
      if (!quizStartedRef.current || disqualifiedRef.current || submittingRef.current || isIntentionalExitRef.current) return
      if (!checkIsFullscreen()) {
        setNeedsFullscreenReentry(true)
        triggerWarning('Exited fullscreen mode')
      } else {
        if (document.visibilityState === 'visible' && document.hasFocus()) {
          clearViolationActive()
        } else {
          setNeedsFullscreenReentry(false)
        }
      }
    }

    document.addEventListener('fullscreenchange', handleFullscreenChange)
    return () => document.removeEventListener('fullscreenchange', handleFullscreenChange)
  }, [clearViolationActive])
```
- **Line 664-668:** Instantiates the fullscreen listener. Checks if the quiz is active and proctoring is enabled.
- **Line 669-670:** If `checkIsFullscreen()` returns `false`, flags the user for re-entry and triggers a warning.
- **Line 671-677:** If in fullscreen and window states are correct, clears active violation flags.

```typescript
  // Tab Swap / Blur Event detection
  useEffect(() => {
    if (DISABLE_PROCTORING) return
    const handleVisibilityChange = () => {
      if (!quizStartedRef.current || disqualifiedRef.current || submittingRef.current || isIntentionalExitRef.current) return
      if (document.visibilityState === 'hidden') {
        setIsWindowBlurred(true)
        triggerWarning('Left the quiz tab / switched apps')
      } else {
        if (checkIsFullscreen() && document.hasFocus()) {
          clearViolationActive()
        }
      }
    }

    const handleWindowBlur = () => {
      if (!quizStartedRef.current || disqualifiedRef.current || submittingRef.current || isIntentionalExitRef.current) return
      setIsWindowBlurred(true)
      triggerWarning('Lost window focus')
    }

    const handleWindowFocus = () => {
      if (!quizStartedRef.current || disqualifiedRef.current || submittingRef.current || isIntentionalExitRef.current) return
      if (checkIsFullscreen() && document.visibilityState === 'visible') {
        clearViolationActive()
      }
    }

    document.addEventListener('visibilitychange', handleVisibilityChange)
    window.addEventListener('blur', handleWindowBlur)
    window.addEventListener('focus', handleWindowFocus)

    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange)
      window.removeEventListener('blur', handleWindowBlur)
      window.removeEventListener('focus', handleWindowFocus)
    }
  }, [clearViolationActive])
```
- **Line 687-691:** Intercepts tab switching. If `document.visibilityState === 'hidden'`, flags the window as blurred and triggers a warning.
- **Line 699-703:** Intercepts window focus loss (e.g. clicking outside the browser window), triggering a warning.
- **Line 712-720:** Binds the listeners on mount and cleans them up on unmount.

---

## 5. Edge Cases & Optimizations
- **Browser Security Blocks on Fullscreen Re-entry:** Modern browsers block requests to go fullscreen unless they are triggered by direct user interactions (like clicking a button).
  - *Fix:* Display a modal block overlay requiring the student to click a "Re-enter Fullscreen" button before allowing them to resume the test.
- **Consecutive Trigger Spamming:** Rapid tab switching can trigger multiple warnings in milliseconds, causing instant disqualification.
  - *Fix:* Enforce an active violation flag (`isViolationActiveRef.current = true`) to ignore subsequent warnings until the student returns to a safe, verified state.

---

## 6. Staff Engineer Viva Board

### Q1: Why must the `dragCounter` pattern or similar violation gates be used to ignore consecutive warning events?
**Answer:**
*"When a user switches tabs, the browser fires both a `visibilitychange` event and a `blur` event almost simultaneously. 

If we did not use a violation gate:
1. The `visibilitychange` event would trigger a warning.
2. The `blur` event would trigger a second warning milliseconds later.
3. The user would receive two warnings for a single tab switch, leading to fast, incorrect disqualification.
By setting a violation flag (`isViolationActiveRef.current = true`) on the first event, we ignore all subsequent events until the user returns to a safe, focused state and clears the violation flag."*

### Q2: What is the Page Visibility API, and why is it preferred over the window `blur` event for detecting tab switches?
**Answer:**
*"- **Window `blur` event:** Fires when the browser window loses focus. This can happen if the user clicks a browser utility (like search bars), clicks a second monitor, or opens an system alert window. It does not guarantee that the tab is hidden.
- **Page Visibility API (`visibilitychange`):** Fires only when the tab is actually hidden (e.g., when the user switches tabs, minimizes the window, or locks their screen).
Using both events allows us to distinguish between minor distractions (focus loss) and active cheating (switching tabs to search for answers)."*

### Q3: Why does requesting fullscreen mode require a user gesture (like a button click)? How does Pookiz handle this browser security rule?
**Answer:**
*"To prevent malicious websites from hijacking the screen, browsers enforce a security rule: requesting fullscreen (`Element.requestFullscreen()`) must be triggered by a direct user interaction (like a mouse click or key press). Calling it programmatically inside an asynchronous background loop will be rejected.

Pookiz handles this by displaying a fullscreen re-entry modal when a violation occurs. The modal blocks the entire UI, preventing the user from viewing questions, and requires them to click a "Re-enter Fullscreen" button to resume, satisfying browser security rules."*

### Q4: How does Pookiz prevent users from using keyboard shortcuts (like Alt+Tab, Win+D) to switch windows?
**Answer:**
*"JavaScript cannot block operating system-level shortcuts (like Alt+Tab or Win+D) because they are intercepted by the OS kernel before reaching the browser.

Since we cannot block these shortcuts directly, we monitor their consequences:
- If a user presses Alt+Tab to switch windows, the browser loses focus, firing the `blur` event.
- If they switch to a different tab, it fires the `visibilitychange` event.
We capture these events to trigger warnings and proctoring locks."*

### Q5: How would you design the database sync strategy for quiz progress to survive client page crashes?
**Answer:**
*"To prevent data loss if the browser crashes, we use a dual-sync strategy:
1. **Local Backup:** We save the student's selected answers, current question index, and warning counts to browser `localStorage` on every transition:
   ```typescript
   localStorage.setItem(`pookiz_answers_${quizId}`, JSON.stringify(answers));
   ```
2. **Server Sync:** We send progress updates to the server `/api/quizzes/save-progress` using the `navigator.sendBeacon` API or `fetch` with the `keepalive: true` flag. This ensures the request completes in the background even if the user closes the tab."*
