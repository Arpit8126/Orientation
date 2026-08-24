# JavaScript — Complete Guide from Zero to Real World

JavaScript is the programming language of the web. It makes pages interactive. It runs in browsers AND on servers (via Node.js). It is the most used programming language in the world.

---

## PART 1: Where JavaScript Runs

```html
<!-- Inside HTML file -->
<script>
  console.log("Hello from inside HTML");
</script>

<!-- External file (BEST) -->
<script src="app.js"></script>
<!-- Place at bottom of body OR use defer/async -->

<!-- defer: download while HTML parses, execute after HTML fully parsed -->
<script src="app.js" defer></script>

<!-- async: download while HTML parses, execute as soon as downloaded -->
<!-- Good for independent scripts (analytics, ads) -->
<script src="analytics.js" async></script>

<!-- type="module": enables ES6 modules (import/export) -->
<script type="module" src="app.js"></script>
```

---

## PART 2: Variables

```javascript
// Three ways to declare variables:

// var — OLD way (avoid in modern code)
var name = "Arpit";
// Problems with var:
// 1. Function-scoped (not block-scoped)
// 2. Can be re-declared (var name = "X"; var name = "Y"; — no error)
// 3. Hoisted to top of function (confusing behavior)

// let — modern, block-scoped, can be reassigned
let age = 21;
age = 22;  // ✅ can change value
// let age = 23; // ❌ cannot re-declare in same scope

// const — block-scoped, CANNOT be reassigned
const PI = 3.14159;
// PI = 3; // ❌ TypeError: Assignment to constant variable

// IMPORTANT: const doesn't mean "immutable" for objects/arrays
const user = { name: "Arpit", age: 21 };
user.age = 22;  // ✅ This WORKS — changing property, not variable
user = {};      // ❌ This fails — trying to reassign the variable

const numbers = [1, 2, 3];
numbers.push(4); // ✅ Modifying the array is fine
numbers = [];    // ❌ Reassigning the variable fails

// RULE: Use const by default. Use let when you need to reassign. Never use var.
```

---

## PART 3: Data Types

```javascript
// ===== PRIMITIVE TYPES (stored by value) =====

// String
let message = "Hello World";
let name = 'Arpit';                  // single or double quotes
let greeting = `Hello, ${name}!`;   // template literal (backtick)
let multiLine = `Line 1
Line 2
Line 3`;

// Number (JavaScript has only ONE number type — both int and decimal)
let integer = 42;
let decimal = 3.14;
let negative = -17;
let big = 1_000_000;        // underscores as separators (readability)
let hex = 0xFF;             // hexadecimal
let binary = 0b1010;        // binary
let octal = 0o17;           // octal
let infinity = Infinity;    // positive infinity
let negInfinity = -Infinity;
let notANumber = NaN;       // result of invalid math operations

// Boolean
let isLoggedIn = true;
let hasError = false;

// null — intentionally empty, absence of value
let selectedUser = null;

// undefined — variable declared but no value assigned
let token;          // token is undefined
let x = undefined;  // explicitly set to undefined

// Symbol — unique identifier (rarely used in everyday code)
const id1 = Symbol("id");
const id2 = Symbol("id");
id1 === id2; // false — every Symbol is unique!

// BigInt — for very large integers (beyond Number.MAX_SAFE_INTEGER)
const bigNum = 9007199254740992n; // n suffix makes it BigInt

// ===== CHECKING TYPES =====
typeof "hello"     // "string"
typeof 42          // "number"
typeof true        // "boolean"
typeof undefined   // "undefined"
typeof null        // "object"  ← famous bug in JS (should be "null")
typeof {}          // "object"
typeof []          // "object"  ← arrays are objects!
typeof function(){} // "function"
typeof Symbol()    // "symbol"
typeof 42n         // "bigint"

// Better checks:
Array.isArray([1,2,3])      // true — use for arrays
null === null               // true — use strict equality for null
value instanceof Date       // true — use instanceof for classes
Object.prototype.toString.call([]) // "[object Array]"
```

---

## PART 4: Type Coercion

JavaScript automatically converts types in certain situations:

```javascript
// Implicit coercion (automatic — often surprising)
"5" + 3       // "53" (string concatenation — number converted to string)
"5" - 3       // 2   (subtraction — string converted to number)
"5" * "3"     // 15  (both strings converted to numbers)
true + 1      // 2   (true = 1)
false + 1     // 1   (false = 0)
null + 1      // 1   (null = 0)
undefined + 1 // NaN (undefined = NaN)
"" + 1        // "1" (empty string is falsy but converts to "")

// Explicit coercion (manual — predictable)
Number("42")      // 42
Number("3.14")    // 3.14
Number("")        // 0
Number("abc")     // NaN
Number(true)      // 1
Number(false)     // 0
Number(null)      // 0
Number(undefined) // NaN

parseInt("42px")   // 42 (parses until non-numeric)
parseInt("0xFF")   // 255 (parses hex)
parseFloat("3.14") // 3.14

String(42)        // "42"
String(true)      // "true"
String(null)      // "null"
String(undefined) // "undefined"
(42).toString()   // "42"
(255).toString(16) // "ff" (base 16 = hex)

Boolean(0)          // false
Boolean("")         // false
Boolean(null)       // false
Boolean(undefined)  // false
Boolean(NaN)        // false
Boolean(false)      // false
// Everything else is truthy:
Boolean(1)          // true
Boolean("hello")    // true
Boolean([])         // true  ← empty array is TRUTHY (gotcha!)
Boolean({})         // true  ← empty object is TRUTHY (gotcha!)
```

---

## PART 5: Operators

```javascript
// ===== ARITHMETIC =====
5 + 3   // 8 (addition)
5 - 3   // 2 (subtraction)
5 * 3   // 15 (multiplication)
5 / 2   // 2.5 (division — always float in JS)
5 % 2   // 1 (modulo — remainder)
5 ** 2  // 25 (exponentiation — 5 to the power of 2)
Math.floor(5 / 2) // 2 (integer division)

// Increment/Decrement
let x = 5;
x++;   // post-increment: returns 5, THEN increases to 6
++x;   // pre-increment: increases to 7 FIRST, then returns 7
x--;   // post-decrement
--x;   // pre-decrement

// Assignment operators
x = 10;    // assign
x += 5;    // x = x + 5  →  15
x -= 3;    // x = x - 3  →  12
x *= 2;    // x = x * 2  →  24
x /= 4;    // x = x / 4  →  6
x %= 4;    // x = x % 4  →  2
x **= 3;   // x = x ** 3 →  8

// ===== COMPARISON =====
5 == "5"    // true  (loose equality — type coercion happens)
5 === "5"   // false (strict equality — no type coercion)
5 != "5"    // false
5 !== "5"   // true

5 > 3    // true
5 >= 5   // true
3 < 5    // true
3 <= 3   // true

// ALWAYS USE === and !== in real code. Never ==.

// ===== LOGICAL =====
true && true   // true  (AND — both must be true)
true && false  // false
true || false  // true  (OR — at least one must be true)
false || false // false
!true          // false (NOT)
!false         // true

// Short-circuit evaluation
false && expensiveFunction()  // function NOT called (short-circuit)
true || expensiveFunction()   // function NOT called (short-circuit)

// Practical uses:
const name = user && user.name;        // user.name only if user is truthy
const display = name || "Anonymous";  // fallback if name is falsy

// ===== NULLISH COALESCING (??) =====
// Returns RIGHT side only if LEFT is null OR undefined (not other falsy values)
const value = null ?? "default";     // "default"
const value2 = 0 ?? "default";       // 0 (0 is not null/undefined)
const value3 = "" ?? "default";      // "" (empty string is not null/undefined)
const name2 = user.name ?? "Unknown"; // only fallback if name is null/undefined

// vs logical OR:
const value4 = 0 || "default";    // "default" (treats 0 as falsy — WRONG!)
const value5 = 0 ?? "default";    // 0 (correct — 0 is valid data)

// ===== OPTIONAL CHAINING (?.) =====
// Access nested properties safely — returns undefined instead of throwing error
const city = user?.address?.city;    // undefined if user or address is null
const length = arr?.length;          // undefined if arr is null/undefined
const result = obj?.method();        // undefined if method doesn't exist
const item = arr?.[0];               // undefined if arr is null/undefined

// vs old way:
const city2 = user && user.address && user.address.city; // ugly
const city3 = user?.address?.city; // clean

// ===== TERNARY OPERATOR =====
const label = isLoggedIn ? "Logout" : "Login";
// same as:
// let label;
// if (isLoggedIn) { label = "Logout"; } else { label = "Login"; }

// Nested ternary (readable if short):
const grade = score >= 90 ? "A" : score >= 80 ? "B" : score >= 70 ? "C" : "F";

// ===== SPREAD OPERATOR (...) =====
const arr1 = [1, 2, 3];
const arr2 = [...arr1, 4, 5, 6]; // [1, 2, 3, 4, 5, 6]

const obj1 = { a: 1, b: 2 };
const obj2 = { ...obj1, c: 3 }; // { a: 1, b: 2, c: 3 }

// Clone (shallow copy)
const arrCopy = [...originalArray];
const objCopy = { ...originalObject };

// Merge arrays
const merged = [...arr1, ...arr2];

// Merge objects (later properties override earlier ones)
const merged2 = { ...defaults, ...overrides };

// Pass array items as function arguments
Math.max(...[1, 5, 3, 9, 2]); // 9

// ===== BITWISE OPERATORS (used occasionally) =====
5 & 3    // 1  (AND: 101 & 011 = 001)
5 | 3    // 7  (OR:  101 | 011 = 111)
5 ^ 3    // 6  (XOR: 101 ^ 011 = 110)
~5       // -6 (NOT: flip all bits)
5 << 1   // 10 (left shift: multiply by 2)
5 >> 1   // 2  (right shift: divide by 2)
5 >>> 1  // 2  (unsigned right shift)

// Common bitwise trick: check if number is odd
n & 1 === 1  // odd
n & 1 === 0  // even
```

---

## PART 6: Strings — Complete Reference

