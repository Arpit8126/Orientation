# React — Complete Guide from Zero to Real World (Extended)

React is a declarative, efficient, and flexible JavaScript library for building user interfaces. It is maintained by Meta (Facebook) and a community of individual developers and companies.

---

## PART 1: Core React Concepts

### What is React?
In traditional web development, if you want to change something on the page (e.g., add a comment to a list), you have to manually find the HTML element using JavaScript (`document.getElementById`) and modify it. As apps grow, this manual DOM manipulation becomes incredibly slow and buggy.

React solves this by introducing:
1. **Declarative UI**: You describe *what* the UI should look like based on the current state, and React automatically updates the DOM to match it.
2. **Component-Based Architecture**: You build the UI out of small, self-contained, reusable building blocks called **Components**.
3. **Virtual DOM**: Instead of updating the real browser DOM directly, React updates a lightweight copy in memory (Virtual DOM) and calculates the most efficient way to update the real DOM (Reconciliation/Diffing).

---

## PART 2: JSX Syntax

JSX (JavaScript XML) is a syntax extension for JavaScript that allows you to write HTML-like code directly inside your JavaScript files.

```jsx
// A basic React Component returning JSX
function Welcome() {
  return <h1>Hello, World!</h1>;
}
```

### JSX Rules:
1. **Single Root Element**: JSX must return a single parent element. If you don't want to add an extra `<div>` to the DOM, use a **Fragment** (`<>` and `</>`):
   ```jsx
   // ❌ WRONG (Multiple root elements)
   return (
     <h1>Title</h1>
     <p>Description</p>
   );

   // ✅ CORRECT (Using a Fragment)
   return (
     <>
       <h1>Title</h1>
       <p>Description</p>
     </>
   );
   ```
2. **Closing Tags**: All tags must be explicitly closed, including self-closing tags:
   ```jsx
   // ✅ Correct: <img src="logo.png" alt="Logo" />
   // ❌ Wrong: <img src="logo.png">
   ```
3. **camelCase Attributes**: HTML attributes are written in camelCase:
   - `class` becomes `className`
   - `for` becomes `htmlFor`
   - `onclick` becomes `onClick`
   - `tabindex` becomes `tabIndex`
4. **JavaScript Expressions**: You can write any JavaScript expression inside JSX by wrapping it in curly braces `{}`:
   ```jsx
   function UserProfile() {
     const name = "Arpit";
     const isLoggedIn = true;
     return (
       <div>
         <h1>Name: {name}</h1>
         <p>Status: {isLoggedIn ? "Active" : "Offline"}</p>
         <p>Math: 2 + 2 = {2 + 2}</p>
       </div>
     );
   }
   ```

---

## PART 3: Components & Props

Components are the building blocks of a React application. They are JavaScript functions that return JSX.

### Functional Components
```jsx
// Component names MUST start with a capital letter!
function ProfileCard() {
  return (
    <div className="card">
      <h2>Arpit Pandey</h2>
      <p>Software Engineer</p>
    </div>
  );
}

// Rendering the component inside another component:
function App() {
  return (
    <div>
      <ProfileCard />
      <ProfileCard />
    </div>
  );
}
```

### Props (Properties)
Props are inputs passed into components, similar to function arguments. Props are **read-only (immutable)**. A component must never modify its own props.

```jsx
// 1. Defining a component that accepts props (using destructuring)
function ProfileCard({ name, role, age = 18 }) { // age has a default value
  return (
    <div className="card">
      <h2>Name: {name}</h2>
      <p>Role: {role}</p>
      <p>Age: {age}</p>
    </div>
  );
}

// 2. Passing props to the component
function App() {
  return (
    <div>
      <ProfileCard name="Arpit" role="Developer" age={21} />
      <ProfileCard name="Priya" role="Designer" />
    </div>
  );
}
```

#### Passing Children (props.children):
You can pass elements between the opening and closing tags of a component. They are accessed inside the component via the special `children` prop.

```jsx
function Modal({ children }) {
  return (
    <div className="modal-overlay">
      <div className="modal-content">
        {children}
      </div>
    </div>
  );
}

// Usage:
function App() {
  return (
    <Modal>
      <h2>Alert!</h2>
      <p>This is dynamic content passed as children.</p>
      <button>Close</button>
    </Modal>
  );
}
```

