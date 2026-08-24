# Frontend Chapter 05: Accessibility (a11y) — Making Apps Usable for Everyone

This chapter covers web accessibility from scratch — what it is, why it matters in interviews, and how to implement it in a Next.js + React app.

---

## 1. Objective & Placement Value
- **Why this is asked:** Top companies (Google, Microsoft, Flipkart, Meesho) take accessibility seriously. It is asked directly in design rounds and frontend interviews.
- **Placement Value:** Shows you build inclusive products. The `a11y` abbreviation (a + 11 letters + y = accessibility) is widely used. Knowing it signals seniority.

---

## 2. The Layman's Analogy

Think of a **public building** in your city:

**Without accessibility:** The main entrance has 30 stairs. People in wheelchairs, with leg injuries, or pushing strollers cannot enter. The building serves only "normal" users.

**With accessibility:** There are stairs AND a ramp AND an elevator AND braille buttons AND audio announcements. The same building serves EVERYONE.

Web accessibility = building websites that work for everyone — including people who are blind (screen readers), deaf (captions), have motor disabilities (keyboard-only navigation), or cognitive disabilities (clear labels, predictable UI).

---

## 3. The Technical Specification

### A. WCAG — The Accessibility Standard

**WCAG (Web Content Accessibility Guidelines)** is the global standard. It has 3 levels:
- **A** — Minimum (critical issues)
- **AA** — Standard (required by most laws/companies)
- **AAA** — Maximum (aspirational)

Most companies target **WCAG 2.1 Level AA**.

The 4 core principles (POUR):
- **Perceivable** — information must be presentable to all senses
- **Operable** — UI must be navigable with keyboard, not just mouse
- **Understandable** — content must be clear and predictable
- **Robust** — works with assistive technologies (screen readers)

---

### B. Semantic HTML — The Foundation

**The biggest accessibility mistake:** Using `<div>` for everything.

```html
<!-- ❌ BAD — meaningless structure -->
<div class="button" onclick="submitForm()">Submit</div>
<div class="heading">Welcome to Pookiz</div>
<div class="nav">
  <div class="link" onclick="goHome()">Home</div>
</div>

<!-- ✅ GOOD — meaningful, accessible structure -->
<button type="submit" onclick="submitForm()">Submit</button>
<h1>Welcome to Pookiz</h1>
<nav>
  <a href="/">Home</a>
</nav>
```

Why semantic HTML is critical for accessibility:
- **Screen readers** (software that reads the page aloud to blind users) announce elements by their type: "Submit, button" vs just "Submit"
- **Keyboard navigation** works automatically for `<button>` and `<a>` — they are focusable and respond to Enter/Space
- **Search engines** understand your page structure better (also good for SEO)

---

### C. ARIA Attributes — When Semantic HTML Isn't Enough

**ARIA (Accessible Rich Internet Applications)** attributes add accessibility information to custom elements:

```tsx
// Custom modal dialog
<div
  role="dialog"                      // tells screen readers: "this is a dialog"
  aria-modal="true"                  // tells screen reader: "rest of page is inactive"
  aria-labelledby="dialog-title"     // points to the element that labels this dialog
  aria-describedby="dialog-body"     // points to descriptive text
>
  <h2 id="dialog-title">Confirm Friend Request</h2>
  <p id="dialog-body">
    Send a friend request to Priya? She will be notified.
  </p>
  <button onClick={onConfirm}>Send Request</button>
  <button onClick={onCancel}>Cancel</button>
</div>
```

**Most important ARIA attributes:**

```tsx
// aria-label: provides a text label when no visible text exists
<button aria-label="Close dialog">
  <XIcon /> {/* icon-only button — screen reader reads "Close dialog" */}
</button>

// aria-expanded: tells screen readers if a section is open/collapsed
<button
  aria-expanded={isMenuOpen}
  aria-controls="nav-menu"
>
  Menu
</button>

// aria-live: announces dynamic content changes to screen readers
// "polite" = wait until user is idle before announcing
// "assertive" = announce immediately (for errors)
<div aria-live="polite" aria-atomic="true">
  {statusMessage} {/* updates announced to screen readers */}
</div>

// aria-hidden: completely hides decorative elements from screen readers
<span aria-hidden="true">🎉</span> Congratulations!
// Screen reader reads: "Congratulations!" not "Party popper emoji Congratulations!"

// aria-required: marks required form fields
<input
  type="email"
  aria-required="true"
  aria-describedby="email-error"
/>
<span id="email-error" aria-live="assertive">
  {emailError} {/* error announced immediately when it appears */}
</span>
```