```javascript
const str = "Hello, World!";

// ===== LENGTH =====
str.length  // 13

// ===== ACCESS CHARACTERS =====
str[0]       // "H"
str[6]       // "W"
str.charAt(0) // "H" (old way)
str.charCodeAt(0) // 72 (Unicode code of 'H')
String.fromCharCode(72) // "H"

// ===== CASE =====
str.toUpperCase()  // "HELLO, WORLD!"
str.toLowerCase()  // "hello, world!"

// ===== SEARCHING =====
str.indexOf("o")         // 4 (first occurrence, -1 if not found)
str.lastIndexOf("o")     // 8 (last occurrence)
str.includes("World")    // true
str.startsWith("Hello")  // true
str.endsWith("!")        // true
str.search(/\d+/)        // index of first regex match

// ===== EXTRACTING =====
str.slice(0, 5)      // "Hello" (start, end — end not included)
str.slice(-6)        // "World!" (negative = from end)
str.slice(7, 12)     // "World"
str.substring(7, 12) // "World" (like slice but no negative support)

// ===== REPLACING =====
str.replace("World", "JavaScript") // "Hello, JavaScript!" (first occurrence only)
str.replace(/l/g, "L")             // "HeLLo, WorLd!" (regex with g flag = all)
str.replaceAll("l", "L")           // "HeLLo, WorLd!" (modern, no regex needed)

// ===== SPLITTING =====
"a,b,c".split(",")    // ["a", "b", "c"]
"hello".split("")     // ["h", "e", "l", "l", "o"]
"hello world".split(" ") // ["hello", "world"]
"hello".split("", 3)  // ["h", "e", "l"] (limit 3 items)

// ===== TRIMMING =====
"  hello  ".trim()       // "hello"
"  hello  ".trimStart()  // "hello  "
"  hello  ".trimEnd()    // "  hello"

// ===== PADDING =====
"5".padStart(3, "0")  // "005" (useful for numbers: 7 → "007")
"5".padEnd(3, ".")    // "5.."

// ===== REPEATING =====
"ha".repeat(3)  // "hahaha"

// ===== CONCATENATION =====
"Hello" + " " + "World"    // "Hello World"
"Hello".concat(" ", "World") // "Hello World"
`Hello ${"World"}`           // "Hello World" (template literals — PREFERRED)

// ===== TEMPLATE LITERALS =====
const name = "Arpit";
const age = 21;
const message = `Hello ${name}, you are ${age} years old.`;
// Can include any expression:
const result = `${2 + 2} is four`;
const html = `
  <div class="card">
    <h2>${user.name}</h2>
    <p>${user.bio}</p>
  </div>
`;

// Tagged template literals (advanced)
function highlight(strings, ...values) {
  return strings.reduce((acc, str, i) =>
    acc + str + (values[i] ? `<strong>${values[i]}</strong>` : ""), "");
}
const result2 = highlight`Hello ${name}, you are ${age} years old`;
// "Hello <strong>Arpit</strong>, you are <strong>21</strong> years old"

// ===== OTHER USEFUL METHODS =====
"hello".at(0)   // "h" (new — supports negative: "hello".at(-1) = "o")
"hello".at(-1)  // "o"

// Convert array to string
["a", "b", "c"].join(", ")  // "a, b, c"

// Check if string is empty
str.length === 0
str === ""
str.trim().length === 0  // handles whitespace-only strings
```

---

## PART 7: Numbers and Math

```javascript
// ===== NUMBER METHODS =====
(3.14159).toFixed(2)     // "3.14" (returns string!)
(1234.567).toFixed(0)    // "1235" (rounds)

(0.000123).toExponential(2) // "1.23e-4"

(1234567).toLocaleString()  // "1,234,567" (locale-specific)
(1234567).toLocaleString("en-IN") // "12,34,567" (Indian format)

Number.isInteger(42)     // true
Number.isInteger(42.5)   // false
Number.isFinite(Infinity) // false
Number.isFinite(42)      // true
Number.isNaN(NaN)        // true (better than global isNaN!)
Number.isNaN("hello")    // false (global isNaN("hello") would be true — confusing)

Number.MAX_SAFE_INTEGER  // 9007199254740991
Number.MIN_SAFE_INTEGER  // -9007199254740991
Number.EPSILON           // 2.22e-16 (smallest difference)
Number.MAX_VALUE         // largest possible number
Number.MIN_VALUE         // smallest positive number

// ===== MATH OBJECT =====
Math.round(4.6)   // 5 (rounds to nearest)
Math.ceil(4.1)    // 5 (always rounds UP)
Math.floor(4.9)   // 4 (always rounds DOWN)
Math.trunc(4.9)   // 4 (removes decimal — like floor for positive)
Math.trunc(-4.9)  // -4 (different from floor for negative)

Math.abs(-5)    // 5 (absolute value)
Math.pow(2, 10) // 1024
Math.sqrt(16)   // 4
Math.cbrt(27)   // 3 (cube root)

Math.min(1, 3, 2)  // 1
Math.max(1, 3, 2)  // 3
Math.min(...[1,3,2]) // 1 (with spread for arrays)

Math.PI   // 3.14159...
Math.E    // 2.71828...

Math.random()         // 0 to 1 (exclusive) — random float
Math.floor(Math.random() * 10)     // 0 to 9
Math.floor(Math.random() * 10) + 1 // 1 to 10

// Random between min and max (inclusive):
function randomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

Math.log(Math.E) // 1 (natural log)
Math.log2(8)     // 3
Math.log10(1000) // 3

Math.sin(Math.PI / 2) // 1
Math.cos(0)           // 1
Math.tan(Math.PI / 4) // 1

Math.sign(-5)  // -1
Math.sign(0)   // 0
Math.sign(5)   // 1
```

---

## PART 8: Arrays — Complete Reference

```javascript
// ===== CREATING ARRAYS =====
const arr = [1, 2, 3, 4, 5];
const empty = [];
const mixed = [1, "hello", true, null, { name: "Arpit" }];
const fromString = Array.from("hello");  // ["h", "e", "l", "l", "o"]
const withLength = Array.from({ length: 5 }, (_, i) => i * 2); // [0, 2, 4, 6, 8]
const filled = new Array(5).fill(0);  // [0, 0, 0, 0, 0]

// ===== ACCESSING =====
arr[0]          // 1 (first)
arr[arr.length - 1] // 5 (last)
arr.at(-1)      // 5 (modern — negative index from end)
arr.at(-2)      // 4

// ===== ADDING AND REMOVING =====
arr.push(6)        // adds to END, returns new length: [1,2,3,4,5,6]
arr.pop()          // removes from END, returns removed item: 6, arr = [1,2,3,4,5]
arr.unshift(0)     // adds to START, returns new length: [0,1,2,3,4,5]
arr.shift()        // removes from START, returns removed item: 0, arr = [1,2,3,4,5]

// splice — add/remove at any position
arr.splice(2, 1)         // remove 1 item at index 2: arr = [1,2,4,5]
arr.splice(2, 0, 3)      // add 3 at index 2 (remove 0): arr = [1,2,3,4,5]
arr.splice(2, 1, 99)     // replace item at index 2: arr = [1,2,99,4,5]
arr.splice(1, 2)         // remove 2 items starting at index 1
arr.splice(-1)           // remove last element

// ===== SEARCHING =====
arr.indexOf(3)           // 2 (first index of 3, -1 if not found)
arr.lastIndexOf(3)       // last index of 3
arr.includes(3)          // true (does array contain 3?)

arr.find(n => n > 3)          // 4 (first element matching condition)
arr.findIndex(n => n > 3)     // 3 (index of first element matching)
arr.findLast(n => n > 3)      // 5 (last element matching — modern)
arr.findLastIndex(n => n > 3) // 4 (index of last matching — modern)

// ===== ITERATION =====
// forEach — do something for each item (returns undefined)
arr.forEach((item, index, array) => {
  console.log(`arr[${index}] = ${item}`);
});

// map — transform each item, returns NEW array
const doubled = arr.map(n => n * 2);  // [2, 4, 6, 8, 10]
const names = users.map(user => user.name); // extract one property

// filter — keep items that pass a test, returns NEW array
const evens = arr.filter(n => n % 2 === 0);  // [2, 4]
const adults = users.filter(user => user.age >= 18);

// reduce — reduce to single value
const sum = arr.reduce((accumulator, current) => accumulator + current, 0);
// 0 is initial value of accumulator
// iterates: (0+1), (1+2), (3+3), (6+4), (10+5) = 15

const max = arr.reduce((max, n) => n > max ? n : max, -Infinity);

// Build an object from array:
const countByCategory = items.reduce((acc, item) => {
  acc[item.category] = (acc[item.category] || 0) + 1;
  return acc;
}, {});

// reduceRight — same but right to left
arr.reduceRight((acc, n) => acc + n, 0);

// some — returns true if ANY element passes the test
arr.some(n => n > 4)   // true (5 > 4)

// every — returns true if ALL elements pass the test
arr.every(n => n > 0)  // true

// ===== TRANSFORMING =====
// flat — flatten nested arrays
[[1, 2], [3, 4]].flat()       // [1, 2, 3, 4]
[1, [2, [3, [4]]]].flat()     // [1, 2, [3, [4]]] (1 level)
[1, [2, [3, [4]]]].flat(2)    // [1, 2, 3, [4]] (2 levels)
[1, [2, [3, [4]]]].flat(Infinity) // [1, 2, 3, 4] (all levels)

// flatMap — map + flat(1) in one step
[[1, 2], [3, 4]].flatMap(x => x) // [1, 2, 3, 4]
arr.flatMap(n => [n, n * 2])      // [1, 2, 2, 4, 3, 6, 4, 8, 5, 10]

// ===== SORTING =====
// sort mutates original array!
const names = ["Charlie", "Alice", "Bob"];
names.sort() // ["Alice", "Bob", "Charlie"] — alphabetical (default)

const nums = [10, 1, 5, 2, 8];
nums.sort()              // [1, 10, 2, 5, 8] — WRONG! (sorts as strings)
nums.sort((a, b) => a - b)  // [1, 2, 5, 8, 10] — correct ascending
nums.sort((a, b) => b - a)  // [10, 8, 5, 2, 1] — descending

// Sort objects by property
users.sort((a, b) => a.name.localeCompare(b.name)); // alphabetical
users.sort((a, b) => a.age - b.age);                 // by age ascending
users.sort((a, b) => b.createdAt - a.createdAt);     // newest first

// toSorted — returns NEW sorted array (doesn't mutate)
const sorted = nums.toSorted((a, b) => a - b);

// ===== COPYING AND JOINING =====
arr.slice()            // shallow copy entire array
arr.slice(1, 3)        // new array from index 1 to 2
arr.slice(-2)          // last 2 elements

arr.concat([6, 7])     // new array with items added at end
[...arr, 6, 7]         // same with spread

// join — array to string
["a", "b", "c"].join("")    // "abc"
["a", "b", "c"].join(", ")  // "a, b, c"
["a", "b", "c"].join(" | ") // "a | b | c"

// ===== REVERSING =====
arr.reverse()          // reverses IN PLACE (mutates)
[...arr].reverse()     // reverse without mutating
arr.toReversed()       // new reversed array (modern, doesn't mutate)

// ===== DESTRUCTURING =====
const [first, second, ...rest] = [1, 2, 3, 4, 5];
// first = 1, second = 2, rest = [3, 4, 5]

const [, , third] = [1, 2, 3]; // skip with commas: third = 3
const [a = 10, b = 20] = [5]; // default values: a = 5, b = 20

// Swap variables
let x = 1, y = 2;
[x, y] = [y, x]; // x = 2, y = 1

// ===== CHECKING =====
Array.isArray([])   // true
Array.isArray({})   // false

// ===== ADVANCED =====
// Array.from with map
Array.from({ length: 10 }, (_, i) => i + 1) // [1, 2, 3, ..., 10]

// keys, values, entries — iterator methods
for (const [index, value] of arr.entries()) {
  console.log(index, value);
}
[...arr.entries()] // [[0,1], [1,2], [2,3], ...]

// Set operations using arrays
const a = [1, 2, 3, 4];
const b = [3, 4, 5, 6];
const union = [...new Set([...a, ...b])]; // [1, 2, 3, 4, 5, 6]
const intersection = a.filter(n => b.includes(n)); // [3, 4]
const difference = a.filter(n => !b.includes(n));  // [1, 2]
```