---

## PART 4: State & Event Handling

### State (`useState`)
State is a component's local memory. Unlike props, state is **mutable** and is managed inside the component. When state changes, React automatically re-renders the component to display the new state.

To use state, we import the `useState` hook from React.

```jsx
import { useState } from "react";

function Counter() {
  // useState returns an array with:
  // 1. The current state value
  // 2. A setter function to update that value
  const [count, setCount] = useState(0); // 0 is the initial state

  function increment() {
    setCount(count + 1);
  }

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment}>Increment</button>
    </div>
  );
}
```

#### Updating State based on Previous State:
If your new state depends on the previous state, always pass a callback function to the setter. This avoids bugs caused by React's state update batching.

```jsx
// ❌ Potential race condition / batching bug:
setCount(count + 1);
setCount(count + 1); // might not increment twice if called in same execution frame

// ✅ Correct (functional update):
setCount(prevCount => prevCount + 1);
setCount(prevCount => prevCount + 1); // guaranteed to increment by 2
```

#### Updating Objects and Arrays in State:
In React, you must **never mutate state directly**. You must always create a new copy of the object or array and update that copy.

```jsx
// ===== OBJECTS =====
const [user, setUser] = useState({ name: "Arpit", age: 21 });

// ❌ WRONG (direct mutation)
user.age = 22;
setUser(user); // React won't detect change because reference didn't change!

// ✅ CORRECT (using spread operator to copy)
setUser(prevUser => ({
  ...prevUser, // copy all properties
  age: 22      // override age
}));

// ===== ARRAYS =====
const [list, setList] = useState(["Apple", "Banana"]);

// ❌ WRONG
list.push("Orange");
setList(list);

// ✅ CORRECT
setList(prevList => [...prevList, "Orange"]); // Append
setList(prevList => prevList.filter(item => item !== "Banana")); // Delete
setList(prevList => prevList.map(item => item === "Apple" ? "Green Apple" : item)); // Update
```

### Event Handling
React events are named using camelCase (`onClick`, `onChange`, `onSubmit`) and are passed as function references, not strings.

```jsx
function Form() {
  const [inputVal, setInputVal] = useState("");

  function handleChange(event) {
    // event.target refers to the DOM element
    setInputVal(event.target.value);
  }

  function handleSubmit(event) {
    event.preventDefault(); // Stop page reload
    console.log("Submitted:", inputVal);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" value={inputVal} onChange={handleChange} />
      <button type="submit">Submit</button>
    </form>
  );
}
```

---

## PART 5: Conditional Rendering & Lists

### Conditional Rendering

```jsx
function Dashboard({ isLoggedIn, userRole }) {
  // Option 1: if/else (standard JavaScript)
  if (!isLoggedIn) {
    return <p>Please log in to continue.</p>;
  }

  return (
    <div>
      <h1>Welcome back!</h1>
      {/* Option 2: Ternary operator (inline if-else) */}
      {userRole === "admin" ? <button>Admin Panel</button> : <button>User Profile</button>}

      {/* Option 3: Logical AND (inline check - render if true, else render nothing) */}
      {userRole === "admin" && <p>You have supervisor access.</p>}
    </div>
  );
}
```
*Note on Logical AND `&&`: Make sure the left side is a pure boolean. If the left side evaluates to `0` or `NaN`, React will render that number on the screen instead of rendering nothing. Use `Double Negation` `!!` or comparison: `count > 0 && <p>...</p>` instead of `count && <p>...</p>`.*

### Rendering Lists
To render multiple components from an array, use the JavaScript `.map()` method.

```jsx
function TodoList() {
  const todos = [
    { id: 1, text: "Learn HTML" },
    { id: 2, text: "Learn CSS" },
    { id: 3, text: "Learn React" }
  ];

  return (
    <ul>
      {todos.map(todo => (
        // Each item in a list MUST have a unique "key" prop!
        <li key={todo.id}>{todo.text}</li>
      ))}
    </ul>
  );
}
```