---

### D. Keyboard Navigation

All interactive elements must be usable with the keyboard alone:

**Tab order** — users press Tab to move between interactive elements (buttons, links, inputs):

```tsx
// ❌ BAD — div with onClick is not keyboard focusable
<div onClick={handleClick}>Click me</div>

// ✅ GOOD — button is automatically in tab order
<button onClick={handleClick}>Click me</button>

// ✅ ALSO GOOD — div can be made focusable with tabIndex
<div
  tabIndex={0}              // 0 = in natural tab order
  role="button"             // tells screen reader it's a button
  onClick={handleClick}
  onKeyDown={(e) => {       // handle keyboard activation
    if (e.key === "Enter" || e.key === " ") handleClick();
  }}
>
  Click me
</div>
```

**Focus management in modals:**

```tsx
// When a modal opens, focus should move INTO the modal
// When it closes, focus should return to the element that opened it

function Modal({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) {
  const modalRef = useRef<HTMLDivElement>(null);
  const triggerRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    if (isOpen) {
      // Focus the first focusable element inside the modal
      modalRef.current?.focus();
    } else {
      // Return focus to the button that opened the modal
      triggerRef.current?.focus();
    }
  }, [isOpen]);

  // Trap focus inside modal — pressing Tab should NOT escape to page behind
  function handleKeyDown(e: React.KeyboardEvent) {
    if (e.key === "Escape") onClose();
    // Tab trapping implementation would go here
  }

  return (
    <>
      <button ref={triggerRef} onClick={() => setIsOpen(true)}>
        Open Modal
      </button>
      {isOpen && (
        <div
          ref={modalRef}
          role="dialog"
          aria-modal="true"
          tabIndex={-1}          // -1 = focusable via JS but not via Tab key
          onKeyDown={handleKeyDown}
        >
          {/* modal content */}
        </div>
      )}
    </>
  );
}
```

---

### E. Color Contrast

**WCAG AA requirement:** Text must have a contrast ratio of at least **4.5:1** against its background.

```css
/* ❌ BAD — light gray on white, unreadable for low-vision users */
.muted-text {
  color: #cccccc;  /* too light on white background */
  background: #ffffff;
  /* contrast ratio: ~1.6:1 — fails WCAG */
}

/* ✅ GOOD — dark enough to read */
.muted-text {
  color: #767676;  /* contrast ratio: 4.54:1 — passes WCAG AA */
  background: #ffffff;
}
```

Tools to check contrast:
- **WebAIM Contrast Checker:** https://webaim.org/resources/contrastchecker/
- **Chrome DevTools** → Inspect → click the color square → shows contrast ratio

---

### F. Images and Alt Text

```tsx
// ❌ BAD — no alt text. Screen reader says "image"
<img src="/avatar.png" />

// ❌ ALSO BAD — unhelpful alt text
<img src="/avatar.png" alt="image" />

// ✅ GOOD — descriptive alt text
<img src={user.avatarUrl} alt={`${user.username}'s profile photo`} />

// ✅ Decorative images should have empty alt
// This tells screen readers to skip it entirely
<img src="/decorative-wave.png" alt="" role="presentation" />

// In Next.js:
import Image from "next/image";
<Image
  src={user.avatarUrl}
  alt={`${user.username}'s profile photo`}
  width={40}
  height={40}
/>
```

---

### G. Forms and Labels

Every form input must have an associated label:

```tsx
// ❌ BAD — input has no label. Screen readers say "edit text"
<input type="text" placeholder="Enter username" />

// ✅ GOOD — explicit label
<label htmlFor="username-input">Username</label>
<input id="username-input" type="text" placeholder="arpit123" />

// ✅ ALSO GOOD — label wrapping the input
<label>
  Username
  <input type="text" placeholder="arpit123" />
</label>

// ✅ GOOD — aria-label when visible label is not possible
<input
  type="search"
  aria-label="Search for users, groups, or posts"
  placeholder="Search..."
/>
```

---

## 4. Line-by-Line Accessibility Audit — Pookiz Chat Input

```tsx
// ❌ Original version (not accessible)
<div className="input-area">
  <div className="emoji-btn" onClick={toggleEmoji}>😊</div>
  <div contentEditable className="message-input" />
  <div className="send-btn" onClick={sendMessage}>Send</div>