---

## PART 9: Objects — Complete Reference

```javascript
// ===== CREATING OBJECTS =====
const user = {
  name: "Arpit",
  age: 21,
  isVerified: true,
  address: {            // nested object
    city: "Mathura",
    state: "UP"
  },
  hobbies: ["coding", "gaming"], // array as value
  greet() {            // method shorthand
    return `Hi, I'm ${this.name}`;
  },
  // same as:
  // greet: function() { return `Hi, I'm ${this.name}`; }
};

// ===== ACCESSING PROPERTIES =====
user.name             // "Arpit" (dot notation)
user["name"]          // "Arpit" (bracket notation — use for dynamic keys)
user.address.city     // "Mathura"
user?.address?.city   // "Mathura" (safe access)

const prop = "name";
user[prop]            // "Arpit" (dynamic property access)

// ===== ADDING / MODIFYING / DELETING =====
user.email = "arpit@example.com"; // add new property
user.age = 22;                    // modify existing
delete user.isVerified;           // remove property

// ===== CHECKING PROPERTIES =====
"name" in user             // true (checks prototype chain too)
user.hasOwnProperty("name") // true (only own properties)
Object.hasOwn(user, "name") // true (modern version)

// ===== DESTRUCTURING =====
const { name, age } = user; // name = "Arpit", age = 22

// Rename while destructuring:
const { name: userName } = user; // userName = "Arpit"

// Default values:
const { role = "user" } = user; // role = "user" (not in object)

// Nested destructuring:
const { address: { city } } = user; // city = "Mathura"

// Rest in destructuring:
const { name: n, ...rest } = user;
// n = "Arpit", rest = { age: 22, address: {...}, hobbies: [...] }

// Function parameter destructuring:
function greetUser({ name, age, role = "user" }) {
  return `Hi ${name} (${role}), age ${age}`;
}
greetUser(user);

// ===== SPREADING OBJECTS =====
const defaults = { theme: "light", language: "en", notifications: true };
const userPrefs = { theme: "dark" };
const settings = { ...defaults, ...userPrefs }; // { theme: "dark", language: "en", notifications: true }
// Later properties override earlier ones!

// Shallow clone:
const clone = { ...original };

// ===== OBJECT METHODS =====
const keys = Object.keys(user);        // ["name", "age", "address", "hobbies", "greet"]
const values = Object.values(user);     // ["Arpit", 22, {...}, [...], f]
const entries = Object.entries(user);  // [["name","Arpit"], ["age",22], ...]

// Convert entries back to object
const obj = Object.fromEntries([["a", 1], ["b", 2]]); // { a: 1, b: 2 }
// Transform object values:
const doubled = Object.fromEntries(
  Object.entries(prices).map(([key, val]) => [key, val * 2])
);

Object.assign(target, source1, source2); // merge into target (mutates target)
const merged = Object.assign({}, obj1, obj2); // merge into new object

Object.freeze(user);  // makes object immutable (can't add/modify/delete)
Object.isFrozen(user); // true

Object.seal(user);   // can modify existing but can't add/delete
Object.isSealed(user); // true

Object.create(proto); // create object with given prototype
Object.getPrototypeOf(obj); // get prototype

// Property descriptors
Object.defineProperty(user, "id", {
  value: "user-123",
  writable: false,    // cannot be changed
  enumerable: false,  // won't show in loops / Object.keys
  configurable: false // cannot be redefined or deleted
});

Object.getOwnPropertyNames(user); // all own property names (including non-enumerable)
Object.getOwnPropertyDescriptor(user, "name"); // descriptor object

// ===== COMPUTED PROPERTY NAMES =====
const prefix = "user";
const obj = {
  [`${prefix}Name`]: "Arpit",  // computed key: "userName"
  [`${prefix}Age`]: 21,         // computed key: "userAge"
};

// ===== SHORTHAND PROPERTIES =====
const name2 = "Arpit";
const age2 = 21;
const obj2 = { name2, age2 };  // same as { name2: name2, age2: age2 }

// ===== GETTERS AND SETTERS =====
const person = {
  _firstName: "Arpit",
  _lastName: "Pandey",
  get fullName() {
    return `${this._firstName} ${this._lastName}`;
  },
  set fullName(value) {
    const parts = value.split(" ");
    this._firstName = parts[0];
    this._lastName = parts[1];
  }
};
person.fullName;           // "Arpit Pandey" (calls getter)
person.fullName = "Raj Kumar"; // calls setter
person._firstName;         // "Raj"
```

---

## PART 10: Functions — Complete Reference

```javascript
// ===== FUNCTION DECLARATION =====
function greet(name) {
  return `Hello, ${name}!`;
}
// Hoisted — can be called BEFORE declaration in code

// ===== FUNCTION EXPRESSION =====
const greet2 = function(name) {
  return `Hello, ${name}!`;
};
// NOT hoisted — must be declared before calling

// ===== ARROW FUNCTIONS =====
const greet3 = (name) => `Hello, ${name}!`;
// If single parameter: can omit parentheses
const double = n => n * 2;
// If single expression: can omit braces and return keyword
// If multiple statements: must use braces and explicit return
const greet4 = (name) => {
  const message = `Hello, ${name}!`;
  console.log(message);
  return message;
};

// Arrow function differences:
// 1. No own `this` — inherits from surrounding scope
// 2. No `arguments` object
// 3. Cannot be used as constructors (no `new`)
// 4. No `prototype` property

// ===== DEFAULT PARAMETERS =====
function createUser(name, role = "user", active = true) {
  return { name, role, active };
}
createUser("Arpit");           // { name: "Arpit", role: "user", active: true }
createUser("Arpit", "admin");  // { name: "Arpit", role: "admin", active: true }

// Default can reference previous parameters:
function greet5(name, greeting = `Hello, ${name}`) {
  return greeting;
}

// ===== REST PARAMETERS =====
function sum(...numbers) {
  return numbers.reduce((acc, n) => acc + n, 0);
}
sum(1, 2, 3, 4, 5); // 15
// numbers = [1, 2, 3, 4, 5]

function logArgs(first, second, ...rest) {
  console.log(first, second, rest);
}
logArgs(1, 2, 3, 4, 5);
// first=1, second=2, rest=[3,4,5]

// ===== ARGUMENTS OBJECT (old way, avoid in modern code) =====
function oldSum() {
  // arguments = array-like object with all passed arguments
  let total = 0;
  for (let i = 0; i < arguments.length; i++) {
    total += arguments[i];
  }
  return total;
}
// Arrow functions don't have arguments — use rest parameters instead

// ===== FIRST-CLASS FUNCTIONS =====
// Functions can be:
// 1. Assigned to variables (already seen)
// 2. Passed as arguments
// 3. Returned from functions

// Passed as argument (callback):
const numbers = [1, 2, 3, 4, 5];
numbers.filter(isEven); // pass function by name
numbers.filter(n => n % 2 === 0); // or use anonymous function

function isEven(n) { return n % 2 === 0; }

// ===== HIGHER-ORDER FUNCTIONS =====
// Functions that take or return other functions

function multiply(factor) {
  return function(number) {
    return number * factor;
  };
}
const double2 = multiply(2);
const triple = multiply(3);
double2(5); // 10
triple(5);  // 15

// ===== IIFE — Immediately Invoked Function Expression =====
(function() {
  // Runs immediately, has its own scope
  // Used to avoid polluting global scope
  const private = "nobody sees this";
})();

// Arrow function IIFE:
(() => {
  console.log("Runs immediately");
})();

// IIFE with return value:
const result = (() => {
  return 42;
})();
```

---

## PART 11: Scope, Hoisting and Closure

```javascript
// ===== SCOPE =====
let globalVar = "I'm global";  // accessible everywhere

function outer() {
  let outerVar = "I'm in outer";  // only accessible in outer and inner

  function inner() {
    let innerVar = "I'm in inner";  // only accessible in inner
    console.log(globalVar);  // ✅ can access outer scopes
    console.log(outerVar);   // ✅ can access outer scopes
    console.log(innerVar);   // ✅ own scope
  }

  inner();
  // console.log(innerVar); // ❌ cannot access inner's scope
}

// Block scope (let and const):
{
  let blockScoped = "only here";
  const alsoBlocked = "only here too";
  var notBlocked = "accessible outside!"; // var ignores blocks!
}
// console.log(blockScoped); // ❌ ReferenceError
console.log(notBlocked);     // ✅ "accessible outside!"

// ===== HOISTING =====
// var declarations are moved to top of function:
console.log(x); // undefined (NOT an error — hoisted but not initialized)
var x = 5;
console.log(x); // 5