#### Why is the `key` prop required?
Keys help React identify which items have changed, been added, or been removed. This is critical for the diffing algorithm (Reconciliation) to update the UI efficiently.
- **Never use array index (`key={index}`)** as keys if the list can be sorted, filtered, or items can be added/removed from the middle. This causes severe rendering bugs and performance issues.
- **Never generate random keys on the fly** (`key={Math.random()}`). This forces React to destroy and recreate the DOM nodes on every single render.

---

## PART 6: Lifting State Up & State Sharing

In React, data flows down (one-way data binding). If sibling components need to share data, they cannot talk to each other directly. Instead, you must **lift the state up** to their closest common parent.

```
       [Parent Component]  <── Holds state & passes down setter
      /                  \
[Sibling A]          [Sibling B]
(Calls setter)       (Receives new state value as prop)
```

```jsx
// Sibling A: Input field
function SearchInput({ value, onChange }) {
  return <input type="text" value={value} onChange={e => onChange(e.target.value)} />;
}

// Sibling B: Results renderer
function SearchResults({ query }) {
  return <p>Searching database for: {query}</p>;
}

// Parent Component holding the state
function SearchManager() {
  const [searchQuery, setSearchQuery] = useState("");

  return (
    <div>
      <SearchInput value={searchQuery} onChange={setSearchQuery} />
      <SearchResults query={searchQuery} />
    </div>
  );
}
```

---

## PART 7: Controlled vs Uncontrolled Components

Forms in React handle data input using one of two patterns:

### 1. Controlled Components (Recommended)
React state is the "single source of truth". The input value is bound to state, and modifications update state.

```jsx
function ControlledForm() {
  const [val, setVal] = useState("");
  return <input type="text" value={val} onChange={e => setVal(e.target.value)} />;
}
```
*Advantage: Easy validation on every keystroke, easy manipulation.*

### 2. Uncontrolled Components
The DOM handles the input value directly. You retrieve the value when needed using a React `ref` or `FormData`.

```jsx
import { useRef } from "react";

function UncontrolledForm() {
  const inputRef = useRef(null);

  function handleSubmit(e) {
    e.preventDefault();
    console.log("Input value:", inputRef.current.value);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input type="text" ref={inputRef} />
      <button type="submit">Submit</button>
    </form>
  );
}
```
*Advantage: Reduces unnecessary re-renders during typing.*

---

## PART 8: Core React Hooks Reference

### 1. `useState`
Local component state. (See Part 4).

### 2. `useEffect`
Handles side effects and subscriptions. (See Part 6 / 13).

### 3. `useRef`
Grants direct DOM access and persists mutable values without re-rendering. (See Part 7 / 12).

### 4. `useReducer`
An alternative to `useState` for managing complex state transitions (useful for state machines). It matches Redux architecture: `dispatch(action) -> reducer(state, action) -> new state`.

```jsx
import { useReducer } from "react";

// 1. Define initial state
const initialState = { status: "idle", error: null };

// 2. Define reducer function
function quizReducer(state, action) {
  switch (action.type) {
    case "START":
      return { status: "playing", error: null };
    case "SUBMIT":
      return { status: "grading", error: null };
    case "FINISH":
      return { status: "completed", error: null };
    case "FAIL":
      return { status: "idle", error: action.payload };
    default:
      return state;
  }
}

function QuizApp() {
  // 3. Setup useReducer
  const [state, dispatch] = useReducer(quizReducer, initialState);

  return (
    <div>
      <p>Current Status: {state.status}</p>
      {state.status === "idle" && (
        <button onClick={() => dispatch({ type: "START" })}>Start Quiz</button>
      )}
      {state.status === "playing" && (
        <button onClick={() => dispatch({ type: "SUBMIT" })}>Submit Answers</button>
      )}
    </div>
  );
}
```

---

## PART 9: Global State Management (Context API)

When you need to share state between components that are far apart in the component tree, passing props down through every level (Prop Drilling) becomes tedious. Context solves this.

```jsx
import { createContext, useContext, useState } from "react";

// 1. Create Context
const ThemeContext = createContext();

// 2. Create Provider component to wrap the app
export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState("light");

  function toggleTheme() {
    setTheme(t => (t === "light" ? "dark" : "light"));
  }

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// 3. Consume Context inside a deep child component
function SettingsButton() {
  // useContext accesses the values passed to Provider
  const { theme, toggleTheme } = useContext(ThemeContext);

  return (
    <button onClick={toggleTheme}>
      Current Theme: {theme} (Click to toggle)
    </button>
  );
}

// 4. Wrap the app with the Provider
function App() {
  return (
    <ThemeProvider>
      <Navbar />
      <MainContent>
        <SettingsButton />
      </MainContent>
    </ThemeProvider>
  );
}
```

