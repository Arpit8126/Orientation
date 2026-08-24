# HTML — Complete Guide from Zero to Real World

HTML (HyperText Markup Language) is the skeleton of every webpage. It defines the **structure and content** of a page. CSS makes it look good. JavaScript makes it interactive. But HTML is the foundation — without it, nothing exists.

---

## PART 1: The Basics

### What Is an HTML Element?

An HTML element = opening tag + content + closing tag:

```html
<tagname>content goes here</tagname>
```

- `<p>Hello World</p>` — a paragraph
- `<h1>Main Title</h1>` — a heading
- `<button>Click Me</button>` — a button

Some elements are **self-closing** (no content, no closing tag):
```html
<img src="photo.jpg" alt="A photo" />
<br />
<input type="text" />
<hr />
<meta charset="UTF-8" />
<link rel="stylesheet" href="style.css" />
```

### Attributes

Attributes give extra information to an element. They go inside the opening tag:

```html
<tagname attribute="value">content</tagname>

<a href="https://google.com">Visit Google</a>
<!--  ^^^attribute name  ^^^value           -->

<img src="photo.jpg" alt="Description" width="300" />
<input type="email" placeholder="Enter email" required />
<div id="main-header" class="header dark">...</div>
```

---

## PART 2: The Complete Document Structure

Every HTML file must follow this exact structure:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Meta information — NOT visible on the page -->
    <meta charset="UTF-8" />
    <!-- UTF-8 supports all characters (Hindi, Chinese, emojis, etc.) -->

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Makes the page work correctly on mobile devices -->

    <title>My Page Title</title>
    <!-- Shown in browser tab and in Google search results -->

    <meta name="description" content="A brief description of this page" />
    <!-- Shown below the title in Google search results -->

    <link rel="stylesheet" href="style.css" />
    <!-- Links an external CSS file -->

    <link rel="icon" href="favicon.ico" type="image/x-icon" />
    <!-- The small icon shown in browser tab -->
  </head>

  <body>
    <!-- Everything visible on the page goes here -->
    <h1>Hello World</h1>
    <p>This is my first webpage.</p>

    <script src="app.js"></script>
    <!-- Script goes at the BOTTOM of body (loads after HTML renders) -->
  </body>
</html>
```

**Key points:**
- `<!DOCTYPE html>` — tells the browser this is HTML5 (not optional)
- `<html lang="en">` — `lang` attribute helps screen readers and search engines
- `<head>` — metadata, CSS links, title (nothing visible here)
- `<body>` — everything the user sees

---

## PART 3: Headings and Text

### Headings (h1 to h6)

```html
<h1>Main Page Title</h1>       <!-- Biggest — only 1 per page for SEO -->
<h2>Section Heading</h2>       <!-- Sub-section -->
<h3>Sub-section Heading</h3>
<h4>Smaller heading</h4>
<h5>Even smaller</h5>
<h6>Smallest heading</h6>      <!-- Rarely used -->
```

**Rule:** Never skip levels (don't jump from h1 to h4). Search engines and screen readers use headings to understand page structure.

### Paragraphs and Text Formatting

```html
<p>This is a paragraph of text.</p>

<p>
  You can have <strong>bold text</strong> and <em>italic text</em> inside a paragraph.
  Use <b>bold</b> for visual only (no meaning) and <strong> for important text.
  Use <i>italic</i> for visual only and <em> for emphasis.
</p>

<p>This is a <span class="highlight">highlighted word</span> inside a paragraph.</p>
<!-- span = inline container, used to style part of text -->

<br />  <!-- Line break — forces text to next line -->
<hr />  <!-- Horizontal rule — draws a horizontal line -->

<p>You can show <mark>highlighted text</mark> like this.</p>
<p>This is <del>deleted text</del> and this is <ins>inserted text</ins>.</p>
<p>H<sub>2</sub>O is water. E=mc<sup>2</sup> is Einstein's formula.</p>
<!-- sub = subscript (below baseline), sup = superscript (above) -->

<code>console.log("Hello")</code>  <!-- Inline code snippet -->

<pre>
  This text
    preserves
      all spacing
        and line breaks
</pre>
<!-- pre = preformatted text, respects spaces and newlines -->

<blockquote cite="https://example.com">
  "The only way to do great work is to love what you do."
  — Steve Jobs
</blockquote>

<abbr title="HyperText Markup Language">HTML</abbr>
<!-- abbr = abbreviation, shows full form on hover -->
```

---

## PART 4: Links

```html
<!-- External link — opens in same tab -->
<a href="https://google.com">Visit Google</a>

<!-- External link — opens in new tab -->
<a href="https://google.com" target="_blank" rel="noopener noreferrer">
  Visit Google (new tab)
</a>
<!-- rel="noopener noreferrer" is a security requirement for target="_blank" -->

<!-- Internal link — to another page in your site -->
<a href="/about">About Us</a>
<a href="contact.html">Contact</a>

<!-- Jump to a specific section on the SAME page (anchor link) -->
<a href="#section-2">Jump to Section 2</a>
<section id="section-2">
  <h2>Section 2</h2>
