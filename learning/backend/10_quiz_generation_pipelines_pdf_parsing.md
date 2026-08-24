# Backend Chapter 10: AI Quiz Generation, PDF Parsing & Rate Limiting

This module covers the architecture of the AI Quiz Generator in Pookiz, detailing PDF text extraction, Groq API integration, custom system prompt design, and dynamic token rate-limit scaling.

---

## 1. Objective & Placement Value
- **Why this is asked:** Integrating AI features requires robust server-side processing. Interviewers evaluate how you handle multipart/form-data uploads, extract text from binary files (PDFs) in memory, design system prompts to return parseable JSON, and manage external API rate limits.
- **Placement Value:** Prepares you to build secure, scalable AI-powered pipelines, parse binary files in memory, and optimize external api requests under rate-limit constraints.

---

## 2. The Layman's Analogy
Think of the AI Quiz generator as a **highly efficient exam creator**:
- **PDF Upload:** You hand a textbook (PDF file) to the assistant.
- **In-Memory Parsing:** The assistant reads the textbook pages in memory without writing files to disk (using `unpdf` to extract raw text).
- **Word Limit Safety Gate:** If the textbook is too thick (exceeds 1000 words), the assistant warns you to keep the text short to avoid overloading the printer.
- **Dynamic Token Budgeting (Rate Limiting):** The assistant calculates how much ink is available (API token limits). They adjust the request size to ensure the printing budget is not exceeded.
- **Compiler Validation Rule:** Before printing questions, the assistant compiles any code snippets to ensure they are valid, providing explanations in a helpful mix of English and Hindi (Hinglish).

---

## 3. The Technical Specification

### A. Multipart Form-Data and In-Memory PDF Parsing
1. **Request Format:** The client uploads the PDF file using standard `multipart/form-data`.
2. **Buffer Extraction:** The server extracts the file and converts the binary stream into a memory buffer (`file.arrayBuffer()`).
3. **In-Memory Text Extraction:** Instead of using heavy native dependencies, Pookiz uses `unpdf` (a lightweight, modern wrapper around PDF.js) to extract the text directly in memory. This eliminates temp-file overhead on serverless functions.
4. **Input Constraints:** Enforces a 10MB file size limit and a 1000-word processing window.

### B. Dynamic Token Budgeting for Rate Limit Mitigation
Groq API free tier has strict rate limits (6,000 Tokens Per Minute - TPM). To prevent API requests from failing:
1. **Input Estimation:** Calculate the input token count based on the extracted text length:
   $$\text{Input Tokens} \approx (\text{Words} \times 1.35) + 600$$
2. **Output Allocation:** Calculate the remaining token budget for the AI's output:
   $$\text{Max Allowed Output} = 6000 - \text{Input Tokens} - 200$$
3. **Dynamic Request:** Set the API call's `max_tokens` dynamically based on the remaining budget. If the budget is too low (e.g., `< 400`), the request is rejected immediately with an error, preventing API failures.

---

## 4. Line-by-Line Code Walkthrough
Let's analyze the AI quiz generation pipeline in [`d:\Pookiz\pookiz-app\src\app\api\quizzes\generate-from-pdf\route.ts`](file:///d:/Pookiz/pookiz-app/src/app/api/quizzes/generate-from-pdf/route.ts):

```typescript
export async function POST(request: Request) {
  try {
    const supabase = (await createClient()) as any;
    const { data: { user }, error: authError } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
```
- **Line 5-13:** Exports the POST handler and verifies user session cookies, returning status `401` if unauthorized.

```typescript
    const formData = await request.formData();
    const file = formData.get("file") as File | null;
    const targetCountStr = formData.get("targetCount") as string | null;

    if (!file) {
      return NextResponse.json({ error: "No PDF file provided." }, { status: 400 });
    }

    if (file.size > 10 * 1024 * 1024) {
      return NextResponse.json({ error: "File exceeds maximum size limit of 10 MB." }, { status: 400 });
    }
```
- **Line 16-18:** Extracts parameters from the `FormData` request object.
- **Line 20-27:** Validates that the file is present and verifies its size is below the 10MB limit.

```typescript
    const bytes = await file.arrayBuffer();
    let text = "";
    try {
      const parsed = await extractText(new Uint8Array(bytes), { mergePages: true });
      text = parsed.text || "";
    } catch (parseErr: any) {
      console.error("PDF Parsing Failure:", parseErr);
      return NextResponse.json({ error: "Failed to parse PDF file. Ensure the document is not corrupted." }, { status: 400 });
    }
```
- **Line 30:** Converts the binary file stream into an in-memory array buffer.
- **Line 33-34:** Invokes `extractText` from the `unpdf` library, merging pages to return a single text string.
- **Line 35-38:** Handles extraction failures, returning status `400`.

