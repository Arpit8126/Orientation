# TypeScript — Complete Guide from Zero to Real World

TypeScript is a strongly typed programming language that builds on JavaScript, giving you better tooling, autocompletion, and compile-time error checking. It compile down to standard JavaScript that runs in any browser or Node.js environment.

---

## PART 1: Why TypeScript?

In standard JavaScript:
- Variables can change their types dynamically (`let x = 5; x = "hello";`).
- Errors like reading properties of `undefined` are only caught at runtime (when a user is running the app).
- Large codebases are difficult to maintain because you don't know the exact "shape" of objects passed between functions.

TypeScript solves this by adding **Static Types** to JavaScript. It catches errors *while you are typing code* inside VS Code, before the code even runs.

---

## PART 2: Core Types

TypeScript allows you to declare the type of variables using a colon (`:`):

```typescript
// Primitives
const name: string = "Arpit";
let age: number = 21; // integers or decimals
let isDeveloper: boolean = true;
let empty: null = null;
let notDefined: undefined = undefined;

// Type Inference (Automatic type detection)
// You don't need to specify types if TypeScript can figure it out:
let username = "arpit"; // TypeScript automatically infers this is a string
// username = 42; // ❌ Compile Error: Type 'number' is not assignable to type 'string'.
```

### Arrays & Tuples
```typescript
// Arrays
let numbers: number[] = [1, 2, 3, 4];
let names: Array<string> = ["Arpit", "Priya"]; // alternative generic syntax

// Tuples (fixed-length arrays with specific types at specific indexes)
let userSession: [string, number] = ["auth-token-123", 3600];
// userSession = [3600, "token"]; // ❌ Compile Error (wrong order)
```

### Any & Unknown
- **`any`**: Turns off type checking completely. Avoid using `any` as it defeats the purpose of TypeScript.
- **`unknown`**: A safe alternative to `any`. Represents any value, but forces you to do type checking before using it.

```typescript
let value: unknown = "hello";

// console.log(value.toUpperCase()); // ❌ Compile Error: object is of type 'unknown'

// Must check type first:
if (typeof value === "string") {
  console.log(value.toUpperCase()); // ✅ Works! (Type refined to string)
}
```

---

## PART 3: Functions in TypeScript

You must type function parameters and return values:

```typescript
// Parameter types and Return type (number)
function add(a: number, b: number): number {
  return a + b;
}

// Void return type (function returns nothing)
function logMessage(message: string): void {
  console.log(message);
}

// Arrow functions
const multiply = (x: number, y: number): number => x * y;

// Optional Parameters (using '?')
// Optional parameters must go AFTER required parameters
function greet(name: string, greeting?: string): string {
  if (greeting) {
    return `${greeting}, ${name}!`;
  }
  return `Hello, ${name}!`;
}

// Default Parameters
function createUser(username: string, role: string = "user"): void {
  console.log(username, role);
}
```

---

## PART 4: Interfaces vs Types

Both `interface` and `type` allow you to define the shape of objects.

### 1. Interfaces
Specifically designed to describe object structures. Can be extended using the `extends` keyword.

```typescript
interface User {
  readonly id: string; // property cannot be changed after creation
  name: string;
  email: string;
  age?: number;        // optional property
}

// Extending an interface
interface Student extends User {
  university: string;
  semester: number;
}

const student: Student = {
  id: "std-123",
  name: "Arpit Pandey",
  email: "arpit@gla.ac.in",
  university: "GLA University",
  semester: 5
};
// student.id = "new-id"; // ❌ Compile Error (readonly)
```

### 2. Type Aliases (`type`)
Can describe object shapes, but can also represent primitives, unions, tuples, and intersection types.

```typescript
type ID = string | number; // Union type

type Status = "pending" | "approved" | "rejected"; // Literal union type

type Admin = {
  adminSince: Date;
};

// Intersection type (combines object shapes)
type AdminUser = User & Admin;

const admin: AdminUser = {
  id: "admin-1",
  name: "SuperAdmin",
  email: "admin@pookiz.com",
  adminSince: new Date()
};
```

### Key Differences:
- **Interfaces** support *declaration merging* (defining the same interface twice merges their properties).
- **Types** are more flexible and are required for unions and intersections.
- Rule of thumb: Use `interface` for public APIs/libraries or extending objects. Use `type` for internal components and complex types.

---

## PART 5: Advanced Types

### 1. Union Types (`|`)
Allows a variable to be one of several types.

```typescript
function printId(id: string | number) {
  // Must refine the type before performing operations specific to that type (Type Narrowing)
  if (typeof id === "string") {
    console.log(id.toUpperCase()); // Safe
  } else {
    console.log(id.toFixed(2));    // Safe
  }
}
```

### 2. Intersection Types (`&`)
Combines multiple types into one.

