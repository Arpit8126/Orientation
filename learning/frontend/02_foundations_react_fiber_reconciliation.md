# Frontend Chapter 02: Foundations of React Fiber & Reconciliation Engine

This module covers the core internals of the React rendering engine, detailing the Virtual DOM, the React Fiber node architecture, the reconciliation process, and the scheduling lifecycle.

---

## 1. Objective & Placement Value
- **Why this is asked:** Elite front-end engineering roles require a deep understanding of React's internals. Interviewers test on Fiber node structures, concurrent rendering states, the two-phase commit lifecycle, and how Hook linked lists map to Fiber objects.
- **Placement Value:** Equips you to diagnose rendering bottlenecks, optimize state batching, and prevent memory leaks in complex React applications.

---

## 2. The Layman's Analogy
Think of the React Fiber reconciliation engine as a **drafting architect and construction crew**:
- **The Old Design (Current Fiber Tree):** The building that is currently standing (the active UI displayed in the browser).
- **The New Blueprint (Work-In-Progress Fiber Tree):** A draft blueprint created on a drafting table. When state updates, the architect creates this draft to sketch layout changes.
- **The Reconciler (The Architect):** The architect compares the standing building with the new draft blueprint. They mark exactly what needs to be changed (e.g., *"paint this door blue, move that chair"*) without touching the standing building yet. They can take breaks, pause, or discard drafts if a new instruction arrives (Concurrent mode).
- **The Committer (The Construction Crew):** Once the draft blueprint is approved, the construction crew executes the changes on the standing building in a single pass (**Commit phase**), preventing the building from being left in an incomplete state.

---

## 3. The Technical Specification

### A. The Fiber Node Architecture
A **Fiber** is a plain JavaScript object representing a unit of work. Every React element corresponds to a Fiber node. Unlike standard DOM trees, Fibers are linked lists that support pausing and prioritizing updates.
Key Fiber node properties:
- `child`: Points to the first direct child component.
- `sibling`: Points to the next sibling component.
- `return`: Points to the parent component.
- `memoizedState`: A linked list of **Hook Objects** representing the component's state variables and effects.

```
                    ┌──────────────┐
                    │  Fiber Node  │
                    │   (Parent)   │
                    └──────┬───────┘
                           │ child
                           ▼
                    ┌──────────────┐  sibling   ┌──────────────┐
                    │  Fiber Node  ├───────────►│  Fiber Node  │
                    │   (Child 1)  │            │   (Child 2)  │
                    └──────────────┘            └──────────────┘
```

### B. The Render and Commit Phases
React executes updates in two distinct phases:
1. **Render Phase (Asynchronous, Interruptible):**
   - React traverses the Fiber tree and computes the diffs.
   - It schedules work using priority levels (e.g., user inputs are high priority; data fetches are low priority).
   - This phase can be paused, aborted, or restarted if higher-priority updates arrive, preventing UI thread blocking.
2. **Commit Phase (Synchronous, Uninterruptible):**
   - React takes the calculated changes (the effect list) and writes them directly to the real DOM in a single synchronous pass.
   - This prevents intermediate, inconsistent states from displaying on the screen.

### C. Hook Linked Lists inside Fibers
Hooks (like `useState` and `useEffect`) are stored inside the Fiber node's `memoizedState` column as a linked list of hook objects:
```typescript
interface Hook {
  memoizedState: any; // The state value or effect callback
  next: Hook | null;   // Points to the next hook in the component
}
```
During rendering, React reads the hooks sequentially based on the execution order. **Calling hooks conditionally or inside loops breaks the execution index**, causing React to match state variables with the wrong hook objects.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze how hooks map to Fiber nodes. Below is a conceptual representation of how React manages Hook lists during execution:

```typescript
// Component definition
function UserCard() {
  const [name, setName] = useState('Arpit'); // Hook 1
  const [banned, setBanned] = useState(false); // Hook 2

  useEffect(() => { // Hook 3
    console.log('Mount event');
  }, []);
```
- **Line 3:** Hook 1 is executed. React allocates the first hook object: `{ memoizedState: 'Arpit', next: null }` and links it to the Fiber's `memoizedState` pointer.
- **Line 4:** Hook 2 is executed. React creates a second hook object: `{ memoizedState: false, next: null }` and appends it to Hook 1's `next` pointer, forming a linked list:
  $$\text{Hook 1} \to \text{Hook 2}$$