---

## PART 10: Performance Optimization

Every time state or props change, React re-renders that component and all of its nested children. In large apps, this can cause lags.

### Memoization Helpers
1. **`React.memo`**: Prevents a functional component from re-rendering if its props have not changed.
   ```jsx
   import React from "react";

   // This child will only re-render if the 'name' prop changes,
   // even if the parent re-renders due to other state changes.
   const ChildComponent = React.memo(({ name }) => {
     console.log("Child render!");
     return <p>Hello {name}</p>;
   });
   ```
2. **`useMemo`**: Caches the *result* of a expensive calculation between renders.
   ```jsx
   import { useMemo } from "react";

   function ExpensiveCalc({ items }) {
     // Only recalculates when the 'items' array changes
     const computedValue = useMemo(() => {
       console.log("Doing heavy calculation...");
       return items.reduce((acc, item) => acc + item.price, 0);
     }, [items]);

     return <p>Total Price: {computedValue}</p>;
   }
   ```
3. **`useCallback`**: Caches a *function reference* between renders. (Useful when passing callbacks to memoized child components, as functions are objects and recreate on every render).
   ```jsx
   import { useCallback, useState } from "react";

   function Parent() {
     const [count, setCount] = useState(0);

     // Caches function reference. Child won't re-render since handleReset stays identical.
     const handleReset = useCallback(() => {
       setCount(0);
     }, []); // empty dependency means reference never changes

     return <Child onReset={handleReset} />;
   }
   ```

---

## PART 11: Portals & Error Boundaries

### Portals (`createPortal`)
Portals allow you to render HTML elements outside of the main DOM tree parent, while maintaining event bubbling within React context. Highly useful for overlays, modals, and tooltips.

```jsx
import { createPortal } from "react-dom";

function Modal({ isOpen, onClose, children }) {
  if (!isOpen) return null;

  // Renders the modal directly inside document.body instead of nested inside the component
  return createPortal(
    <div className="modal-overlay">
      <div className="modal-content">
        {children}
        <button onClick={onClose}>Close</button>
      </div>
    </div>,
    document.body
  );
}
```

### Error Boundaries
Error boundaries are React components that catch JavaScript errors anywhere in their child component tree, log those errors, and display a fallback UI instead of crashing the entire page.

*Note: As of React 19, Error Boundaries must still be written as class components, as functional components do not support the lifecycle methods required.*

```jsx
import React from "react";

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    // Update state so the next render shows the fallback UI
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    // Log the error to an error reporting service
    console.error("ErrorBoundary caught an error", error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      // Custom fallback UI
      return <h1>Something went wrong. Please refresh.</h1>;
    }

    return this.props.children;
  }
}

// Usage:
function App() {
  return (
    <ErrorBoundary>
      <MyBuggyComponent />
    </ErrorBoundary>
  );
}
```

---

## PART 12: React 19 New Features & Hooks

React 19 introduces native hooks and compiler updates that change how form logic is written.

### 1. `useActionState` (Handles Pending & Error States)
Replaces `useFormState` (React 18). It runs an async function, returns updated state, and tracks the pending state automatically.

```jsx
import { useActionState } from "react";

// Action function receives previous state and formData
async function subscribeAction(prevState, formData) {
  const email = formData.get("email");
  try {
    await api.subscribeEmail(email);
    return { success: true, message: "Subscribed!" };
  } catch (err) {
    return { success: false, message: "Subscription failed." };
  }
}

function SubscriptionForm() {
  // Hook returns: [state, formActionDispatch, isPending]
  const [state, formAction, isPending] = useActionState(subscribeAction, {
    success: false,
    message: ""
  });

  return (
    <form action={formAction}>
      <input type="email" name="email" required />
      <button type="submit" disabled={isPending}>
        {isPending ? "Subscribing..." : "Subscribe"}
      </button>
      {state.message && <p>{state.message}</p>}
    </form>
  );
}
```