</section>

<!-- Email link — opens user's email app -->
<a href="mailto:arpit@example.com">Send Email</a>

<!-- Phone link — works on mobile -->
<a href="tel:+919876543210">Call Us</a>

<!-- Download link -->
<a href="/files/resume.pdf" download>Download Resume</a>
<a href="/files/resume.pdf" download="Arpit_Resume.pdf">Download Resume</a>
<!-- download attribute with value = custom filename when downloaded -->

<!-- Link wrapping an image (clickable image) -->
<a href="https://google.com">
  <img src="logo.png" alt="Click to visit Google" />
</a>
```

---

## PART 5: Images

```html
<!-- Basic image -->
<img src="photo.jpg" alt="A beautiful sunset" />

<!-- Always provide alt text:
  - Screen readers read it for blind users
  - Shows if image fails to load
  - Helps search engines understand the image
  - Leave empty alt="" for decorative images -->

<!-- Image with size control -->
<img src="photo.jpg" alt="Description" width="600" height="400" />

<!-- Image with different sources for different sizes (responsive) -->
<picture>
  <source media="(max-width: 600px)" srcset="small.jpg" />
  <source media="(max-width: 1200px)" srcset="medium.jpg" />
  <img src="large.jpg" alt="Description" />
  <!-- Browser picks the most appropriate source -->
</picture>

<!-- Srcset — multiple resolutions -->
<img
  src="photo.jpg"
  srcset="photo-400.jpg 400w, photo-800.jpg 800w, photo-1200.jpg 1200w"
  sizes="(max-width: 600px) 400px, (max-width: 900px) 800px, 1200px"
  alt="Description"
/>
<!-- Browser picks right resolution for the screen — saves bandwidth -->

<!-- Lazy loading — image only loads when scrolled into view -->
<img src="photo.jpg" alt="Description" loading="lazy" />

<!-- Figure with caption -->
<figure>
  <img src="chart.png" alt="Sales chart for Q1 2026" />
  <figcaption>Figure 1: Sales increased by 40% in Q1 2026.</figcaption>
</figure>
```

---

## PART 6: Lists

```html
<!-- Unordered list (bullet points) -->
<ul>
  <li>First item</li>
  <li>Second item</li>
  <li>Third item</li>
</ul>

<!-- Ordered list (numbered) -->
<ol>
  <li>Step one</li>
  <li>Step two</li>
  <li>Step three</li>
</ol>

<!-- Ordered list with custom start and type -->
<ol start="5" type="A">
  <!-- type: 1 (default), A (uppercase), a (lowercase), I (Roman), i -->
  <li>This starts at E</li>
  <li>This is F</li>
</ol>

<!-- Nested list -->
<ul>
  <li>Fruits
    <ul>
      <li>Apple</li>
      <li>Banana</li>
    </ul>
  </li>
  <li>Vegetables
    <ul>
      <li>Carrot</li>
      <li>Spinach</li>
    </ul>
  </li>
</ul>

<!-- Definition list — for glossaries, FAQs -->
<dl>
  <dt>HTML</dt>
  <dd>HyperText Markup Language — the structure of web pages.</dd>

  <dt>CSS</dt>
  <dd>Cascading Style Sheets — controls the appearance of web pages.</dd>

  <dt>JavaScript</dt>
  <dd>A programming language that makes web pages interactive.</dd>
</dl>
```

---

## PART 7: Tables

Tables are for **tabular data only** — not for layout.

```html
<table>
  <!-- caption = title of the table -->
  <caption>Student Marks — Semester 5</caption>

  <!-- thead = header row(s) -->
  <thead>
    <tr>
      <th scope="col">Name</th>
      <th scope="col">Subject</th>
      <th scope="col">Marks</th>
      <th scope="col">Grade</th>
    </tr>
  </thead>

  <!-- tbody = data rows -->
  <tbody>
    <tr>
      <td>Arpit Pandey</td>
      <td>Data Structures</td>
      <td>85</td>
      <td>A</td>
    </tr>
    <tr>
      <td>Priya Sharma</td>
      <td>Algorithms</td>
      <td>92</td>
      <td>A+</td>
    </tr>
  </tbody>

  <!-- tfoot = footer row (totals, summaries) -->
  <tfoot>
    <tr>
      <td colspan="2">Class Average</td>
      <!-- colspan merges cells horizontally -->
      <td>88.5</td>
      <td>A</td>
    </tr>
  </tfoot>
</table>

<!-- rowspan — merge cells vertically -->
<table>
  <tr>
    <td rowspan="2">Monday</td>
    <td>Period 1: Math</td>
  </tr>
  <tr>
    <td>Period 2: Science</td>
  </tr>