- **Line 6:** Hook 3 is executed and appended, extending the linked list.

```typescript
  // VIOLATION: Conditional Hook Call
  if (name === 'Arpit') {
    const [role, setRole] = useState('student'); // Hook 4 (Will crash React on name change)
  }
}
```
- **Line 13:** If `name` changes to a different value, this hook is skipped. On the next render, React traverses the hook list. The 4th hook call will map to the 5th hook object in the list, causing state mismatches and application crashes.

---

## 5. Edge Cases & Optimizations
- **Stale Closures inside `useEffect`:** When a callback hook (like `useEffect` or `useCallback`) does not include reference variables in its dependency array, it captures a snapshot of the variables from the render cycle when the hook was instantiated. When invoked later, it will read the outdated (stale) values.
  - *Fix:* Ensure the dependency array includes all reactive variables, or use a mutable `useRef` pointing to the variable.
- **Excessive Re-renders (Unnecessary Diffing):** Parent state updates force all children to re-render, even if their props haven't changed.
  - *Fix:* Wrap static children in `React.memo`, or offload expensive computations to `useMemo`.

---

## 6. Staff Engineer Viva Board

### Q1: Why do React Hooks rely on call order consistency, and what happens under the hood if this rule is broken?
**Answer:**
*"React Hooks are stored inside the component's Fiber node as a single, sequentially linked list. When a component renders:
1. React sets an internal pointer to the first hook object in the list.
2. Every time a hook is invoked, React reads the current state value from that object and advances the pointer to the next hook (`currentHook = currentHook.next`).
3. React does not keep track of hooks by name; it relies entirely on their index position in the call sequence.

If a hook is placed inside an `if` block and skipped during a render:
- The execution order changes.
- All subsequent hook calls will read from the wrong hook objects in the list, causing state mismatches and runtime crashes.
This is why hooks must only be called at the top level of React components."*

### Q2: What is the difference between the Render Phase and the Commit Phase in React?
**Answer:**
*"- **Render Phase (Asynchronous & Interruptible):** React traverses the Fiber tree and computes changes (creating a work-in-progress tree). This phase can be paused, aborted, or restarted by the scheduler if a higher-priority task (like user input) occurs, keeping the UI responsive.
- **Commit Phase (Synchronous & Uninterruptible):** Once the render phase completes, React takes the changes and writes them directly to the real DOM in a single synchronous pass. This phase cannot be paused, preventing layout inconsistencies from displaying on the screen."*

### Q3: Explain how React 18's concurrent features (like `useTransition` or `useDeferredValue`) optimize rendering performance.
**Answer:**
*"Before React 18, all rendering updates were treated as high-priority, synchronous blocks. If a query update caused a heavy list to filter, the UI would freeze until the list completed rendering.

React 18's concurrent features allow us to split updates into priority levels:
- **Urgent Updates:** Direct interactions like typing inside an input field.
- **Non-Urgent Transitions:** Secondary updates like filtering a search result list.
By wrapping the search update inside `startTransition`, we tell the React scheduler that this render can be paused. If the user types another character mid-render, React immediately aborts the current search render and starts a new one with the updated character, keeping the typing input smooth."*

### Q4: Why does a state update in a parent component force all child components to re-render, and how do you optimize this behavior?
**Answer:**
*"By default, when a state changes in a parent component, React marks the parent's Fiber node as dirty and traverses its entire subtree, re-rendering all child components. This is because React assumes children might depend on the updated parent state.

To optimize this:
1. **`React.memo`:** Wraps the child component. React will skip re-rendering the child if its props have not changed.
2. **`useCallback` / `useMemo`:** Prevents generating new object or function references on every render, ensuring props pass strict equality checks (`===`) inside `React.memo` components."*

### Q5: What is a stale closure in React, and how do you resolve it?
**Answer:**
*"A stale closure occurs when a function (such as a callback inside `useEffect`, `useCallback`, or an event listener) captures variables from an older render cycle.

For example, if a `useEffect` runs once on mount (`[]`) and registers a click listener that references a state variable `count`:
- The listener is created once, capturing the initial value `count = 0`.
- When the user clicks, the listener will always read `0`, even if `count` has updated in the component.
To resolve this, we must include `count` in the dependency array (forcing the effect to re-run and register a new listener with the updated closure), or store the value inside a mutable `useRef` object."*