// Function declarations are fully hoisted:
greet("Arpit"); // ✅ Works! "Hello Arpit"
function greet(name) { return `Hello ${name}`; }

// let and const are hoisted but in "temporal dead zone":
// console.log(y); // ❌ ReferenceError (cannot access before initialization)
let y = 10;

// ===== CLOSURES =====
// A closure is a function that "remembers" the variables from its outer scope
// even after the outer function has returned.

function makeCounter() {
  let count = 0;  // This variable is "closed over"

  return {
    increment() { count++; },
    decrement() { count--; },
    getCount() { return count; }
  };
}

const counter = makeCounter();
counter.increment(); // count is now 1 (private to this closure)
counter.increment(); // count is now 2
counter.getCount();  // 2

const counter2 = makeCounter(); // NEW closure — separate count
counter2.getCount(); // 0 (independent of counter)

// Common use case: factory functions with private state
function createUser(name) {
  let loginCount = 0;  // private

  return {
    name,
    login() {
      loginCount++;
      console.log(`${name} logged in. Total: ${loginCount}`);
    },
    getLoginCount() {
      return loginCount;
    }
  };
}

// Common closure bug (var in loop):
for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 1000); // prints 3, 3, 3 (bug!)
}

// Fix 1: Use let (block scope)
for (let i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 1000); // prints 0, 1, 2 ✅
}

// Fix 2: IIFE closure (older technique)
for (var i = 0; i < 3; i++) {
  ((j) => setTimeout(() => console.log(j), 1000))(i);
}
```

---

## PART 12: `this` Keyword

```javascript
// `this` depends on HOW a function is called, not where it's defined

// 1. Global context
console.log(this); // window (browser) or global (Node.js)

// 2. Regular function (non-strict mode)
function show() {
  console.log(this); // window (browser)
}

// Regular function (strict mode)
"use strict";
function show2() {
  console.log(this); // undefined
}

// 3. Object method
const user = {
  name: "Arpit",
  greet() {
    console.log(this.name); // "Arpit" — this = user object
  }
};
user.greet(); // ✅ "Arpit"

// But if you extract the method:
const greetFn = user.greet;
greetFn(); // ❌ undefined — this is now window/undefined

// 4. Arrow functions (NO own `this`)
const user2 = {
  name: "Arpit",
  greet: () => {
    console.log(this.name); // undefined! Arrow uses outer this (window)
  },
  greetCorrect() {
    // Use regular function for methods!
    const arrowFn = () => {
      console.log(this.name); // "Arpit" — inherits from greetCorrect
    };
    arrowFn();
  }
};

// 5. Explicit binding
function introduce(greeting, punctuation) {
  return `${greeting}, I'm ${this.name}${punctuation}`;
}
const person = { name: "Arpit" };

introduce.call(person, "Hello", "!");        // "Hello, I'm Arpit!"
introduce.apply(person, ["Hello", "!"]);     // same — apply takes array
const boundIntro = introduce.bind(person);   // creates new function permanently bound
boundIntro("Hi", ".");                       // "Hi, I'm Arpit."

// 6. Class (constructor)
class User {
  constructor(name) {
    this.name = name;  // this = the new instance
  }
  greet() {
    return `Hi, I'm ${this.name}`; // this = instance
  }
}

// 7. Event handlers
button.addEventListener("click", function() {
  console.log(this); // the button element
});

button.addEventListener("click", () => {
  console.log(this); // window (arrow has no own this)
});
```

---

## PART 13: Prototypes and Classes

```javascript
// ===== PROTOTYPES =====
// Every object has a hidden [[Prototype]] link to another object
// When you access a property, JS looks up the prototype chain

const animal = {
  speak() {
    return `${this.name} makes a sound`;
  }
};

const dog = Object.create(animal); // dog's prototype = animal
dog.name = "Rex";
dog.bark = function() { return "Woof!"; };

dog.speak(); // "Rex makes a sound" — found on prototype!
dog.bark();  // "Woof!" — own method
dog.toString(); // found on Object.prototype (top of chain)

// prototype chain: dog → animal → Object.prototype → null

// ===== CONSTRUCTOR FUNCTIONS (old way) =====
function Animal(name, type) {
  this.name = name;  // own property (created on each instance)
  this.type = type;
}
// Methods go on prototype (shared across all instances):
Animal.prototype.speak = function() {
  return `${this.name} says hello`;
};

const cat = new Animal("Whiskers", "cat");
cat.speak(); // "Whiskers says hello"

// ===== CLASSES (modern ES6+ way) =====
class Animal2 {
  // Private fields (truly private — can only be accessed inside class)
  #id;
  #createdAt;

  constructor(name, type) {
    this.name = name;    // public instance property
    this.type = type;
    this.#id = Math.random().toString(36);  // private
    this.#createdAt = new Date();
  }

  // Instance method (on prototype — shared)
  speak() {
    return `${this.name} (${this.type}) says hello`;
  }

  // Getter
  get info() {
    return `${this.name} is a ${this.type}`;
  }

  // Setter
  set info(value) {
    const [name, , type] = value.split(" ");
    this.name = name;
    this.type = type;
  }

  // Static method — called on the CLASS, not on instances
  static create(name, type) {
    return new Animal2(name, type);
  }

  // Static property
  static count = 0;

  // Private method
  #generateId() {
    return Math.random().toString(36);
  }

  // toString override
  toString() {
    return `Animal(${this.name})`;
  }
}

// ===== INHERITANCE =====
class Dog extends Animal2 {
  constructor(name, breed) {
    super(name, "dog"); // MUST call super() before using this
    this.breed = breed;
  }

  bark() {
    return "Woof!";
  }

  // Override parent method
  speak() {
    return `${super.speak()} AND barks!`; // super.method() calls parent
  }
}

const rex = new Dog("Rex", "Labrador");
rex.speak();  // "Rex (dog) says hello AND barks!"
rex.bark();   // "Woof!"

rex instanceof Dog;     // true
rex instanceof Animal2; // true (inheritance)

// ===== MIXINS (multiple inheritance workaround) =====
const Serializable = (Base) => class extends Base {
  serialize() {
    return JSON.stringify(this);
  }
};

const Loggable = (Base) => class extends Base {
  log() {
    console.log(`[${new Date().toISOString()}]`, this);
  }
};

class Entity {
  constructor(id) { this.id = id; }
}

class User3 extends Serializable(Loggable(Entity)) {
  constructor(id, name) {
    super(id);
    this.name = name;
  }
}

const user3 = new User3("1", "Arpit");
user3.serialize(); // "{\"id\":\"1\",\"name\":\"Arpit\"}"
user3.log();       // logs with timestamp
```

---

## PART 14: Promises and Asynchronous JavaScript

```javascript
// ===== WHY ASYNC? =====
// JavaScript is single-threaded — only one thing runs at a time
// But we need to do things that take time (network calls, timers)
// Without async, the entire program would freeze while waiting

// ===== CALLBACKS (old way — leads to "callback hell") =====
getUserFromDatabase(userId, function(user) {
  getOrdersForUser(user.id, function(orders) {
    getProductDetails(orders[0].productId, function(product) {
      // 5 levels deep = callback hell / pyramid of doom
      renderPage(user, orders, product, function(html) {
        displayPage(html, function() {
          console.log("Done! But this is unreadable!");
        });
      });
    });
  });
});

// ===== PROMISES =====
// A Promise is an object that represents a value that will be available later
// It has 3 states: pending → fulfilled | rejected

// Creating a Promise:
const fetchUser = new Promise((resolve, reject) => {
  // resolve(value) — called when successful
  // reject(error) — called when failed

  setTimeout(() => {
    const success = true;
    if (success) {
      resolve({ id: "1", name: "Arpit" }); // fulfilled
    } else {
      reject(new Error("User not found"));  // rejected
    }
  }, 1000);
});

// Using a Promise:
fetchUser
  .then(user => {            // runs on success
    console.log(user);
    return user.id;          // can chain — returned value becomes next .then's input
  })
  .then(id => {
    return fetchOrders(id);  // return another promise for chaining
  })
  .then(orders => {
    console.log(orders);
  })
  .catch(error => {          // runs on any rejection
    console.error("Error:", error.message);
  })
  .finally(() => {           // runs ALWAYS (success or failure)
    hideLoadingSpinner();
  });

// ===== PROMISE STATIC METHODS =====

// Promise.all — wait for ALL promises, fail if ANY fails
const [user, orders, products] = await Promise.all([
  fetchUser(userId),
  fetchOrders(userId),
  fetchProducts(),
]);

// Promise.allSettled — wait for ALL, never fails, gives all results
const results = await Promise.allSettled([
  fetchUser(userId),
  fetchOrders(userId),
  mightFail(),
]);
results.forEach(result => {
  if (result.status === "fulfilled") {
    console.log("Success:", result.value);
  } else {
    console.log("Failed:", result.reason);
  }
});

// Promise.race — resolves/rejects as soon as FIRST one settles
const fastest = await Promise.race([
  fetchFromServer1(),
  fetchFromServer2(),
]);

// Promise.any — resolves when ANY succeeds, fails only if ALL fail
const firstSuccess = await Promise.any([
  mightFail1(),
  mightFail2(),
  willSucceed(),
]);

// Promise.resolve / Promise.reject — create already-settled promises
Promise.resolve(42).then(v => console.log(v)); // 42
Promise.reject(new Error("oops")).catch(e => console.log(e));
```

---

## PART 15: async/await

```javascript
// async/await is syntactic sugar over Promises — makes async code look synchronous

// async function always returns a Promise
async function fetchUserData(userId) {
  // await pauses execution until the Promise resolves
  const response = await fetch(`https://api.example.com/users/${userId}`);
  // execution continues here only after the fetch is done

  const user = await response.json();
  // execution continues here only after JSON is parsed

  return user; // wraps in Promise.resolve(user) automatically
}

// Using an async function:
fetchUserData("123")
  .then(user => console.log(user))
  .catch(err => console.error(err));

// OR with async/await (inside another async function):
async function main() {
  const user = await fetchUserData("123");
  console.log(user);
}

// ===== ERROR HANDLING WITH TRY/CATCH =====
async function loadProfile(userId) {
  try {
    const user = await fetchUser(userId);      // might throw
    const profile = await fetchProfile(user.id); // might throw
    return { user, profile };
  } catch (error) {
    // Catches errors from ANY await in the try block
    console.error("Failed to load profile:", error.message);
    return null;
  } finally {
    hideLoader(); // always runs
  }
}