</table>
```

---

## PART 8: Forms — Complete Guide

Forms collect user input and send it to a server.

```html
<form action="/submit" method="POST" enctype="multipart/form-data">
  <!-- action = where to send the data (URL) -->
  <!-- method = GET (data in URL) or POST (data in body) -->
  <!-- enctype = multipart/form-data required ONLY when uploading files -->

  <!-- ===== TEXT INPUTS ===== -->
  <label for="username">Username:</label>
  <input
    type="text"
    id="username"
    name="username"
    placeholder="Enter username"
    value=""
    required
    minlength="3"
    maxlength="20"
    autocomplete="username"
  />
  <!-- id links to label's "for" — for accessibility -->
  <!-- name = key when data is sent to server -->
  <!-- required = cannot submit without filling this -->

  <!-- Email input — auto validates email format -->
  <label for="email">Email:</label>
  <input type="email" id="email" name="email" required />

  <!-- Password — hides typed characters -->
  <label for="password">Password:</label>
  <input type="password" id="password" name="password" minlength="8" required />

  <!-- Number input -->
  <label for="age">Age:</label>
  <input type="number" id="age" name="age" min="1" max="120" step="1" />

  <!-- Range slider -->
  <label for="volume">Volume:</label>
  <input type="range" id="volume" name="volume" min="0" max="100" value="50" />

  <!-- Date and time -->
  <input type="date" name="dob" min="2000-01-01" max="2026-12-31" />
  <input type="time" name="meeting-time" />
  <input type="datetime-local" name="appointment" />
  <input type="month" name="birth-month" />
  <input type="week" name="semester-week" />

  <!-- Color picker -->
  <input type="color" name="fav-color" value="#ff6600" />

  <!-- URL input — validates URL format -->
  <input type="url" name="website" placeholder="https://example.com" />

  <!-- Phone number -->
  <input type="tel" name="phone" pattern="[0-9]{10}" placeholder="10-digit number" />

  <!-- Hidden input — user cannot see but it sends data -->
  <input type="hidden" name="csrf_token" value="abc123xyz" />

  <!-- ===== TEXTAREA — multiline text ===== -->
  <label for="bio">Bio:</label>
  <textarea
    id="bio"
    name="bio"
    rows="4"
    cols="50"
    placeholder="Tell us about yourself..."
    maxlength="500"
  ></textarea>
  <!-- Note: textarea has a closing tag, unlike input -->

  <!-- ===== CHECKBOXES ===== -->
  <fieldset>
    <legend>Choose your interests:</legend>

    <input type="checkbox" id="coding" name="interests" value="coding" checked />
    <label for="coding">Coding</label>

    <input type="checkbox" id="music" name="interests" value="music" />
    <label for="music">Music</label>

    <input type="checkbox" id="sports" name="interests" value="sports" />
    <label for="sports">Sports</label>
  </fieldset>

  <!-- ===== RADIO BUTTONS — only one can be selected ===== -->
  <fieldset>
    <legend>Gender:</legend>

    <input type="radio" id="male" name="gender" value="male" />
    <label for="male">Male</label>

    <input type="radio" id="female" name="gender" value="female" />
    <label for="female">Female</label>

    <input type="radio" id="other" name="gender" value="other" />
    <label for="other">Other</label>
  </fieldset>
  <!-- All radio buttons with the same "name" are a group — only one selectable -->

  <!-- ===== SELECT DROPDOWN ===== -->
  <label for="city">Select City:</label>
  <select id="city" name="city" required>
    <option value="">-- Select a city --</option>
    <!-- empty value forces user to choose -->
    <option value="delhi">Delhi</option>
    <option value="mumbai" selected>Mumbai</option>
    <!-- selected = default selection -->
    <option value="bangalore">Bangalore</option>
    <option value="mathura">Mathura</option>
  </select>

  <!-- Select with option groups -->
  <select name="course">
    <optgroup label="Engineering">
      <option value="cse">Computer Science</option>
      <option value="mech">Mechanical</option>
    </optgroup>
    <optgroup label="Science">
      <option value="physics">Physics</option>
      <option value="chemistry">Chemistry</option>
    </optgroup>
  </select>

  <!-- Multiple select — hold Ctrl/Cmd to select multiple -->
  <select name="languages" multiple size="4">
    <option value="js">JavaScript</option>
    <option value="py">Python</option>
    <option value="java">Java</option>
    <option value="cpp">C++</option>
  </select>

  <!-- Datalist — text input with suggestions -->
  <label for="university">University:</label>
  <input list="university-list" id="university" name="university" />
  <datalist id="university-list">
    <option value="GLA University" />
    <option value="IIT Delhi" />
    <option value="VIT Vellore" />
    <option value="BITS Pilani" />
  </datalist>

  <!-- ===== FILE UPLOAD ===== -->
  <label for="avatar">Upload Profile Photo:</label>
  <input
    type="file"
    id="avatar"
    name="avatar"
    accept="image/png, image/jpeg, image/webp"
  />

  <!-- Multiple file upload -->
  <input type="file" name="documents" accept=".pdf,.docx" multiple />

  <!-- ===== BUTTONS ===== -->
  <!-- Submit — submits the form -->
  <button type="submit">Submit Form</button>

  <!-- Reset — clears all form inputs -->
  <button type="reset">Clear Form</button>

  <!-- Button — does nothing by default, controlled by JavaScript -->
  <button type="button" id="preview-btn">Preview</button>

  <!-- Input submit (older style) -->
  <input type="submit" value="Submit" />
  <input type="reset" value="Reset" />
  <input type="image" src="submit-button.png" alt="Submit" />

  <!-- ===== FIELDSET & LEGEND ===== -->
  <fieldset>
    <legend>Personal Information</legend>
    <label for="fname">First Name:</label>
    <input type="text" id="fname" name="fname" />
    <label for="lname">Last Name:</label>
    <input type="text" id="lname" name="lname" />
  </fieldset>

  <!-- ===== OUTPUT — result of a calculation ===== -->
  <form oninput="result.value = parseInt(a.value) + parseInt(b.value)">
    <input type="number" id="a" value="0" /> +
    <input type="number" id="b" value="0" /> =
    <output name="result" for="a b">0</output>
  </form>

  <!-- ===== PROGRESS & METER ===== -->
  <progress value="70" max="100">70%</progress>
  <!-- progress = shows how much of a task is done -->

  <meter value="0.75" min="0" max="1" low="0.25" high="0.75" optimum="1">
    75%
  </meter>
  <!-- meter = measures a value in a known range (disk space, score) -->

