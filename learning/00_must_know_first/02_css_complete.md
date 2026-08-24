# CSS — Complete Guide from Zero to Real World

CSS (Cascading Style Sheets) controls how HTML elements look. Without CSS, every website looks like a plain text document. CSS adds colors, fonts, layouts, animations, and responsive design.

---

## PART 1: How to Add CSS

```html
<!-- Method 1: External stylesheet (BEST — separates concerns) -->
<link rel="stylesheet" href="style.css" />

<!-- Method 2: Internal / Embedded (inside <head>) -->
<style>
  p {
    color: red;
  }
</style>

<!-- Method 3: Inline (WORST — hard to maintain, highest specificity) -->
<p style="color: red; font-size: 16px;">Text</p>
```

**Always use external stylesheets in real projects.**

---

## PART 2: CSS Syntax

```css
/* Selector { property: value; } */

p {
  color: red;        /* text color */
  font-size: 16px;   /* text size */
  margin: 20px;      /* space outside element */
}

/* Selector = what element to style */
/* Property = what to change */
/* Value = how to change it */
/* Declaration = property: value */
/* Rule = selector + all declarations */
```

---

## PART 3: Selectors — Complete Reference

### Basic Selectors

```css
/* Element selector — targets all <p> tags */
p { color: gray; }

/* Class selector — targets elements with class="highlight" */
.highlight { background-color: yellow; }

/* ID selector — targets ONE element with id="hero" */
#hero { font-size: 48px; }

/* Universal selector — targets EVERYTHING (use carefully) */
* { box-sizing: border-box; margin: 0; padding: 0; }

/* Multiple selectors — same style for all */
h1, h2, h3 { font-family: Arial, sans-serif; }
```

### Combinator Selectors

```css
/* Descendant — .card h2 matches any h2 INSIDE a .card at any depth */
.card h2 { font-size: 24px; }

/* Child — .nav > a matches DIRECT children only */
.nav > a { color: white; }

/* Adjacent sibling — h2 + p matches first p IMMEDIATELY after h2 */
h2 + p { margin-top: 0; }

/* General sibling — h2 ~ p matches ALL p siblings after h2 */
h2 ~ p { color: gray; }
```

### Attribute Selectors

```css
/* Has attribute */
[disabled] { opacity: 0.5; cursor: not-allowed; }

/* Exact value */
[type="email"] { border-color: blue; }

/* Starts with */
[href^="https"] { color: green; } /* secure links */

/* Ends with */
[href$=".pdf"] { color: red; } /* PDF links */

/* Contains */
[class*="btn"] { cursor: pointer; } /* any class containing "btn" */

/* Contains word (space-separated) */
[class~="active"] { font-weight: bold; }

/* Starts with value followed by - */
[lang|="en"] { } /* matches en, en-US, en-GB */

/* Case-insensitive */
[type="TEXT" i] { } /* matches type="text", type="TEXT", type="Text" */
```

### Pseudo-Classes

```css
/* User action states */
a:hover { color: blue; }          /* mouse over */
button:focus { outline: 2px solid blue; } /* keyboard focus */
a:active { color: red; }          /* being clicked */
input:focus-visible { }           /* focused via keyboard only */

/* Link states */
a:link { color: blue; }           /* unvisited link */
a:visited { color: purple; }      /* visited link */

/* Structural */
li:first-child { font-weight: bold; }      /* first child of parent */
li:last-child { border-bottom: none; }     /* last child */
li:nth-child(2) { background: pink; }     /* exactly 2nd child */
li:nth-child(odd) { background: #f5f5f5; } /* 1st, 3rd, 5th... */
li:nth-child(even) { background: white; } /* 2nd, 4th, 6th... */
li:nth-child(3n) { }                       /* every 3rd: 3, 6, 9... */
li:nth-child(3n+1) { }                     /* 1, 4, 7, 10... */
li:nth-last-child(1) { }                   /* counted from end */

p:first-of-type { }  /* first <p> among siblings */
p:last-of-type { }   /* last <p> among siblings */
p:nth-of-type(2) { } /* second <p> among siblings */
p:only-child { }     /* element that has no siblings */
p:only-of-type { }   /* only <p> among its siblings */

/* Form states */
input:required { border-color: red; }
input:optional { border-color: gray; }
input:valid { border-color: green; }
input:invalid { border-color: red; }
input:placeholder-shown { } /* while placeholder is visible (empty) */
input:checked { }           /* checked checkbox or radio */
input:disabled { opacity: 0.5; }
input:enabled { }
input:read-only { background: #f0f0f0; }
input:focus-within { }     /* parent when any child is focused */

/* Negation */
:not(p) { }                /* everything except <p> */
:not(.disabled) { }        /* elements without .disabled class */
:not(:last-child) { }      /* all but last child */

/* Target — element whose id matches URL hash */
#section-2:target { background: yellow; }
/* If URL is page.html#section-2, this element gets highlighted */

/* Empty — elements with no children */
p:empty { display: none; }

/* Root — :root is the <html> element (use for CSS variables) */
:root { --primary-color: #6366f1; }

/* Has (modern CSS) — parent selector */
.card:has(img) { border: 2px solid blue; }
/* .card that contains an <img> */
```

### Pseudo-Elements

```css
/* ::before — insert content BEFORE element content */
.required-field::before {
  content: "* ";
  color: red;
}

/* ::after — insert content AFTER element content */
.external-link::after {
  content: " ↗";
}

/* ::placeholder — style placeholder text */
input::placeholder {
  color: #999;
  font-style: italic;
}

/* ::selection — text highlighted by user */
::selection {
  background-color: #6366f1;
  color: white;
}

/* ::first-line — first line of a paragraph */
p::first-line {
  font-size: 1.2em;
  font-weight: bold;
}

/* ::first-letter — first letter of a paragraph */
p::first-letter {
  font-size: 3em;
  float: left;
  margin-right: 8px;
}

/* ::marker — bullet/number in lists */
li::marker {
  color: blue;
  font-weight: bold;
}

/* ::file-selector-button — the button in file input */
input[type="file"]::file-selector-button {
  background: #6366f1;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
}
```

---

## PART 4: Specificity — Who Wins When Rules Conflict?

When two CSS rules target the same element, **specificity** decides which one wins.