```typescript
    const requestedCount = targetCountStr ? parseInt(targetCountStr, 10) : 5;
    const targetCount = Math.min(30, Math.max(1, isNaN(requestedCount) ? 5 : requestedCount));

    const estimatedInputTokens = Math.ceil(words.length * 1.35) + 600;
    const maxAllowedOutput = 6000 - estimatedInputTokens - 200;

    if (maxAllowedOutput < 400) {
      return NextResponse.json({
        error: "The uploaded PDF content is too long for the Groq API Free Tier rate limits. Please upload a shorter document."
      }, { status: 400 });
    }
```
- **Line 62-63:** Resolves the target question count, bounding it between 1 and 30 questions.
- **Line 66-67:** Calculates the input token count and the remaining output token budget.
- **Line 69-73:** If the remaining budget is below the minimum threshold (400 tokens), rejects the request to prevent API errors.

---

## 5. Edge Cases & Optimizations
- **Non-Text PDFs (Scanned Images):** If a PDF contains scanned images instead of text, `extractText` returns an empty string.
  - *Fix:* Check if the extracted text length is 0. If so, return a clear error message suggesting the user upload a text-selectable PDF.
- **AI Hallucinations (Malformed JSON):** Large language models can sometimes output text prefixes (e.g., *"Here is your JSON:"*) or trailing text, breaking JSON parsing.
  - *Fix:* Enforce structured outputs in the API configuration (`response_format: { type: "json_object" }`) or use regex to extract the JSON block.

---

## 6. Staff Engineer Viva Board

### Q1: Why did you choose the `unpdf` library instead of standard server dependencies like `pdf-parse` or native binaries?
**Answer:**
*"We chose **`unpdf`** (which uses PDF.js under the hood) because it is written in pure JavaScript and does not require native C++ compiler bindings or external system tools (like `pdftotext`). 

This is critical for serverless deployments (like Vercel). Native dependencies add compile-time errors and increase function size. `unpdf` runs in any JavaScript environment (Node.js, Edge, browser), keeps the deployment bundle small, and parses PDFs in memory without needing disk writes."*

### Q2: Walk me through the dynamic token estimation calculation. How does this prevent API request failures?
**Answer:**
*"The Groq free tier has a strict rate limit of 6,000 Tokens Per Minute (TPM). 

To prevent requests from failing with HTTP `429 Too Many Requests` errors:
1. We calculate input tokens by mapping words to tokens (roughly 1.35 tokens per word) and adding 600 tokens for the system prompt.
2. We subtract this from our 6,000 token limit (minus a 200 token safety margin) to find the maximum allowed output.
3. If this remaining budget is below 400 tokens, we abort the request immediately.
This prevents sending queries that would exceed the rate limit, keeping the service stable."*

### Q3: What is the risk of using a JSON output format configuration (`response_format: { type: "json_object" }`) in LLM API calls?
**Answer:**
*"When configuring the API to return a JSON object, the LLM is forced to output a valid JSON string. 

The risk is that if the output token limit is reached mid-generation, the LLM will stop writing immediately. Since it was cut off, the closing brackets of the JSON structure will be missing, returning a malformed JSON string that fails parsing on the server. To handle this, we must configure a sufficient `max_tokens` budget and handle parsing errors gracefully in the route code."*

### Q4: How does Pookiz ensure that generated Java code snippets in quizzes compile correctly?
**Answer:**
*"We enforce code compilation accuracy by adding a validation instruction to the AI system prompt:
```
- COMPILER VALIDATION RULE: Before outputting any Java code snippet block, mentally compile it. If a class is not marked 'abstract' but contains an abstract method, it will cause a compilation error. You must ensure the correct_option_index accurately reflects this reality (Compilation Error option must be marked correct if the code is invalid).
```
This forces the model to evaluate compile-time rules (such as inheritance, visibility modifiers, and abstract rules) and set the correct option index accordingly, improving quiz accuracy."*

### Q5: What is the advantage of using streams to return AI responses, and why did Pookiz choose synchronous JSON responses instead?
**Answer:**
*"Streaming returns the response chunk-by-chunk as it is generated, allowing the UI to show content immediately and improving perceived performance.

Pookiz chose synchronous JSON responses because the generated questions must be validated, parsed, and stored as a structured `questions` array. If we streamed the response, the server would have to collect the stream chunks anyway to validate the JSON structure before saving it. A synchronous JSON response is simpler to implement and validate."*