</form>
```

### Form Validation Attributes

```html
<!-- required — field must be filled -->
<input type="text" required />

<!-- minlength / maxlength — for text inputs -->
<input type="text" minlength="3" maxlength="50" />

<!-- min / max — for number, date, range -->
<input type="number" min="1" max="100" />

<!-- pattern — validates against a regex -->
<input type="text" pattern="[A-Za-z]{3,}" title="Only letters, min 3 chars" />

<!-- step — for number inputs -->
<input type="number" step="0.5" /> <!-- allows 0, 0.5, 1.0, 1.5 -->

<!-- novalidate — disable browser validation (you handle it with JS) -->
<form novalidate>...</form>

<!-- autocomplete -->
<input type="email" autocomplete="email" />
<input type="password" autocomplete="current-password" />
<input type="text" autocomplete="given-name" />
```

---

## PART 9: Semantic HTML — The Right Tags for the Right Purpose

Semantic elements describe their meaning to both the browser and developer:

```html
<body>

  <!-- HEADER — top section of page or a section -->
  <header>
    <nav>
      <a href="/">Home</a>
      <a href="/about">About</a>
      <a href="/contact">Contact</a>
    </nav>
    <h1>Pookiz — Campus Social Network</h1>
  </header>

  <!-- MAIN — the main content (only 1 per page) -->
  <main id="main-content">

    <!-- SECTION — a thematic group of content -->
    <section id="features">
      <h2>Features</h2>

      <!-- ARTICLE — independent, self-contained content -->
      <!-- (like a blog post, news article, comment) -->
      <article>
        <h3>Real-Time Messaging</h3>
        <p>Chat with classmates instantly across devices.</p>
        <time datetime="2026-01-15">January 15, 2026</time>
      </article>

      <article>
        <h3>Video Calling</h3>
        <p>High-quality peer-to-peer video calls.</p>
      </article>
    </section>

    <!-- ASIDE — sidebar content, tangentially related to main content -->
    <aside>
      <h2>Quick Stats</h2>
      <p>10,000+ students connected</p>
      <p>50+ universities</p>
    </aside>

  </main>

  <!-- FOOTER — bottom section -->
  <footer>
    <p>&copy; 2026 Pookiz. All rights reserved.</p>
    <address>
      Contact us: <a href="mailto:support@pookiz.com">support@pookiz.com</a>
    </address>
  </footer>

  <!-- DIALOG — popup / modal dialog -->
  <dialog id="confirm-modal">
    <h2>Confirm Action</h2>
    <p>Are you sure you want to delete this post?</p>
    <button onclick="document.getElementById('confirm-modal').close()">Cancel</button>
    <button>Confirm Delete</button>
  </dialog>

  <!-- DETAILS and SUMMARY — accordion/expandable content -->
  <details>
    <summary>Click to expand: What is RLS?</summary>
    <p>Row Level Security is a PostgreSQL feature that controls which rows a user can see...</p>
  </details>

</body>
```

**When to use which:**

| Tag | Use when |
|---|---|
| `<header>` | Top of page or section (logo, nav, title) |
| `<nav>` | Navigation links |
| `<main>` | Primary content — one per page |
| `<section>` | Group of related content with a heading |
| `<article>` | Standalone content (blog post, comment, tweet) |
| `<aside>` | Related but separate (sidebar, related posts) |
| `<footer>` | Bottom info (copyright, links, contact) |
| `<figure>` | Image with caption |
| `<time>` | Dates and times |
| `<address>` | Contact information |
| `<dialog>` | Modal/popup dialog |
| `<details>` | Expandable content |
| `<mark>` | Highlighted/relevant text |

---

## PART 10: Media Elements

### Video

```html
<video
  src="intro.mp4"
  controls
  autoplay
  muted
  loop
  width="640"
  height="360"
  poster="thumbnail.jpg"