```
Specificity score (highest to lowest):
1. Inline styles            → 1,0,0,0  (always wins)
2. ID selectors             → 0,1,0,0
3. Class, attribute, pseudo-class → 0,0,1,0
4. Element, pseudo-element  → 0,0,0,1

Examples:
  p                 → 0,0,0,1
  .text             → 0,0,1,0
  #title            → 0,1,0,0
  p.text            → 0,0,1,1  (element + class)
  #title .text p    → 0,1,1,1  (id + class + element)
  style="..."       → 1,0,0,0  (always wins)
  !important        → Nuclear option, overrides everything
```

```css
/* Lower specificity — loses */
p { color: gray; }            /* 0,0,0,1 */

/* Higher specificity — wins */
.article p { color: black; }  /* 0,0,1,1 */

/* Nuclear option — avoid using this */
p { color: blue !important; }
/* !important overrides everything including inline styles */
```

**Best practice:** Keep specificity low and consistent. Avoid `!important` — it creates maintenance nightmares.

---

## PART 5: The Box Model

Every HTML element is a rectangular box with four layers:

```
┌──────────────────────────────────────┐
│              MARGIN                  │  ← Space OUTSIDE the border
│  ┌────────────────────────────────┐  │
│  │            BORDER              │  │  ← The border line
│  │  ┌──────────────────────────┐  │  │
│  │  │          PADDING         │  │  │  ← Space INSIDE border, outside content
│  │  │  ┌────────────────────┐  │  │  │
│  │  │  │      CONTENT       │  │  │  │  ← The actual text/image
│  │  │  └────────────────────┘  │  │  │
│  │  └──────────────────────────┘  │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

```css
div {
  /* Content */
  width: 300px;
  height: 200px;

  /* Padding — space inside the border */
  padding: 20px;              /* all 4 sides */
  padding: 10px 20px;         /* top/bottom 10px, left/right 20px */
  padding: 10px 20px 15px;    /* top 10, left/right 20, bottom 15 */
  padding: 10px 20px 15px 5px; /* top right bottom left (clockwise) */
  padding-top: 10px;
  padding-right: 20px;
  padding-bottom: 15px;
  padding-left: 5px;

  /* Border */
  border: 2px solid black;    /* width style color */
  border: 1px dashed #ccc;
  border: 3px dotted red;
  border-top: 2px solid blue;
  border-right: none;
  border-radius: 8px;         /* rounded corners */
  border-radius: 50%;         /* makes square into circle */
  border-radius: 10px 20px;   /* top-left/bottom-right, top-right/bottom-left */

  /* Margin — space outside the border */
  margin: 20px;
  margin: 10px auto;          /* top/bottom 10px, left/right auto (centers element) */
  margin-top: 10px;
  margin: 0;                  /* remove all margin */

  /* Outline — similar to border but OUTSIDE the box model (doesn't affect layout) */
  outline: 2px solid blue;
  outline-offset: 4px;        /* space between border and outline */
}
```

### Box Sizing

```css
/* Default: content-box — width/height = content only */
/* Total width = width + padding + border */
div {
  width: 300px;
  padding: 20px;
  border: 2px solid;
  /* Actual total width = 300 + 20 + 20 + 2 + 2 = 344px */
}

/* Better: border-box — width/height includes padding and border */
/* Total width = exactly what you set */
* {
  box-sizing: border-box;   /* Apply to everything — this is the modern default */
}
div {
  width: 300px;
  padding: 20px;
  border: 2px solid;
  /* Actual total width = exactly 300px */
}
```

**Always add `* { box-sizing: border-box; }` to your CSS.**

---

## PART 6: Display Property

Controls how an element participates in layout:

```css
/* block — full width, starts on new line */
div { display: block; }

/* inline — only as wide as content, no width/height */
span { display: inline; }

/* inline-block — flows inline but accepts width/height */
img { display: inline-block; }

/* none — completely hides element (removed from layout) */
.hidden { display: none; }
/* vs */
.invisible { visibility: hidden; } /* hidden but still takes space */

/* flex — makes element a flex container */
.container { display: flex; }

/* inline-flex — flex container but flows inline */
.badge { display: inline-flex; }

/* grid — makes element a grid container */
.layout { display: grid; }

/* inline-grid — grid container that flows inline */
.small-grid { display: inline-grid; }

/* table, table-row, table-cell — for table-like layouts (rarely needed) */
.row { display: table-row; }
.cell { display: table-cell; }

/* contents — element itself has no box, but children render normally */
.wrapper { display: contents; }
/* Useful for removing unnecessary wrapper divs from styling perspective */
```

---

## PART 7: Position Property

Controls where an element is positioned:

```css
/* static (default) — normal document flow, top/left/right/bottom have NO effect */
div { position: static; }

/* relative — offset from its NORMAL position, other elements unaffected */
div {
  position: relative;
  top: 20px;    /* move 20px DOWN from where it would normally be */
  left: 10px;   /* move 10px RIGHT */
}
/* The element's original space is preserved */

/* absolute — positioned relative to NEAREST positioned ancestor */
/* Removed from normal document flow */
.parent {
  position: relative; /* ← this creates the positioning context */
}
.child {
  position: absolute;
  top: 0;
  right: 0;    /* top-right corner of parent */
  width: 100px;
  height: 100px;
}
/* If no positioned ancestor, positions relative to <html> */

/* fixed — positioned relative to VIEWPORT */
/* Stays in place even when scrolling */
.back-to-top {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 100;
}
.sticky-header {
  position: fixed;
  top: 0;
  width: 100%;
}

/* sticky — hybrid of relative and fixed */
/* Behaves relative until it hits a threshold, then acts like fixed */
.table-header {
  position: sticky;
  top: 0;         /* sticks to top of scroll container */
  background: white;
  z-index: 10;
}
/* Stays visible when scrolling past it — great for table headers and navbars */