// ===== PARALLEL vs SEQUENTIAL =====
// Sequential (slower — each waits for previous):
async function sequential() {
  const user = await fetchUser();       // waits 1 second
  const orders = await fetchOrders();   // waits 1 second after user
  const products = await fetchProducts(); // waits 1 second after orders
  // Total: ~3 seconds
}

// Parallel (faster — all run simultaneously):
async function parallel() {
  const [user, orders, products] = await Promise.all([
    fetchUser(),
    fetchOrders(),
    fetchProducts(),
  ]);
  // Total: ~1 second (all run at same time)
}

// ===== ASYNC ITERATION =====
async function processStream(stream) {
  for await (const chunk of stream) {
    process(chunk);
  }
}

// ===== ASYNC IN ARRAY METHODS =====
// ❌ WRONG — forEach doesn't await
arr.forEach(async (item) => {
  await processItem(item); // not awaited by forEach!
});

// ✅ CORRECT — use for...of loop
for (const item of arr) {
  await processItem(item); // properly awaited, sequential
}

// ✅ CORRECT — parallel with Promise.all
await Promise.all(arr.map(item => processItem(item)));
```

---

## PART 16: Error Handling

```javascript
// ===== TRY/CATCH/FINALLY =====
try {
  const result = riskyOperation();
  console.log(result);
} catch (error) {
  // error is an Error object with message and stack properties
  console.error(error.message); // readable message
  console.error(error.stack);   // full stack trace
  console.error(error.name);    // error type ("TypeError", "ReferenceError", etc.)
} finally {
  // Always runs — use for cleanup
  closeConnection();
}

// ===== THROWING ERRORS =====
function divide(a, b) {
  if (b === 0) {
    throw new Error("Cannot divide by zero");
    // OR throw specific error types:
    throw new TypeError("b must be a number");
    throw new RangeError("b must not be zero");
  }
  return a / b;
}

// ===== CUSTOM ERROR CLASSES =====
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = "ValidationError";
    this.field = field;
  }
}

class NetworkError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.name = "NetworkError";
    this.statusCode = statusCode;
  }
}

// Using custom errors:
function validateUser(user) {
  if (!user.name) throw new ValidationError("Name is required", "name");
  if (!user.email.includes("@")) throw new ValidationError("Invalid email", "email");
}

try {
  validateUser({ name: "", email: "invalid" });
} catch (error) {
  if (error instanceof ValidationError) {
    console.log(`Validation error on field: ${error.field}`);
  } else if (error instanceof NetworkError) {
    console.log(`Network error: ${error.statusCode}`);
  } else {
    throw error; // re-throw unknown errors
  }
}

// ===== ERROR TYPES =====
try {
  null.property;  // TypeError
} catch(e) { console.log(e.name); } // "TypeError"

try {
  undeclaredVar; // ReferenceError
} catch(e) { console.log(e.name); }

try {
  eval("{"); // SyntaxError
} catch(e) { console.log(e.name); }

try {
  new Array(-1); // RangeError
} catch(e) { console.log(e.name); }

// AggregateError — for multiple errors (from Promise.any)
try {
  await Promise.any([
    Promise.reject(new Error("Error 1")),
    Promise.reject(new Error("Error 2")),
  ]);
} catch (e) {
  console.log(e instanceof AggregateError); // true
  console.log(e.errors); // [Error: "Error 1", Error: "Error 2"]
}
```

---

## PART 17: DOM Manipulation

```javascript
// ===== SELECTING ELEMENTS =====
document.getElementById("header")              // by id (returns element or null)
document.querySelector(".card")               // first match (CSS selector)
document.querySelectorAll(".card")            // all matches (NodeList)
document.querySelector("input[type='email']") // any CSS selector
document.querySelector("#form > .submit-btn") // nested selector

document.getElementsByClassName("card")  // HTMLCollection (live)
document.getElementsByTagName("div")     // HTMLCollection (live)
document.getElementsByName("username")   // NodeList

// Starting from a specific element:
const form = document.querySelector("form");
form.querySelector("input")              // first input inside form
form.querySelectorAll("input")           // all inputs inside form

// Traversal:
element.parentElement              // parent element
element.parentNode                 // parent node (could be text node)
element.children                   // HTMLCollection of child elements
element.childNodes                 // NodeList of all child nodes
element.firstElementChild          // first child element
element.lastElementChild           // last child element
element.nextElementSibling         // next sibling element
element.previousElementSibling     // previous sibling element
element.closest(".card")           // nearest ancestor matching selector

// ===== READING/WRITING CONTENT =====
element.textContent         // gets/sets text (strips HTML tags, safe)
element.innerHTML           // gets/sets HTML (parses HTML, XSS risk!)
element.innerText           // gets visible text only (respects CSS visibility)
element.outerHTML           // gets element including itself
element.value               // for inputs, textareas, selects

element.textContent = "Hello <b>World</b>"; // renders literally: "Hello <b>World</b>"
element.innerHTML = "Hello <b>World</b>";   // renders: Hello World (bold)
// NEVER set innerHTML with user-provided data — XSS security vulnerability!

// ===== CREATING ELEMENTS =====
const div = document.createElement("div");
const text = document.createTextNode("Hello");
const fragment = document.createDocumentFragment();
// Fragment is off-DOM — batch changes then insert once (performance)

// ===== INSERTING ELEMENTS =====
parent.appendChild(child);         // add at end
parent.prepend(child);             // add at start (modern)
parent.append(child1, child2);    // add multiple at end (modern)
parent.insertBefore(new, reference); // insert before reference element
reference.after(new);             // insert after reference (modern)
reference.before(new);            // insert before reference (modern)

// insertAdjacentHTML — fast HTML insertion
element.insertAdjacentHTML("beforebegin", "<div>Before</div>");
element.insertAdjacentHTML("afterbegin", "<div>First child</div>");
element.insertAdjacentHTML("beforeend", "<div>Last child</div>");
element.insertAdjacentHTML("afterend", "<div>After</div>");

// ===== REMOVING ELEMENTS =====
element.remove();                  // remove self
parent.removeChild(child);         // remove child (older)
parent.replaceChild(newEl, oldEl); // replace child
element.replaceWith(newEl);        // replace self with new element

// ===== ATTRIBUTES =====
element.getAttribute("src")        // get attribute
element.setAttribute("src", "new.jpg") // set attribute
element.removeAttribute("disabled") // remove attribute
element.hasAttribute("disabled")    // check if exists

element.id                // get/set id
element.className         // get/set class string
element.name              // get/set name

// ===== CLASSES =====
element.classList.add("active", "highlight")    // add classes
element.classList.remove("active")              // remove class
element.classList.toggle("active")             // add if absent, remove if present
element.classList.toggle("dark", true)         // force add
element.classList.toggle("dark", false)        // force remove
element.classList.contains("active")           // check if has class
element.classList.replace("old", "new")        // replace class

// ===== STYLES =====
element.style.color = "red";           // set inline style
element.style.backgroundColor = "blue"; // camelCase for hyphenated properties
element.style.cssText = "color: red; font-size: 16px;"; // set multiple at once
element.style.removeProperty("color"); // remove inline style

// Get computed style (includes CSS file styles):
const computed = getComputedStyle(element);
computed.getPropertyValue("color");    // actual current color
computed.fontSize;                     // actual font-size

// ===== DIMENSIONS AND POSITION =====
element.offsetWidth    // width including padding and border
element.offsetHeight   // height including padding and border
element.clientWidth    // width including padding, excluding border
element.clientHeight   // height including padding, excluding border
element.scrollWidth    // total scrollable width
element.scrollHeight   // total scrollable height
element.scrollTop      // how much has been scrolled vertically
element.scrollLeft     // how much has been scrolled horizontally

const rect = element.getBoundingClientRect();
rect.top     // distance from viewport top
rect.left    // distance from viewport left
rect.right   // distance from viewport right
rect.bottom  // distance from viewport bottom
rect.width   // element width
rect.height  // element height

element.scrollIntoView();              // scroll element into view
element.scrollIntoView({ behavior: "smooth", block: "center" });

// Window scroll
window.scrollTo(0, 0);               // scroll to top
window.scrollTo({ top: 500, behavior: "smooth" });
window.scrollY;                       // current vertical scroll position
window.scrollX;                       // current horizontal scroll position
```

---

## PART 18: Events — Complete Reference

```javascript
// ===== ADDING EVENT LISTENERS =====
element.addEventListener("click", handler);
element.addEventListener("click", handler, { once: true });    // run only once
element.addEventListener("click", handler, { passive: true }); // for scroll events
element.addEventListener("click", handler, { capture: true }); // capture phase

// Remove listener (must reference same function):
element.removeEventListener("click", handler);

// ===== COMMON EVENTS =====
// Mouse events:
"click"         // single click
"dblclick"      // double click
"mousedown"     // mouse button pressed
"mouseup"       // mouse button released
"mousemove"     // mouse moves over element
"mouseenter"    // mouse enters element (no bubbling)
"mouseleave"    // mouse leaves element (no bubbling)
"mouseover"     // mouse enters element OR child (bubbles)
"mouseout"      // mouse leaves element OR child (bubbles)
"contextmenu"   // right-click
"wheel"         // mouse wheel scroll

// Keyboard events:
"keydown"       // key pressed (fires repeatedly when held)
"keyup"         // key released
"keypress"      // deprecated, use keydown

// Form events:
"submit"        // form submitted
"change"        // value changed and element loses focus
"input"         // value changes (fires on every keystroke)
"focus"         // element gains focus
"blur"          // element loses focus
"focusin"       // focus (bubbles unlike focus)
"focusout"      // blur (bubbles unlike blur)
"reset"         // form reset

// Window events:
"load"          // page fully loaded (including images)
"DOMContentLoaded" // HTML parsed (use this instead of load usually)
"resize"        // window resized
"scroll"        // page scrolled
"beforeunload"  // about to close/navigate away
"unload"        // page unloaded
"online"        // browser came online
"offline"       // browser went offline

// Drag and drop:
"dragstart"     // starts dragging
"drag"          // dragging
"dragend"       // drag ended
"dragover"      // dragging over target (must preventDefault!)
"dragenter"     // entered target
"dragleave"     // left target
"drop"          // dropped on target (must preventDefault!)