>
  <!-- poster = image shown before video plays -->
  <!-- controls = show play/pause/volume controls -->
  <!-- autoplay = play immediately (requires muted in most browsers) -->
  <!-- muted = no sound (required for autoplay) -->
  <!-- loop = replay when finished -->
  Your browser does not support the video tag.
  <!-- Text shown if browser can't play video -->
</video>

<!-- Multiple video sources for browser compatibility -->
<video controls>
  <source src="video.mp4" type="video/mp4" />
  <source src="video.webm" type="video/webm" />
  <source src="video.ogg" type="video/ogg" />
  <p>Your browser doesn't support video. <a href="video.mp4">Download it</a></p>
</video>

<!-- Video with subtitles (closed captions) -->
<video controls>
  <source src="lecture.mp4" type="video/mp4" />
  <track
    kind="subtitles"
    src="subtitles-en.vtt"
    srclang="en"
    label="English"
    default
  />
  <track kind="subtitles" src="subtitles-hi.vtt" srclang="hi" label="Hindi" />
</video>
```

### Audio

```html
<audio controls>
  <source src="podcast.mp3" type="audio/mpeg" />
  <source src="podcast.ogg" type="audio/ogg" />
  Your browser does not support the audio element.
</audio>

<!-- Audio with all attributes -->
<audio src="music.mp3" controls autoplay muted loop preload="auto"></audio>
<!-- preload: none | metadata | auto -->
```

### iframe — Embed External Content

```html
<!-- Embed a YouTube video -->
<iframe
  width="560"
  height="315"
  src="https://www.youtube.com/embed/VIDEO_ID"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope"
  allowfullscreen
></iframe>

<!-- Embed a Google Map -->
<iframe
  src="https://www.google.com/maps/embed?pb=!1m18..."
  width="600"
  height="450"
  style="border:0;"
  allowfullscreen
  loading="lazy"
></iframe>

<!-- Embed another webpage -->
<iframe src="https://example.com" title="Example site" width="800" height="600"></iframe>
```

---

## PART 11: HTML5 APIs (Used with JavaScript)

### Canvas — Drawing Graphics

```html
<canvas id="myCanvas" width="400" height="200">
  Your browser does not support canvas.
</canvas>

<script>
  const canvas = document.getElementById("myCanvas");
  const ctx = canvas.getContext("2d");

  // Draw a filled rectangle
  ctx.fillStyle = "blue";
  ctx.fillRect(10, 10, 150, 80); // x, y, width, height

  // Draw a circle
  ctx.beginPath();
  ctx.arc(200, 100, 50, 0, Math.PI * 2); // x, y, radius, start angle, end angle
  ctx.fillStyle = "red";
  ctx.fill();

  // Draw text
  ctx.font = "24px Arial";
  ctx.fillStyle = "white";
  ctx.fillText("Hello Canvas", 50, 55);
</script>
```

### Template Element — Reusable HTML Fragments

```html
<!-- Template is not rendered until cloned and inserted with JavaScript -->
<template id="user-card-template">
  <div class="user-card">
    <img class="avatar" alt="User avatar" />
    <h3 class="name"></h3>
    <p class="bio"></p>
  </div>
</template>

<div id="users-container"></div>

<script>
  const template = document.getElementById("user-card-template");
  const container = document.getElementById("users-container");

  const users = [
    { name: "Arpit", bio: "Full-stack developer", avatar: "arpit.jpg" },
    { name: "Priya", bio: "UI designer", avatar: "priya.jpg" },
  ];

  users.forEach((user) => {
    const clone = template.content.cloneNode(true); // true = deep clone
    clone.querySelector(".name").textContent = user.name;
    clone.querySelector(".bio").textContent = user.bio;
    clone.querySelector(".avatar").src = user.avatar;
    container.appendChild(clone);
  });
</script>
```

---

## PART 12: HTML Comments, Entities & Special Characters

```html
<!-- This is an HTML comment — not visible on the page -->
<!--
  Multi-line comments work like this
  Useful for temporarily hiding code
-->

<!-- ===== HTML ENTITIES — special characters ===== -->
<!-- Use entities when the character has special meaning in HTML -->