/* z-index — controls which element appears on top */
/* Higher number = on top. Only works on positioned elements */
.modal { z-index: 1000; }
.overlay { z-index: 999; }
.header { z-index: 100; }
.dropdown { z-index: 50; }
```

---

## PART 8: Flexbox — Complete Guide

Flexbox is the most useful CSS feature for one-dimensional layouts (row OR column).

```css
/* ===== FLEX CONTAINER (parent) ===== */
.container {
  display: flex;

  /* Direction of main axis */
  flex-direction: row;            /* → left to right (default) */
  flex-direction: row-reverse;   /* ← right to left */
  flex-direction: column;        /* ↓ top to bottom */
  flex-direction: column-reverse; /* ↑ bottom to top */

  /* Wrapping */
  flex-wrap: nowrap;   /* all items on one line (default) */
  flex-wrap: wrap;     /* wrap to next line when needed */
  flex-wrap: wrap-reverse; /* wrap upward */

  /* Shorthand for direction + wrap */
  flex-flow: row wrap;

  /* Alignment on MAIN AXIS (direction of flex-direction) */
  justify-content: flex-start;   /* items at start (default) */
  justify-content: flex-end;     /* items at end */
  justify-content: center;       /* items centered */
  justify-content: space-between; /* items spread, no space at edges */
  justify-content: space-around; /* items spread, half-space at edges */
  justify-content: space-evenly; /* items spread, equal space everywhere */

  /* Alignment on CROSS AXIS (perpendicular to flex-direction) */
  align-items: stretch;     /* items fill cross axis height (default) */
  align-items: flex-start;  /* items at start of cross axis */
  align-items: flex-end;    /* items at end of cross axis */
  align-items: center;      /* items centered on cross axis */
  align-items: baseline;    /* items aligned by text baseline */

  /* Alignment when multiple rows exist (when flex-wrap: wrap) */
  align-content: flex-start;
  align-content: flex-end;
  align-content: center;
  align-content: space-between;
  align-content: space-around;
  align-content: stretch;

  /* Gap between items */
  gap: 20px;           /* same gap in all directions */
  gap: 20px 10px;      /* row-gap column-gap */
  row-gap: 20px;
  column-gap: 10px;
}

/* ===== FLEX ITEMS (children) ===== */
.item {
  /* How much to grow relative to siblings (default: 0 = don't grow) */
  flex-grow: 1;    /* grows to fill available space */
  flex-grow: 2;    /* grows twice as much as flex-grow: 1 items */
  flex-grow: 0;    /* don't grow (default) */

  /* How much to shrink when space is tight (default: 1 = can shrink) */
  flex-shrink: 1;  /* can shrink (default) */
  flex-shrink: 0;  /* don't shrink (fixed size) */

  /* Base size before grow/shrink */
  flex-basis: auto;   /* use width/height (default) */
  flex-basis: 200px;  /* start at 200px */
  flex-basis: 0;      /* start at 0 (used with flex-grow) */
  flex-basis: 33.33%; /* 3 equal columns */

  /* Shorthand: grow shrink basis */
  flex: 0 1 auto;   /* default */
  flex: 1;          /* flex: 1 1 0 — grow to fill equally */
  flex: auto;       /* flex: 1 1 auto */
  flex: none;       /* flex: 0 0 auto — fixed, no grow or shrink */

  /* Override container's align-items for this specific item */
  align-self: auto;         /* use container's align-items (default) */
  align-self: flex-start;
  align-self: flex-end;
  align-self: center;
  align-self: stretch;

  /* Order — controls render order (doesn't affect HTML order) */
  order: 0;   /* default */
  order: -1;  /* appears first */
  order: 1;   /* appears last among default items */
}
```

### Common Flexbox Patterns

```css
/* Center anything perfectly */
.center-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}

/* Navigation bar */
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
}

/* Equal-width columns */
.columns {
  display: flex;
  gap: 20px;
}
.column {
  flex: 1; /* all columns equal width */
}

/* Sidebar layout */
.layout {
  display: flex;
}
.sidebar {
  flex: 0 0 250px; /* fixed 250px, don't grow or shrink */
}
.content {
  flex: 1; /* takes remaining space */
}

/* Push last item to the right */
.header {
  display: flex;
  align-items: center;
}
.logo { flex: 1; }            /* logo takes all space */
.actions { flex: 0 0 auto; } /* buttons don't grow */

/* Card with footer pinned to bottom */
.card {
  display: flex;
  flex-direction: column;
  height: 300px;
}
.card-body { flex: 1; }       /* takes remaining space */
.card-footer { flex: 0; }     /* stays at bottom */
```

---

## PART 9: CSS Grid — Complete Guide

Grid is for two-dimensional layouts (rows AND columns simultaneously).

```css
/* ===== GRID CONTAINER ===== */
.grid {
  display: grid;

  /* Define columns */
  grid-template-columns: 200px 200px 200px;       /* 3 fixed columns */
  grid-template-columns: 1fr 1fr 1fr;             /* 3 equal columns (fr = fraction) */
  grid-template-columns: repeat(3, 1fr);          /* same as above */
  grid-template-columns: 200px 1fr;               /* fixed + flexible */
  grid-template-columns: repeat(3, minmax(150px, 1fr)); /* min 150, max equal */
  grid-template-columns: auto 1fr auto;           /* content-based + flexible */

  /* Define rows */
  grid-template-rows: 100px auto 50px;    /* header content footer */
  grid-template-rows: repeat(3, 200px);  /* 3 rows of 200px */

  /* Auto-create rows for overflow items */
  grid-auto-rows: 200px;             /* each new row = 200px */
  grid-auto-rows: minmax(100px, auto); /* min 100px, grows with content */

  /* Auto-create columns */
  grid-auto-columns: 150px;
  grid-auto-flow: column;  /* default: row — add items row by row */
                           /* column — add items column by column */

  /* Gap between cells */
  gap: 20px;
  row-gap: 20px;
  column-gap: 10px;

  /* Named areas */
  grid-template-areas:
    "header header header"
    "sidebar main main"
    "footer footer footer";

  /* Alignment of items in their cells */
  justify-items: start;    /* horizontal: start/end/center/stretch */
  align-items: center;     /* vertical: start/end/center/stretch */

  /* Alignment of all grid tracks in the container */
  justify-content: space-between;
  align-content: start;
}

/* ===== GRID ITEMS ===== */
.item {
  /* Span columns */
  grid-column: 1 / 3;          /* from column line 1 to 3 */
  grid-column: 1 / span 2;     /* start at 1, span 2 columns */
  grid-column: 2;              /* place in column 2 */

  /* Span rows */
  grid-row: 1 / 3;
  grid-row: 1 / span 2;

  /* Place item in named area */
  grid-area: header;

  /* Override container alignment for this item */
  justify-self: center;
  align-self: end;

  /* Shorthand: row-start / column-start / row-end / column-end */
  grid-area: 1 / 1 / 2 / 3;
}
```

### Common Grid Patterns

```css
/* Responsive grid — auto-fit creates columns as space allows */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}
/* This creates as many 250px-minimum columns as fit — responsive without media queries! */

