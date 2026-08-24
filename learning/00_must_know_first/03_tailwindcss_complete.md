# Tailwind CSS — Complete Guide from Zero to Real World

Tailwind CSS is a utility-first CSS framework. Instead of writing custom CSS rules in a stylesheet (e.g., `.card { background: white; padding: 16px; }`), you write utility classes directly inside your HTML/JSX code (e.g., `className="bg-white p-4"`).

Tailwind v4 is the newest release, offering a faster build engine, modern CSS features, and complete configuration inside standard CSS stylesheets.

---

## PART 1: The Utility-First Concept

### Traditional CSS:
```html
<div class="user-card">
  <h2>Arpit</h2>
</div>
```
```css
.user-card {
  background-color: #ffffff;
  padding: 24px;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
```

### Tailwind CSS:
```html
<div class="bg-white p-6 rounded-lg shadow-md">
  <h2>Arpit</h2>
</div>
```

### Why use utility classes?
1. **No custom CSS file growing over time**: The design system is fixed, preventing bloating.
2. **Safer modifications**: Changing utility classes on one element will never break other elements on the site.
3. **No class name brainstorming**: You don't have to invent names like `.card-inner-wrapper-v2`.

---

## PART 2: Core Utility Class Catalog

Here are the most common Tailwind classes categorized:

### 1. Layout & Positioning
- **Display**: `block`, `inline`, `inline-block`, `flex`, `grid`, `hidden`, `contents`.
- **Position**: `static`, `relative`, `absolute`, `fixed`, `sticky`.
- **Offsets**: `top-0`, `right-4`, `bottom-10`, `left-1/2` (50% position).
- **Z-Index**: `z-0`, `z-10`, `z-20`, `z-50`, `z-auto`.
- **Overflow**: `overflow-auto`, `overflow-hidden`, `overflow-scroll`, `overflow-x-hidden`.

### 2. Spacing (Margin & Padding)
Tailwind uses a numeric spacing scale. `1` unit = `0.25rem` (`4px`).
- **Padding**: 
  - `p-4` = `16px` on all sides.
  - `px-6` = `24px` horizontal (left/right).
  - `py-2` = `8px` vertical (top/bottom).
  - `pt-4`, `pr-2`, `pb-8`, `pl-1` = individual sides.
- **Margin**:
  - `m-4`, `mx-auto` (centers block elements), `my-2`.
  - `mt-4`, `mr-2`, `mb-8`, `ml-1`.
  - `-mt-4` = negative margin (pushes element upwards).

### 3. Colors & Backgrounds
Colors follow a shade scale from 50 (lightest) to 950 (darkest).
- **Text Color**: `text-red-500`, `text-blue-900`, `text-slate-100`, `text-transparent`.
- **Background Color**: `bg-indigo-500`, `bg-emerald-50`, `bg-neutral-900`.
- **Opacity**: `bg-opacity-50`, `text-opacity-80` (or `bg-black/50` syntax).
- **Gradients**: `bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500`.

### 4. Sizing
- **Width**: 
  - Fixed: `w-4` (16px), `w-64` (256px).
  - Relative: `w-1/2` (50%), `w-1/3` (33%), `w-3/4` (75%).
  - Viewport/Total: `w-full` (100%), `w-screen` (100vw), `w-auto`.
  - Constraints: `min-w-0`, `max-w-2xl` (42rem), `max-w-full`.
- **Height**: `h-4`, `h-64`, `h-full`, `h-screen` (100vh).

### 5. Typography
- **Font Size**: `text-xs` (12px), `text-sm` (14px), `text-base` (16px), `text-lg` (18px), `text-xl` (20px), `text-3xl` (30px), `text-6xl` (60px).
- **Font Weight**: `font-light`, `font-normal`, `font-medium`, `font-semibold`, `font-bold`, `font-black`.
- **Alignment**: `text-left`, `text-center`, `text-right`, `text-justify`.
- **Style**: `italic`, `non-italic`, `uppercase`, `lowercase`, `capitalize`.
- **Decoration**: `underline`, `no-underline`, `line-through`.
- **Letter Spacing**: `tracking-tighter`, `tracking-normal`, `tracking-wide`.
- **Truncation**: `truncate` (ellipsis on single line).

### 6. Borders & Effects
- **Borders**: `border` (1px border), `border-2` (2px), `border-t-4` (4px top border).
- **Border Color**: `border-gray-200`, `border-indigo-500`.
- **Border Radius**: `rounded` (4px), `rounded-md` (6px), `rounded-lg` (8px), `rounded-2xl` (16px), `rounded-full` (circle).
- **Shadows**: `shadow-sm`, `shadow` (normal), `shadow-md`, `shadow-lg`, `shadow-xl`, `shadow-none`.
- **Filters**: `blur`, `blur-sm`, `backdrop-blur-md`.

### 7. Flexbox & Grid
- **Flexbox Parent**:
  - `flex`: `display: flex`.
  - `flex-col`: Stack children vertically.
  - `items-center`: Align items along cross axis.
  - `justify-between`: Spread items along main axis.
  - `gap-4`: Spacing between children.