&lt;    <!-- < (less than — would start a tag if written directly) -->
&gt;    <!-- > (greater than) -->
&amp;   <!-- & (ampersand) -->
&quot;  <!-- " (double quote) -->
&apos;  <!-- ' (apostrophe) -->
&nbsp;  <!-- non-breaking space — prevents line break -->
&copy;  <!-- © copyright symbol -->
&reg;   <!-- ® registered trademark -->
&trade; <!-- ™ trademark -->
&mdash; <!-- — em dash -->
&ndash; <!-- – en dash -->
&hellip; <!-- … ellipsis -->
&euro;  <!-- € euro sign -->
&pound; <!-- £ pound sign -->
&yen;   <!-- ¥ yen sign -->
&rupee; <!-- ₹ rupee sign (use &#8377; for older browsers) -->

<!-- Numeric entities — use the character's Unicode code point -->
&#65;    <!-- A (decimal) -->
&#x41;   <!-- A (hexadecimal) -->
&#8377;  <!-- ₹ Indian Rupee -->
```

---

## PART 13: Data Attributes

Custom attributes you define yourself, prefixed with `data-`:

```html
<!-- Store extra data on elements -->
<button data-user-id="123" data-action="delete" onclick="handleDelete(this)">
  Delete User
</button>

<div
  data-quiz-id="quiz-abc"
  data-difficulty="hard"
  data-question-count="20"
  class="quiz-card"
>
  Advanced JavaScript Quiz
</div>

<script>
  function handleDelete(button) {
    // Access data attributes with dataset
    const userId = button.dataset.userId; // "123" (camelCase: data-user-id → userId)
    const action = button.dataset.action; // "delete"
    console.log(`${action} user ${userId}`);
  }

  // Access via querySelector
  const quizCard = document.querySelector(".quiz-card");
  console.log(quizCard.dataset.quizId);         // "quiz-abc"
  console.log(quizCard.dataset.difficulty);     // "hard"
  console.log(quizCard.dataset.questionCount);  // "20"

  // Modify data attribute
  quizCard.dataset.difficulty = "easy";

  // Also works with getAttribute/setAttribute
  quizCard.getAttribute("data-quiz-id"); // "quiz-abc"
  quizCard.setAttribute("data-quiz-id", "quiz-xyz");
</script>
```

---

## PART 14: Accessibility in HTML (ARIA)

Accessibility ensures your site works for everyone, including people using screen readers.

```html
<!-- Use semantic HTML first — it's automatically accessible -->
<button>Submit</button>  <!-- Better than <div onclick="...">Submit</div> -->

<!-- aria-label — adds invisible text label for screen readers -->
<button aria-label="Close dialog">✕</button>
<!-- Screen reader says: "Close dialog, button" not "✕, button" -->

<!-- aria-labelledby — points to existing element as label -->
<h2 id="form-title">Login Form</h2>
<form aria-labelledby="form-title">...</form>

<!-- aria-describedby — points to description text -->
<input type="password" aria-describedby="password-hint" />
<p id="password-hint">Password must be 8+ characters with a number.</p>

<!-- aria-hidden — hide decorative elements from screen readers -->
<span aria-hidden="true">⭐</span> 5 stars

<!-- role — defines what element is when no semantic tag exists -->
<div role="button" tabindex="0">Click me</div>
<div role="alert">Your session is about to expire!</div>
<div role="dialog" aria-modal="true" aria-labelledby="dialog-title">
  <h2 id="dialog-title">Confirm Delete</h2>
</div>

<!-- aria-live — announce dynamic content changes -->
<div aria-live="polite">Status: Saving...</div>
<!-- polite = wait for user idle, assertive = interrupt immediately -->

<!-- aria-expanded — for dropdowns, accordions -->
<button aria-expanded="false" aria-controls="dropdown-menu">Menu</button>
<ul id="dropdown-menu" hidden>
  <li><a href="/">Home</a></li>
  <li><a href="/about">About</a></li>
</ul>

<!-- aria-required — required form fields -->
<input type="email" aria-required="true" />

<!-- aria-invalid — invalid input -->
<input type="email" aria-invalid="true" aria-describedby="email-error" />
<span id="email-error" role="alert">Please enter a valid email.</span>

<!-- tabindex — controls keyboard tab order -->
<div tabindex="0">Focusable via keyboard</div>  <!-- 0 = natural order -->
<div tabindex="-1">Focusable via JS only</div>  <!-- -1 = skip in tab order -->
<!-- Never use positive tabindex (1, 2, 3) — causes confusion -->

<!-- Skip link — allows keyboard users to skip navigation -->
<a href="#main-content" class="skip-link">Skip to main content</a>
<main id="main-content">...</main>

<!-- Language attribute for screen readers -->
<html lang="en">
<p lang="hi">नमस्ते दुनिया</p>
```

---

## PART 15: Meta Tags — SEO and Social Sharing

```html
<head>
  <!-- ===== BASIC SEO ===== -->
  <title>Pookiz — Campus Social Network | Real-time Chat & Groups</title>
  <!-- 50-60 characters optimal for Google display -->

  <meta name="description"
    content="Connect with classmates on Pookiz. Real-time messaging, video calls, anonymous posts, and quiz management for university students." />
  <!-- 150-160 characters optimal -->

  <meta name="keywords" content="campus social network, university chat, student community" />
  <!-- Less important today but still good practice -->

  <meta name="author" content="Arpit Pandey" />

  <!-- ===== ROBOTS ===== -->
  <meta name="robots" content="index, follow" />
  <!-- index = include in search, follow = crawl links -->
  <!-- noindex = exclude from search (private pages) -->
  <!-- nofollow = don't follow links (user-generated content) -->

  <link rel="canonical" href="https://pookiz.vercel.app/" />
  <!-- Tells Google: this is the "official" version of the URL -->

  <!-- ===== OPEN GRAPH (Facebook, LinkedIn, WhatsApp previews) ===== -->
  <meta property="og:type" content="website" />
  <meta property="og:url" content="https://pookiz.vercel.app/" />
  <meta property="og:title" content="Pookiz — Campus Social Network" />
  <meta property="og:description" content="Real-time campus social platform for university students." />
  <meta property="og:image" content="https://pookiz.vercel.app/og-image.png" />
  <!-- og:image should be 1200×630px -->
  <meta property="og:site_name" content="Pookiz" />
  <meta property="og:locale" content="en_US" />

  <!-- ===== TWITTER CARD ===== -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="Pookiz — Campus Social Network" />
  <meta name="twitter:description" content="Real-time campus social platform." />
  <meta name="twitter:image" content="https://pookiz.vercel.app/og-image.png" />
  <meta name="twitter:creator" content="@ArpitPandey" />

  <!-- ===== ICONS ===== -->
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
  <!-- Apple touch icon = icon when user adds site to iPhone home screen -->

  <!-- ===== PWA (Progressive Web App) ===== -->
  <link rel="manifest" href="/manifest.json" />
  <!-- manifest.json defines PWA properties: name, icons, theme color -->

  <meta name="theme-color" content="#6366f1" />
  <!-- Browser UI color on mobile (Chrome shows this in address bar) -->

  <!-- ===== PERFORMANCE ===== -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <!-- Start DNS lookup early for external resources -->

  <link rel="preload" href="/fonts/inter.woff2" as="font" type="font/woff2" crossorigin />
  <!-- Load critical font before it's needed -->
</head>
```

---

## PART 16: Inline vs Block vs Inline-Block

```html
<!--
BLOCK elements:
  - Take up full width of parent
  - Start on a new line
  - Can have width, height, margin, padding on all sides
  Examples: div, p, h1-h6, section, article, header, footer, ul, ol, li, table, form

INLINE elements:
  - Take only as much width as needed
  - Don't start on a new line (flow with text)
  - width and height have NO effect
  - top/bottom margin and padding don't work as expected
  Examples: span, a, strong, em, img, input, button, label, code

INLINE-BLOCK elements:
  - Flow inline (don't start new line) BUT can have width, height, margin, padding
  - img and button behave like inline-block by default
-->

<!-- Common mistake — trying to set height on a span -->
<span style="width: 200px; height: 100px; background: red;">
  This won't work as expected — span is inline
</span>

<!-- Fix — use display: inline-block or change to block -->
<span style="display: inline-block; width: 200px; height: 100px; background: red;">
  This works!
</span>
```

---

## PART 17: Common HTML Mistakes to Avoid

```html
<!-- ❌ WRONG: No DOCTYPE -->
<html>...</html>

<!-- ✅ CORRECT -->
<!DOCTYPE html>
<html>...</html>

<!-- ❌ WRONG: Multiple h1 tags (bad for SEO) -->
<h1>Title</h1>
<h1>Another Title</h1>

<!-- ✅ CORRECT: One h1, multiple h2 -->
<h1>Main Title</h1>
<h2>Section 1</h2>
<h2>Section 2</h2>

<!-- ❌ WRONG: img without alt -->
<img src="photo.jpg" />

<!-- ✅ CORRECT -->
<img src="photo.jpg" alt="Arpit at graduation" />

<!-- ❌ WRONG: Nested block inside inline -->
<span>
  <div>This is invalid HTML</div>
</span>

<!-- ✅ CORRECT -->
<div>
  <span>This is valid</span>
</div>

<!-- ❌ WRONG: form inside form (nested forms are invalid) -->
<form>
  <form>...</form>
</form>

<!-- ❌ WRONG: label without for/id connection -->
<label>Username</label>
<input type="text" />

<!-- ✅ CORRECT -->
<label for="username">Username</label>
<input type="text" id="username" />

<!-- ❌ WRONG: Using table for layout -->
<table>
  <tr>
    <td>Left column</td>
    <td>Right column</td>
  </tr>
</table>

<!-- ✅ CORRECT: Use CSS flexbox/grid for layout -->
<div class="two-column-layout">
  <div>Left column</div>
  <div>Right column</div>
</div>

<!-- ❌ WRONG: Inline styles everywhere (hard to maintain) -->
<p style="color: red; font-size: 16px; margin-top: 20px;">Text</p>

<!-- ✅ CORRECT: Use CSS classes -->
<p class="error-text">Text</p>

<!-- ❌ WRONG: JavaScript directly in HTML (hard to maintain) -->
<button onclick="alert('Hello')">Click</button>

<!-- ✅ CORRECT: Use addEventListener in a script file -->
<button id="greet-btn">Click</button>
<script>
  document.getElementById("greet-btn").addEventListener("click", () => {
    alert("Hello");
  });
</script>
```

---

## PART 18: HTML5 APIs Overview

These HTML5 features are accessed through JavaScript:

```javascript
// ===== LOCAL STORAGE =====
// Stores data in browser permanently (until manually cleared)
localStorage.setItem("theme", "dark");
const theme = localStorage.getItem("theme"); // "dark"
localStorage.removeItem("theme");
localStorage.clear(); // removes everything

// ===== SESSION STORAGE =====
// Same as localStorage but cleared when browser tab closes
sessionStorage.setItem("quizId", "quiz-123");
sessionStorage.getItem("quizId"); // "quiz-123"

// ===== GEOLOCATION =====
navigator.geolocation.getCurrentPosition(
  (position) => {
    console.log(position.coords.latitude);  // e.g., 27.4924
    console.log(position.coords.longitude); // e.g., 77.6737
  },
  (error) => {
    console.log("Location denied:", error.message);
  }
);

// ===== CLIPBOARD =====
// Copy text to clipboard
await navigator.clipboard.writeText("Copied text!");

// Read from clipboard
const text = await navigator.clipboard.readText();

// ===== DRAG AND DROP =====
// See draggable attribute usage below

// ===== NOTIFICATION API =====
// Request permission first
Notification.requestPermission().then((permission) => {
  if (permission === "granted") {
    new Notification("New message!", {
      body: "Arpit sent you a message.",
      icon: "/icon-192.png",
    });
  }
});

// ===== PAGE VISIBILITY API =====
// Detect when user switches tabs (used in Pookiz anti-cheat!)
document.addEventListener("visibilitychange", () => {
  if (document.hidden) {
    console.log("User switched away from the tab");
  } else {
    console.log("User is back on the tab");
  }
});

// ===== FULLSCREEN API =====
document.getElementById("video").requestFullscreen();
document.exitFullscreen();

// ===== HISTORY API =====
// Navigate without page reload
history.pushState({ page: "about" }, "About", "/about");
history.replaceState({ page: "home" }, "Home", "/");
history.back();
history.forward();
history.go(-2); // go back 2 pages

// ===== INTERSECTION OBSERVER — detect when element is visible =====
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("visible");
    }
  });
});
observer.observe(document.querySelector(".animate-on-scroll"));