// Touch events (mobile):
"touchstart"    // finger touched screen
"touchmove"     // finger moved
"touchend"      // finger lifted
"touchcancel"   // touch interrupted

// Clipboard:
"copy"          // user copies
"cut"           // user cuts
"paste"         // user pastes

// Animation and Transition:
"animationstart"
"animationend"
"animationiteration"
"transitionend"

// Custom events:
const event = new CustomEvent("userLoggedIn", {
  detail: { userId: "123", name: "Arpit" },
  bubbles: true,
  cancelable: true,
});
element.dispatchEvent(event);
element.addEventListener("userLoggedIn", (e) => console.log(e.detail));

// ===== THE EVENT OBJECT =====
element.addEventListener("click", (event) => {
  event.type           // "click"
  event.target         // element that was clicked
  event.currentTarget  // element the listener is attached to
  event.bubbles        // true (does this event bubble?)
  event.cancelable     // true (can it be prevented?)
  event.defaultPrevented // true if preventDefault was called
  event.timeStamp      // when event occurred

  // Mouse-specific:
  event.clientX, event.clientY   // position relative to viewport
  event.pageX, event.pageY       // position relative to document
  event.offsetX, event.offsetY   // position relative to target element
  event.screenX, event.screenY   // position relative to screen
  event.button  // 0=left, 1=middle, 2=right
  event.buttons // bitmask of all pressed buttons
  event.altKey, event.ctrlKey, event.shiftKey, event.metaKey // modifier keys

  // Keyboard-specific:
  event.key      // "a", "Enter", "ArrowLeft", " " (space), etc.
  event.code     // "KeyA", "Enter", "ArrowLeft", "Space" (physical key)
  event.keyCode  // deprecated (numeric code)

  // Preventing default behavior:
  event.preventDefault(); // stop default action (form submit, link follow, etc.)

  // Stopping event propagation:
  event.stopPropagation(); // stop bubbling up the DOM
  event.stopImmediatePropagation(); // stop AND prevent other listeners on same element
});

// ===== EVENT BUBBLING AND CAPTURING =====
/*
  Capturing phase: event travels DOWN from document → target element
  Target phase: event is at the target
  Bubbling phase: event travels UP from target → document

  By default, listeners run in BUBBLING phase
  Use { capture: true } to run in CAPTURING phase
*/

document.addEventListener("click", (e) => {
  console.log("document clicked — BUBBLING PHASE");
});
div.addEventListener("click", (e) => {
  console.log("div clicked");
  e.stopPropagation(); // stop here — document won't hear it
});

// ===== EVENT DELEGATION =====
// Instead of listeners on each child, one listener on parent
// More efficient, works for dynamically added elements

// ❌ BAD — listener on each item
document.querySelectorAll(".todo-item").forEach(item => {
  item.addEventListener("click", handleTodoClick);
});

// ✅ GOOD — one listener on parent
document.querySelector(".todo-list").addEventListener("click", (event) => {
  const item = event.target.closest(".todo-item");
  if (item) {
    handleTodoClick(item);
  }
});
```

---

## PART 19: Fetch API and HTTP Requests

```javascript
// ===== BASIC FETCH =====
const response = await fetch("https://api.example.com/users");
// fetch returns a Promise that resolves to Response object

const data = await response.json();    // parse JSON body
const text = await response.text();    // get text body
const blob = await response.blob();    // get binary data (images, files)
const buffer = await response.arrayBuffer(); // raw binary

// ===== RESPONSE PROPERTIES =====
response.ok          // true if status 200-299
response.status      // 200, 404, 500, etc.
response.statusText  // "OK", "Not Found", "Internal Server Error"
response.headers     // Headers object
response.url         // final URL (after redirects)
response.redirected  // true if redirected

// ===== GET REQUEST =====
async function getUsers() {
  const response = await fetch("/api/users");

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }

  return response.json();
}

// ===== POST REQUEST =====
async function createUser(userData) {
  const response = await fetch("/api/users", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
    body: JSON.stringify(userData),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.message || "Failed to create user");
  }

  return response.json();
}

// ===== PUT / PATCH / DELETE =====
// PUT — replace entire resource
await fetch(`/api/users/${id}`, {
  method: "PUT",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify(updatedData),
});

// PATCH — partial update
await fetch(`/api/users/${id}`, {
  method: "PATCH",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ name: "New Name" }),
});

// DELETE
await fetch(`/api/users/${id}`, {
  method: "DELETE",
  headers: { "Authorization": `Bearer ${token}` },
});

// ===== SENDING FORM DATA =====
const formData = new FormData();
formData.append("name", "Arpit");
formData.append("avatar", fileInput.files[0]);

await fetch("/api/upload", {
  method: "POST",
  body: formData, // Don't set Content-Type! Browser sets it with boundary
});

// ===== URL WITH QUERY PARAMS =====
const params = new URLSearchParams({
  page: 1,
  limit: 20,
  search: "arpit",
  sort: "name",
});
const response2 = await fetch(`/api/users?${params}`);
// URL: /api/users?page=1&limit=20&search=arpit&sort=name

// ===== ABORT REQUESTS =====
const controller = new AbortController();
const { signal } = controller;

const fetchPromise = fetch("/api/slow-endpoint", { signal });

// Cancel after 5 seconds:
const timeoutId = setTimeout(() => controller.abort(), 5000);

try {
  const response3 = await fetchPromise;
  clearTimeout(timeoutId);
  return response3.json();
} catch (error) {
  if (error.name === "AbortError") {
    console.log("Request cancelled");
  }
}

// ===== READING HEADERS =====
response.headers.get("Content-Type")  // "application/json"
response.headers.get("X-Total-Count") // custom header
for (const [key, value] of response.headers) {
  console.log(key, value);
}
```

---

## PART 20: Modules (import/export)

```javascript
// ===== NAMED EXPORTS =====
// utils.js
export function formatDate(date) {
  return date.toLocaleDateString("en-IN");
}

export function formatCurrency(amount) {
  return `₹${amount.toLocaleString("en-IN")}`;
}

export const TAX_RATE = 0.18;

export class Calculator {
  add(a, b) { return a + b; }
}

// ===== DEFAULT EXPORT (only one per file) =====
// user.js
export default class UserService {
  async getUser(id) { ... }
  async updateUser(id, data) { ... }
}

// ===== IMPORTING =====
// Named imports:
import { formatDate, formatCurrency } from "./utils.js";
import { formatDate as fDate } from "./utils.js"; // rename
import * as utils from "./utils.js";  // import all as namespace
utils.formatDate(new Date());

// Default import (can name it anything):
import UserService from "./user.js";
import MyUserService from "./user.js"; // same thing, different local name

// Mixed:
import UserService, { formatDate } from "./module.js";

// Side effects only (run module but don't import anything):
import "./init.js";

// Dynamic imports (lazy loading):
const module = await import("./heavy-module.js");
module.default(); // use default export

// Conditional import:
if (isDev) {
  const { debug } = await import("./debug-tools.js");
  debug();
}

// ===== RE-EXPORTING =====
// index.js — barrel file
export { formatDate, formatCurrency } from "./utils.js";
export { default as UserService } from "./user.js";
export * from "./constants.js";

// Then consumers import from one place:
import { formatDate, UserService, TAX_RATE } from "./index.js";
```

---

## PART 21: Iterators, Generators, and Symbols

```javascript
// ===== ITERATORS =====
// An iterator is an object with a next() method that returns { value, done }

const range = {
  from: 1,
  to: 5,
  [Symbol.iterator]() {  // makes object iterable
    let current = this.from;
    const last = this.to;
    return {
      next() {
        if (current <= last) {
          return { value: current++, done: false };
        }
        return { value: undefined, done: true };
      }
    };
  }
};

for (const n of range) {
  console.log(n); // 1, 2, 3, 4, 5
}

[...range]; // [1, 2, 3, 4, 5]

// ===== GENERATORS =====
// A generator function returns a Generator object which is both an iterator and iterable

function* counter(start, end) {
  for (let i = start; i <= end; i++) {
    yield i;  // pause here and return i
  }
}

const gen = counter(1, 5);
gen.next(); // { value: 1, done: false }
gen.next(); // { value: 2, done: false }
gen.next(); // { value: 3, done: false }
// ... etc
gen.next(); // { value: 5, done: false }
gen.next(); // { value: undefined, done: true }

// Use with for...of:
for (const n of counter(1, 5)) {
  console.log(n); // 1, 2, 3, 4, 5
}

// Infinite generator:
function* fibonacci() {
  let a = 0, b = 1;
  while (true) {
    yield a;
    [a, b] = [b, a + b];
  }
}
const fib = fibonacci();
const first10 = Array.from({ length: 10 }, () => fib.next().value);
// [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

// Async generators:
async function* asyncRange(start, end) {
  for (let i = start; i <= end; i++) {
    await new Promise(resolve => setTimeout(resolve, 100)); // simulate async
    yield i;
  }
}

for await (const n of asyncRange(1, 5)) {
  console.log(n);
}
```

---

## PART 22: Map, Set, WeakMap, WeakSet

```javascript
// ===== MAP =====
// Like an object but keys can be ANY type, and insertion order preserved

const map = new Map();
map.set("name", "Arpit");     // string key
map.set(42, "answer");        // number key
map.set(true, "yes");         // boolean key
const objKey = {};
map.set(objKey, "object key"); // object key!

map.get("name")    // "Arpit"
map.get(42)        // "answer"
map.has("name")    // true
map.delete("name") // removes
map.size           // number of entries
map.clear()        // remove all

// Iterating:
for (const [key, value] of map) { console.log(key, value); }
map.forEach((value, key) => console.log(key, value));
[...map.keys()]    // array of keys
[...map.values()]  // array of values
[...map.entries()] // array of [key, value] pairs

// Create from entries:
const map2 = new Map([["a", 1], ["b", 2], ["c", 3]]);

// Convert to/from object:
const obj = Object.fromEntries(map2);  // { a: 1, b: 2, c: 3 }
const map3 = new Map(Object.entries(obj));

// ===== SET =====
// Collection of unique values

const set = new Set([1, 2, 3, 2, 1]); // duplicates removed
set; // Set { 1, 2, 3 }

set.add(4)       // add value
set.has(1)       // true
set.delete(1)    // remove
set.size         // 2
set.clear()      // remove all