- **Flexbox Children**:
  - `flex-1`: Grow/shrink to fill space.
  - `flex-shrink-0`: Prevent shrinking.
- **Grid Parent**:
  - `grid`: `display: grid`.
  - `grid-cols-3`: 3 equal-width columns.
  - `grid-cols-1 md:grid-cols-3`: 1 column on mobile, 3 columns on tablet/desktop.
- **Grid Children**:
  - `col-span-2`: Span 2 columns.

---

## PART 3: Responsive Design & Breakpoints

Tailwind uses mobile-first media queries. Styles are applied to mobile by default and overridden for larger screens using breakpoint prefixes.

### Default Breakpoints:
- `sm:`: 640px (tablet size)
- `md:`: 768px (large tablet)
- `lg:`: 1024px (small desktop)
- `xl:`: 1280px (desktop)
- `2xl:`: 1536px (large screen)

```html
<!-- Example of a responsive layout -->
<div class="w-full p-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
  <!-- 
    Mobile: grid-cols-1 (single column)
    Tablet (sm): grid-cols-2 (two columns)
    Desktop (lg): grid-cols-4 (four columns)
  -->
  <div class="bg-gray-100 p-4 rounded">Card 1</div>
  <div class="bg-gray-100 p-4 rounded">Card 2</div>
  <div class="bg-gray-100 p-4 rounded">Card 3</div>
  <div class="bg-gray-100 p-4 rounded">Card 4</div>
</div>
```

---

## PART 4: State Variants (Hover, Focus, etc.)

You can conditionally apply utility classes when an element is in a specific state using prefixes.

```html
<!-- Hover and Focus States -->
<button class="bg-indigo-500 text-white px-4 py-2 rounded transition-colors hover:bg-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-300">
  Submit
</button>

<!-- Group Hover (Style child when parent is hovered) -->
<div class="group border p-4 hover:border-indigo-500">
  <h3 class="group-hover:text-indigo-500">Card Title</h3>
  <p class="text-gray-500">Card details here...</p>
</div>

<!-- Peer Modifier (Style sibling when input status changes) -->
<input type="email" class="peer border rounded p-2" />
<p class="text-red-500 invisible peer-invalid:visible">
  Please enter a valid email address.
</p>
```

---

## PART 5: Dark Mode

Apply styles specifically when dark mode is enabled using the `dark:` variant.

```html
<div class="bg-white text-gray-900 dark:bg-gray-900 dark:text-gray-100">
  <h1>Visual Theme Adaptable Header</h1>
  <p class="text-gray-600 dark:text-gray-400">Content adapts to user preferences.</p>
</div>
```

How to trigger dark mode depends on your setup:
1. **Media Preference (default)**: Adapts automatically to browser theme settings.
2. **Class-based manual toggler**: Apply class `dark` on the top `<html>` tag dynamically using JavaScript.

---

## PART 6: Tailwind CSS v4 Configuration & CSS Directives

In Tailwind v4, custom configs are written directly inside your main CSS file (`globals.css` / `style.css`) instead of a separate JavaScript config file.

```css
/* src/app/globals.css */

/* Import Tailwind engine directives */
@import "tailwindcss";

/* Extend Tailwind configuration inside standard CSS variables */
@theme {
  --color-primary: #6366f1;
  --color-primary-dark: #4f46e5;
  
  --font-display: "Outfit", sans-serif;
  
  --animate-shimmer: shimmer 2s infinite linear;
  
  @keyframes shimmer {
    0% { background-position: -200% 0; }
    100% { background-position: 200% 0; }
  }
}

/* Custom utility component classes (use @utility directive) */
@utility btn-primary {
  background-color: var(--color-primary);
  color: white;
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  transition: background-color 0.2s;
  
  &:hover {
    background-color: var(--color-primary-dark);
  }
}
```

---

## Summary: Tailwind CSS v4 Cheat Sheet

| Category | Tailwind Class Example | CSS Equivalent |
|---|---|---|
| **Flex Layout** | `flex items-center justify-between` | `display: flex; align-items: center; justify-content: space-between;` |
| **Grid Layout** | `grid grid-cols-3 gap-4` | `display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;` |
| **Spacing** | `p-4 my-2` | `padding: 16px; margin-top: 8px; margin-bottom: 8px;` |
| **Responsive** | `w-full md:w-1/2` | `width: 100%; @media(min-width: 768px) { width: 50%; }` |
| **Theme / State**| `hover:bg-blue-600 dark:bg-black`| `:hover { bg: #2563eb; }` when user has dark-theme config |
| **Transitions** | `transition-all duration-300` | `transition: all 0.3s ease-in-out;` |
| **Text Overflow**| `truncate` | `white-space: nowrap; overflow: hidden; text-overflow: ellipsis;` |
| **Custom Style** | `bg-[linear-gradient(...)]` | Arbitrary values supported inside square brackets |
```