```typescript
interface HasName { name: string; }
interface HasAge { age: number; }

type Person = HasName & HasAge;
```

### 3. Type Assertions (`as`)
Tell TypeScript that you know the type of an object better than it does. Use with caution.

```typescript
const inputElement = document.getElementById("search-input") as HTMLInputElement;
// inputElement is now typed as HTMLInputElement instead of basic HTMLElement
console.log(inputElement.value); // Safe
```

### 4. Non-Null Assertion (`!`)
Assert that a value is not `null` or `undefined`.

```typescript
const element = document.getElementById("header")!;
// element will be treated as HTMLElement, not HTMLElement | null
```

---

## PART 6: Generics

Generics are type parameters. They allow you to write reusable components/functions that work with different types while maintaining type safety.

```typescript
// Generic Function: T is a placeholder replaced with the actual type when called
function getFirstElement<T>(arr: T[]): T {
  return arr[0];
}

const firstNum = getFirstElement<number>([1, 2, 3]); // Type is number
const firstStr = getFirstElement<string>(["a", "b"]); // Type is string

// TypeScript can also infer the type automatically:
const firstBool = getFirstElement([true, false]); // Type is boolean
```

### Generic Interfaces & Types:
```typescript
interface ApiResponse<T> {
  data: T | null;
  error: string | null;
  status: number;
}

type Profile = { username: string; email: string };

const userResponse: ApiResponse<Profile> = {
  data: { username: "arpit", email: "arpit@gla.ac.in" },
  error: null,
  status: 200
};
```

### Generic Constraints:
Restrict the types that a generic parameter can accept using `extends`.

```typescript
interface HasLength {
  length: number;
}

// T must be a type that contains a .length property
function logLength<T extends HasLength>(item: T): void {
  console.log(item.length);
}

logLength("hello"); // ✅ Works (strings have length)
logLength([1, 2]);  // ✅ Works (arrays have length)
// logLength(123);  // ❌ Compile Error (number has no length)
```

---

## PART 7: Utility Types

TypeScript provides several built-in utility types to transform existing types.

```typescript
interface Task {
  id: string;
  title: string;
  description: string;
  completed: boolean;
}

// 1. Partial<T> — Makes all properties optional
type UpdateTaskInput = Partial<Task>;
// Equivalent to: { id?: string; title?: string; ... }

// 2. Required<T> — Makes all properties required
type StrictTask = Required<Task>;

// 3. Readonly<T> — Makes all properties readonly
const myTask: Readonly<Task> = {
  id: "1",
  title: "Learn TS",
  description: "Study hard",
  completed: false
};
// myTask.completed = true; // ❌ Compile Error

// 4. Pick<T, Keys> — Creates a type containing only the specified keys
type TaskPreview = Pick<Task, "id" | "title">;
// Equivalent to: { id: string; title: string; }

// 5. Omit<T, Keys> — Creates a type removing the specified keys
type NewTaskInput = Omit<Task, "id" | "completed">;
// Equivalent to: { title: string; description: string; }

// 6. Record<Keys, Type> — Creates an object mapping key types to value types
type UserRoles = Record<string, "admin" | "user" | "guest">;
const roles: UserRoles = {
  arpit: "admin",
  priya: "user"
};
```

---

## PART 8: tsconfig.json — Core Configurations

TypeScript is configured using the `tsconfig.json` file in the root of the project.

```json
{
  "compilerOptions": {
    "target": "es2022",           /* Compile output to modern JS version */
    "module": "commonjs",         /* Module system (commonjs for Node, esnext for React/Next.js) */
    "lib": ["dom", "es2022"],     /* Libraries available at compile time */
    "strict": true,               /* Enable strict type checking (CRITICAL!) */
    "noImplicitAny": true,        /* Error when variables default to 'any' */
    "strictNullChecks": true,     /* Forces explicit null checks */
    "esModuleInterop": true,       /* Compatibility with CommonJS modules */
    "skipLibCheck": true,         /* Skip type checking of declaration files (.d.ts) */
    "forceConsistentCasingInFileNames": true /* Case sensitive import check */
  }
}
```

---

## Summary: TypeScript Cheat Sheet

| Task | TypeScript Code Pattern |
|---|---|
| **Type Variable** | `const name: string = "Arpit";` |
| **Type Array** | `const arr: number[] = [1, 2];` |
| **Union Type** | `let id: string \| number;` |
| **Object shape (API)** | `interface Profile { name: string; }` |
| **Alias / Unions** | `type Status = "pending" \| "done";` |
| **Destructure Parameters** | `function ({ name }: { name: string })` |
| **Nullable check** | `user?.profile?.username` (Optional chaining) |
| **Generics** | `function fn<T>(val: T): T` |
| **Utility (optional fields)** | `Partial<MyType>` |
| **Utility (select fields)** | `Pick<MyType, 'id' \| 'name'>` |
```