</div>
```

**Problems:**
- `<div>` buttons are not keyboard focusable
- No labels — screen reader doesn't know what anything does
- Emoji button has no text alternative
- ContentEditable div is complex for screen readers

```tsx
// ✅ Accessible version
<div role="group" aria-label="Message composition area">

  <button
    type="button"
    aria-label="Open emoji picker"
    aria-expanded={emojiOpen}
    onClick={toggleEmoji}
  >
    <span aria-hidden="true">😊</span>
  </button>

  <textarea
    aria-label="Type a message"
    aria-multiline="true"
    placeholder="Type a message..."
    rows={1}
    onKeyDown={(e) => {
      if (e.key === "Enter" && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
      }
    }}
  />

  <button
    type="submit"
    aria-label="Send message"
    onClick={sendMessage}
    disabled={messageEmpty}    // disabled state is also announced by screen readers
  >
    Send
  </button>

</div>
```

---

## 5. Edge Cases & Best Practices

- **Don't use color alone to convey information.** Adding a red border on invalid fields is good, but ALSO add an error message text. Colorblind users cannot see the red.

- **Provide skip links.** Screen reader and keyboard users must navigate your header navigation on every page. A "Skip to main content" link lets them jump directly to the content:
  ```tsx
  <a href="#main-content" className="skip-link">
    Skip to main content
  </a>
  <main id="main-content">...</main>
  ```

- **Test with a screen reader.** On Windows: NVDA (free). On Mac: VoiceOver (built-in, Cmd+F5). On mobile: TalkBack (Android), VoiceOver (iOS). Use your app with eyes closed.

- **Use `prefers-reduced-motion`.** Some users have vestibular disorders that make animations nauseating:
  ```css
  @media (prefers-reduced-motion: reduce) {
    * {
      animation: none !important;
      transition: none !important;
    }
  }
  ```

---

## 6. Staff Engineer Viva Board

### Q1: What is web accessibility and why does it matter beyond ethics?
**Answer:**
*"Web accessibility means building websites usable by people with disabilities — visual, hearing, motor, and cognitive. Beyond ethics, it matters for:*
*1. **Legal compliance:** Several countries have laws requiring accessibility (ADA in USA, EAA in Europe). Inaccessible apps face lawsuits.*
*2. **Market size:** ~15% of the world's population has some form of disability — ~1 billion people.*
*3. **SEO improvement:** Semantic HTML and proper headings used for accessibility also help search engine ranking.*
*4. **Situational use cases:** Good accessibility also helps non-disabled users — captions help people in noisy environments; keyboard navigation helps power users."*

### Q2: What is the difference between `aria-label`, `aria-labelledby`, and `aria-describedby`?
**Answer:**
*"All three provide text information to screen readers, but they serve different roles:*

*- `aria-label='Close'` — provides an immediate label string directly in the attribute. Used when there is no visible text.*
*- `aria-labelledby='modal-title'` — points to the ID of another element whose text becomes this element's label. Used when the label text already exists in the DOM (e.g., a dialog's heading labels the whole dialog).*
*- `aria-describedby='error-msg'` — points to supplementary description. Announced after the label. Used for error messages, helper text, or long descriptions.*

*A button with both:*
```tsx
<button aria-label="Send" aria-describedby="send-hint">Send</button>
<span id="send-hint">Ctrl+Enter to send without clicking</span>
```
*Screen reader says: 'Send, button. Ctrl+Enter to send without clicking.'"*

### Q3: What is `tabIndex` and when would you use `-1` vs `0`?
**Answer:**
*"`tabIndex` controls whether and in what order an element receives keyboard focus:*
*- `tabIndex='0'` — element is in the natural tab order (after all naturally focusable elements like buttons and links).*
*- `tabIndex='-1'` — element CAN be focused via JavaScript (`element.focus()`) but is NOT in the tab order. Users pressing Tab will skip it. I use this for modals — the modal `<div>` needs `tabIndex='-1'` so I can call `.focus()` on it when the modal opens, but Tab should then cycle through BUTTONS inside the modal, not the modal wrapper itself.*
*- `tabIndex='1'` (positive) — skips ahead in tab order. Avoid this — it creates confusion and is considered an anti-pattern."*