// Iterating:
for (const val of set) { console.log(val); }
set.forEach(val => console.log(val));
[...set]         // convert to array

// Remove duplicates from array:
const unique = [...new Set([1, 2, 2, 3, 3, 4])]; // [1, 2, 3, 4]

// Set operations:
const a = new Set([1, 2, 3, 4]);
const b = new Set([3, 4, 5, 6]);
const union = new Set([...a, ...b]);              // {1,2,3,4,5,6}
const intersection = new Set([...a].filter(x => b.has(x))); // {3,4}
const difference = new Set([...a].filter(x => !b.has(x)));  // {1,2}

// ===== WEAKMAP =====
// Keys must be objects, not enumerable, doesn't prevent garbage collection
const weakMap = new WeakMap();
const obj1 = {};
weakMap.set(obj1, "data associated with obj1");
weakMap.get(obj1); // "data associated with obj1"
// When obj1 is garbage collected, its entry is automatically removed
// Use for: private data, caching per-object

// ===== WEAKSET =====
// Set of objects, not enumerable, allows garbage collection
const weakSet = new WeakSet();
weakSet.add(document.getElementById("header"));
// When the element is removed from DOM and GC'd, it leaves the WeakSet
// Use for: tracking which elements have been processed
```

---

## PART 23: The Event Loop — How JavaScript Really Works

```javascript
/*
JavaScript is SINGLE-THREADED — only one piece of code runs at a time.
But it can handle async operations through the Event Loop.

The key components:
1. Call Stack   — where synchronous code runs (LIFO)
2. Heap         — where objects are stored in memory
3. Web APIs     — browser provides: setTimeout, fetch, addEventListener
4. Microtask Queue — for Promises (.then callbacks)
5. Macrotask Queue (Task Queue) — for setTimeout, setInterval, events

EXECUTION ORDER:
1. Run all synchronous code (Call Stack)
2. Run ALL microtasks (Promise callbacks) until queue is empty
3. Run ONE macrotask (setTimeout callback)
4. Go back to step 2

Priority: Synchronous > Microtasks > Macrotasks
*/

console.log("1 — sync");

setTimeout(() => console.log("2 — setTimeout (macrotask)"), 0);
// Even with 0ms delay, it goes to macrotask queue!

Promise.resolve().then(() => console.log("3 — Promise (microtask)"));

queueMicrotask(() => console.log("4 — queueMicrotask (microtask)"));

console.log("5 — sync");

// Output order:
// 1 — sync
// 5 — sync
// 3 — Promise (microtask)
// 4 — queueMicrotask (microtask)
// 2 — setTimeout (macrotask)

// ===== PRACTICAL IMPLICATIONS =====

// Long synchronous tasks BLOCK the UI (bad!):
// Never do this:
function heavyComputation() {
  for (let i = 0; i < 1000000000; i++) {} // blocks UI for seconds!
}

// Fix: Use Web Workers for heavy computation:
const worker = new Worker("heavy-worker.js");
worker.postMessage({ data: bigData });
worker.onmessage = (e) => console.log("Result:", e.data);

// Or break work into chunks with setTimeout:
function processInChunks(items) {
  let index = 0;

  function processChunk() {
    const end = Math.min(index + 100, items.length);
    while (index < end) {
      processItem(items[index++]);
    }
    if (index < items.length) {
      setTimeout(processChunk, 0); // yield to event loop between chunks
    }
  }

  processChunk();
}
```

---

## PART 24: Timers

```javascript
// ===== SETTIMEOUT =====
const id = setTimeout(() => {
  console.log("Runs after 1 second");
}, 1000);

clearTimeout(id); // cancel before it runs

// setTimeout with arguments:
setTimeout((name, age) => {
  console.log(`${name} is ${age}`);
}, 500, "Arpit", 21);

// ===== SETINTERVAL =====
const intervalId = setInterval(() => {
  console.log("Runs every second");
}, 1000);

clearInterval(intervalId); // stop interval

// Interval that stops itself:
let count = 0;
const id2 = setInterval(() => {
  count++;
  console.log(`Tick ${count}`);
  if (count >= 5) clearInterval(id2);
}, 1000);

// ===== REQUESTANIMATIONFRAME =====
// Better than setInterval for animations — synced with browser refresh (60fps)
function animate(timestamp) {
  // timestamp = milliseconds since page load
  element.style.left = (timestamp / 10 % 300) + "px";
  requestAnimationFrame(animate); // schedule next frame
}

const animFrameId = requestAnimationFrame(animate);
cancelAnimationFrame(animFrameId); // stop

// ===== DEBOUNCE =====
// Delay execution until user STOPS doing something (e.g., typing)
function debounce(fn, delay) {
  let timeoutId;
  return function(...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn.apply(this, args), delay);
  };
}

const debouncedSearch = debounce((query) => {
  fetch(`/api/search?q=${query}`).then(r => r.json()).then(showResults);
}, 300);

searchInput.addEventListener("input", (e) => debouncedSearch(e.target.value));
// API called only 300ms after user STOPS typing — not on every keystroke

// ===== THROTTLE =====
// Ensure function runs at most once per time period (even if called more)
function throttle(fn, interval) {
  let lastTime = 0;
  return function(...args) {
    const now = Date.now();
    if (now - lastTime >= interval) {
      lastTime = now;
      return fn.apply(this, args);
    }
  };
}

const throttledScroll = throttle(() => {
  updateScrollPosition();
}, 100);

window.addEventListener("scroll", throttledScroll);
// Scroll handler runs at most 10 times per second (every 100ms)
```

---

## PART 25: JSON

```javascript
// JSON — JavaScript Object Notation (data exchange format)
// Supported types: string, number, boolean, null, array, object
// NOT supported: undefined, functions, Symbol, Date (converts to string), BigInt

// ===== STRINGIFY — JS to JSON string =====
const user = { name: "Arpit", age: 21, active: true };
JSON.stringify(user);
// '{"name":"Arpit","age":21,"active":true}'

// With indentation (for readable output):
JSON.stringify(user, null, 2);
/*
{
  "name": "Arpit",
  "age": 21,
  "active": true
}
*/

// With replacer — filter properties:
JSON.stringify(user, ["name", "age"]); // only include name and age
JSON.stringify(user, (key, value) => {
  if (typeof value === "number") return value * 2; // double all numbers
  return value;
});

// ===== PARSE — JSON string to JS =====
const jsonString = '{"name":"Arpit","age":21}';
const parsed = JSON.parse(jsonString);
parsed.name; // "Arpit"

// With reviver — transform values during parsing:
JSON.parse(jsonString, (key, value) => {
  if (key === "age") return value + 1; // add 1 to age
  return value;
});

// Deep clone objects with JSON (simple but has limitations):
const deepCopy = JSON.parse(JSON.stringify(original));
// ❌ Loses: undefined, functions, Date objects (becomes strings), RegExp, Set, Map

// Error handling:
try {
  JSON.parse("invalid json{");
} catch (e) {
  console.error("JSON parse error:", e.message); // SyntaxError
}
```

---

## PART 26: Regular Expressions

```javascript
// Regex is used for pattern matching and text manipulation

// ===== CREATING =====
const pattern = /hello/i;            // literal (i = case insensitive)
const dynamic = new RegExp("hello", "i"); // constructor (for dynamic patterns)

// ===== FLAGS =====
/pattern/i   // case insensitive
/pattern/g   // global — find ALL matches (not just first)
/pattern/m   // multiline — ^ and $ match line start/end
/pattern/s   // dotAll — . matches newlines too
/pattern/gi  // multiple flags combined

// ===== BASIC PATTERNS =====
/hello/          // matches "hello" exactly
/[aeiou]/        // matches any vowel
/[^aeiou]/       // matches any NON-vowel (^ inside [] = negate)
/[a-z]/          // matches any lowercase letter
/[A-Z]/          // matches any uppercase letter
/[0-9]/          // matches any digit
/[a-zA-Z0-9]/    // matches any letter or digit

// Special characters:
/./              // any character (except newline)
/\d/             // digit [0-9]
/\D/             // non-digit [^0-9]
/\w/             // word character [a-zA-Z0-9_]
/\W/             // non-word character
/\s/             // whitespace (space, tab, newline, etc.)
/\S/             // non-whitespace
/\b/             // word boundary
/\B/             // non-word boundary

// Anchors:
/^hello/         // must start with "hello"
/world$/         // must end with "world"
/^hello world$/  // must be exactly "hello world"

// Quantifiers:
/a*/             // a zero or more times
/a+/             // a one or more times
/a?/             // a zero or one times (optional)
/a{3}/           // exactly 3 a's
/a{2,4}/         // 2 to 4 a's
/a{2,}/          // 2 or more a's
/a*?/            // lazy (non-greedy) — as FEW as possible
/a+?/            // lazy

// Groups:
/(hello)/        // capturing group
/(?:hello)/      // non-capturing group
/(?<name>hello)/ // named capturing group

// Alternation:
/cat|dog/        // "cat" OR "dog"

// Lookahead/Lookbehind:
/\d+(?= dollars)/  // digits followed by " dollars" (positive lookahead)
/\d+(?! dollars)/  // digits NOT followed by " dollars" (negative lookahead)
/(?<=\$)\d+/       // digits preceded by "$" (positive lookbehind)

// ===== USING REGEX =====
const email = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const phone = /^[6-9]\d{9}$/;  // Indian mobile number
const url = /^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b/;
const strongPassword = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

// test() — returns true/false
email.test("arpit@example.com");  // true
phone.test("9876543210");         // true

// match() — returns matches
"Hello World".match(/\w+/g);      // ["Hello", "World"]
"Hello World".match(/(\w+) (\w+)/);
// ["Hello World", "Hello", "World"] — [full, group1, group2]