/* Full page layout */
.page {
  display: grid;
  grid-template-rows: 64px 1fr 50px;
  grid-template-areas:
    "header"
    "main"
    "footer";
  min-height: 100vh;
}
header { grid-area: header; }
main { grid-area: main; }
footer { grid-area: footer; }

/* Sidebar + content layout */
.layout {
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-template-areas:
    "sidebar header"
    "sidebar main"
    "sidebar footer";
}
.sidebar { grid-area: sidebar; }
.header { grid-area: header; }
.main { grid-area: main; }

/* Holy grail layout */
.holy-grail {
  display: grid;
  grid-template-columns: 200px 1fr 200px;
  grid-template-rows: auto 1fr auto;
  grid-template-areas:
    "header header header"
    "left main right"
    "footer footer footer";
  min-height: 100vh;
}
```

---

## PART 10: Typography — Fonts and Text

```css
/* ===== FONT FAMILY ===== */
body {
  /* Specify multiple fonts — browser tries each until one works */
  font-family: "Inter", "Helvetica Neue", Arial, sans-serif;
  /* Always end with a generic family: serif, sans-serif, monospace, cursive, fantasy */
}

/* Load a Google Font (in HTML head) */
/* <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" /> */

/* Load font locally with @font-face */
@font-face {
  font-family: "MyCustomFont";
  src: url("/fonts/MyFont.woff2") format("woff2"),
       url("/fonts/MyFont.woff") format("woff");
  font-weight: normal;
  font-style: normal;
  font-display: swap; /* show fallback font until custom font loads */
}

/* ===== FONT SIZE ===== */
p { font-size: 16px; }       /* pixels — absolute */
p { font-size: 1rem; }       /* relative to root (html) font-size */
p { font-size: 1em; }        /* relative to parent element's font-size */
p { font-size: 1.2vw; }      /* percentage of viewport width */

/* Set root font size — then use rem everywhere */
html { font-size: 16px; }    /* 1rem = 16px */
h1 { font-size: 3rem; }      /* 48px */
h2 { font-size: 2rem; }      /* 32px */

/* Clamp — responsive font size without media queries */
h1 { font-size: clamp(1.5rem, 5vw, 3rem); }
/* minimum 1.5rem, scales with viewport, maximum 3rem */

/* ===== FONT WEIGHT ===== */
p { font-weight: 400; }      /* normal (same as "normal") */
p { font-weight: 700; }      /* bold (same as "bold") */
p { font-weight: 100; }      /* thin */
p { font-weight: 300; }      /* light */
p { font-weight: 500; }      /* medium */
p { font-weight: 600; }      /* semi-bold */
p { font-weight: 800; }      /* extra-bold */
p { font-weight: 900; }      /* black */

/* ===== FONT STYLE ===== */
em { font-style: italic; }
cite { font-style: normal; }

/* ===== LINE HEIGHT ===== */
p { line-height: 1.6; }      /* unitless — recommended (relative to font-size) */
p { line-height: 24px; }     /* absolute */
p { line-height: 160%; }     /* percentage */

/* ===== LETTER SPACING ===== */
h1 { letter-spacing: -0.02em; }  /* slightly tighter (good for large headings) */
.caps { letter-spacing: 0.1em; } /* wider (good for uppercase labels) */

/* ===== WORD SPACING ===== */
p { word-spacing: 0.1em; }

/* ===== TEXT ALIGNMENT ===== */
p { text-align: left; }
p { text-align: right; }
p { text-align: center; }
p { text-align: justify; }   /* stretch to fill width (like newspaper) */
p { text-align: start; }     /* language-appropriate start (left for LTR) */

/* ===== TEXT DECORATION ===== */
a { text-decoration: none; }          /* remove underline */
a { text-decoration: underline; }
p { text-decoration: line-through; }  /* strikethrough */
p { text-decoration: overline; }
p { text-decoration: underline dotted red; } /* style + color */
p { text-underline-offset: 4px; }    /* space between text and underline */

/* ===== TEXT TRANSFORM ===== */
h1 { text-transform: uppercase; }
p { text-transform: lowercase; }
p { text-transform: capitalize; }   /* First Letter Of Each Word */
p { text-transform: none; }

/* ===== TEXT INDENT ===== */
p { text-indent: 2em; }   /* indent first line (book paragraph style) */

/* ===== WORD WRAP / OVERFLOW ===== */
p { word-wrap: break-word; }          /* break long words */
p { overflow-wrap: break-word; }      /* modern version */
p { word-break: break-all; }          /* break at any character */
p { white-space: nowrap; }            /* prevent wrapping */
p { white-space: pre; }               /* preserve spaces and newlines */
p { white-space: pre-wrap; }          /* preserve + wrap */

/* Text overflow — ellipsis for truncated text */
.truncate {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;  /* shows "..." when text is cut off */
  width: 200px;
}

/* Multi-line truncation */
.clamp-text {
  display: -webkit-box;
  -webkit-line-clamp: 3;       /* show max 3 lines */
  -webkit-box-orient: vertical;
  overflow: hidden;
}
```

---

## PART 11: Colors

```css
/* ===== COLOR FORMATS ===== */

/* Named colors */
p { color: red; }
p { color: cornflowerblue; }
p { color: tomato; }