### 2. `useFormStatus` (Child Form Indicators)
Allows nested children components to read their parent form's submission state without prop drilling.

```jsx
import { useFormStatus } from "react-dom";

function SubmitButton() {
  // Reads status of parent <form> wrapper
  const { pending, data, method, action } = useFormStatus();

  return (
    <button type="submit" disabled={pending}>
      {pending ? "Submitting..." : "Submit"}
    </button>
  );
}

// Usage:
function App() {
  return (
    <form action={someAction}>
      <input type="text" name="name" />
      <SubmitButton /> {/* Accesses form state internally */}
    </form>
  );
}
```

### 3. `use` Hook (Inline Promises & Context)
React 19 introduces `use()`. Unlike standard hooks, `use` can be called inside loops and conditional statements.

```jsx
import { use, Suspense } from "react";

// Read Context with 'use' (alternative to useContext)
function ThemeWidget() {
  if (condition) {
    const { theme } = use(ThemeContext); // Called inside condition!
    return <div>Theme: {theme}</div>;
  }
  return <div>Default Widget</div>;
}

// Read Promise/Data fetching with 'use'
// (Suspends render until fetch resolves, must wrap parent in Suspense)
const fetchUsersPromise = fetch("https://api.example.com/users").then(r => r.json());

function UsersList() {
  const users = use(fetchUsersPromise); // Suspends component during fetch

  return (
    <ul>
      {users.map(u => <li key={u.id}>{u.name}</li>)}
    </ul>
  );
}

function App() {
  return (
    <Suspense fallback={<p>Loading users...</p>}>
      <UsersList />
    </Suspense>
  );
}
```

### 4. Ref as a Prop (No more `forwardRef`)
In React 19, `ref` can be passed as a normal prop to child components.

```jsx
// React 18: Required React.forwardRef((props, ref) => ...)
// React 19: Just use normal prop parameter!
function CustomInput({ label, ref }) {
  return (
    <label>
      {label}
      <input ref={ref} />
    </label>
  );
}
```

---

## PART 13: Functional Hooks vs Class Lifecycle Methods

In interview prep, you are often asked how functional hooks correspond to older class component lifecycles.

| Class Lifecycle Method | Functional Component Hook equivalent |
|---|---|
| `componentDidMount` | Empty array dependency: `useEffect(() => { ... }, [])` |
| `componentDidUpdate` | Triggers when state/prop dependencies change: `useEffect(() => { ... }, [dependency])` |
| `componentWillUnmount` | Return callback inside effect: `useEffect(() => { return () => { cleanup(); } }, [])` |
| `shouldComponentUpdate` | Wrap component inside `React.memo(Component)` |

---

## Summary: Core React Cheat Sheet

| Feature | Key Hook / API | Example Usage |
|---|---|---|
| **Component Creation** | Function returning JSX | `function Card() { return <div />; }` |
| **Passing Values Down** | `props` (destructured parameters) | `function User({ name }) { return <p>{name}</p>; }` |
| **Component State** | `useState(initialVal)` | `const [val, setVal] = useState("");` |
| **Lifecycle / Fetching** | `useEffect(callback, dependencies)`| `useEffect(() => { loadData(); }, [id]);` |
| **Referencing DOM** | `useRef(null)` | `const ref = useRef(null); <div ref={ref} />` |
| **Avoid Prop Drilling** | `createContext` & `useContext` | `const contextVal = useContext(MyContext);` |
| **Memoize Calculation** | `useMemo(callback, dependencies)` | `const value = useMemo(() => calc(data), [data]);` |
| **Memoize Callback** | `useCallback(callback, dependencies)`| `const clickHandler = useCallback(() => ..., []);` |
| **Render Outside Parent**| `createPortal(jsx, targetNode)` | `createPortal(<Modal />, document.body)` |
| **React 19 Actions** | `useActionState(action, initial)` | `const [state, formAction, pending] = useActionState(...)` |
| **React 19 Pending Check**| `useFormStatus()` | `const { pending } = useFormStatus();` |
| **Inline Promise / Context**| `use(Promise | Context)` | `const value = use(MyContext);` |
| **Prevent Crash** | Class Component + lifecycle methods | `<ErrorBoundary><Child /></ErrorBoundary>` |
```