// Named groups:
const dateStr = "2026-07-29";
const match = dateStr.match(/(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/);
match.groups.year;  // "2026"
match.groups.month; // "07"
match.groups.day;   // "29"

// matchAll() — returns iterator of all matches with groups
const text = "cat sat on mat";
const matches = [...text.matchAll(/(\w)at/g)];
// [{match: "cat", groups: ...}, {match: "sat", ...}, {match: "mat", ...}]

// replace() / replaceAll()
"Hello World".replace(/World/, "JavaScript"); // "Hello JavaScript"
"aabba".replace(/a/g, "x");   // "xxbbx"
"2026-07-29".replace(/(\d{4})-(\d{2})-(\d{2})/, "$3/$2/$1"); // "29/07/2026"

// With function:
"hello world".replace(/\b\w/g, c => c.toUpperCase()); // "Hello World"

// search() — returns index of first match
"hello world".search(/world/); // 6

// split() with regex
"one1two2three".split(/\d/); // ["one", "two", "three"]
```

---

## PART 27: Storage APIs

```javascript
// ===== LOCAL STORAGE =====
// Persistent — survives browser close/reopen
// ~5MB limit, strings only, synchronous

localStorage.setItem("theme", "dark");
localStorage.getItem("theme");  // "dark"
localStorage.removeItem("theme");
localStorage.clear();           // remove ALL items
localStorage.length;            // number of items

// Store objects (must stringify):
const user = { name: "Arpit", age: 21 };
localStorage.setItem("user", JSON.stringify(user));
const savedUser = JSON.parse(localStorage.getItem("user") || "null");

// ===== SESSION STORAGE =====
// Cleared when tab closes. Same API as localStorage
sessionStorage.setItem("quizState", JSON.stringify(state));
sessionStorage.getItem("quizState");
sessionStorage.clear();

// ===== INDEXEDDB =====
// Full database in the browser — large amounts of structured data

const request = indexedDB.open("MyDatabase", 1);

request.onerror = (e) => console.error("DB error", e);
request.onsuccess = (e) => {
  const db = e.target.result;
  // use db here
};

request.onupgradeneeded = (e) => {
  const db = e.target.result;
  const store = db.createObjectStore("users", { keyPath: "id" });
  store.createIndex("name", "name", { unique: false });
};

// ===== COOKIES =====
// Sent to server on every request
// Can be set with expiry, domain, path, secure, httpOnly (server-only)

// Client-side cookies:
document.cookie = "theme=dark";
document.cookie = `theme=dark; max-age=${60*60*24*7}; path=/`; // 7 days
document.cookie = "theme=dark; secure; samesite=strict";

// Reading cookies:
const cookies = Object.fromEntries(
  document.cookie.split("; ").map(c => c.split("="))
);
cookies.theme; // "dark"
```

---

## PART 28: Advanced Patterns

```javascript
// ===== MEMOIZATION =====
// Cache function results to avoid recalculating
function memoize(fn) {
  const cache = new Map();
  return function(...args) {
    const key = JSON.stringify(args);
    if (cache.has(key)) return cache.get(key);
    const result = fn.apply(this, args);
    cache.set(key, result);
    return result;
  };
}

const expensiveCalc = memoize((n) => {
  // Simulate expensive operation
  return n * n;
});

expensiveCalc(5);  // calculates
expensiveCalc(5);  // returns cached result

// ===== CURRYING =====
// Transform function with multiple args into chain of single-arg functions
function multiply(a) {
  return function(b) {
    return function(c) {
      return a * b * c;
    };
  };
}
multiply(2)(3)(4);  // 24

// Auto-curry helper:
const curry = fn => {
  const arity = fn.length;
  return function curried(...args) {
    if (args.length >= arity) return fn(...args);
    return (...more) => curried(...args, ...more);
  };
};

// ===== OBSERVER PATTERN =====
class EventEmitter {
  #listeners = new Map();

  on(event, listener) {
    if (!this.#listeners.has(event)) this.#listeners.set(event, new Set());
    this.#listeners.get(event).add(listener);
    return () => this.off(event, listener); // return unsubscribe function
  }

  off(event, listener) {
    this.#listeners.get(event)?.delete(listener);
  }

  emit(event, ...args) {
    this.#listeners.get(event)?.forEach(listener => listener(...args));
  }

  once(event, listener) {
    const wrapper = (...args) => {
      listener(...args);
      this.off(event, wrapper);
    };
    return this.on(event, wrapper);
  }
}

const emitter = new EventEmitter();
const unsub = emitter.on("message", (text) => console.log("Got:", text));
emitter.emit("message", "Hello"); // "Got: Hello"
unsub(); // unsubscribe

// ===== PROXY =====
// Intercept object operations
const handler = {
  get(target, prop) {
    console.log(`Getting ${prop}`);
    return prop in target ? target[prop] : `Property ${prop} not found`;
  },
  set(target, prop, value) {
    if (typeof value !== "string") throw new TypeError("Only strings allowed");
    target[prop] = value;
    return true; // must return true
  }
};

const user = new Proxy({ name: "Arpit" }, handler);
user.name;         // logs "Getting name", returns "Arpit"
user.age;          // logs "Getting age", returns "Property age not found"
user.name = "Raj"; // works
user.age = 21;     // throws TypeError

// ===== REFLECT =====
// Provides methods for JavaScript operations (meta-programming)
Reflect.has(obj, "name")           // same as "name" in obj
Reflect.get(obj, "name")           // same as obj.name
Reflect.set(obj, "name", "New")    // same as obj.name = "New"
Reflect.deleteProperty(obj, "name") // same as delete obj.name
Reflect.ownKeys(obj)               // all own property names (including symbols)

// ===== DEFENSIVE PROGRAMMING =====
// Guard clauses — return early instead of nesting
function processUser(user) {
  // Early returns for invalid states
  if (!user) return null;
  if (!user.email) throw new Error("Email required");
  if (!user.isVerified) return { error: "User not verified" };

  // Happy path code is at the same indentation level
  return processVerifiedUser(user);
}

// ===== OBJECT.FREEZE DEEP =====
function deepFreeze(obj) {
  Object.getOwnPropertyNames(obj).forEach(name => {
    const value = obj[name];
    if (value && typeof value === "object") deepFreeze(value);
  });
  return Object.freeze(obj);
}
```

---

## PART 29: Performance Tips

```javascript
// ===== AVOID MEMORY LEAKS =====

// Memory leak: event listeners not removed
function setupModal() {
  const handler = () => closeModal();
  document.addEventListener("keydown", handler);

  // MUST remove when done:
  return () => document.removeEventListener("keydown", handler);
}

// Memory leak: timers not cleared
let intervalId;
function startPolling() {
  intervalId = setInterval(fetchData, 5000);
}
function stopPolling() {
  clearInterval(intervalId); // MUST clear
}

// Memory leak: circular references (rare in modern JS, handled by GC)

// ===== EFFICIENT DOM MANIPULATION =====
// Bad: DOM read inside loop causes layout thrashing
items.forEach(item => {
  const height = container.offsetHeight; // forces layout recalculation each time!
  item.style.height = height + "px";
});

// Good: read once, write many
const height = container.offsetHeight; // read once
items.forEach(item => {
  item.style.height = height + "px"; // write only
});

// Bad: many separate DOM insertions
items.forEach(item => {
  const el = document.createElement("div");
  container.appendChild(el); // forces re-render each time!
});

// Good: use DocumentFragment
const fragment = document.createDocumentFragment();
items.forEach(item => {
  const el = document.createElement("div");
  fragment.appendChild(el); // off-DOM, no reflow
});
container.appendChild(fragment); // one DOM operation

// ===== VIRTUAL SCROLLING =====
// For long lists — only render visible items
// Pookiz chat uses this approach for message history

// ===== WEB WORKERS =====
// Run heavy computation in background thread
const worker = new Worker("worker.js");
worker.postMessage({ task: "heavyCalc", data: bigArray });
worker.onmessage = (e) => {
  console.log("Result:", e.data.result);
};
// worker.js:
// self.onmessage = (e) => {
//   const result = heavyCalculation(e.data.data);
//   self.postMessage({ result });
// };

// ===== INTERSECTION OBSERVER for Lazy Loading =====
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const img = entry.target;
      img.src = img.dataset.src; // load image only when visible
      observer.unobserve(img);   // stop observing after loaded
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll("img[data-src]").forEach(img => observer.observe(img));
```

---

## PART 30: `use strict` and Modern Best Practices

```javascript
"use strict"; // Enable strict mode for entire file
// OR automatically enabled in ES6 modules and classes

// Strict mode prevents:
// - Using undeclared variables
// - Deleting variables
// - Duplicate parameter names
// - Writing to read-only properties
// - with statement
// - eval() creating variables

// ===== BEST PRACTICES =====
// 1. Always use const/let, never var
// 2. Use === instead of ==
// 3. Use optional chaining (?.) and nullish coalescing (??)
// 4. Handle all promises (don't ignore .catch)
// 5. Type check inputs in functions
// 6. Prefer immutability — use spread instead of mutating
// 7. Use descriptive variable names
// 8. Avoid global variables
// 9. Use modules for code organization
// 10. Comment complex logic, but prefer readable code

// ===== COMMON GOTCHAS =====

// 0.1 + 0.2 !== 0.3 (floating point)
0.1 + 0.2;            // 0.30000000000000004
Math.round((0.1 + 0.2) * 100) / 100; // 0.3 (fix)

// typeof null === "object" (historical bug)
null === null; // true (use this to check for null)

// NaN !== NaN
NaN === NaN;      // false
Number.isNaN(NaN); // true (use this)

// Array typeof
typeof [];        // "object"
Array.isArray([]); // true (use this)

// Empty array/object are truthy
if ([]) console.log("truthy!"); // prints
if ({}) console.log("truthy!"); // prints

// parseInt needs radix for reliable parsing
parseInt("08");    // might be 0 (octal) in old engines
parseInt("08", 10); // always 8 (base 10) — always specify radix!
```

---

## Summary: JavaScript in One Page

| Topic | Key Concepts |
|---|---|
| **Variables** | `const`, `let`, never `var` |
| **Types** | string, number, boolean, null, undefined, symbol, bigint, object |
| **Operators** | `===`, `??`, `?.`, spread `...`, ternary |
| **Strings** | Template literals, slice, includes, split, join |
| **Arrays** | map, filter, reduce, forEach, find, flat, spread |
| **Objects** | Destructuring, spread, Object.keys/values/entries |
| **Functions** | Arrow functions, default params, rest params, closures |
| **Classes** | constructor, extends, super, private `#fields`, static |
| **Async** | Promises, async/await, try/catch, Promise.all |
| **DOM** | querySelector, addEventListener, createElement |
| **Events** | Event bubbling, delegation, event object |
| **Fetch** | GET/POST/PUT/DELETE, headers, JSON |
| **Modules** | import/export, named, default, dynamic |
| **Storage** | localStorage, sessionStorage |
| **Performance** | Debounce, throttle, lazy loading, Web Workers |