/* Hex colors */
p { color: #ff0000; }       /* red */
p { color: #ff0000ff; }     /* red with full opacity */
p { color: #f00; }          /* shorthand (3 chars) */
p { color: #f00f; }         /* shorthand with opacity */

/* RGB */
p { color: rgb(255, 0, 0); }
p { color: rgb(255, 0, 0, 0.5); }   /* with transparency (0-1) */
p { color: rgba(255, 0, 0, 0.5); }  /* same, older syntax */

/* HSL — Hue Saturation Lightness (most intuitive) */
p { color: hsl(0, 100%, 50%); }     /* red */
p { color: hsl(240, 100%, 50%); }   /* blue */
p { color: hsl(120, 100%, 50%); }   /* green */
p { color: hsl(0, 100%, 50%, 0.5); } /* semi-transparent red */

/*
  Hue:        0-360 degrees (color wheel: 0=red, 120=green, 240=blue, 360=red)
  Saturation: 0% = gray, 100% = full color
  Lightness:  0% = black, 50% = normal, 100% = white
*/

/* oklch — modern, perceptually uniform (best for design systems) */
p { color: oklch(0.7 0.15 250); } /* lightness chroma hue */

/* currentColor — inherits the current color value */
.icon {
  color: blue;
  border: 2px solid currentColor; /* border will also be blue */
}

/* transparent */
.ghost-button {
  background: transparent;
  border: 2px solid white;
  color: white;
}

/* Gradients (used in backgrounds) */
.gradient {
  background: linear-gradient(to right, #6366f1, #8b5cf6);
  background: linear-gradient(135deg, red, blue, green);
  background: radial-gradient(circle, red, blue);
  background: conic-gradient(from 0deg, red, yellow, green, blue, red);
}
```

---

## PART 12: Backgrounds

```css
div {
  /* Background color */
  background-color: #f0f0f0;
  background-color: rgba(0, 0, 0, 0.5); /* semi-transparent */

  /* Background image */
  background-image: url("photo.jpg");
  background-image: url("photo.jpg"), url("overlay.png"); /* multiple images */
  background-image: linear-gradient(to right, #6366f1, #8b5cf6);

  /* How to repeat the image */
  background-repeat: no-repeat;  /* don't repeat */
  background-repeat: repeat;     /* tile in both directions (default) */
  background-repeat: repeat-x;   /* tile horizontally only */
  background-repeat: repeat-y;   /* tile vertically only */
  background-repeat: space;      /* tile without clipping */
  background-repeat: round;      /* tile and scale to fit without clipping */

  /* Position of background image */
  background-position: center;
  background-position: top right;
  background-position: 50% 50%;
  background-position: 20px 40px;

  /* Size of background image */
  background-size: auto;         /* original size */
  background-size: cover;        /* fill entire element (may crop) */
  background-size: contain;      /* fit entirely inside (may leave gaps) */
  background-size: 300px 200px;  /* exact size */
  background-size: 50% auto;

  /* Whether image scrolls with page */
  background-attachment: scroll;  /* scrolls with page (default) */
  background-attachment: fixed;   /* stays fixed as page scrolls (parallax effect) */
  background-attachment: local;   /* scrolls with element's content */

  /* Where background starts (origin) */
  background-origin: padding-box; /* default */
  background-origin: border-box;
  background-origin: content-box;

  /* Where background is clipped */
  background-clip: border-box;    /* default — shows under border */
  background-clip: padding-box;   /* clips at padding edge */
  background-clip: content-box;   /* clips at content edge */
  background-clip: text;          /* clips to text shape (cool effect!) */

  /* Shorthand: color image position / size repeat attachment origin clip */
  background: #f0f0f0 url("photo.jpg") center / cover no-repeat;
}

/* Cool text gradient effect */
.gradient-text {
  background: linear-gradient(to right, #6366f1, #ec4899);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  color: transparent;
}
```

---

## PART 13: Shadows

```css
/* Box shadow */
div {
  /* offset-x offset-y blur-radius color */
  box-shadow: 4px 4px 8px rgba(0,0,0,0.2);

  /* offset-x offset-y blur-radius spread-radius color */
  box-shadow: 0 4px 12px 0 rgba(0,0,0,0.15);

  /* inset — shadow INSIDE the element */
  box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);

  /* Multiple shadows */
  box-shadow: 0 2px 4px rgba(0,0,0,0.1), 0 8px 16px rgba(0,0,0,0.1);

  /* No shadow */
  box-shadow: none;

  /* Colored shadow (for glow effects) */
  box-shadow: 0 0 20px rgba(99,102,241,0.5);
}

/* Text shadow */
h1 {
  text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
  text-shadow: 0 0 10px rgba(99,102,241,0.8); /* glow effect */

  /* Multiple text shadows */
  text-shadow: 1px 1px 0 #000, 2px 2px 0 #333, 3px 3px 0 #666;

  text-shadow: none;
}
```

---

## PART 14: Transitions and Animations

### Transitions — Smooth Change Between States

```css
/* Basic transition */
button {
  background: blue;
  transition: background 0.3s ease;
}
button:hover {
  background: darkblue;
}

/* Transition all properties */
.card {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.2);
}

/* Full transition syntax */
.element {
  transition:
    property       /* what to animate (color, transform, all) */
    duration       /* how long (0.3s, 300ms) */
    timing-function /* speed curve */
    delay;         /* wait before starting */
}

.button {
  transition: background-color 0.3s ease 0s,
              transform 0.2s ease-out 0s,
              box-shadow 0.3s ease 0s;
}

/* Timing functions */
.el { transition: all 0.3s ease; }           /* slow start and end */
.el { transition: all 0.3s linear; }         /* constant speed */
.el { transition: all 0.3s ease-in; }        /* slow start, fast end */
.el { transition: all 0.3s ease-out; }       /* fast start, slow end */
.el { transition: all 0.3s ease-in-out; }    /* slow start and end */
.el { transition: all 0.3s steps(5); }       /* step-by-step (5 steps) */
.el { transition: all 0.3s cubic-bezier(0.68, -0.55, 0.27, 1.55); } /* bounce */
```

### @keyframes Animations

```css
/* Define the animation */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0%   { transform: scale(1); }
  50%  { transform: scale(1.05); }
  100% { transform: scale(1); }
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

@keyframes bounce {
  0%, 20%, 53%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-30px); }
  70% { transform: translateY(-15px); }
  90% { transform: translateY(-4px); }
}

@keyframes shimmer {
  0%   { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

/* Apply animations */
.modal {
  animation: fadeIn 0.3s ease-out;
}

.notification {
  animation: slideUp 0.4s ease-out;
}

.loader {
  animation:
    spin             /* animation name */
    1s               /* duration */
    linear           /* timing function */
    infinite;        /* iteration count: 1, 2, infinite */
}

.card {
  animation:
    fadeIn           /* name */
    0.5s             /* duration */
    ease-out         /* timing */
    0.2s             /* delay */
    1                /* iteration count */
    normal           /* direction: normal, reverse, alternate, alternate-reverse */
    forwards;        /* fill-mode: none, forwards, backwards, both */
                     /* forwards = stay at final keyframe state after animation */
}

/* Pause/play animation */
.paused { animation-play-state: paused; }
.running { animation-play-state: running; }

/* Respect user's reduced motion preference */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## PART 15: Transform

```css
/* 2D Transforms */
.el {
  /* Move element */
  transform: translateX(50px);   /* move right 50px */
  transform: translateY(-20px);  /* move up 20px */
  transform: translate(50px, -20px); /* move right and up */
  transform: translate(50%, 50%); /* percentage of own size */

  /* Scale element */
  transform: scaleX(1.5);      /* stretch horizontally by 1.5x */
  transform: scaleY(0.8);      /* compress vertically */
  transform: scale(1.5);       /* scale both axes */
  transform: scale(1.5, 0.8);  /* scale differently per axis */

  /* Rotate element */
  transform: rotate(45deg);    /* clockwise 45 degrees */
  transform: rotate(-45deg);   /* counterclockwise */
  transform: rotate(0.5turn);  /* half rotation */

  /* Skew element */
  transform: skewX(20deg);
  transform: skewY(10deg);
  transform: skew(20deg, 10deg);

  /* Chain multiple transforms */
  transform: translateX(50px) rotate(45deg) scale(1.2);

  /* Origin of transformation (default: center center) */
  transform-origin: top left;
  transform-origin: 0 0;
  transform-origin: 50% 50%;
}

/* 3D Transforms */
.card-3d {
  transform: rotateX(45deg);         /* tilt top-bottom */
  transform: rotateY(45deg);         /* spin left-right */
  transform: rotateZ(45deg);         /* same as 2D rotate */
  transform: rotate3d(1, 1, 0, 45deg);
  transform: translateZ(50px);       /* move toward/away from viewer */
  transform: perspective(500px) rotateY(45deg);

  /* 3D perspective for children */
  perspective: 500px;                /* applied to parent */
  perspective-origin: center;
}

/* 3D card flip effect */
.card { perspective: 1000px; }
.card-inner {
  transform-style: preserve-3d;
  transition: transform 0.6s;
}
.card:hover .card-inner {
  transform: rotateY(180deg);
}
.card-front, .card-back {
  backface-visibility: hidden;  /* hides back face of flipped element */
}
.card-back {
  transform: rotateY(180deg);
}
```

---

## PART 16: CSS Variables (Custom Properties)

```css
/* Define variables */
:root {
  /* Colors */
  --color-primary: #6366f1;
  --color-primary-dark: #4338ca;
  --color-secondary: #8b5cf6;
  --color-success: #10b981;
  --color-danger: #ef4444;
  --color-warning: #f59e0b;
  --color-text: #1f2937;
  --color-text-muted: #6b7280;
  --color-background: #ffffff;
  --color-surface: #f9fafb;
  --color-border: #e5e7eb;

  /* Typography */
  --font-sans: "Inter", "Helvetica Neue", Arial, sans-serif;
  --font-mono: "Fira Code", "Courier New", monospace;
  --font-size-sm: 0.875rem;  /* 14px */
  --font-size-base: 1rem;    /* 16px */
  --font-size-lg: 1.125rem;  /* 18px */
  --font-size-xl: 1.25rem;   /* 20px */
  --font-size-2xl: 1.5rem;   /* 24px */
  --font-size-3xl: 1.875rem; /* 30px */
  --font-size-4xl: 2.25rem;  /* 36px */

  /* Spacing scale */
  --space-1: 0.25rem;  /* 4px */
  --space-2: 0.5rem;   /* 8px */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-12: 3rem;    /* 48px */
  --space-16: 4rem;    /* 64px */

  /* Border radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.07);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);

  /* Transitions */
  --transition-fast: 150ms ease;
  --transition-normal: 250ms ease;
  --transition-slow: 350ms ease;

  /* Z-index scale */
  --z-base: 1;
  --z-dropdown: 100;
  --z-sticky: 200;
  --z-overlay: 300;
  --z-modal: 400;
  --z-toast: 500;
}

/* Use variables */
button {
  background-color: var(--color-primary);
  color: white;
  border-radius: var(--radius-md);
  padding: var(--space-2) var(--space-4);
  font-family: var(--font-sans);
  font-size: var(--font-size-base);
  transition: background-color var(--transition-fast);
}

button:hover {
  background-color: var(--color-primary-dark);
}

/* Dark mode with variables */
@media (prefers-color-scheme: dark) {
  :root {
    --color-text: #f9fafb;
    --color-background: #111827;
    --color-surface: #1f2937;
    --color-border: #374151;
  }
}

/* Manual dark mode toggle */
[data-theme="dark"] {
  --color-text: #f9fafb;
  --color-background: #111827;
  --color-surface: #1f2937;
}

/* Variables inside JavaScript */
/* document.documentElement.style.setProperty('--color-primary', '#ff0000'); */
/* const value = getComputedStyle(document.documentElement).getPropertyValue('--color-primary'); */

/* Fallback value */
div { color: var(--color-text, black); }
/* If --color-text is not defined, use black */
```

---

## PART 17: Media Queries — Responsive Design

```css
/* ===== BREAKPOINTS ===== */
/* Common breakpoints (use these or define your own): */
/* xs: < 480px    (small mobile) */
/* sm: 480-639px  (mobile) */
/* md: 640-767px  (large mobile/small tablet) */
/* lg: 768-1023px (tablet) */
/* xl: 1024-1279px (small desktop) */
/* 2xl: ≥ 1280px  (desktop) */

/* Mobile-first approach (recommended) */
/* Write base styles for mobile, then override for larger screens */

/* Base (mobile) */
.container {
  padding: 16px;
  max-width: 100%;
}

/* Tablet (768px and up) */
@media (min-width: 768px) {
  .container {
    padding: 24px;
    max-width: 768px;
    margin: 0 auto;
  }
}

/* Desktop (1024px and up) */
@media (min-width: 1024px) {
  .container {
    padding: 32px;
    max-width: 1280px;
  }
}

/* Desktop-first approach */
/* Write base styles for desktop, then override for smaller screens */
@media (max-width: 1023px) { /* tablet */ }
@media (max-width: 767px) { /* mobile */ }

/* Range queries */
@media (min-width: 768px) and (max-width: 1023px) {
  /* tablet only */
}

/* Orientation */
@media (orientation: landscape) { }
@media (orientation: portrait) { }

/* Device features */
@media (hover: hover) {
  /* Device supports hover (mouse) */
  button:hover { background: blue; }
}
@media (hover: none) {
  /* Touch device — no hover */
}

/* Display mode (PWA) */
@media (display-mode: standalone) {
  /* App installed as PWA */
}

/* Print styles */
@media print {
  .no-print { display: none; }
  body { font-size: 12pt; color: black; }
  a { color: black; text-decoration: none; }
  a::after { content: " (" attr(href) ")"; } /* show URLs when printing */
}

/* Prefer reduced motion (accessibility) */
@media (prefers-reduced-motion: reduce) {
  * { animation: none !important; transition: none !important; }
}

/* Prefer color scheme */
@media (prefers-color-scheme: dark) { }
@media (prefers-color-scheme: light) { }

/* High DPI / Retina displays */
@media (-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi) {
  .logo { background-image: url("logo@2x.png"); }
}

/* Container queries (modern — query parent size, not viewport) */
.card-container {
  container-type: inline-size;
  container-name: card;
}
@container card (min-width: 400px) {
  .card { flex-direction: row; }
}
```

---

## PART 18: Units — Complete Reference

```css
/* ===== ABSOLUTE UNITS ===== */
p { font-size: 16px; }   /* pixels — most common */
p { font-size: 12pt; }   /* points — for print */
p { width: 5cm; }        /* centimeters — for print */
p { width: 2in; }        /* inches — for print */

/* ===== RELATIVE UNITS ===== */
p { font-size: 1em; }    /* relative to PARENT element's font-size */
                          /* 1em = 16px if parent is 16px */
                          /* Problem: nested em values compound (1.5em inside 1.5em = 2.25em) */

p { font-size: 1rem; }   /* relative to ROOT (html) element's font-size */
                          /* Does NOT compound — always 1rem = html's font-size */
                          /* RECOMMENDED for font sizes */

/* Viewport units */
div { width: 100vw; }    /* 100% of viewport width */
div { height: 100vh; }   /* 100% of viewport height */
div { width: 50vmin; }   /* 50% of smaller dimension (width or height) */
div { width: 50vmax; }   /* 50% of larger dimension */

/* Dynamic viewport units (newer — accounts for mobile browser chrome) */
div { height: 100dvh; }  /* dynamic — accounts for URL bar show/hide */
div { height: 100svh; }  /* small — minimum viewport height */
div { height: 100lvh; }  /* large — maximum viewport height */

/* Percentage */
div { width: 50%; }      /* 50% of parent's width */
div { height: 50%; }     /* 50% of parent's height (parent must have defined height) */
p { font-size: 120%; }   /* 120% of parent's font-size */

/* fr — fraction unit (only in Grid) */
.grid { grid-template-columns: 1fr 2fr 1fr; }
/* 1fr + 2fr + 1fr = 4fr total. Columns: 25% 50% 25% */

/* ch — width of "0" character (good for text containers) */
article { max-width: 65ch; } /* optimal reading width is 60-75 chars */

/* ex — height of "x" character */
p { line-height: 3ex; }

/* lh — current line height */
/* rlh — root line height */

/* ===== WHEN TO USE WHICH ===== */
/*
  px  → borders, shadows, small fixed sizes
  rem → font-sizes, spacing (consistent, respects user preferences)
  em  → icon sizes (matches text size), local spacing proportional to text
  %   → fluid widths, heights relative to parent
  vw/vh → full-page layouts, viewport-relative sizing
  fr  → grid columns/rows
  ch  → article/paragraph max-width
*/
```

---

## PART 19: Overflow

```css
div {
  overflow: visible;  /* content shows outside box (default) */
  overflow: hidden;   /* hides content outside box (and creates BFC) */
  overflow: scroll;   /* always show scrollbars */
  overflow: auto;     /* show scrollbars only when needed (recommended) */
  overflow: clip;     /* clips without creating scroll context */

  /* Separate X and Y */
  overflow-x: hidden;
  overflow-y: auto;
  overflow-x: scroll;

  /* Scrolling behavior */
  scroll-behavior: smooth;   /* smooth animated scrolling */
  scroll-behavior: auto;     /* instant scrolling (default) */

  /* Snap scrolling */
  scroll-snap-type: x mandatory;  /* horizontal snap required */
  scroll-snap-type: y proximity;  /* vertical snap when close */
}

.scroll-item {
  scroll-snap-align: start;  /* snap to start of item */
  scroll-snap-align: center; /* snap to center */
  scroll-snap-align: end;    /* snap to end */
}

/* Custom scrollbar (webkit browsers) */
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: #f1f1f1; }
::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover { background: #555; }
```

---

## PART 20: CSS Filters and Effects

```css
/* Filters — apply visual effects to elements */
img {
  filter: blur(4px);                    /* blur */
  filter: brightness(1.5);             /* 0 = black, 1 = normal, 2 = double bright */
  filter: contrast(2);                  /* 0 = gray, 1 = normal, 2 = high contrast */
  filter: grayscale(1);                 /* 0 = color, 1 = full grayscale */
  filter: hue-rotate(90deg);            /* rotate colors */
  filter: invert(1);                    /* 0 = normal, 1 = fully inverted */
  filter: opacity(0.5);                 /* transparency (prefer CSS opacity instead) */
  filter: saturate(2);                  /* 0 = grayscale, 1 = normal, 2 = super saturated */
  filter: sepia(1);                     /* 0 = normal, 1 = full sepia */
  filter: drop-shadow(4px 4px 8px rgba(0,0,0,0.3)); /* like box-shadow but for non-rect */

  /* Chain multiple filters */
  filter: brightness(1.1) contrast(1.05) saturate(1.1);
}

/* Backdrop filter — apply effects to the background BEHIND the element */
.glass-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(12px) brightness(1.1);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Opacity */
.faded { opacity: 0.5; }     /* 0 = invisible, 1 = fully visible */
.invisible { opacity: 0; }   /* invisible but still takes space */
/* Note: opacity affects ALL children. Use rgba() for just background transparency */

/* Mix blend mode */
.overlay {
  mix-blend-mode: multiply;
  mix-blend-mode: screen;
  mix-blend-mode: overlay;
}
```

---

## PART 21: CSS Functions

```css
/* calc() — do math with CSS values */
.sidebar { width: calc(100% - 250px); }
.button { padding: calc(var(--space-2) * 1.5) calc(var(--space-4) * 1.5); }
.grid { grid-template-columns: calc(50% - 10px) calc(50% - 10px); }

/* clamp(min, preferred, max) */
h1 { font-size: clamp(1.5rem, 5vw, 3rem); }
.container { width: clamp(320px, 90%, 1200px); }

/* min() and max() */
.container { width: min(90%, 1200px); }   /* takes the smaller value */
.sidebar { width: max(200px, 20%); }      /* takes the larger value */

/* env() — access environment variables (safe areas for notched phones) */
body {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}

/* attr() — use HTML attribute value in CSS */
a::after {
  content: attr(href);   /* shows URL after link */
}
div::after {
  content: attr(data-label);  /* shows data attribute value */
}
```

---

## PART 22: BEM — CSS Naming Convention

BEM (Block Element Modifier) is the most popular naming convention for large projects:

```css
/* Block — standalone component */
.card { }
.button { }
.nav { }

/* Element — part of a block (double underscore) */
.card__header { }
.card__body { }
.card__footer { }
.button__icon { }
.nav__item { }
.nav__link { }

/* Modifier — variation of block or element (double dash) */
.button--primary { background: blue; }
.button--secondary { background: gray; }
.button--large { padding: 16px 32px; }
.button--disabled { opacity: 0.5; }

.card--featured { border: 2px solid gold; }
.card--dark { background: #1a1a1a; color: white; }

.nav__item--active { font-weight: bold; }
```

```html
<!-- Usage in HTML -->
<div class="card card--featured">
  <div class="card__header">
    <h2 class="card__title">Featured Post</h2>
  </div>
  <div class="card__body">
    <p class="card__text">Content here...</p>
  </div>
  <div class="card__footer">
    <button class="button button--primary">Read More</button>
    <button class="button button--secondary button--large">Share</button>
  </div>
</div>
```

---

## PART 23: Common CSS Patterns

```css
/* ===== CENTERING ===== */
/* Horizontally center a block element */
.center { margin: 0 auto; max-width: 600px; }

/* Flex centering */
.flex-center { display: flex; justify-content: center; align-items: center; }

/* Grid centering */
.grid-center { display: grid; place-items: center; }

/* Absolute center */
.absolute-center {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

/* ===== ASPECT RATIO ===== */
.video-wrapper { aspect-ratio: 16 / 9; }
.square { aspect-ratio: 1; }
.profile-pic { aspect-ratio: 1; border-radius: 50%; }

/* ===== OBJECT FIT for images/videos ===== */
img {
  width: 100%;
  height: 300px;
  object-fit: cover;     /* fills box, crops excess */
  object-fit: contain;   /* fits inside box, adds letterbox */
  object-fit: fill;      /* stretches to fill (distorts) */
  object-fit: none;      /* original size */
  object-position: top center; /* where to anchor when cropping */
}

/* ===== SMOOTH SCROLLING ===== */
html { scroll-behavior: smooth; }

/* ===== CSS RESET ===== */
*, *::before, *::after { box-sizing: border-box; }
* { margin: 0; padding: 0; }
body { line-height: 1.5; -webkit-font-smoothing: antialiased; }
img, video { max-width: 100%; display: block; }
button { cursor: pointer; border: none; background: none; font: inherit; }
input, textarea, select { font: inherit; }
p, h1, h2, h3, h4, h5, h6 { overflow-wrap: break-word; }
```

---

## PART 24: CSS Grid Advanced — Subgrid and Masonry

```css
/* Subgrid — child inherits parent grid tracks */
.grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}
.card {
  grid-column: span 2;
  display: grid;
  grid-template-columns: subgrid; /* uses parent's column tracks */
}

/* Masonry layout (Chrome Canary / Firefox with flag) */
.masonry {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-template-rows: masonry;
}
```

---

## PART 25: Logical Properties (Modern CSS)

Logical properties work for any writing direction (LTR, RTL, vertical):

```css
/* Instead of left/right, use start/end */
p {
  margin-inline-start: 20px;   /* left in LTR, right in RTL */
  margin-inline-end: 20px;     /* right in LTR, left in RTL */
  margin-inline: 20px;         /* both sides */
  margin-block-start: 10px;    /* top */
  margin-block-end: 10px;      /* bottom */
  margin-block: 10px;          /* top and bottom */

  padding-inline: 20px;
  padding-block: 10px;

  border-inline-start: 3px solid blue;  /* left border in LTR */
  border-block-end: 1px solid gray;     /* bottom border */

  inset-inline-start: 0;  /* left: 0 in LTR */
  inset-block-start: 0;   /* top: 0 */

  inline-size: 300px;     /* width in horizontal writing */
  block-size: 200px;      /* height in horizontal writing */
  max-inline-size: 100%;  /* max-width */
}
```

---

## Summary: Most Important CSS Properties

| Category | Properties |
|---|---|
| **Box Model** | `width`, `height`, `padding`, `margin`, `border`, `box-sizing` |
| **Typography** | `font-family`, `font-size`, `font-weight`, `line-height`, `text-align`, `color` |
| **Display** | `display`, `visibility`, `opacity` |
| **Position** | `position`, `top`, `right`, `bottom`, `left`, `z-index` |
| **Flexbox** | `display:flex`, `flex-direction`, `justify-content`, `align-items`, `flex`, `gap` |
| **Grid** | `display:grid`, `grid-template-columns`, `grid-template-rows`, `gap`, `grid-area` |
| **Background** | `background-color`, `background-image`, `background-size`, `background-position` |
| **Borders** | `border`, `border-radius`, `outline` |
| **Transform** | `transform: translate/scale/rotate/skew` |
| **Animation** | `transition`, `animation`, `@keyframes` |
| **Shadows** | `box-shadow`, `text-shadow` |
| **Overflow** | `overflow`, `text-overflow`, `white-space` |
| **Variables** | `--variable`, `var()` |
| **Responsive** | `@media`, `clamp()`, `min()`, `max()` |
| **Modern** | `aspect-ratio`, `object-fit`, `backdrop-filter`, `gap` |