// ===== MUTATION OBSERVER — watch DOM changes =====
const mutationObserver = new MutationObserver((mutations) => {
  mutations.forEach((mutation) => {
    console.log("DOM changed:", mutation.type);
  });
});
mutationObserver.observe(document.body, { childList: true, subtree: true });
```

---

## PART 19: Drag and Drop

```html
<div id="source" draggable="true">Drag me!</div>
<div id="target">Drop here</div>

<script>
  const source = document.getElementById("source");
  const target = document.getElementById("target");

  source.addEventListener("dragstart", (e) => {
    e.dataTransfer.setData("text/plain", source.id);
    e.dataTransfer.effectAllowed = "move";
  });

  target.addEventListener("dragover", (e) => {
    e.preventDefault(); // required to allow dropping
    e.dataTransfer.dropEffect = "move";
    target.classList.add("drag-over");
  });

  target.addEventListener("dragleave", () => {
    target.classList.remove("drag-over");
  });

  target.addEventListener("drop", (e) => {
    e.preventDefault();
    const id = e.dataTransfer.getData("text/plain");
    const draggedElement = document.getElementById(id);
    target.appendChild(draggedElement);
    target.classList.remove("drag-over");
  });
</script>
```

---

## Summary: HTML Tags Reference

| Category | Tags |
|---|---|
| **Document** | `<!DOCTYPE>`, `<html>`, `<head>`, `<body>` |
| **Metadata** | `<title>`, `<meta>`, `<link>`, `<style>`, `<base>` |
| **Headings** | `<h1>` to `<h6>` |
| **Text** | `<p>`, `<span>`, `<br>`, `<hr>`, `<strong>`, `<em>`, `<b>`, `<i>`, `<mark>`, `<del>`, `<ins>`, `<sub>`, `<sup>`, `<code>`, `<pre>`, `<blockquote>`, `<abbr>` |
| **Links** | `<a>` |
| **Media** | `<img>`, `<picture>`, `<source>`, `<video>`, `<audio>`, `<iframe>`, `<canvas>`, `<svg>` |
| **Lists** | `<ul>`, `<ol>`, `<li>`, `<dl>`, `<dt>`, `<dd>` |
| **Tables** | `<table>`, `<caption>`, `<thead>`, `<tbody>`, `<tfoot>`, `<tr>`, `<th>`, `<td>` |
| **Forms** | `<form>`, `<input>`, `<textarea>`, `<select>`, `<option>`, `<optgroup>`, `<label>`, `<button>`, `<fieldset>`, `<legend>`, `<datalist>`, `<output>`, `<progress>`, `<meter>` |
| **Semantic Structure** | `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<aside>`, `<footer>`, `<figure>`, `<figcaption>`, `<time>`, `<address>`, `<dialog>`, `<details>`, `<summary>` |
| **Scripting** | `<script>`, `<noscript>`, `<template>` |
| **Formatting** | `<div>`, `<template>` |
