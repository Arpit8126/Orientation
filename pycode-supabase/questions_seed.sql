-- PyCode Student — Full Question Seed
-- Generated automatically. Run in Supabase SQL Editor.

BEGIN;
TRUNCATE public.coding_questions RESTART IDENTITY CASCADE;

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (1,'1. Greet with f-String','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>greet(name)</code> that takes a person''s name and returns a greeting message using a Python f-string.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">f-strings (formatted string literals) let you embed expressions directly inside string literals using <code>f"..."</code> syntax. They are the modern, readable way to format strings in Python.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>name = "Alice"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Hello, Alice!"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>name = "PyCode"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Hello, PyCode!"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>The name can be any non-empty string</code></li>
</ul>','easy',100,'python-basics','def greet(name):
    # Use an f-string to return the greeting
    pass','def ref_impl(*args):
    return f"Hello, {args[0]}!"

assert "greet" in exec_globals, "Function greet not found"
fn = exec_globals["greet"]
test_cases = ["Alice", "PyCode", "World", "Python 3"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (2,'2. Identify Variable Types','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>get_type(val)</code> that takes any value and returns its Python type as a string — e.g. <code>"int"</code>, <code>"str"</code>, <code>"float"</code>, <code>"bool"</code>, <code>"list"</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use Python''s built-in <code>type()</code> function and access <code>.__name__</code> to get the type name as a string.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = 42</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"int"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">type(42).__name__ == "int"</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = 3.14</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"float"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = "hello"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"str"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 4</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = True</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"bool"</code></div>
  
</div>','easy',100,'python-basics','def get_type(val):
    # Return the type name as a string
    pass','def ref_impl(*args):
    return type(args[0]).__name__

assert "get_type" in exec_globals, "Function get_type not found"
fn = exec_globals["get_type"]
test_cases = [42, 3.14, "hello", True, [1,2], (1,2), None]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 7',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (3,'3. Type Conversion','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>convert(s)</code> that takes a numeric string <code>s</code> (e.g. <code>"42"</code>) and returns a tuple <code>(as_int, as_float, back_to_str)</code> — the value converted to int, float, and then back to string.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Type conversion (casting) is fundamental in Python. Use <code>int()</code>, <code>float()</code>, and <code>str()</code> built-ins.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "42"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(42, 42.0, "42")</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">int("42")=42, float("42")=42.0, str(42)="42"</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "3"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 3.0, "3")</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>Input is always a valid numeric string representing a whole number</code></li>
</ul>','easy',100,'python-basics','def convert(s):
    # Convert s to int, float, and back to string
    pass','def ref_impl(*args):
    n = int(args[0])
    return (n, float(n), str(n))

assert "convert" in exec_globals, "Function convert not found"
fn = exec_globals["convert"]
test_cases = ["42", "3", "0", "100", "-7"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (4,'4. All Arithmetic Operators','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>all_ops(a, b)</code> that takes two integers and returns a tuple of all six arithmetic results:
<code>(a+b, a-b, a*b, a//b, a%b, a**b)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This covers the 6 core Python arithmetic operators: addition, subtraction, multiplication, floor division, modulo, and exponentiation.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 10, b = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(13, 7, 30, 3, 1, 1000)</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">10+3=13, 10-3=7, 10*3=30, 10//3=3, 10%3=1, 10**3=1000</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 5, b = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(7, 3, 10, 2, 1, 25)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>b is always non-zero</code></li>
</ul>','easy',100,'python-basics','def all_ops(a, b):
    # Return tuple of (sum, diff, product, floor_div, modulo, power)
    pass','def ref_impl(*args):
    a, b = args[0], args[1]
    return (a+b, a-b, a*b, a//b, a%b, a**b)

assert "all_ops" in exec_globals, "Function all_ops not found"
fn = exec_globals["all_ops"]
test_cases = [(10, 3), (5, 2), (8, 4), (7, 3)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (5,'5. String Slicing & Indexing','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>string_info(s)</code> that takes a string <code>s</code> and returns a tuple:
<code>(first_char, last_char, first_three, last_three, reversed_str)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Strings in Python are sequences. You access characters with <code>s[0]</code>, <code>s[-1]</code>, and slices with <code>s[start:end:step]</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Python"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("P", "n", "Pyt", "hon", "nohtyP")</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Indexing and slicing the string</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Hello"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("H", "o", "Hel", "llo", "olleH")</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>Length of s is at least 3</code></li>
</ul>','easy',100,'python-basics','def string_info(s):
    # Return (first_char, last_char, first_three, last_three, reversed)
    pass','def ref_impl(*args):
    return (args[0][0], args[0][-1], args[0][:3], args[0][-3:], args[0][::-1])

assert "string_info" in exec_globals, "Function string_info not found"
fn = exec_globals["string_info"]
test_cases = ["Python", "Hello", "abcdef", "Data"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (6,'6. Comparison Operators','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>compare(a, b)</code> that takes two numbers and returns a tuple of all six comparison results:
<code>(a==b, a!=b, a>b, a<b, a>=b, a<=b)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Comparison operators return boolean values (<code>True</code>/<code>False</code>) and are the foundation of every conditional statement.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 5, b = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(False, True, True, False, True, False)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 4, b = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(True, False, False, False, True, True)</code></div>
  
</div>','easy',100,'python-basics','def compare(a, b):
    # Return tuple of comparison results
    pass','def ref_impl(*args):
    a, b = args[0], args[1]
    return (a==b, a!=b, a>b, a<b, a>=b, a<=b)

assert "compare" in exec_globals, "Function compare not found"
fn = exec_globals["compare"]
test_cases = [(5, 3), (4, 4), (-1, 2), (10, 10), (0, 1)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (7,'7. Boolean Logic','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>bool_ops(a, b)</code> that takes two boolean values and returns a tuple:
<code>(a and b, a or b, not a, a ^ b)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Python uses the keywords <code>and</code>, <code>or</code>, <code>not</code> for boolean logic. The last item <code>^</code> is the XOR operator — it returns True if exactly one of the two is True.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = True, b = False</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(False, True, False, True)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = True, b = True</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(True, True, False, False)</code></div>
  
</div>','easy',100,'python-basics','def bool_ops(a, b):
    # Return (a and b, a or b, not a, a XOR b)
    pass','def ref_impl(*args):
    a, b = args[0], args[1]
    return (a and b, a or b, not a, a ^ b)

assert "bool_ops" in exec_globals, "Function bool_ops not found"
fn = exec_globals["bool_ops"]
test_cases = [(True, False), (True, True), (False, False), (False, True)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (8,'8. Multiple Assignment & Unpacking','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>unpack_and_swap(lst)</code> that takes a list of exactly 3 elements, unpacks it into three variables <code>a, b, c</code>, then swaps <code>a</code> and <code>c</code> in a single line using Python''s multiple assignment, and returns the new tuple <code>(a, b, c)</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Python allows multiple assignment in one line: <code>a, b = b, a</code>. This is cleaner and more Pythonic than using a temporary variable.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [1, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 2, 1)</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">a,b,c = 1,2,3 → swap a,c → 3,2,1</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [10, 20, 30]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(30, 20, 10)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>List always has exactly 3 elements</code></li>
</ul>','easy',100,'python-basics','def unpack_and_swap(lst):
    # Unpack, swap a and c, return tuple
    pass','def ref_impl(*args):
    a, b, c = args[0]
    a, c = c, a
    return (a, b, c)

assert "unpack_and_swap" in exec_globals, "Function unpack_and_swap not found"
fn = exec_globals["unpack_and_swap"]
test_cases = [[1, 2, 3], [10, 20, 30], ["x", "y", "z"], [99, 0, -1]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (9,'9. Truthy & Falsy Values','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>is_truthy(val)</code> that returns <code>True</code> if the value is truthy in Python and <code>False</code> if it is falsy.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">In Python, these values are considered "falsy": <code>0</code>, <code>0.0</code>, <code>""</code> (empty string), <code>[]</code> (empty list), <code>{}</code> (empty dict), <code>None</code>, <code>False</code>. Everything else is truthy.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">0 is falsy in Python</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = "hello"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Non-empty strings are truthy</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>val = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Empty list is falsy</span></div>
</div>','easy',100,'python-basics','def is_truthy(val):
    # Return True if val is truthy, False if falsy
    pass','def ref_impl(*args):
    return bool(args[0])

assert "is_truthy" in exec_globals, "Function is_truthy not found"
fn = exec_globals["is_truthy"]
test_cases = [0, 1, "", "hello", [], [0], None, False, True, 0.0]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 10',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (10,'10. String Multiplication & Repetition','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>repeat_info(s, n)</code> that takes a string <code>s</code> and a positive integer <code>n</code>, and returns a tuple:
<code>(repeated, length_after, upper, lower)</code></p>
<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Where:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>repeated</code> = the string repeated <code>n</code> times (<code>s * n</code>)</li>
  <li class="py-0.5"><code>length_after</code> = its length</li>
  <li class="py-0.5"><code>upper</code> = the repeated string in uppercase</li>
  <li class="py-0.5"><code>lower</code> = the repeated string in lowercase</li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "ab", n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("ababab", 6, "ABABAB", "ababab")</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Hi", n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("HiHi", 4, "HIHI", "hihi")</code></div>
  
</div>','easy',100,'python-basics','def repeat_info(s, n):
    # Return (repeated, length, upper, lower)
    pass','def ref_impl(*args):
    r = args[0] * args[1]
    return (r, len(r), r.upper(), r.lower())

assert "repeat_info" in exec_globals, "Function repeat_info not found"
fn = exec_globals["repeat_info"]
test_cases = [("ab", 3), ("Hi", 2), ("x", 5), ("py", 1)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (11,'11. Positive, Negative or Zero','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>classify_number(n)</code> that takes a number and returns <code>"Positive"</code>, <code>"Negative"</code>, or <code>"Zero"</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This is the simplest if/elif/else chain — the foundation of all decision-making in Python.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Positive"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">5 is strictly greater than 0, so it is Positive.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Negative"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">-3 is less than 0, so it is Negative.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Zero"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">0 is neither positive nor negative, so it is Zero.</span></div>
</div>','easy',100,'python-basics','def classify_number(n):
    # Return "Positive", "Negative", or "Zero"
    pass','def ref_impl(*args):
    if args[0] > 0: return "Positive"
    elif args[0] < 0: return "Negative"
    return "Zero"

assert "classify_number" in exec_globals, "Function classify_number not found"
fn = exec_globals["classify_number"]
test_cases = [5, -3, 0, -100, 0.0, 0.1]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (12,'12. Absolute Value Without abs()','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>my_abs(n)</code> that returns the absolute value of a number <em>without</em> using Python''s built-in <code>abs()</code> function.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use an <code>if/else</code> statement: if the number is negative, negate it; otherwise return it as-is.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -7</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>7</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The absolute value of -7 is 7 (negated to make it positive).</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>5</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The absolute value of 5 is 5 (returns as-is).</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The absolute value of 0 is 0.</span></div>
</div>','easy',100,'python-basics','def my_abs(n):
    # Return absolute value without abs()
    pass','def ref_impl(*args):
    return -args[0] if args[0] < 0 else args[0]

assert "my_abs" in exec_globals, "Function my_abs not found"
fn = exec_globals["my_abs"]
test_cases = [-7, 5, 0, -100, 3.14, -2.5]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (13,'13. Find Maximum of Three','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>max_of_three(a, b, c)</code> that returns the largest of three numbers <em>without</em> using the built-in <code>max()</code> function.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use nested <code>if/elif/else</code> to compare all three values.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=1, b=2, c=3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>3</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">3 is the largest among 1, 2, and 3.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=10, b=10, c=5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>10</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">10 is the largest among 10, 10, and 5.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=-1, b=-5, c=-2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">-1 is the largest among -1, -5, and -2.</span></div>
</div>','easy',100,'python-basics','def max_of_three(a, b, c):
    # Return the largest without using max()
    pass','def ref_impl(*args):
    a,b,c=args[0],args[1],args[2]
    if a>=b and a>=c: return a
    elif b>=a and b>=c: return b
    return c

assert "max_of_three" in exec_globals, "Function max_of_three not found"
fn = exec_globals["max_of_three"]
test_cases = [(1,2,3), (5,3,4), (-1,-5,-2), (10,10,10), (0,0,1)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (14,'14. FizzBuzz','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>fizzbuzz(n)</code> that takes an integer and returns:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>"FizzBuzz"</code> if divisible by both 3 and 5</li>
  <li class="py-0.5"><code>"Fizz"</code> if divisible by 3 only</li>
  <li class="py-0.5"><code>"Buzz"</code> if divisible by 5 only</li>
  <li class="py-0.5">The number itself as a string otherwise</li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This is the most famous coding interview warm-up question. Order matters — always check the combined divisibility first.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 15</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"FizzBuzz"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">15 is divisible by both 3 and 5, so we return "FizzBuzz".</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Fizz"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">9 is divisible by 3 but not 5, so we return "Fizz".</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 20</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Buzz"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">20 is divisible by 5 but not 3, so we return "Buzz".</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 4</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 7</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"7"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">7 is not divisible by 3 or 5, so we return "7" as a string.</span></div>
</div>','easy',100,'python-basics','def fizzbuzz(n):
    # Return FizzBuzz, Fizz, Buzz, or the number as string
    pass','def ref_impl(*args):
    n=args[0]
    if n%15==0: return "FizzBuzz"
    elif n%3==0: return "Fizz"
    elif n%5==0: return "Buzz"
    return str(n)

assert "fizzbuzz" in exec_globals, "Function fizzbuzz not found"
fn = exec_globals["fizzbuzz"]
test_cases = [15, 9, 20, 7, 1, 30, 5, 3]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 8',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (15,'15. Vowel or Consonant','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>vowel_or_consonant(ch)</code> that takes a single character and returns <code>"Vowel"</code>, <code>"Consonant"</code>, or <code>"Neither"</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Vowels are: a, e, i, o, u (both upper and lowercase). Any other letter is a consonant. Non-letter characters (digits, symbols, spaces) return <code>"Neither"</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "a"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Vowel"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"a" is a lowercase vowel.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "B"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Consonant"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"B" is an uppercase consonant.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "3"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Neither"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"3" is a digit, which is neither a vowel nor a consonant.</span></div>
</div>','easy',100,'python-basics','def vowel_or_consonant(ch):
    # Return "Vowel", "Consonant", or "Neither"
    pass','def ref_impl(*args):
    c=args[0].lower()
    if not c.isalpha(): return "Neither"
    return "Vowel" if c in "aeiou" else "Consonant"

assert "vowel_or_consonant" in exec_globals, "Function vowel_or_consonant not found"
fn = exec_globals["vowel_or_consonant"]
test_cases = ["a", "B", "3", "U", "z", "!", " "]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 7',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (16,'16. Leap Year Check','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>is_leap_year(year)</code> that returns <code>True</code> if the given year is a leap year, <code>False</code> otherwise.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Leap year rules:
1. Divisible by 4 → potentially a leap year
2. But if also divisible by 100 → NOT a leap year
3. Unless also divisible by 400 → IS a leap year</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This requires nested conditions or a single compound boolean expression.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>year = 2024</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">2024 ÷ 4 = 0 remainder, not divisible by 100</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>year = 1900</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">1900 ÷ 100 = 0, but 1900 ÷ 400 ≠ 0</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>year = 2000</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">2000 ÷ 400 = 0, so it is a leap year</span></div>
</div>','easy',100,'python-basics','def is_leap_year(year):
    # Return True if leap year, False otherwise
    pass','def ref_impl(*args):
    y=args[0]
    return y%4==0 and (y%100!=0 or y%400==0)

assert "is_leap_year" in exec_globals, "Function is_leap_year not found"
fn = exec_globals["is_leap_year"]
test_cases = [2024, 1900, 2000, 2023, 100, 400]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (17,'17. Grade Calculator','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>calculate_grade(score)</code> that takes a score (0-100) and returns a letter grade:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">Score >= 90 → <code>"A"</code></li>
  <li class="py-0.5">Score >= 80 → <code>"B"</code></li>
  <li class="py-0.5">Score >= 70 → <code>"C"</code></li>
  <li class="py-0.5">Score >= 60 → <code>"D"</code></li>
  <li class="py-0.5">Score < 60 → <code>"F"</code></li>
  <li class="py-0.5">Score < 0 or > 100 → <code>"Invalid"</code></li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>score = 95</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"A"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">95 is greater than or equal to 90, yielding an A grade.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>score = 72</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"C"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">72 is between 70 and 79, yielding a C grade.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>score = 55</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"F"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">55 is less than 60, yielding an F grade.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 4</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>score = -5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Invalid"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">-5 is out of bounds (0-100).</span></div>
</div>','easy',100,'python-basics','def calculate_grade(score):
    # Return letter grade A-F or Invalid
    pass','def ref_impl(*args):
    s=args[0]
    if s<0 or s>100: return "Invalid"
    elif s>=90: return "A"
    elif s>=80: return "B"
    elif s>=70: return "C"
    elif s>=60: return "D"
    return "F"

assert "calculate_grade" in exec_globals, "Function calculate_grade not found"
fn = exec_globals["calculate_grade"]
test_cases = [95, 82, 70, 59, -5, 101, 60, 80, 90]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 9',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (18,'18. Season Detector','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>get_season(month)</code> that takes a month number (1-12) and returns the season:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">Dec, Jan, Feb (12, 1, 2) → <code>"Winter"</code></li>
  <li class="py-0.5">Mar, Apr, May (3, 4, 5) → <code>"Spring"</code></li>
  <li class="py-0.5">Jun, Jul, Aug (6, 7, 8) → <code>"Summer"</code></li>
  <li class="py-0.5">Sep, Oct, Nov (9, 10, 11) → <code>"Autumn"</code></li>
  <li class="py-0.5">Any other number → <code>"Invalid"</code></li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>month = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Winter"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Month 1 is January, which is a Winter month.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>month = 7</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Summer"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Month 7 is July, which is a Summer month.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>month = 13</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Invalid"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">13 is not a valid month number (1-12).</span></div>
</div>','easy',100,'python-basics','def get_season(month):
    # Return the season name
    pass','def ref_impl(*args):
    m=args[0]
    if m in [12,1,2]: return "Winter"
    elif m in [3,4,5]: return "Spring"
    elif m in [6,7,8]: return "Summer"
    elif m in [9,10,11]: return "Autumn"
    return "Invalid"

assert "get_season" in exec_globals, "Function get_season not found"
fn = exec_globals["get_season"]
test_cases = [1, 2, 3, 6, 9, 12, 13, 0]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 8',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (19,'19. Valid Triangle Check','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>is_valid_triangle(a, b, c)</code> that returns <code>True</code> if the three sides form a valid triangle, <code>False</code> otherwise.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A triangle is valid if the sum of any two sides is strictly greater than the third side. This must hold for all three combinations.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=3, b=4, c=5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">3+4>5, 3+5>4, 4+5>3</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=1, b=2, c=3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">1+2=3 is not strictly greater</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=0, b=2, c=3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Side of length 0 is invalid</span></div>
</div>','easy',100,'python-basics','def is_valid_triangle(a, b, c):
    # Return True if valid triangle
    pass','def ref_impl(*args):
    a,b,c=args[0],args[1],args[2]
    return a+b>c and a+c>b and b+c>a

assert "is_valid_triangle" in exec_globals, "Function is_valid_triangle not found"
fn = exec_globals["is_valid_triangle"]
test_cases = [(3,4,5), (1,2,3), (5,12,13), (0,2,3), (10,1,1)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (20,'20. Ticket Price Calculator','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>ticket_price(age, is_student)</code> that returns ticket price based on rules:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">Children under 5 → Free (<code>0</code>)</li>
  <li class="py-0.5">Seniors 65+ → <code>5</code> (50% discount)</li>
  <li class="py-0.5">Students → <code>8</code> (20% discount)</li>
  <li class="py-0.5">Everyone else → <code>10</code> (full price)</li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Note: the age rules take priority over the student discount.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>age=4, is_student=False</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Age is under 5, ticket is free.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>age=70, is_student=False</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>5</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Age is 65+, ticket is discounted to 5.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>age=20, is_student=True</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>8</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Age is 20 and student flag is True, ticket is discounted to 8.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 4</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>age=30, is_student=False</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>10</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Full price ticket.</span></div>
</div>','easy',100,'python-basics','def ticket_price(age, is_student):
    # Return ticket price as integer
    pass','def ref_impl(*args):
    age,stud=args[0],args[1]
    if age<5: return 0
    elif age>=65: return 5
    elif stud: return 8
    return 10

assert "ticket_price" in exec_globals, "Function ticket_price not found"
fn = exec_globals["ticket_price"]
test_cases = [(4,False), (70,False), (20,True), (25,False), (5,True), (64,True)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (21,'21. BMI Classifier','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>bmi_classify(weight, height)</code> that computes BMI = weight(kg) / height(m)² and returns:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">BMI < 18.5 → <code>"Underweight"</code></li>
  <li class="py-0.5">18.5 ≤ BMI < 25 → <code>"Normal"</code></li>
  <li class="py-0.5">25 ≤ BMI < 30 → <code>"Overweight"</code></li>
  <li class="py-0.5">BMI ≥ 30 → <code>"Obese"</code></li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>weight=40, height=1.60</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Underweight"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">BMI = 40/1.6² = 15.6</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>weight=70, height=1.75</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Normal"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">BMI = 70/1.75² = 22.9</span></div>
</div>','easy',100,'python-basics','def bmi_classify(weight, height):
    # Calculate BMI and return category
    pass','def ref_impl(*args):
    w,h=args[0],args[1]
    bmi=w/(h*h)
    if bmi<18.5: return "Underweight"
    elif bmi<25.0: return "Normal"
    elif bmi<30.0: return "Overweight"
    return "Obese"

assert "bmi_classify" in exec_globals, "Function bmi_classify not found"
fn = exec_globals["bmi_classify"]
test_cases = [(50,1.60), (40,1.60), (80,1.60), (70,1.60), (100,1.75)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (22,'22. Rock Paper Scissors','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>rps_winner(p1, p2)</code> that takes two choices (<code>"rock"</code>, <code>"paper"</code>, or <code>"scissors"</code>) and returns <code>"Player 1"</code>, <code>"Player 2"</code>, or <code>"Draw"</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Rules: Rock beats Scissors, Scissors beats Paper, Paper beats Rock.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>p1="rock", p2="scissors"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Player 1"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Player 1 chose rock and Player 2 chose scissors. Since rock beats scissors, Player 1 wins.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>p1="paper", p2="paper"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Draw"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Both players chose paper, resulting in a Draw.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>p1="scissors", p2="rock"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Player 2"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Player 1 chose scissors and Player 2 chose rock. Since rock beats scissors, Player 2 wins.</span></div>
</div>','easy',100,'python-basics','def rps_winner(p1, p2):
    # Return who wins or "Draw"
    pass','def ref_impl(*args):
    p1,p2=args[0],args[1]
    if p1==p2: return "Draw"
    wins=[("rock","scissors"),("scissors","paper"),("paper","rock")]
    return "Player 1" if (p1,p2) in wins else "Player 2"

assert "rps_winner" in exec_globals, "Function rps_winner not found"
fn = exec_globals["rps_winner"]
test_cases = [("rock","scissors"), ("paper","paper"), ("scissors","rock"), ("paper","rock"), ("rock","paper")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (23,'23. Simple Calculator','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>calculate(a, b, op)</code> that performs the operation specified by the string <code>op</code> on numbers <code>a</code> and <code>b</code>. Supported operators: <code>"+"</code>, <code>"-"</code>, <code>"*"</code>, <code>"/"</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return <code>"Error: Division by zero"</code> if op is <code>"/"</code> and b is 0. Return <code>"Error: Invalid operator"</code> for unknown operators.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=10, b=5, op="+"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>15</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The operator is "+", so we add 10 and 5 to get 15.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=10, b=0, op="/"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Error: Division by zero"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Division by zero is invalid, so we return an error message.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=5, b=2, op="%"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Error: Invalid operator"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The modulo operator "%" is not supported, so we return an error message.</span></div>
</div>','easy',100,'python-basics','def calculate(a, b, op):
    # Return result or error string
    pass','def ref_impl(*args):
    a,b,op=args[0],args[1],args[2]
    if op=="+":
        return a+b
    elif op=="-":
        return a-b
    elif op=="*":
        return a*b
    elif op=="/":
        if b==0: return "Error: Division by zero"
        return a/b
    return "Error: Invalid operator"

assert "calculate" in exec_globals, "Function calculate not found"
fn = exec_globals["calculate"]
test_cases = [(10,5,"+"), (10,3,"-"), (4,3,"*"), (10,5,"/"), (10,0,"/"), (5,2,"%")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (24,'24. Character Classifier','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>classify_char(ch)</code> that takes a single character and returns its category:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">Uppercase letter → <code>"Uppercase"</code></li>
  <li class="py-0.5">Lowercase letter → <code>"Lowercase"</code></li>
  <li class="py-0.5">Digit (0–9) → <code>"Digit"</code></li>
  <li class="py-0.5">Anything else → <code>"Special"</code></li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "A"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Uppercase"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"A" is an uppercase letter.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "z"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Lowercase"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"z" is a lowercase letter.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "5"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Digit"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"5" is a numeric digit.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 4</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>ch = "#"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Special"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"#" is a special character symbol.</span></div>
</div>','easy',100,'python-basics','def classify_char(ch):
    # Return the character category
    pass','def ref_impl(*args):
    c=args[0]
    if c.isupper(): return "Uppercase"
    elif c.islower(): return "Lowercase"
    elif c.isdigit(): return "Digit"
    return "Special"

assert "classify_char" in exec_globals, "Function classify_char not found"
fn = exec_globals["classify_char"]
test_cases = ["A", "z", "5", "#", " ", "Z", "0", "!"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 8',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (25,'25. Quadratic Roots Counter','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>count_roots(a, b, c)</code> that determines how many real roots the quadratic equation <code>ax² + bx + c = 0</code> has.</p>
<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Use the discriminant: <code>D = b² - 4ac</code></p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">D > 0 → 2 real roots</li>
  <li class="py-0.5">D = 0 → 1 real root (repeated)</li>
  <li class="py-0.5">D < 0 → 0 real roots</li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Assume a ≠ 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=1, b=-3, c=2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">D = 9-8 = 1 > 0 → two roots</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=1, b=2, c=1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">D = 4-4 = 0 → one root</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a=1, b=1, c=1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">D = 1-4 = -3 < 0 → no real roots</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>a is always non-zero</code></li>
</ul>','medium',200,'python-basics','def count_roots(a, b, c):
    # Return number of real roots: 0, 1, or 2
    pass','def ref_impl(*args):
    a,b,c=args[0],args[1],args[2]
    d=b*b-4*a*c
    if d>0: return 2
    elif d==0: return 1
    return 0

assert "count_roots" in exec_globals, "Function count_roots not found"
fn = exec_globals["count_roots"]
test_cases = [(1,-3,2), (1,2,1), (1,1,1), (2,4,2), (1,0,-1)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (26,'26. Number Reverse','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a signed integer n, reverse its digits mathematically. You must extract each digit from the back of the number using the modulo operator (% 10), add it to a running total scaled by 10, and then truncate the last digit of the original number using integer division (/ 10).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5792</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2975</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -408</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-804</code></div>
  
</div>','easy',100,'python-basics','def even_or_odd(n):
    # Return "Even" or "Odd"
    pass','def ref_impl(*args):
    return "Even" if args[0] % 2 == 0 else "Odd"

assert "even_or_odd" in exec_globals, "Function even_or_odd not found"
fn = exec_globals["even_or_odd"]
test_cases = [42, -17, 0, -2, 100]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (27,'27. String Reverse','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, reverse the sequence of its characters. This is a foundational memory manipulation problem. The standard approach requires a two-pointer logic: one pointer at the start (0) and one at the end (s.length() - 1), swapping characters while moving toward the center.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "hello"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"olleh"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Data Science"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"ecneicS ataD"</code></div>
  
</div>','easy',100,'python-basics','def reverse_integer(n):
    # Reverse the digits of n
    pass','def ref_impl(*args):
    sign=-1 if args[0]<0 else 1
    return int(str(abs(args[0]))[::-1])*sign

assert "reverse_integer" in exec_globals, "Function reverse_integer not found"
fn = exec_globals["reverse_integer"]
test_cases = [5792, -408, 9300, 0, 7]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (28,'28. Count Digits in a Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, compute the total number of digits present in its base-10 representation. This can be solved iteratively by dividing the number by 10 until it reaches 0, or mathematically using the base-10 logarithm formula: log10(n) + 1.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 34521</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>5</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  
</div>','easy',100,'python-basics','def count_digits(n):
    # Count digits in n
    pass','def ref_impl(*args):
    return len(str(abs(args[0])))

assert "count_digits" in exec_globals, "Function count_digits not found"
fn = exec_globals["count_digits"]
test_cases = [34521, -9, 0, -500, 100000]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (29,'29. Sum of Digits of a Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, calculate the absolute sum of all its individual digits. You must iteratively isolate each digit from the units place upwards and accumulate the total value.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 1234</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>10</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Since 1 + 2 + 3 + 4 = 10</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -506</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>11</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Since -5 + 0 + 6 = 11</span></div>
</div>','easy',100,'python-basics','def sum_of_digits(n):
    # Sum all digits of n
    pass','def ref_impl(*args):
    return sum(int(d) for d in str(abs(args[0])))

assert "sum_of_digits" in exec_globals, "Function sum_of_digits not found"
fn = exec_globals["sum_of_digits"]
test_cases = [1234, -506, 0, -45]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (30,'30. Swap Two Numbers','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two variables a and b, interchange their values. You must be prepared to demonstrate this using two distinct logical strategies:Using a temporary placeholder variable.Without any additional memory variables (using arithmetic addition/subtraction or bitwise XOR operations).</p>','easy',100,'python-basics','def swap_numbers(a, b):
    # Return (b, a) swapped
    pass','def ref_impl(*args):
    return (args[1],args[0])

assert "swap_numbers" in exec_globals, "Function swap_numbers not found"
fn = exec_globals["swap_numbers"]
test_cases = [(5,10), (-3,7), (4,4)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (31,'31. Check Even or Odd','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, determine whether it is completely divisible by 2 (Even) or leaves a remainder (Odd). This can be executed using the standard arithmetic modulo operator (n % 2 == 0) or optimized via bitwise logic checking the Least Significant Bit (LSB) ((n & 1) == 0).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 42</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Even"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -17</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Odd"</code></div>
  
</div>','easy',100,'python-basics','def is_palindrome_number(n):
    # Return True if palindrome number
    pass','def ref_impl(*args):
    n=args[0]
    if n<0: return False
    return str(n)==str(n)[::-1]

assert "is_palindrome_number" in exec_globals, "Function is_palindrome_number not found"
fn = exec_globals["is_palindrome_number"]
test_cases = [1221, -121, 10, 0, 12321]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (32,'32. Fibonacci Series Generation','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, generate the first n terms of the Fibonacci sequence. The sequence begins with 0 and 1, and each subsequent number is the sum of the previous two numbers (F[n] = F[n-1] + F[n-2]). The output should be a sequence or list containing exactly n elements.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 1, 1, 2, 3]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0]</code></div>
  
</div>','easy',100,'python-basics','def is_armstrong(n):
    # Return True if Armstrong number
    pass','def ref_impl(*args):
    n=args[0]
    s=str(n)
    l=len(s)
    return sum(int(d)**l for d in s)==n

assert "is_armstrong" in exec_globals, "Function is_armstrong not found"
fn = exec_globals["is_armstrong"]
test_cases = [153, 123, 1634, 0, 7, 370]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (33,'33. Nth Fibonacci Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, calculate the exact value of the n-th Fibonacci number. While the generation problem requires tracking the whole list, this problem requires optimizing space complexity down to O(1) by only storing the last two terms during iteration instead of maintaining an entire history array.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>34</code></div>
  
</div>','easy',100,'python-basics','def generate_fibonacci(n):
    # Return list of first n Fibonacci numbers
    pass','def ref_impl(*args):
    n=args[0]
    if n<=0: return []
    if n==1: return [0]
    res=[0,1]
    while len(res)<n:
        res.append(res[-1]+res[-2])
    return res

assert "generate_fibonacci" in exec_globals, "Function generate_fibonacci not found"
fn = exec_globals["generate_fibonacci"]
test_cases = [5, 1, 0, 2, 8]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (34,'34. Factorial of a Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a non-negative integer n, compute the product of all positive integers less than or equal to n (n! = n  ×  (n-1)  ×  ...  ×  1).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>120</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  
</div>','easy',100,'python-basics','def nth_fibonacci(n):
    # Return the nth Fibonacci number (0-indexed)
    pass','def ref_impl(*args):
    n=args[0]
    if n<=0: return 0
    if n==1: return 1
    a,b=0,1
    for _ in range(2,n+1):
        a,b=b,a+b
    return b

assert "nth_fibonacci" in exec_globals, "Function nth_fibonacci not found"
fn = exec_globals["nth_fibonacci"]
test_cases = [0, 1, 2, 9, 10]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (35,'35. Check Prime Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, check whether it is a prime number (divisible only by 1 and itself). A naive loop checking up to n yields an inefficient O(n) footprint. The solution must use mathematical logic to optimize verification to O(\sqrt{n}) by checking factors up to the square root of n.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 11</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>true</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>false</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Since 2  ×  2 = 4</span></div>
</div>','easy',100,'python-basics','def factorial(n):
    # Return n! (n factorial)
    pass','def ref_impl(*args):
    import math
    return math.factorial(args[0])

assert "factorial" in exec_globals, "Function factorial not found"
fn = exec_globals["factorial"]
test_cases = [5, 0, 1, 10, 7]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (36,'36. Armstrong Number Check','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, determine if it is an Armstrong number (also known as a Narcissistic number). An Armstrong number is equal to the sum of its own digits, each raised to the power of the total number of digits in that number.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 153</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>true</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">153 has 3 digits. 1^3 + 5^3 + 3^3 = 1 + 125 + 27 = 153.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 123</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>false</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">1^3 + 2^3 + 3^3 = 1 + 8 + 27 = 36  !=  123.</span></div>
</div>','easy',100,'python-basics','def is_prime(n):
    # Return True if n is prime
    pass','def ref_impl(*args):
    n=args[0]
    if n<=1: return False
    for i in range(2,int(n**0.5)+1):
        if n%i==0: return False
    return True

assert "is_prime" in exec_globals, "Function is_prime not found"
fn = exec_globals["is_prime"]
test_cases = [11, 4, 1, 2, 9, -5, 97]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 7',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (37,'37. Palindrome Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, return true if n is a palindrome, and false otherwise. An integer is a palindrome when it reads the same backward as forward. To satisfy standard data-manipulation constraints, you must achieve this without converting the number into a string, forcing you to reverse the digits mathematically.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 1221</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>true</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -121</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>false</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Reading from left-to-right yields -121. From right-to-left, it translates to 121-, failing the match.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Negative Sign Formats: All negative numbers must immediately fail and return false.</code></li><li><code>Trailing Zeros: Any positive number ending in 0 (like 10, 290, 1100) is fundamentally non-palindromic because no standard integer begins with 0. The exception is the number 0 itself, which must return true.</code></li><li><code>Preventing Partial Overflows: When reversing the entire number to check for equivalence, large numbers near the 32-bit ceiling might overflow. To prevent this, design the logic to stop reversing once it reaches the exact halfway point of the number (originalNumber <= reversedNumber).</code></li>
</ul>','medium',200,'python-basics','def count_primes(n):
    # Count primes strictly less than n
    pass','def ref_impl(*args):
    n=args[0]
    if n<=2: return 0
    ip=[True]*n
    ip[0]=ip[1]=False
    for i in range(2,int(n**0.5)+1):
        if ip[i]:
            for j in range(i*i,n,i):
                ip[j]=False
    return sum(ip)

assert "count_primes" in exec_globals, "Function count_primes not found"
fn = exec_globals["count_primes"]
test_cases = [10, 2, 0, 1, 100]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (38,'38. Add Digits (Digital Root)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer num, repeatedly add all its individual digits until the calculated result contains only one single digit, then return it. While loops can solve this iteratively, the objective is to implement this using number theory (congruence formula) to achieve a constant execution footprint of O(1) time and O(1) space.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num = 38</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">3 + 8 = 11 \rightarrow 1 + 1 = 2. Since 2 is a single digit, return it.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div>','easy',100,'python-basics','def gcd_lcm(a, b):
    # Return (gcd, lcm) as a tuple
    pass','def ref_impl(*args):
    import math
    a,b=args[0],args[1]
    x,y=abs(a),abs(b)
    g=math.gcd(x,y)
    if g==0: return (0,0)
    l=(x//g)*y
    return (g,l)

assert "gcd_lcm" in exec_globals, "Function gcd_lcm not found"
fn = exec_globals["gcd_lcm"]
test_cases = [(24,36), (7,9), (0,8), (-24,36), (12,18)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (39,'39. Base 7 / Binary Conversion (Arbitrary Base Conversion)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a base-10 signed integer num, return its equivalent value represented in a target alternate radix system (such as Base 7 or Base 2/Binary) as a string. The logic requires continually capturing the remainder of the number divided by the target base, truncating the number, and building the result string from right to left.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num = 100 (Converting to Base 7)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"202"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">100 = (2  ×  7^2) + (0  ×  7^1) + (2  ×  7^0)</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num = -7 (Converting to Base 7)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"-10"</code></div>
  
</div>','easy',100,'python-basics','def trailing_zeroes(n):
    # Count trailing zeros in n!
    pass','def ref_impl(*args):
    n=args[0]
    count=0
    while n>=5:
        count+=n//5
        n//=5
    return count

assert "trailing_zeroes" in exec_globals, "Function trailing_zeroes not found"
fn = exec_globals["trailing_zeroes"]
test_cases = [5, 3, 0, 25, 125]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (40,'40. Integer to Roman','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a base-10 integer between 1 and 3999, convert it into its traditional Roman Numeral string representation. Roman numbers are written using seven distinct symbols (I=1, V=5, X=10, L=50, C=100, D=500, M=1000). The logic requires matching values against a descending dictionary lookup of symbols, handling subtractive prefix forms like 4 (IV), 9 (IX), 40 (XL), and 900 (CM) dynamically.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num = 58</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"LVIII"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">L = 50, V = 5, III = 3.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num = 1994</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"MCMXCIV"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">M = 1000, CM = 900, XC = 90, IV = 4.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Subtractive Transitions: Inputs hitting exact subtractive switchpoints (e.g., 400 returning "CD", or 90 returning "XC") must pass flawlessly without resolving to incorrect additive repetitions like "CCCC" or "LXXXX".</code></li><li><code>Maximum Scope Limits: Ensure inputs reaching the problem ceiling value (3999) safely accumulate out to "MMMCMXCIX".</code></li>
</ul>','easy',100,'python-basics','def is_happy(n):
    # Return True if n is a happy number
    pass','def ref_impl(*args):
    n=args[0]
    seen=set()
    while n!=1 and n not in seen:
        seen.add(n)
        n=sum(int(d)**2 for d in str(n))
    return n==1

assert "is_happy" in exec_globals, "Function is_happy not found"
fn = exec_globals["is_happy"]
test_cases = [19, 2, 7, 1, 4]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (41,'41. Roman to Integer','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a valid Roman Numeral string s, convert it back into its equivalent base-10 integer form. The processing logic reads the string from left to right. If a smaller symbol value appears before a larger symbol value, it indicates that a subtractive configuration is active (e.g., IV), requiring you to subtract the smaller value from the running total instead of adding it.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "III"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>3</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "MCMXCIV"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1994</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Single Character Conversions: Individual primitive tokens like "M" or "X" must successfully map directly to 1000 or 10.</code></li><li><code>Trailing Monotonic Steps: Complex mixed structures that terminate in minor tail values (e.g., "CDXLIV" for 444) must continuously track the character immediately to their right to accurately detect and execute look-ahead subtraction routines.</code></li>
</ul>','easy',100,'python-basics','def is_ugly(n):
    # Return True if n is an ugly number
    pass','def ref_impl(*args):
    n=args[0]
    if n<=0: return False
    for p in [2,3,5]:
        while n%p==0:
            n//=p
    return n==1

assert "is_ugly" in exec_globals, "Function is_ugly not found"
fn = exec_globals["is_ugly"]
test_cases = [6, 14, 1, 0, -8, 30]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (42,'42. Excel Sheet Column Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string columnTitle that represents the column title as it appears in an Excel sheet, return its corresponding column number. This problem requires you to implement positional notation logic. The alphabet strings function like a base-26 numbering system where character tokens A through Z represent values 1 through 26.As you traverse the string from left to right, you shift the previously accumulated total by multiplying it by 26 before adding the value of the current character:Total = Total  ×  26 + (Current Character - ''A'' + 1)</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>columnTitle = "AB"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>28</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"A" = 1, "B" = 2. Total = 1  ×  26 + 2 = 28.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>columnTitle = "ZY"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>701</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"Z" = 26, "Y" = 25. Total = 26  ×  26 + 25 = 676 + 25 = 701.</span></div>
</div>','easy',100,'python-basics','def add_digits(num):
    # Repeatedly sum digits until single digit (digital root)
    pass','def ref_impl(*args):
    num=args[0]
    if num==0: return 0
    return 9 if num%9==0 else num%9

assert "add_digits" in exec_globals, "Function add_digits not found"
fn = exec_globals["add_digits"]
test_cases = [38, 0, 9, 18, 999]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (43,'43. Multiply Strings (BigInteger Simulation)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two non-negative integers represented as strings num1 and num2, return the product of num1 and num2, also represented as a string. You cannot use built-in arbitrary-precision libraries (like BigInteger in Java) or convert the inputs directly to integers.This problem tests your ability to simulate long multiplication manually. You create an array of size num1.length() + num2.length() to store the intermediate products, multiply individual digits from right to left, accumulate the results at their correct positional indices, and handle the carry values systematically.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num1 = "2", num2 = "3"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"6"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>num1 = "123", num2 = "456"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"56088"</code></div>
  
</div>','medium',200,'python-basics','def my_pow(x, n):
    # Implement x to the power n
    pass','def ref_impl(*args):
    x,n=args[0],args[1]
    return round(x**n,5)

assert "my_pow" in exec_globals, "Function my_pow not found"
fn = exec_globals["my_pow"]
test_cases = [(2.0,10), (2.1,3), (2.0,-2), (0.0,5), (1.0,100), (2.0,0)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (44,'44. String to Integer (atoi implementation)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Implement the myAtoi(string s) function, which converts a string into a signed 32-bit integer. The logic must simulate the robust parsing engine of standard low-level environments by following these precise sequential rules:Ignore any leading whitespace.Check if the next character is a sign symbol (''-'' or ''+'').Read in next characters until the next non-digit character or the end of the input is reached.Convert these digits into an integer.Clamp the final integer to stay within the signed 32-bit range: [-2^31, 2^31 - 1].</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "   -42"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-42</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "4193 with words"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>4193</code></div>
  
</div>','easy',100,'python-basics','def roman_to_int(s):
    # Convert Roman numeral string to integer
    pass','def ref_impl(*args):
    s=args[0]
    roman={"I":1,"V":5,"X":10,"L":50,"C":100,"D":500,"M":1000}
    ans=0
    for i in range(len(s)):
        if i+1<len(s) and roman[s[i]]<roman[s[i+1]]:
            ans-=roman[s[i]]
        else:
            ans+=roman[s[i]]
    return ans

assert "roman_to_int" in exec_globals, "Function roman_to_int not found"
fn = exec_globals["roman_to_int"]
test_cases = ["III", "MCMXCIV", "CDXLIV", "X", "IV"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (45,'45. Next Greater Element III (Digit Permutation)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a positive integer n, find the smallest positive integer that uses exactly the same digits present in n and is strictly greater than n. If no such integer exists, return -1.This requires identifying the next lexicographical permutation of the digit sequence:Traverse from right to left to find the first digit that is smaller than the digit to its immediate right (this is the swap pivot index i).If no such pivot exists, the digits are in descending order, meaning no greater permutation can be formed.Traverse from the right edge again to find the smallest digit that is greater than the digit at index i. Swap them.Reverse the entire sequence of digits to the right of index i to keep the resulting number as small as possible.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 12</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>21</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 21</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  
</div>','medium',200,'python-basics','def int_to_roman(num):
    # Convert integer to Roman numeral string
    pass','def ref_impl(*args):
    num=args[0]
    val=[1000,900,500,400,100,90,50,40,10,9,5,4,1]
    syb=["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"]
    rn=""
    i=0
    while num>0:
        for _ in range(num//val[i]):
            rn+=syb[i]
            num-=val[i]
        i+=1
    return rn

assert "int_to_roman" in exec_globals, "Function int_to_roman not found"
fn = exec_globals["int_to_roman"]
test_cases = [58, 1994, 3999, 4, 9]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (46,'46. Count Primes (Sieve of Eratosthenes)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, return the number of prime numbers that are strictly less than n. Checking every number from 2 to n individually results in a slow O(n\sqrt{n}) time complexity.Instead, use the Sieve of Eratosthenes. Create a boolean array of size n initialized to true. Starting from 2, if a number is prime, mark all of its multiples as false (composite). To optimize this, start marking multiples from i^2 instead of 2  ×  i, and terminate the outer loop as soon as i^2  >=  n.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 10</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>4</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">There are 4 prime numbers strictly less than 10: 2, 3, 5, and 7.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">There are no primes strictly less than 2.</span></div>
</div>','medium',200,'python-basics','def multiply_strings(num1, num2):
    # Multiply two non-negative integers given as strings
    pass','def ref_impl(*args):
    return str(int(args[0])*int(args[1]))

assert "multiply_strings" in exec_globals, "Function multiply_strings not found"
fn = exec_globals["multiply_strings"]
test_cases = [("2","3"), ("123","456"), ("0","456"), ("999","999"), ("1","0")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (47,'47. Greatest Common Divisor (GCD) & LCM','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two integers a and b, calculate their Greatest Common Divisor (GCD) and Least Common Multiple (LCM).To do this efficiently, use Euclid''s Algorithm, which states that GCD(a, b) = GCD(b, a  %  b) until b becomes 0. Once the GCD is found, compute the LCM using the mathematical property:LCM(a, b) = a  ×  b / GCD(a, b)</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 24, b = 36</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>GCD = 12, LCM = 72</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 7, b = 9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>GCD = 1, LCM = 63</code></div>
  
</div>','medium',200,'python-basics','def my_atoi(s):
    # Convert string to 32-bit signed integer (like C atoi)
    pass','def ref_impl(*args):
    s=args[0].lstrip()
    if not s: return 0
    sign=1
    i=0
    if s[0]=="-":
        sign=-1
        i+=1
    elif s[0]=="+":
        i+=1
    res=0
    while i<len(s) and s[i].isdigit():
        res=res*10+int(s[i])
        i+=1
    res*=sign
    INT_MIN,INT_MAX=-2**31,2**31-1
    return max(INT_MIN,min(INT_MAX,res))

assert "my_atoi" in exec_globals, "Function my_atoi not found"
fn = exec_globals["my_atoi"]
test_cases = ["   -42", "4193 with words", "words and 987", "9999999999", "-9999999999", "+"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (48,'48. Factorial Trailing Zeroes','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, return the number of trailing zeroes in n!. Your solution must run in O(\log n) time complexity.Calculating the literal factorial value first is impossible because numbers like 100! quickly overflow even 64-bit long structures. Instead, use prime factorization logic: a trailing zero is created by multiplying 2  ×  5. In any factorial sequence, the prime factor 2 is always more abundant than 5. Therefore, the problem simplifies to counting how many times the prime factor 5 appears in the numbers from 1 to n:Trailing Zeroes = n / 5 + n / 25 + n / 125 + ...</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">5! = 120, which has exactly 1 trailing zero.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">3! = 6, which has 0 trailing zeroes.</span></div>
</div>','medium',200,'python-basics','def next_greater_digit_arrangement(n):
    # Find smallest integer greater than n with same digits
    pass','def ref_impl(*args):
    n=args[0]
    digits=list(str(n))
    i=len(digits)-2
    while i>=0 and digits[i]>=digits[i+1]:
        i-=1
    if i<0: return -1
    j=len(digits)-1
    while digits[j]<=digits[i]:
        j-=1
    digits[i],digits[j]=digits[j],digits[i]
    digits[i+1:]=reversed(digits[i+1:])
    res=int("".join(digits))
    return res if res<2**31 else -1

assert "next_greater_digit_arrangement" in exec_globals, "Function next_greater_digit_arrangement not found"
fn = exec_globals["next_greater_digit_arrangement"]
test_cases = [12, 21, 1999999999, 987520, 51111, 230241]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (49,'49. Super Pow (Modular Exponentiation)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Calculate a^b  % 1337 where a is a positive integer and b is an extremely large positive integer given as an array of its individual digits.Because b can contain thousands of digits, it cannot be converted into standard primitive datatypes. You must solve this by combining Modular Arithmetic with positional digit expansion:a^[1, 2, 3, 4]  % m =  <= ft( (a^[1, 2, 3])^10  ×  a^4 \right)  % mThis pattern allows you to process the array from left to right using a combination of a modular power helper function and recursive scaling.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 2, b = [3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>8</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>a = 2, b = [1, 0]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1024 (Since 2^10 = 1024, and 1024  % 1337 = 1024).</code></div>
  
</div>','medium',200,'python-basics','def convert_to_base(num, base):
    # Convert num to given base (2-9), return as string
    pass','def ref_impl(*args):
    num,base=args[0],args[1]
    if num==0: return "0"
    sign="-" if num<0 else ""
    n=abs(num)
    res=[]
    while n>0:
        res.append(str(n%base))
        n//=base
    return sign+"".join(res[::-1])

assert "convert_to_base" in exec_globals, "Function convert_to_base not found"
fn = exec_globals["convert_to_base"]
test_cases = [(100,7), (-7,7), (0,7), (5,2), (-5,2), (255,2)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (50,'50. Ugly Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">An ugly number is a positive integer whose prime factors are limited strictly to 2, 3, and 5. Given an integer n, return true if n is an ugly number, and false otherwise.The logic requires you to systematically strip away all factors of 2, 3, and 5 by dividing the number as long as it is evenly divisible. If the number reduces down to exactly 1 after this process, it is an ugly number.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 6</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>true</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">6 = 2  ×  3. Its prime factors are completely limited to the set of [2, 3, 5].</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 14</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>false</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">14 = 2  ×  7. Since it includes the prime factor 7, it is not an ugly number.</span></div>
</div>','easy',100,'python-basics','def excel_column_number(columnTitle):
    # Convert Excel column title (e.g. "AB") to number
    pass','def ref_impl(*args):
    t=args[0]
    ans=0
    for c in t:
        ans=ans*26+(ord(c)-ord("A")+1)
    return ans

assert "excel_column_number" in exec_globals, "Function excel_column_number not found"
fn = exec_globals["excel_column_number"]
test_cases = ["AB", "ZY", "A", "Z", "FXSHRXW"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (51,'51. Happy Number','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write an algorithm to determine if a number n is "happy". A happy number is defined by a process where you replace the number by the sum of the squares of its digits, repeating the process until the number equals 1, or it loops endlessly in a cycle that does not include 1. Those numbers for which this process ends in 1 are happy. Return true if it is happy, and false if not.To solve this efficiently without using excessive memory, you can treat the sequence of numbers as a linked list problem and apply Floyd''s Tortoise and Hare cycle-detection algorithm. Alternatively, you can track previously visited numbers using a HashSet.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 19</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>true</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">1^2 + 9^2 = 828^2 + 2^2 = 686^2 + 8^2 = 1001^2 + 0^2 + 0^2 = 1 (Stops at 1)</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>false</code></div>
  
</div>','hard',300,'python-basics','def super_pow(a, b):
    # Compute a^b mod 1337 where b is given as list of digits
    pass','def ref_impl(*args):
    a,b=args[0],args[1]
    mod=1337
    return pow(a%mod,int("".join(map(str,b))),mod)

assert "super_pow" in exec_globals, "Function super_pow not found"
fn = exec_globals["super_pow"]
test_cases = [(2,[3]), (2,[1,0]), (2147483647,[2,0,0])]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (52,'52. Integer Break','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, break it into the sum of k positive integers, where k  >=  2, and maximize the product of those integers. Return the maximum product you can get.This problem utilizes number theory and logic to discover a specific mathematical pattern. Breaking the number into as many factors of 3 as possible yields the maximum product because the mathematical constant e \approx 2.718 is the optimal base for maximizing products, and 3 is the closest integer to e.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">2 = 1 + 1, and 1  ×  1 = 1. (Must break into at least 2 parts).</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 10</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>36</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">10 = 3 + 3 + 4, and 3  ×  3  ×  4 = 36.</span></div>
</div>','hard',300,'python-basics','def integer_break(n):
    # Break n into positive integers summing to n, maximise product
    pass','def ref_impl(*args):
    n=args[0]
    if n==2: return 1
    if n==3: return 2
    c3=n//3
    r=n%3
    if r==1:
        return (3**(c3-1))*4
    elif r==2:
        return (3**c3)*2
    return 3**c3

assert "integer_break" in exec_globals, "Function integer_break not found"
fn = exec_globals["integer_break"]
test_cases = [2, 10, 3, 4, 8]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (53,'53. Perfect Squares (Lagrange''s Four-Square Properties)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, return the least number of perfect square numbers (e.g., 1, 4, 9, 16, ...) that sum to n.While this is widely known as a Dynamic Programming problem, it can be optimized to run in O(\sqrt{n}) time using Lagrange''s Four-Square Theorem. The theorem states that every natural number can be represented as the sum of four or fewer integer squares. By combining this with Legendre''s Three-Square Theorem, the answer can only ever be 1, 2, 3, or 4.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 12</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>3</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">12 = 4 + 4 + 4.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 13</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">13 = 4 + 9.</span></div>
</div>','medium',200,'python-basics','def num_squares(n):
    # Least number of perfect square numbers that sum to n
    pass','def ref_impl(*args):
    n=args[0]
    while n%4==0: n//=4
    if n%8==7: return 4
    for i in range(int(n**0.5)+1):
        if i*i==n: return 1
    for i in range(int(n**0.5)+1):
        j2=n-i*i
        j=int(j2**0.5)
        if j*j==j2: return 2
    return 3

assert "num_squares" in exec_globals, "Function num_squares not found"
fn = exec_globals["num_squares"]
test_cases = [12, 13, 4, 7, 36]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (54,'54. Nim Game (Game Theory Logic)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">You are playing the following Nim Game with your friend:There is a heap of stones on the table.You and your friend take turns making moves, and you go first.Each turn, the person whose turn it is will remove 1 to 3 stones from the heap.The one who removes the last stone is the winner.Given n, the number of stones in the heap, return true if you can win the game assuming both you and your friend play optimally, otherwise return false. This problem tests your ability to identify mathematical induction patterns and game state strategies to reduce a seemingly complex recursive game tree down to a single O(1) logical condition.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>false</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">If there are 4 stones, you can never win. Whether you remove 1, 2, or 3 stones, your friend can remove the remaining stones on their next turn to win the game.</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>true</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">You take the 1 remaining stone and win immediately.</span></div>
</div>','easy',100,'python-basics','def can_win_nim(n):
    # Return True if first player wins Nim game
    pass','def ref_impl(*args):
    return args[0]%4!=0

assert "can_win_nim" in exec_globals, "Function can_win_nim not found"
fn = exec_globals["can_win_nim"]
test_cases = [4, 1, 2, 3, 8, 135]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (55,'55. Pow(x, n) (Binary Exponentiation)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Implement pow(x, n), which calculates x raised to the power n (i.e., x^n). A naive approach multiplies x exactly n times, running in an inefficient O(n) time loop.To pass technical interview performance bounds, you must use Binary Exponentiation (also known as exponentiation by squaring) to reduce the complexity to O(\log n). The logic cuts the problem in half at each step:x^n = \begin{cases} (x^2)^n/2 & if  n  is even \\ x  ×  (x^2)^(n-1)/2 & if  n  is odd \end{cases}</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>x = 2.00000, n = 10</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1024.00000</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>x = 2.10000, n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>9.26100</code></div>
  
</div>','easy',100,'python-basics','def is_perfect_number(n):
    # Return True if n equals sum of its proper divisors
    pass','def ref_impl(*args):
    n=args[0]
    if n<=1: return False
    return sum(i for i in range(1,n) if n%i==0)==n

assert "is_perfect_number" in exec_globals, "Function is_perfect_number not found"
fn = exec_globals["is_perfect_number"]
test_cases = [6, 28, 12, 1, 496, 8128]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (56,'56. Solid Star Square Pattern','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a solid square pattern composed of asterisks (*). The grid must contain exactly n rows, and each row must contain exactly n asterisks. Each asterisk in a row should be separated by a single space character.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, the pattern cannot be formed; in this scenario, print nothing (an empty output).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">* * * * *
* * * * *
* * * * *
* * * * *
* * * * *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">* *
* *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (The absolute minimal single-cell grid boundary condition)</code></li><li><code>n = -3 (Negative constraint handling resulting in zero operations)</code></li><li><code>n = 10 (Large uniform grid tracking row/column loop termination)</code></li>
</ul>','easy',100,'python-basics','def solid_square(n):
    # Write your code here
    pass','def ref_impl(*args):
    if args[0] <= 0: return ""
    return "\n".join([" ".join(["*"] * args[0])] * args[0])

assert "solid_square" in exec_globals, "Function solid_square not found"
fn = exec_globals["solid_square"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (57,'57. Right-Angled Star Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of asterisks (*). The triangle must have exactly n rows. The first row must contain exactly 1 asterisk, the second row must contain 2 asterisks, and each subsequent row must increase the count by 1 until the n-th row, which contains exactly n asterisks. Each asterisk within a row should be separated by a single space character.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
* *
* * *
* * * *
* * * * *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
* *
* * *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Single row boundary case printing a solitary asterisk)</code></li><li><code>n = 0 (Zero constraint exit validation)</code></li><li><code>n = 6 (Verifying that the sequence scales linearly row-by-row)</code></li>
</ul>','easy',100,'python-basics','def right_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    if args[0] <= 0: return ""
    return "\n".join([" ".join(["*"] * i) for i in range(1, args[0] + 1)])

assert "right_triangle" in exec_globals, "Function right_triangle not found"
fn = exec_globals["right_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (58,'58. Right-Angled Number Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern using sequential integers. The pattern must contain exactly n rows.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
1 2
1 2 3
1 2 3 4
1 2 3 4 5</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
1 2</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Displays only the starting number 1)</code></li><li><code>n = 4 (Verifying that the loop resets the numerical sequence back to 1 at the start of every new row)</code></li><li><code>n = -5 (Negative boundary verification check)</code></li>
</ul>','easy',100,'python-basics','def number_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    if args[0] <= 0: return ""
    return "\n".join([" ".join(str(j) for j in range(1, i + 1)) for i in range(1, args[0] + 1)])

assert "number_triangle" in exec_globals, "Function number_triangle not found"
fn = exec_globals["number_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (59,'59. Repeating Number Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of repeating numbers. The pattern must contain exactly n rows.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
2 2
3 3 3
4 4 4 4
5 5 5 5 5</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
2 2
3 3 3</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Minimal grid displaying only 1)</code></li><li><code>n = 6 (Ensuring the digit character updates across higher loop indices while matching the column length)</code></li><li><code>n = -2 (Graceful termination on negative boundaries)</code></li>
</ul>','easy',100,'python-basics','def repeating_number_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    if args[0] <= 0: return ""
    return "\n".join([" ".join([str(i)] * i) for i in range(1, args[0] + 1)])

assert "repeating_number_triangle" in exec_globals, "Function repeating_number_triangle not found"
fn = exec_globals["repeating_number_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (60,'60. Inverted Right-Angled Star Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print an inverted right-angled triangle pattern of asterisks (*). The pattern must contain exactly n rows. The characters in each row should be separated by a single space.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">* * * * *
* * * *
* * *
* *
*</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">* * *
* *
*</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Solitary cell structural match)</code></li><li><code>n = 4 (Verifying that loop decrements systematically trim the trailing star positions)</code></li><li><code>n = -10 (Handling out-of-bounds lower limits safely)</code></li>
</ul>','easy',100,'python-basics','def inverted_right_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    if args[0] <= 0: return ""
    return "\n".join([" ".join(["*"] * i) for i in range(args[0], 0, -1)])

assert "inverted_right_triangle" in exec_globals, "Function inverted_right_triangle not found"
fn = exec_globals["inverted_right_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (61,'61. Inverted Right-Angled Number Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print an inverted right-angled triangle pattern of numbers. The grid must contain exactly n rows. Numbers within each row must be separated by a single space.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1 2 3 4 5
1 2 3 4
1 2 3
1 2
1</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1 2
1</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Outputs only the baseline scalar character 1)</code></li><li><code>n = 4 (Ensuring inner loop counts decrease its terminal boundaries while keeping the start value anchored to 1)</code></li><li><code>n = -4 (Invalid range configuration safety check)</code></li>
</ul>','easy',100,'python-basics','def inverted_number_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    if args[0] <= 0: return ""
    return "\n".join([" ".join(str(j) for j in range(1, i + 1)) for i in range(args[0], 0, -1)])

assert "inverted_number_triangle" in exec_globals, "Function inverted_number_triangle not found"
fn = exec_globals["inverted_number_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (62,'62. Star Pyramid Pattern','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a centered pyramid pattern composed of asterisks (*). The pyramid must contain exactly n rows. The first row contains exactly 1 asterisk centered relative to the bottom row, and each subsequent row increases the asterisk count by exactly 2 (forming an odd sequence: 1, 3, 5, 7, ...).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The output must be formatted with leading spaces to maintain a perfectly symmetrical, centered alignment. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
  ***
 *****
*******</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
***</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (The minimal single-row pyramid showing one asterisk)</code></li><li><code>n = 5 (Verifying perfect centered spacing across higher horizontal layers)</code></li><li><code>n = -2 (Zero operations for invalid input boundaries)</code></li>
</ul>','easy',100,'python-basics','def star_pyramid(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        spaces = " " * (n - i)
        stars = " ".join(["*"] * i)
        lines.append(spaces + stars)
    return "\n".join(lines)

assert "star_pyramid" in exec_globals, "Function star_pyramid not found"
fn = exec_globals["star_pyramid"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (63,'63. Inverted Star Pyramid Pattern','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print an inverted centered pyramid pattern composed of asterisks (*). The pattern must contain exactly n rows. The first row must display the maximum width sequence of asterisks, and each subsequent row must decrease the asterisk count by exactly 2.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The rows must include leading spaces to keep the entire shape centered and inverted symmetrically. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*********
 *******
  *****
   ***
    *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">***
 *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = -1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Prints just a single asterisk)</code></li><li><code>n = 4 (Ensures the top row correctly outputs exactly 7 asterisks and tapers down cleanly)</code></li><li><code>n = 0 (Graceful termination check)</code></li>
</ul>','easy',100,'python-basics','def inverted_star_pyramid(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(n, 0, -1):
        spaces = " " * (n - i)
        stars = " ".join(["*"] * i)
        lines.append(spaces + stars)
    return "\n".join(lines)

assert "inverted_star_pyramid" in exec_globals, "Function inverted_star_pyramid not found"
fn = exec_globals["inverted_star_pyramid"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (64,'64. Star Diamond Pattern','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a symmetrical diamond pattern composed of asterisks (*). The diamond consists of a top upright pyramid followed by an inverted pyramid, creating a shape with a maximum thickness row in the center. The total height of the shape scales relative to the input parameter n.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Leading spaces must be managed perfectly across all rows to center the entire diamond. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
   ***
  *****
 *******
*********
*********
 *******
  *****
   ***
    *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
*</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 2 (Smallest complex multi-layer diamond layout)</code></li><li><code>n = 6 (Testing structural stability when splitting the growing and shrinking segments)</code></li><li><code>n = -5 (Negative boundary verification check)</code></li>
</ul>','medium',200,'python-basics','def star_diamond(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        spaces = " " * (n - i)
        stars = " ".join(["*"] * i)
        lines.append(spaces + stars)
    for i in range(n - 1, 0, -1):
        spaces = " " * (n - i)
        stars = " ".join(["*"] * i)
        lines.append(spaces + stars)
    return "\n".join(lines)

assert "star_diamond" in exec_globals, "Function star_diamond not found"
fn = exec_globals["star_diamond"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (65,'65. Half Star Diamond Pattern','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a sideways, right-pointing arrow pattern of asterisks (*). The pattern grows wider row-by-row until it reaches a maximum row width of n asterisks, after which it immediately begins narrowing down row-by-row until it terminates at 1 asterisk.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">No leading spaces are required for alignment; every row starts immediately at the left margin. Each asterisk within a row should be separated by a single space character. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
* *
* * *
* * * *
* * * * *
* * * *
* * *
* *
*</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*
* *
*</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (A single row with a single asterisk)</code></li><li><code>n = 4 (Ensures that the peak width reaches exactly 4 stars and matches the image layout)</code></li><li><code>n = -1 (Negative parameter safety check)</code></li>
</ul>','medium',200,'python-basics','def half_star_diamond(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        lines.append(" ".join(["*"] * i))
    for i in range(n - 1, 0, -1):
        lines.append(" ".join(["*"] * i))
    return "\n".join(lines)

assert "half_star_diamond" in exec_globals, "Function half_star_diamond not found"
fn = exec_globals["half_star_diamond"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (66,'66. Alternating Binary Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of alternating binary digits (1 and 0). The triangle must contain exactly n rows. The characters within each row must alternate between 1 and 0 with a single space separating them.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The first element of any row must match the value required by the alternating grid layout shown in the image (rows alternate their starting characters). If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
0 1
1 0 1
0 1 0 1
1 0 1 0 1</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
0 1
1 0 1</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Outputs only a single 1)</code></li><li><code>n = 4 (Ensures that row 4 starts with 0 and alternates properly)</code></li><li><code>n = -3 (Out-of-bounds input boundary check)</code></li>
</ul>','medium',200,'python-basics','def binary_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        row = []
        val = 1 if i % 2 != 0 else 0
        for j in range(i):
            row.append(str(val))
            val = 1 - val
        lines.append(" ".join(row))
    return "\n".join(lines)

assert "binary_triangle" in exec_globals, "Function binary_triangle not found"
fn = exec_globals["binary_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (67,'67. Mirror Number Canopy Pattern','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a symmetric numerical canopy pattern. The output must have exactly n rows. Each row consists of an increasing sequence of numbers on the left, an empty space gap in the middle, and a matching reversed sequence of numbers on the right.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The total horizontal character span remains constant, meaning the middle gap shrinks as the numerical sequences expand row-by-row. In the final n-th row, the left and right sequences meet in the center with no empty spaces between them. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1      1
12    21
123  321
12344321</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1  1
1221</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Displays the meeting point row 11 instantly)</code></li><li><code>n = 5 (Verifying precise width tracking of the empty internal spaces)</code></li><li><code>n = -6 (Handling negative grid heights cleanly)</code></li>
</ul>','medium',200,'python-basics','def mirror_canopy(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        left = "".join(str(j) for j in range(1, i + 1))
        right = "".join(str(j) for j in range(i, 0, -1))
        spaces = " " * (2 * (n - i))
        lines.append(left + spaces + right)
    return "\n".join(lines)

assert "mirror_canopy" in exec_globals, "Function mirror_canopy not found"
fn = exec_globals["mirror_canopy"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (68,'68. Floyd''s Number Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of continuously increasing positive integers. The triangle must contain exactly n rows. Unlike other number triangles that reset on each row, the numbers in this pattern continue to increment sequentially from 1 upward throughout the entire grid. Each number within a row must be separated by a single space character.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
2 3
4 5 6
7 8 9 10
11 12 13 14 15</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
2 3</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Prints only the starting value 1)</code></li><li><code>n = 4 (Ensures the final row accurately outputs the sequence ending at 10)</code></li><li><code>n = -4 (Graceful exit for invalid dimensions)</code></li>
</ul>','medium',200,'python-basics','def floyds_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    curr = 1
    for i in range(1, n + 1):
        row = []
        for _ in range(i):
            row.append(str(curr))
            curr += 1
        lines.append(" ".join(row))
    return "\n".join(lines)

assert "floyds_triangle" in exec_globals, "Function floyds_triangle not found"
fn = exec_globals["floyds_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (69,'69. Incrementing Alphabet Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of uppercase English alphabets. The triangle must contain exactly n rows. The i-th row (where i corresponds to the row index starting from 1) must display an alphabetical sequence beginning with ''A'' and progressing up to the i-th character of the alphabet. No spaces are present between the characters.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0 or greater than 26, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">A
AB
ABC
ABCD
ABCDE</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">A
AB</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Outputs only the single character ''A'')</code></li><li><code>n = 26 (Maximum upper limit boundary covering all characters up to ''Z'')</code></li><li><code>n = 27 (Out-of-bounds safety check resulting in an empty output)</code></li>
</ul>','medium',200,'python-basics','def alphabet_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0 or n > 26: return ""
    return "\n".join(["".join(chr(65 + j) for j in range(i)) for i in range(1, n + 1)])

assert "alphabet_triangle" in exec_globals, "Function alphabet_triangle not found"
fn = exec_globals["alphabet_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, 28]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (70,'70. Inverted Alphabet Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print an inverted right-angled triangle pattern of uppercase English alphabets. The pattern must contain exactly n rows. The first row must display a sequence of uppercase characters starting from ''A'' up to the n-th letter of the alphabet. Each subsequent row must shorten its alphabetical sequence limit by exactly one trailing character until the final row, which outputs only the letter ''A''.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0 or greater than 26, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">ABCDE
ABCD
ABC
AB
A</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">ABC
AB
A</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Displays only the baseline letter ''A'')</code></li><li><code>n = 4 (Ensures the initial row correctly spans from ''A'' to ''D'')</code></li><li><code>n = -5 (Negative boundary verification check)</code></li>
</ul>','medium',200,'python-basics','def inverted_alphabet_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0 or n > 26: return ""
    return "\n".join(["".join(chr(65 + j) for j in range(i)) for i in range(n, 0, -1)])

assert "inverted_alphabet_triangle" in exec_globals, "Function inverted_alphabet_triangle not found"
fn = exec_globals["inverted_alphabet_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, 28]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (71,'71. Repeating Alphabet Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of repeating uppercase alphabets. The pattern must contain exactly n rows. The i-th row must consist entirely of the i-th letter of the English alphabet, repeated exactly i times. No spaces separate the characters within a row.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If n is less than or equal to 0 or greater than 26, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">A
BB
CCC
DDDD
EEEEE</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">A
BB
CCC</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Displays a solitary ''A'')</code></li><li><code>n = 6 (Verifying character progression shifts accurately to ''F'' on the sixth row)</code></li><li><code>n = -1 (Negative constraint exit validation)</code></li>
</ul>','medium',200,'python-basics','def repeating_alphabet_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0 or n > 26: return ""
    return "\n".join([chr(65 + i - 1) * i for i in range(1, n + 1)])

assert "repeating_alphabet_triangle" in exec_globals, "Function repeating_alphabet_triangle not found"
fn = exec_globals["repeating_alphabet_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, 28]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (72,'72. Alphabet Palindrome Pyramid','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a centered pyramid pattern using alphabetical palindromes. The pyramid must contain exactly n rows. Each row consists of a sequence of letters that grows alphabetically starting from ''A'' up to a maximum character defined by that row, and then reverses back down to ''A''.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Leading spaces must be applied to ensure the entire pyramid is centered symmetrically. If n is less than or equal to 0 or greater than 26, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">A
  ABA
 ABCBA
ABCDCBA</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">A
ABA</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Minimal layer showing only ''A'')</code></li><li><code>n = 5 (Verifying width alignment and centering up to character ''E'')</code></li><li><code>n = 28 (Exceeds uppercase alphabet limits, returns empty)</code></li>
</ul>','medium',200,'python-basics','def alphabet_palindrome_pyramid(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0 or n > 26: return ""
    lines = []
    for i in range(1, n + 1):
        spaces = " " * (n - i)
        left = "".join(chr(65 + j) for j in range(i))
        right = "".join(chr(65 + j) for j in range(i - 2, -1, -1))
        lines.append(spaces + left + right)
    return "\n".join(lines)

assert "alphabet_palindrome_pyramid" in exec_globals, "Function alphabet_palindrome_pyramid not found"
fn = exec_globals["alphabet_palindrome_pyramid"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, 28]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (73,'73. Shifting Alphabet Window','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a right-angled triangle pattern of letters where each row starts with a progressively earlier letter of the alphabet. The grid must contain exactly n rows.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The first row begins with the n-th letter of the alphabet. Each subsequent row begins with the letter immediately preceding the previous row''s starting letter, and prints a sequence that runs forward up to the n-th letter of the alphabet. Characters within each row are separated by a single space. If n is less than or equal to 0 or greater than 26, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">E
D E
C D E
B C D E
A B C D E</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">C
B C
A B C</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Outputs only the baseline character ''A'')</code></li><li><code>n = 4 (Ensures row 1 starts with ''D'' and the final row spans from ''A'' to ''D'')</code></li><li><code>n = -2 (Invalid bounds safety check)</code></li>
</ul>','medium',200,'python-basics','def alphabet_window(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0 or n > 26: return ""
    lines = []
    for i in range(1, n + 1):
        row = [chr(65 + n - i + j) for j in range(i)]
        lines.append(" ".join(row))
    return "\n".join(lines)

assert "alphabet_window" in exec_globals, "Function alphabet_window not found"
fn = exec_globals["alphabet_window"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, 28]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (74,'74. Symmetrical Star Canopy (The Inverted Butterfly)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a symmetrical star canopy pattern that consists of two mirror-image halves meeting at a central horizontal axis.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The top half begins with a solid row of asterisks (*) and, row by row, splits open from the center to create a widening empty rectangular space flanked by shrinking outer wings of stars. The bottom half reverses this layout: it begins with a wide empty center gap flanked by thin outer star wings, which then narrow row by row until they close completely at a final solid baseline row of asterisks.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Every asterisk within the rows must be printed immediately adjacent to the next without spaces. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">**********
****  ****
***    ***
**      **
*        *
*        *
**      **
***    ***
****  ****
**********</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">****
*  *
*  *
****</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (The minimal 2x2 boundary layout printing a solid 2-star line on top and bottom)</code></li><li><code>n = 4 (Ensures that the thickest row contains exactly 8 asterisks with no interior gaps)</code></li><li><code>n = -3 (Graceful handling of negative constraints resulting in zero output)</code></li>
</ul>','hard',300,'python-basics','def inverted_butterfly(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        stars = "*" * (n - i + 1)
        spaces = " " * (2 * (i - 1))
        lines.append(stars + spaces + stars)
    for i in range(1, n + 1):
        stars = "*" * i
        spaces = " " * (2 * (n - i))
        lines.append(stars + spaces + stars)
    return "\n".join(lines)

assert "inverted_butterfly" in exec_globals, "Function inverted_butterfly not found"
fn = exec_globals["inverted_butterfly"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (75,'75. Symmetrical Star Bow (The Standard Butterfly)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a symmetrical star bow pattern. This pattern is the visual inverse of the canopy structure: the top half starts narrow at the outer margins with a wide empty center gap, and grows inward row by row until the stars meet in the middle to form a completely solid row of asterisks. The bottom half then mirrors this shape, splitting outward row by row from the center to finish with narrow star clusters on the outer edges.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">No spaces exist between adjacent asterisks. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*        *
**      **
***    ***
****  ****
**********
****  ****
***    ***
**      **
*        *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">*  *
****
*  *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Displays a single solid line ** instantly)</code></li><li><code>n = 4 (Verifying that the absolute middle row scales out to a maximum length of 8 solid stars)</code></li><li><code>n = -5 (Negative boundary dimension safety check)</code></li>
</ul>','hard',300,'python-basics','def butterfly(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    for i in range(1, n + 1):
        stars = "*" * i
        spaces = " " * (2 * (n - i))
        lines.append(stars + spaces + stars)
    for i in range(1, n):
        stars = "*" * (n - i)
        spaces = " " * (2 * i)
        lines.append(stars + spaces + stars)
    return "\n".join(lines)

assert "butterfly" in exec_globals, "Function butterfly not found"
fn = exec_globals["butterfly"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (76,'76. Hollow Star Box Frame','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a hollow box frame structure using asterisks (*). The frame consists of exactly n vertical layers. The first layer and the final layer form solid horizontal borders of asterisks. All middle structural layers contain exactly two asterisks positioned on the absolute left and right boundaries, separated by an empty internal space.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Each character within a row must be separated by a single space character to maintain a square proportions matrix. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">* * * *
*     *
*     *
* * * *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">* *
* *</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Prints only a single asterisk *)</code></li><li><code>n = 5 (Ensures the internal empty space rows scale perfectly across 3 interior layers)</code></li><li><code>n = -2 (Out-of-bounds input boundary check)</code></li>
</ul>','hard',300,'python-basics','def hollow_square(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    if n == 1: return "*"
    lines = []
    lines.append(" ".join(["*"] * n))
    for _ in range(n - 2):
        lines.append("*" + " " * (2 * n - 3) + "*")
    lines.append(" ".join(["*"] * n))
    return "\n".join(lines)

assert "hollow_square" in exec_globals, "Function hollow_square not found"
fn = exec_globals["hollow_square"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (77,'77. Concentric Number Grid','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print a concentric numerical square grid layout. The pattern is built out of nested square borders, where the absolute outermost border is composed entirely of the number n, the next inner border is composed of n - 1, and this pattern decrements inward layer by layer until it reaches the central cell, which contains the number 1.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The total dimensions of the grid will have an odd height and width equal to (2 * n) - 1 columns and rows. Every single number within a row must be separated by a single space character. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">4 4 4 4 4 4 4
4 3 3 3 3 3 4
4 3 2 2 2 3 4
4 3 2 1 2 3 4
4 3 2 2 2 3 4
4 3 3 3 3 3 4
4 4 4 4 4 4 4</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">2 2 2
2 1 2
2 2 2</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (The absolute baseline matrix displaying only the single core integer 1)</code></li><li><code>n = 3 (Ensures the grid spans exactly 5x5 dimensions and scales numbers downward towards the center)</code></li><li><code>n = -1 (Negative parameter check resulting in safe exit execution)</code></li>
</ul>','hard',300,'python-basics','def concentric_grid(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    size = 2 * n - 1
    lines = []
    for r in range(size):
        row = []
        for c in range(size):
            d = min(r, c, size - 1 - r, size - 1 - c)
            row.append(str(n - d))
        lines.append(" ".join(row))
    return "\n".join(lines)

assert "concentric_grid" in exec_globals, "Function concentric_grid not found"
fn = exec_globals["concentric_grid"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (78,'78. String Upper, Lower, Strip','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>clean_string(s)</code> that takes a string with possible leading/trailing whitespace and mixed case, and returns a tuple:
<code>(stripped, upper, lower, title_case)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use Python''s built-in string methods: <code>.strip()</code>, <code>.upper()</code>, <code>.lower()</code>, <code>.title()</code></p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "  hello world  "</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("hello world", "HELLO WORLD", "hello world", "Hello World")</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">.strip() removes spaces, .title() capitalizes each word</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "  PyTHON  "</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("PyTHON", "PYTHON", "python", "Python")</code></div>
  
</div>','easy',100,'python-advanced','def clean_string(s):
    # Return (stripped, upper, lower, title_case)
    pass','def ref_impl(*args):
    r=args[0].strip()
    return (r, r.upper(), r.lower(), r.title())

assert "clean_string" in exec_globals, "Function clean_string not found"
fn = exec_globals["clean_string"]
test_cases = ["  hello world  ", "  PyTHON  ", "TEST", "  a  b  "]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (79,'79. Split and Join','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>split_and_join(sentence)</code> that takes a sentence string, splits it into words, and then returns a tuple:
<code>(words_list, word_count, joined_with_dash)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use <code>.split()</code> which splits on whitespace by default, and <code>"-".join(lst)</code> to join with a dash separator.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "the quick brown fox"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(["the","quick","brown","fox"], 4, "the-quick-brown-fox")</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "hello world"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(["hello","world"], 2, "hello-world")</code></div>
  
</div>','easy',100,'python-advanced','def split_and_join(sentence):
    # Return (words_list, word_count, joined_with_dash)
    pass','def ref_impl(*args):
    words=args[0].split()
    return (words, len(words), "-".join(words))

assert "split_and_join" in exec_globals, "Function split_and_join not found"
fn = exec_globals["split_and_join"]
test_cases = ["the quick brown fox", "hello world", "single", "a b c d e"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (80,'80. Replace and Find','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>modify_string(s, old, new_val)</code> that returns a tuple:
<code>(replaced, first_index, count)</code></p>
<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Where:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>replaced</code> = the string with all occurrences of <code>old</code> replaced by <code>new_val</code></li>
  <li class="py-0.5"><code>first_index</code> = the index of first occurrence of <code>old</code> (-1 if not found)</li>
  <li class="py-0.5"><code>count</code> = how many times <code>old</code> appears</li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use <code>.replace()</code>, <code>.find()</code>, and <code>.count()</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s="hello world", old="l", new_val="L"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("heLLo worLd", 2, 3)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s="python", old="z", new_val="Z"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("python", -1, 0)</code></div>
  
</div>','easy',100,'python-advanced','def modify_string(s, old, new_val):
    # Return (replaced, first_index, count)
    pass','def ref_impl(*args):
    s,old,new=args[0],args[1],args[2]
    return (s.replace(old,new), s.find(old), s.count(old))

assert "modify_string" in exec_globals, "Function modify_string not found"
fn = exec_globals["modify_string"]
test_cases = [("hello world","l","L"), ("python","z","Z"), ("abcabc","a","X"), ("aaa","a","b")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (81,'81. Starts With & Ends With','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>check_affixes(s, prefix, suffix)</code> that returns a tuple:
<code>(starts_with_prefix, ends_with_suffix, both)</code> — all boolean values.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use Python''s <code>.startswith()</code> and <code>.endswith()</code> string methods.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s="Python Programming", prefix="Py", suffix="ing"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(True, True, True)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s="Hello World", prefix="Hi", suffix="World"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(False, True, False)</code></div>
  
</div>','easy',100,'python-advanced','def check_affixes(s, prefix, suffix):
    # Return (starts, ends, both) as booleans
    pass','def ref_impl(*args):
    s,p,su=args[0],args[1],args[2]
    st=s.startswith(p)
    en=s.endswith(su)
    return (st,en,st and en)

assert "check_affixes" in exec_globals, "Function check_affixes not found"
fn = exec_globals["check_affixes"]
test_cases = [("Python Programming","Py","ing"), ("Hello World","Hi","World"), ("abc","a","c"), ("abc","x","y")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (82,'82. isalpha, isdigit, isalnum','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>check_string_type(s)</code> that returns a tuple:
<code>(is_alpha, is_digit, is_alnum, is_space)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use the built-in string methods <code>.isalpha()</code>, <code>.isdigit()</code>, <code>.isalnum()</code>, <code>.isspace()</code>. Each returns True only if ALL characters in the string satisfy the condition.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Hello"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(True, False, True, False)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "12345"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(False, True, True, False)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Hello123"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(False, False, True, False)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>s is a non-empty string</code></li>
</ul>','easy',100,'python-advanced','def check_string_type(s):
    # Return (is_alpha, is_digit, is_alnum, is_space)
    pass','def ref_impl(*args):
    s=args[0]
    return (s.isalpha(), s.isdigit(), s.isalnum(), s.isspace())

assert "check_string_type" in exec_globals, "Function check_string_type not found"
fn = exec_globals["check_string_type"]
test_cases = ["Hello", "12345", "Hello123", "   ", "abc!"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (83,'83. Count Specific Characters','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>char_counts(s)</code> that takes a string and returns a tuple:
<code>(vowels, consonants, digits, spaces, specials)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Count each type of character in the string. Vowels are a,e,i,o,u (case-insensitive). Consonants are other letters. Specials are anything else that''s not a digit or space.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Hello World 2024!"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 7, 4, 1, 1)</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Vowels: e,o,o=3 | Consonants: H,l,l,W,r,l,d=7 | Digits: 2024=4 | Spaces: 1 | Specials: !=1</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "abc"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(1, 2, 0, 0, 0)</code></div>
  
</div>','easy',100,'python-advanced','def char_counts(s):
    # Return (vowels, consonants, digits, spaces, specials)
    pass','def ref_impl(*args):
    s=args[0]
    v=sum(1 for c in s if c.lower() in "aeiou")
    co=sum(1 for c in s if c.isalpha() and c.lower() not in "aeiou")
    d=sum(1 for c in s if c.isdigit())
    sp=sum(1 for c in s if c==" ")
    spec=sum(1 for c in s if not c.isalnum() and c!=" ")
    return (v,co,d,sp,spec)

assert "char_counts" in exec_globals, "Function char_counts not found"
fn = exec_globals["char_counts"]
test_cases = ["Hello World 2024!", "abc", "12 + 34", ""]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (84,'84. String Padding & Alignment','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>align_string(s, width)</code> that returns a tuple of the string aligned three ways within a field of the given <code>width</code>:
<code>(left_aligned, right_aligned, center_aligned)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use Python''s string methods <code>.ljust(width)</code>, <code>.rjust(width)</code>, <code>.center(width)</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s="hi", width=6</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("hi    ", "    hi", "  hi  ")</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s="abc", width=5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>("abc  ", "  abc", " abc ")</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>width is always >= len(s)</code></li>
</ul>','easy',100,'python-advanced','def align_string(s, width):
    # Return (left, right, center) aligned strings
    pass','def ref_impl(*args):
    s,w=args[0],args[1]
    return (s.ljust(w),s.rjust(w),s.center(w))

assert "align_string" in exec_globals, "Function align_string not found"
fn = exec_globals["align_string"]
test_cases = [("hi",6), ("abc",5), ("x",4), ("python",10)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (85,'85. Palindrome Using String Methods','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>is_palindrome_clean(s)</code> that checks if a string is a palindrome after cleaning it.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Cleaning steps (using string methods):
1. Convert to lowercase with <code>.lower()</code>
2. Keep only alphanumeric characters — iterate and use <code>.isalnum()</code>
3. Compare the cleaned string with its reverse (<code>[::-1]</code>)</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "A man, a plan, a canal: Panama"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "race a car"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Was it a car or a cat I saw?"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div>','easy',100,'python-advanced','def is_palindrome_clean(s):
    # Clean s and check if palindrome
    pass','def ref_impl(*args):
    s=args[0]
    clean="".join(c for c in s.lower() if c.isalnum())
    return clean==clean[::-1]

assert "is_palindrome_clean" in exec_globals, "Function is_palindrome_clean not found"
fn = exec_globals["is_palindrome_clean"]
test_cases = ["A man, a plan, a canal: Panama", "race a car", "Was it a car or a cat I saw?", "", "a"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (86,'86. Word Frequency','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>word_frequency(sentence)</code> that takes a sentence string, splits it into words (lowercased), and returns a dictionary mapping each unique word to its count.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This combines <code>.lower()</code>, <code>.split()</code>, and dictionary operations.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "the cat sat on the mat"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"the": 2, "cat": 1, "sat": 1, "on": 1, "mat": 1}</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "hello hello world"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"hello": 2, "world": 1}</code></div>
  
</div>','easy',100,'python-advanced','def word_frequency(sentence):
    # Return dict of word: count
    pass','def ref_impl(*args):
    words=args[0].lower().split()
    freq={}
    for w in words:
        freq[w]=freq.get(w,0)+1
    return freq

assert "word_frequency" in exec_globals, "Function word_frequency not found"
fn = exec_globals["word_frequency"]
test_cases = ["the cat sat on the mat", "hello hello world", "a a a", "one"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (87,'87. Format a Report Line','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>format_report(name, score, rank)</code> that returns a neatly formatted report line using an f-string:</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans"><code>f"Rank {rank:02d} | {name:<15} | Score: {score:06.2f}"</code></p>
<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Format specifiers:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>:02d</code> → integer with leading zeros (min width 2)</li>
  <li class="py-0.5"><code>:<15</code> → left-align with width 15</li>
  <li class="py-0.5"><code>:06.2f</code> → float with 2 decimal places, min width 6, leading zeros</li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>name="Alice", score=95.5, rank=1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Rank 01 | Alice           | Score: 095.50"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>name="Bob", score=7.3, rank=10</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Rank 10 | Bob             | Score: 007.30"</code></div>
  
</div>','easy',100,'python-advanced','def format_report(name, score, rank):
    # Return the formatted report line
    pass','def ref_impl(*args):
    n,sc,rk=args[0],args[1],args[2]
    return f"Rank {rk:02d} | {n:<15} | Score: {sc:06.2f}"

assert "format_report" in exec_globals, "Function format_report not found"
fn = exec_globals["format_report"]
test_cases = [("Alice",95.5,1), ("Bob",7.3,10), ("Charlie",100.0,3)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (88,'88. Check if a String is a Palindrome','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, determine whether it reads the exact same forward as it does backward. The verification must be completely case-insensitive.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Only alphanumeric characters (letters and numbers) should be evaluated. All whitespace characters, punctuation marks, and special structural symbols must be completely ignored. An empty string or a string consisting entirely of skipped characters satisfies this condition by default.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "A man, a plan, a canal: Panama"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "race a car"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = " "</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "ab_a"</code></li><li><code>Expected Output: True</code></li><li><code>Input: s = "0P"</code></li><li><code>Expected Output: False</code></li><li><code>Input: s = "a"</code></li><li><code>Expected Output: True</code></li><li><code>Input: s = ".,."</code></li><li><code>Expected Output: True</code></li><li><code>Input: s = ""</code></li><li><code>Expected Output: True</code></li>
</ul>','easy',100,'python-advanced','def is_palindrome(s):
    pass','def ref_impl(*args):
    import re
    clean=re.sub(r"[^a-zA-Z0-9]","",args[0]).lower()
    return clean==clean[::-1]

assert "is_palindrome" in exec_globals, "Function is_palindrome not found"
fn = exec_globals["is_palindrome"]
test_cases = ["A man, a plan, a canal: Panama", "race a car", ""]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (89,'89. Count Vowels, Consonants, and Digits','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, analyze its content and find the total count of vowels, consonants, and numeric digits present. Return the calculated values as a tuple format: (vowel_count, consonant_count, digit_count).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Vowels: The English letters ''a'', ''e'', ''i'', ''o'', ''u'' (in both uppercase and lowercase forms).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Consonants: Any other English alphabet letter that is not a vowel.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Digits: Any numerical character ranging from ''0'' to ''9''.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Any white spaces, punctuation marks, or special characters present in the string must be completely ignored and excluded from all three counts.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "Hello World 2026!"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 7, 4)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "xyz"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 3, 0)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = ""</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 0, 0)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "AEIOUaeiou"</code></li><li><code>Expected Output: (10, 0, 0)</code></li><li><code>Input: s = "1234567890"</code></li><li><code>Expected Output: (0, 0, 10)</code></li><li><code>Input: s = "!!!   !!!"</code></li><li><code>Expected Output: (0, 0, 0)</code></li><li><code>Input: s = "bcdfghjklmnpqrstvwxyz"</code></li><li><code>Expected Output: (0, 21, 0)</code></li><li><code>Input: s = ""</code></li><li><code>Expected Output: (0, 0, 0)</code></li>
</ul>','easy',100,'python-advanced','def count_vowels_consonants_digits(s):
    pass','def ref_impl(*args):
    v=sum(1 for c in args[0] if c.lower() in "aeiou")
    c=sum(1 for c in args[0] if c.isalpha() and c.lower() not in "aeiou")
    d=sum(1 for c in args[0] if c.isdigit())
    return (v,c,d)

assert "count_vowels_consonants_digits" in exec_globals, "Function count_vowels_consonants_digits not found"
fn = exec_globals["count_vowels_consonants_digits"]
test_cases = ["Hello World 2026!", "xyz", ""]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (90,'90. Find the First Non-Repeating Character','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, scan through the text and identify the very first character that appears exactly once throughout the entire string.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return the 0-based index position of this unique character. If every single character in the string repeats at least once elsewhere, or if the string is completely empty, return -1.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "leetcode"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "loveleetcode"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "aabb"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "a"</code></li><li><code>Expected Output: 0</code></li><li><code>Input: s = "abcdeabcde"</code></li><li><code>Expected Output: -1</code></li><li><code>Input: s = "abcdefg"</code></li><li><code>Expected Output: 0</code></li><li><code>Input: s = "ccca"</code></li><li><code>Expected Output: 3</code></li><li><code>Input: s = ""</code></li><li><code>Expected Output: -1</code></li>
</ul>','easy',100,'python-advanced','def first_uniq_char(s):
    pass','def ref_impl(*args):
    s=args[0]
    for idx,char in enumerate(s):
        if s.count(char)==1:
            return idx
    return -1

assert "first_uniq_char" in exec_globals, "Function first_uniq_char not found"
fn = exec_globals["first_uniq_char"]
test_cases = ["leetcode", "loveleetcode", "aabb", "a"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (92,'92. Check if Two Strings are Anagrams','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two strings, s and t, determine whether t is an anagram of s.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">An anagram is defined as a word or phrase formed by rearranging the exact letters of a different word or phrase, using all the original letters exactly once. The evaluation must check for an absolute matching frequency of every single character character-for-character. If the strings have different lengths, they cannot be anagrams.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "anagram", t = "nagaram"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "rat", t = "car"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "", t = ""</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "a", t = "ab"</code></li><li><code>Expected Output: False</code></li><li><code>Input: s = "aa", t = "a"</code></li><li><code>Expected Output: False</code></li><li><code>Input: s = "ab", t = "ba"</code></li><li><code>Expected Output: True</code></li><li><code>Input: s = "aabc", t = "abca"</code></li><li><code>Expected Output: True</code></li><li><code>Input: s = "", t = ""</code></li><li><code>Expected Output: True</code></li>
</ul>','easy',100,'python-advanced','def is_anagram(s, t):
    pass','def ref_impl(*args):
    return sorted(args[0])==sorted(args[1])

assert "is_anagram" in exec_globals, "Function is_anagram not found"
fn = exec_globals["is_anagram"]
test_cases = [("anagram","nagaram"), ("rat","car")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (93,'93. Valid Palindrome II','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, return True if the string can be a palindrome after deleting at most one character from it.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A palindrome is a string that reads the same forward and backward. You can choose to delete zero characters or exactly one character from any position in the string to satisfy the condition.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "aba"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "abca"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">You can delete the character ''c'' to get "aba", or ''b'' to get "aca"</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "abc"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "deeee"</code></li><li><code>Expected Output: True (Deleting the first character ''d'' yields "eeee")</code></li><li><code>Input: s = "abcdefba"</code></li><li><code>Expected Output: False (Requires deleting more than one character to form a palindrome)</code></li><li><code>Input: s = "aguokkgauktcjmdwwdonecahexwjjotfsocipyzhwqvhuabcitjbmuzhrrznaswwmjjumszumbjticaubhqvwhzyipcosftojjwxehacenodwwdmjctkuagukkouga"</code></li><li><code>Expected Output: True (Testing a long string with a single mismatch deep inside the structure)</code></li><li><code>Input: s = "a"</code></li><li><code>Expected Output: True</code></li>
</ul>','easy',100,'python-advanced','def valid_palindrome_ii(s):
    pass','def ref_impl(*args):
    s=args[0]
    left,right=0,len(s)-1
    while left<right:
        if s[left]!=s[right]:
            s1,s2=s[left:right],s[left+1:right+1]
            return s1==s1[::-1] or s2==s2[::-1]
        left,right=left+1,right-1
    return True

assert "valid_palindrome_ii" in exec_globals, "Function valid_palindrome_ii not found"
fn = exec_globals["valid_palindrome_ii"]
test_cases = ["aba", "abca", "abc"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (94,'94. String Compression (Run-Length Encoding)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an array of characters chars, compress it using a run-length encoding algorithm.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">For each group of consecutive repeating characters:</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If the group length is 1, append the character to the result.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Otherwise, append the character followed by the group''s length.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The compression must be done in-place, modifying the input array directly. The new length of the compressed array must be returned. The structural digits of any count greater than or equal to 10 must be split into single individual string characters (e.g., a count of 12 becomes "1", then "2").</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>chars = ["a","a","b","b","c","c","c"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>6</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The input array becomes ["a","2","b","2","c","3"]</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>chars = ["a"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The input array becomes ["a"]</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>chars = ["a","b","b","b","b","b","b","b","b","b","b","b","b"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>4</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The input array becomes ["a","b","1","2"]</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: chars = ["a","a","a","a","a","a","a","a","a","a"]</code></li><li><code>Expected Output: 3 (Modifies to ["a","1","0"])</code></li><li><code>Input: chars = ["a","b","c"]</code></li><li><code>Expected Output: 3 (Modifies to ["a","b","c"] since no repetitions occur)</code></li><li><code>Input: chars = []</code></li><li><code>Expected Output: 0</code></li>
</ul>','medium',200,'python-advanced','def compress(chars):
    pass','assert "compress" in exec_globals, "Function compress not found"
fn = exec_globals["compress"]
tc1 = ["a","a","b","b","c","c","c"]
k1 = fn(tc1)
assert k1 == 6 and tc1[:6] == ["a","2","b","2","c","3"], f"Failed tc1: got {k1}, {tc1}"
tc2 = ["a"]
k2 = fn(tc2)
assert k2 == 1 and tc2[:1] == ["a"], f"Failed tc2: got {k2}, {tc2}"
tc3 = ["a","b","b","b","b","b","b","b","b","b","b","b","b"]
k3 = fn(tc3)
assert k3 == 4 and tc3[:4] == ["a","b","1","2"], f"Failed tc3: got {k3}, {tc3}"
exec_globals["passed_cases"] = 3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (95,'95. Reverse Words in a String','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an input string s, reverse the order of the words.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A word is defined as a sequence of non-space characters. The words in s will be separated by at least one space. Return a string of the words in reverse order concatenated by a single space.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Constraint Requirements: The input string s may contain leading spaces, trailing spaces, or multiple spaces between two words. The returned string must not contain leading or trailing spaces, and words must be separated by exactly one single space.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "the sky is blue"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"blue is sky the"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "  hello world  "</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"world hello"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "a good   example"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"example good a"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "  Bob    Loves  Alice  "</code></li><li><code>Expected Output: "Alice Loves Bob"</code></li><li><code>Input: s = "Alice"</code></li><li><code>Expected Output: "Alice"</code></li><li><code>Input: s = "   "</code></li><li><code>Expected Output: ""</code></li>
</ul>','easy',100,'python-advanced','def reverse_words(s):
    pass','def ref_impl(*args):
    return " ".join(args[0].split()[::-1])

assert "reverse_words" in exec_globals, "Function reverse_words not found"
fn = exec_globals["reverse_words"]
test_cases = ["the sky is blue", "  hello world  ", "a good   example"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (96,'96. Longest Palindromic Substring','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, find and return the longest contiguous substring within s that forms a valid palindrome.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A substring is a contiguous sequence of characters within a string. If multiple palindromic substrings share the maximum length, returning any one of them is acceptable.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "babad"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"bab"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Note: "aba" is also a completely valid answer</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "cbbd"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"bb"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "a"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"a"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "aacabdkacaa"</code></li><li><code>Expected Output: "aca"</code></li><li><code>Input: s = "bb"</code></li><li><code>Expected Output: "bb"</code></li><li><code>Input: s = "abcdefg"</code></li><li><code>Expected Output: "a" (When no larger matches exist, any single character satisfies the base length 1)</code></li><li><code>Input: s = ""</code></li><li><code>Expected Output: ""</code></li>
</ul>','medium',200,'python-advanced','def longest_palindrome(s):
    pass','def ref_impl(*args):
    s=args[0]
    if not s: return ""
    res=""
    for i in range(len(s)):
        l,r=i,i
        while l>=0 and r<len(s) and s[l]==s[r]:
            if (r-l+1)>len(res): res=s[l:r+1]
            l-=1;r+=1
        l,r=i,i+1
        while l>=0 and r<len(s) and s[l]==s[r]:
            if (r-l+1)>len(res): res=s[l:r+1]
            l-=1;r+=1
    return res

assert "longest_palindrome" in exec_globals, "Function longest_palindrome not found"
fn = exec_globals["longest_palindrome"]
test_cases = ["babad", "cbbd", "a"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (97,'97. Is Subsequence','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two strings s and t, determine if s is a subsequence of t.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A subsequence of a string is a new string that is formed from the original string by deleting some (can be none) of the characters without disturbing the relative positions of the remaining characters. (e.g., "ace" is a subsequence of "abcde" while "aec" is not). Return True if conditions match, otherwise False.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "abc", t = "ahbgdc"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "axc", t = "ahbgdc"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "", t = "ahbgdc"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "abc", t = "abc"</code></li><li><code>Expected Output: True</code></li><li><code>Input: s = "b", t = "c"</code></li><li><code>Expected Output: False</code></li><li><code>Input: s = "aaaaaa", t = "bbaaaa"</code></li><li><code>Expected Output: False (Mismatched absolute letter counts)</code></li><li><code>Input: s = "", t = ""</code></li><li><code>Expected Output: True</code></li>
</ul>','easy',100,'python-advanced','def is_subsequence(s, t):
    pass','def ref_impl(*args):
    s,t=args[0],args[1]
    i,j=0,0
    while i<len(s) and j<len(t):
        if s[i]==t[j]: i+=1
        j+=1
    return i==len(s)

assert "is_subsequence" in exec_globals, "Function is_subsequence not found"
fn = exec_globals["is_subsequence"]
test_cases = [("abc","ahbgdc"), ("axc","ahbgdc")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (99,'99. Longest Substring Without Repeating Characters','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a string s, find the length of the longest contiguous substring that contains entirely unique characters (no character appears more than once within that substring span).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "abcabcbb"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>3</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The longest unique substring is "abc"</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "bbbbb"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The longest unique substring is "b"</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "pwwkew"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>3</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The longest unique substring is "wke"</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = " "</code></li><li><code>Expected Output: 1 (A single space character is a valid unique character)</code></li><li><code>Input: s = "dvdf"</code></li><li><code>Expected Output: 3 (The substring "vdf" is the longest unique segment)</code></li><li><code>Input: s = ""</code></li><li><code>Expected Output: 0</code></li>
</ul>','medium',200,'python-advanced','def length_of_longest_substring(s):
    pass','def ref_impl(*args):
    s=args[0]
    used={}
    start=0
    max_len=0
    for i,c in enumerate(s):
        if c in used and start<=used[c]:
            start=used[c]+1
        else:
            max_len=max(max_len,i-start+1)
        used[c]=i
    return max_len

assert "length_of_longest_substring" in exec_globals, "Function length_of_longest_substring not found"
fn = exec_globals["length_of_longest_substring"]
test_cases = ["abcabcbb", "bbbbb", "pwwkew"]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (101,'101. Find All Anagrams in a String','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two strings s and p, return an array of all the start indices of p''s anagrams inside s. You may return the answer list in any sorting order.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, using all the original letters exactly once. This means you are looking for substrings in s that match the length and exact character frequencies of p.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "cbaebabacd", p = "abc"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 6]</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The anagram matches start at index 0 ["cba"] and index 6 ["bac"]</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>s = "abab", p = "ab"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 1, 2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: s = "aaaaaaaaaa", p = "aaaaaaaa"</code></li><li><code>Expected Output: [0, 1, 2]</code></li><li><code>Input: s = "af", p = "be"</code></li><li><code>Expected Output: []</code></li><li><code>Input: s = "", p = "a"</code></li><li><code>Expected Output: []</code></li>
</ul>','medium',200,'python-advanced','def find_anagrams(s, p):
    pass','def ref_impl(*args):
    s,p=args[0],args[1]
    from collections import Counter
    res=[]
    ns,np=len(s),len(p)
    if ns<np: return []
    pc=Counter(p)
    sc=Counter()
    for i in range(ns):
        sc[s[i]]+=1
        if i>=np:
            if sc[s[i-np]]==1:
                del sc[s[i-np]]
            else:
                sc[s[i-np]]-=1
        if pc==sc:
            res.append(i-np+1)
    return res

assert "find_anagrams" in exec_globals, "Function find_anagrams not found"
fn = exec_globals["find_anagrams"]
test_cases = [("cbaebabacd","abc"), ("abab","ab")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (105,'105. Longest Common Prefix','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function to find the longest common prefix string amongst an array of strings strs.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A prefix is a collection of characters at the absolute beginning of a string. If no common prefix exists across all strings in the array, return an empty string "".</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>strs = ["flower","flow","flight"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"fl"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>strs = ["dog","racecar","car"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>""</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>strs = ["a"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"a"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>Input: strs = ["","b"]</code></li><li><code>Expected Output: "" (An empty string in the input array immediately nullifies any prefix)</code></li><li><code>Input: strs = ["ab", "a"]</code></li><li><code>Expected Output: "a"</code></li><li><code>Input: strs = ["cir", "car"]</code></li><li><code>Expected Output: "c"</code></li><li><code>Input: strs = []</code></li><li><code>Expected Output: ""</code></li>
</ul>','easy',100,'python-advanced','def longest_common_prefix(strs):
    pass','def ref_impl(*args):
    strs=args[0]
    if not strs: return ""
    prefix=strs[0]
    for s in strs[1:]:
        while not s.startswith(prefix):
            prefix=prefix[:-1]
            if not prefix: return ""
    return prefix

assert "longest_common_prefix" in exec_globals, "Function longest_common_prefix not found"
fn = exec_globals["longest_common_prefix"]
test_cases = [["flower","flow","flight"], ["dog","racecar","car"], [], ["abc"]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (106,'106. List Methods — Append, Pop, Insert','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>list_operations(nums)</code> that takes a list and performs these operations in sequence, returning the final list:
1. Append 100 to the end
2. Insert 0 at position 0 (front)
3. Pop the last element
4. Return the modified list</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 1, 2, 3]</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">append 100 → [1,2,3,100], insert 0 at front → [0,1,2,3,100], pop → [0,1,2,3]</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 5]</code></div>
  
</div>','easy',100,'python-advanced','def list_operations(nums):
    # Modify the list in-place, return it
    pass','def ref_impl(*args):
    lst=list(args[0])
    lst.append(100)
    lst.insert(0,0)
    lst.pop()
    return lst

assert "list_operations" in exec_globals, "Function list_operations not found"
fn = exec_globals["list_operations"]
test_cases = [[1,2,3], [5], [], [10,20]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (107,'107. List Slicing','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>slice_list(lst)</code> that returns a tuple of 5 different slices:
<code>(first_three, last_three, every_second, reversed_list, middle)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Where middle = everything except the first and last element. If the list has fewer than 3 elements, return empty list for those slices.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [0,1,2,3,4,5,6,7,8,9]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([0,1,2], [7,8,9], [0,2,4,6,8], [9,8,7,6,5,4,3,2,1,0], [1,2,3,4,5,6,7,8])</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [1,2,3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([1,2,3], [1,2,3], [1,3], [3,2,1], [2])</code></div>
  
</div>','easy',100,'python-advanced','def slice_list(lst):
    # Return tuple of 5 slices
    pass','def ref_impl(*args):
    l=args[0]
    return (l[:3],l[-3:],l[::2],l[::-1],l[1:-1])

assert "slice_list" in exec_globals, "Function slice_list not found"
fn = exec_globals["slice_list"]
test_cases = [[0,1,2,3,4,5,6,7,8,9], [1,2,3], [10,20,30,40,50]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (108,'108. Sorting Lists','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>sort_info(lst)</code> that returns a tuple:
<code>(sorted_asc, sorted_desc, min_val, max_val, sum_val)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use <code>sorted()</code> (which returns a new list), not <code>.sort()</code> (which modifies in-place). Use built-in <code>min()</code>, <code>max()</code>, <code>sum()</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [3,1,4,1,5,9,2,6]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([1,1,2,3,4,5,6,9], [9,6,5,4,3,2,1,1], 1, 9, 31)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([5], [5], 5, 5, 5)</code></div>
  
</div>','easy',100,'python-advanced','def sort_info(lst):
    # Return (sorted_asc, sorted_desc, min, max, sum)
    pass','def ref_impl(*args):
    l=args[0]
    return (sorted(l),sorted(l,reverse=True),min(l),max(l),sum(l))

assert "sort_info" in exec_globals, "Function sort_info not found"
fn = exec_globals["sort_info"]
test_cases = [[3,1,4,1,5,9,2,6], [5], [-3,0,3], [100,-100,0]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (109,'109. List Comprehension Basics','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>comprehension_ops(nums)</code> that returns a tuple of four new lists created using list comprehensions:</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">1. Squares of all numbers: <code>[x**2 for x in nums]</code>
2. Only even numbers: <code>[x for x in nums if x%2==0]</code>
3. Absolute values: <code>[abs(x) for x in nums]</code>
4. Strings of numbers: <code>[str(x) for x in nums]</code></p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1,-2,3,-4,5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([1,4,9,16,25], [-2,-4], [1,2,3,4,5], ["1","-2","3","-4","5"])</code></div>
  
</div>','easy',100,'python-advanced','def comprehension_ops(nums):
    # Return tuple of 4 lists using comprehensions
    pass','def ref_impl(*args):
    n=args[0]
    return ([x**2 for x in n],[x for x in n if x%2==0],[abs(x) for x in n],[str(x) for x in n])

assert "comprehension_ops" in exec_globals, "Function comprehension_ops not found"
fn = exec_globals["comprehension_ops"]
test_cases = [[1,-2,3,-4,5], [0,2,4,6], [-1,-2,-3], []]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (110,'110. 2D Lists (Matrix Basics)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>matrix_info(matrix)</code> that takes a 2D list (list of lists) and returns a tuple:
<code>(rows, cols, flat, transposed)</code></p>
<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Where:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>rows</code> = number of rows</li>
  <li class="py-0.5"><code>cols</code> = number of columns in row 0</li>
  <li class="py-0.5"><code>flat</code> = all elements in one list (flattened)</li>
  <li class="py-0.5"><code>transposed</code> = the matrix transposed (rows become columns)</li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1,2,3],[4,5,6]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(2, 3, [1,2,3,4,5,6], [[1,4],[2,5],[3,6]])</code></div>
  
</div>','easy',100,'python-advanced','def matrix_info(matrix):
    # Return (rows, cols, flat, transposed)
    pass','def ref_impl(*args):
    m=args[0]
    r=len(m)
    c=len(m[0]) if m else 0
    flat=[x for row in m for x in row]
    trans=[[m[i][j] for i in range(r)] for j in range(c)]
    return (r,c,flat,trans)

assert "matrix_info" in exec_globals, "Function matrix_info not found"
fn = exec_globals["matrix_info"]
test_cases = [[[1,2,3],[4,5,6]], [[1,2],[3,4],[5,6]], [[1]]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (111,'111. zip and enumerate','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>zip_and_enumerate(names, scores)</code> that:
1. Creates a list of <code>(index, name, score)</code> tuples using <code>enumerate</code> and <code>zip</code>
2. Returns the tuple list sorted by score descending</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This teaches two of Python''s most useful built-in functions for iterating over sequences.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>names=["Alice","Bob","Carol"], scores=[85,92,78]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[(1,"Bob",92),(0,"Alice",85),(2,"Carol",78)]</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Sorted by score descending</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>Both lists have the same length</code></li>
</ul>','easy',100,'python-advanced','def zip_and_enumerate(names, scores):
    # Return list of (idx, name, score) sorted by score descending
    pass','def ref_impl(*args):
    names,scores=args[0],args[1]
    result=[(i,n,s) for i,(n,s) in enumerate(zip(names,scores))]
    return sorted(result,key=lambda x:x[2],reverse=True)

assert "zip_and_enumerate" in exec_globals, "Function zip_and_enumerate not found"
fn = exec_globals["zip_and_enumerate"]
test_cases = [(["Alice","Bob","Carol"],[85,92,78]), (["X","Y"],[1,2])]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (112,'112. Remove Duplicates & Keep Order','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>unique_ordered(lst)</code> that removes duplicate elements from a list while maintaining the original order of first occurrences.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">For example: <code>[3,1,2,1,3]</code> → <code>[3,1,2]</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Hint: Use a set to track seen elements and a list comprehension.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [3,1,2,1,3,4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[3,1,2,4]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [1,1,1,2]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1,2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[]</code></div>
  
</div>','easy',100,'python-advanced','def unique_ordered(lst):
    # Remove duplicates preserving order
    pass','def ref_impl(*args):
    seen=set()
    res=[]
    for x in args[0]:
        if x not in seen:
            seen.add(x)
            res.append(x)
    return res

assert "unique_ordered" in exec_globals, "Function unique_ordered not found"
fn = exec_globals["unique_ordered"]
test_cases = [[3,1,2,1,3,4], [1,1,1,2], [], [5,4,3,2,1], [1,2,1,2]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (113,'113. Flatten Nested List','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>flatten(nested)</code> that takes a list that may contain integers or other lists (one level of nesting), and returns a single flat list with all integers.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">For example: <code>[[1,2],[3,[4]],5]</code> → <code>[1,2,3,4,5]</code> — only one level of nesting is guaranteed.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nested = [[1,2],[3,4],[5]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1,2,3,4,5]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nested = [1,[2,3],4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1,2,3,4]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nested = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>At most one level of nesting</code></li>
</ul>','medium',200,'python-advanced','def flatten(nested):
    # Flatten one level of nesting
    pass','def ref_impl(*args):
    result=[]
    for item in args[0]:
        if isinstance(item,list):
            result.extend(item)
        else:
            result.append(item)
    return result

assert "flatten" in exec_globals, "Function flatten not found"
fn = exec_globals["flatten"]
test_cases = [[[1,2],[3,4],[5]], [1,[2,3],4], [], [[1],[2],[3]], [1,2,3]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (114,'114. Find Maximum and Minimum Element in a List','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, find and return both the maximum element and the minimum element present in the list. Return the result as a tuple: (maximum, minimum).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If the input list is completely empty, there are no elements to evaluate; in this case, return (None, None).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [3, 5, 1, 9, -2, 7]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(9, -2)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [42]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(42, 42)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(None, None)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [7] (Single-element list where maximum must equal minimum)</code></li><li><code>nums = [5, 5, 5, 5] (A list where all elements are identical values)</code></li><li><code>nums = [-10, -20, -3, -50] (A list containing exclusively negative integers)</code></li><li><code>nums = [] (An empty list)</code></li>
</ul>','easy',100,'python-advanced','def find_max_min(nums):
    pass','def ref_impl(*args):
    return (max(args[0]),min(args[0])) if args[0] else (None,None)

assert "find_max_min" in exec_globals, "Function find_max_min not found"
fn = exec_globals["find_max_min"]
test_cases = [[3,5,1,9,-2,7], [42], [], [5,5,5], [-10,-20,-3]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (115,'115. Find the Second Largest and Second Smallest Element','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an unsorted list of integers nums, find and return the second largest and the second smallest unique elements in the list. Return the result as a tuple: (second_largest, second_smallest).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If a unique second largest element does not exist (due to insufficient unique numbers), its value should be returned as None. Similarly, if a unique second smallest element does not exist, its value should be returned as None. If the input list is empty, return (None, None).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [12, 35, 1, 10, 34, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(34, 10)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [10, 10, 10]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(None, None)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(None, None)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [10, 20, 20, 5, 5] (Duplicate maximum and duplicate minimum values present)</code></li><li><code>nums = [8, 8] (A list containing fewer than two unique elements)</code></li><li><code>nums = [-5, -1, -10, 0] (A list containing a mix of negative values and zero)</code></li><li><code>nums = [] (An empty list)</code></li>
</ul>','easy',100,'python-advanced','def find_second_largest_smallest(nums):
    pass','def ref_impl(*args):
    nums=list(set(args[0]))
    if len(nums)<2: return (None,None)
    nums.sort()
    return (nums[-2],nums[1])

assert "find_second_largest_smallest" in exec_globals, "Function find_second_largest_smallest not found"
fn = exec_globals["find_second_largest_smallest"]
test_cases = [[3,5,1,9,-2,7], [42], [], [5,5,5], [1,2]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (116,'116. Count Even and Odd Numbers in a List','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, determine the total count of even integers and the total count of odd integers present in the list. Return the result as a tuple format: (even_count, odd_count).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">An integer is considered even if it is perfectly divisible by 2, and odd if it leaves a remainder. Negative numbers must be categorized accurately based on this rule. If the input list is completely empty, return (0, 0).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 7, 11, 44, 8, 9]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 3)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [0, -2, -4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 0)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 0)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [0] (A list containing only the number zero, which is mathematically even)</code></li><li><code>nums = [-3, -5, -6, -8] (A list containing negative odd and negative even integers)</code></li><li><code>nums = [] (An empty list)</code></li>
</ul>','easy',100,'python-advanced','def count_even_odd(nums):
    pass','def ref_impl(*args):
    evens=sum(1 for x in args[0] if x%2==0)
    odds=len(args[0])-evens
    return (evens,odds)

assert "count_even_odd" in exec_globals, "Function count_even_odd not found"
fn = exec_globals["count_even_odd"]
test_cases = [[1,2,3,4,5], [], [2,4,6]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (117,'117. Check if a List is Sorted (Ascending or Descending)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of numbers nums, check whether the list is completely sorted in non-decreasing (ascending) order OR completely sorted in non-increasing (descending) order.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return True if the list satisfies either sorting condition from start to finish. Return False if the elements fluctuate up and down. By definition, an empty list or a list containing a single element has no out-of-order pairs and must return True.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 2, 5, 7]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [4, 7, 2, 9]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>False</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [] (An empty list)</code></li><li><code>nums = [9] (A single-element list)</code></li><li><code>nums = [3, 3, 3, 3] (A list containing all identical elements)</code></li><li><code>nums = [20, 15, 10, 5] (A strictly descending list)</code></li>
</ul>','easy',100,'python-advanced','def is_sorted(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    if len(nums)<=1: return True
    asc=all(nums[i]<=nums[i+1] for i in range(len(nums)-1))
    desc=all(nums[i]>=nums[i+1] for i in range(len(nums)-1))
    return asc or desc

assert "is_sorted" in exec_globals, "Function is_sorted not found"
fn = exec_globals["is_sorted"]
test_cases = [[1,2,3,5], [5,4,3,1], [1,3,2], [], [5]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (118,'118. Reverse a List In-Place','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list nums, reverse the order of its elements. You must perform this operation in-place by mutating the input list directly. Your function should modify the original object and not return a new copy. If the list is empty or contains only one element, it remains unchanged.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3, 4, 5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [5, 4, 3, 2, 1]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = ["A", "B"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes ["B", "A"]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes []</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2, 3] (An odd-length list where the middle element stays in position)</code></li><li><code>nums = [10, 20, 30, 40] (An even-length list where all elements change positions)</code></li><li><code>nums = [] or [5] (Empty or single-element boundary conditions)</code></li>
</ul>','easy',100,'python-advanced','def reverse_list(nums):
    pass','assert "reverse_list" in exec_globals
fn=exec_globals["reverse_list"]
a1=[1,2,3]; fn(a1); assert a1==[3,2,1], f"Got {a1}"
a2=[]; fn(a2); assert a2==[], f"Got {a2}"
a3=[5]; fn(a3); assert a3==[5], f"Got {a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (119,'119. Sum and Average of Elements in a List','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of numbers nums, calculate the total sum of all elements and their arithmetic average (mean). Return the result as a tuple: (total_sum, average).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If the input list is completely empty, it has no mathematical sum or length; in this scenario, return (0, 0.0) to safeguard against division errors.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(10, 2.5)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-5, 5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 0.0)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 0.0)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [] (An empty list)</code></li><li><code>nums = [-2, -4, -6] (A list containing exclusively negative integers)</code></li><li><code>nums = [0.1, 0.2, 0.3] (A list containing floating-point decimal numbers)</code></li>
</ul>','easy',100,'python-advanced','def sum_average(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    if not nums: return (0,0.0)
    s=sum(nums)
    return (s,s/len(nums))

assert "sum_average" in exec_globals, "Function sum_average not found"
fn = exec_globals["sum_average"]
test_cases = [[1,2,3,4], [], [5]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (120,'120. Move All Zeroes to the End of the List (In-Place)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, move all 0s to the end of it while maintaining the relative order of the non-zero elements.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">In-Place: You must modify the input list directly by shifting elements within its existing memory. You are not allowed to create a copy of the list or allocate an auxiliary list.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Relative Order: The non-zero numbers must remain in the exact same sequence relative to one another after the zeroes are moved. For example, if 1 appeared before 3 originally, 1 must still appear before 3 in the final modified list.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If the list is empty or contains no zeroes, it remains unchanged.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [0, 1, 0, 3, 12]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1, 3, 12, 0, 0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [0]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [4, 5, 6]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [4, 5, 6]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [] (An empty list)</code></li><li><code>nums = [0, 0, 0] (A list containing exclusively zeroes)</code></li><li><code>nums = [1, 2, 3, 0] (Zero is already at the correct terminal position)</code></li><li><code>nums = [0, 0, 9] (Multiple consecutive zeroes at the very front of the list)</code></li>
</ul>','easy',100,'python-advanced','def move_zeroes(nums):
    pass','assert "move_zeroes" in exec_globals
fn=exec_globals["move_zeroes"]
a1=[0,1,0,3,12]; fn(a1); assert a1==[1,3,12,0,0], f"Got {a1}"
a2=[0]; fn(a2); assert a2==[0], f"Got {a2}"
a3=[1,2,3]; fn(a3); assert a3==[1,2,3], f"Got {a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (121,'121. Remove Duplicates from a Sorted List (In-Place)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list nums sorted in non-decreasing (ascending) order, remove the duplicate elements in-place such that each unique element appears only once. The relative order of the unique elements must be kept identical.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Since the final length of the unique elements will be smaller than or equal to the original list size, your function must return an integer k, representing the number of unique elements. The first k slots of the modified nums list must hold these unique elements. The values stored beyond the first k elements do not matter.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If the list is empty, return 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 1, 2]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>Return value = 2, nums becomes [1, 2, _]</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">where _ represents any don''t-care value</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>Return value = 5, nums becomes [0, 1, 2, 3, 4, _, _, _, _, _]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>Return value = 0, nums becomes []</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2, 3, 4] (A sorted list that contains zero duplicates initially)</code></li><li><code>nums = [5, 5, 5, 5] (A list where every single element is a duplicate of the first)</code></li><li><code>nums = [-3, -3, -1, 0, 0, 2] (Handling negative integers and zero across duplicates)</code></li>
</ul>','easy',100,'python-advanced','def remove_duplicates(nums):
    pass','assert "remove_duplicates" in exec_globals
fn=exec_globals["remove_duplicates"]
a1=[1,1,2]; k1=fn(a1); assert k1==2 and a1[:2]==[1,2], f"Got {k1},{a1}"
a2=[]; k2=fn(a2); assert k2==0, f"Got {k2}"
a3=[1,2,3]; k3=fn(a3); assert k3==3 and a3[:3]==[1,2,3], f"Got {k3},{a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (122,'122. Rotate a List Left or Right by k Steps','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list nums, rotate the list to the right by k steps, where k is a non-negative integer.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Rotate to the Right: Shifting elements toward the higher indices. An element at the last index wraps around to index 0. Moving a list right by 1 step means the last element becomes the first element, and all other elements slide one slot to the right.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The modification must be performed in-place. Note that k can be zero, or it can be significantly larger than the total length of the list.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3, 4, 5, 6, 7], k = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [5, 6, 7, 1, 2, 3, 4]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-1, -100, 3, 99], k = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [3, 99, -1, -100]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2], k = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1, 2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2], k = 5 (k is larger than the list length; must wrap around correctly via modulo scaling)</code></li><li><code>nums = [1, 2, 3], k = 3 (k is exactly equal to the list length; results in zero net positional change)</code></li><li><code>nums = [], k = 10 (An empty list modified by any rotation step value)</code></li>
</ul>','easy',100,'python-advanced','def rotate_list(nums, k):
    pass','assert "rotate_list" in exec_globals
fn=exec_globals["rotate_list"]
a1=[1,2,3,4,5,6,7]; fn(a1,3); assert a1==[5,6,7,1,2,3,4], f"Got {a1}"
a2=[-1,-100,3,99]; fn(a2,2); assert a2==[3,99,-1,-100], f"Got {a2}"
a3=[1,2]; fn(a3,0); assert a3==[1,2], f"Got {a3}"
a4=[1,2]; fn(a4,5); assert a4==[2,1], f"Got {a4}"
exec_globals["passed_cases"]=4
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (123,'123. Separate Even and Odd Numbers','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an unsorted list of integers nums, rearrange its elements in-place so that all even numbers appear at the beginning of the list, immediately followed by all odd numbers.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">You are not required to preserve the original relative order of the numbers within the even group or within the odd group; any arrangement is acceptable as long as all evens precede all odds. If the list is empty, it remains unchanged.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [3, 5, 2, 4, 9, 8]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [2, 4, 8, 3, 9, 5]</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Note: [8, 4, 2, 5, 9, 3] is also valid</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 3, 5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1, 3, 5]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes []</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [2, 4, 6, 8] (A list that contains only even numbers)</code></li><li><code>nums = [2, 4, 1, 3] (A list that is already perfectly partitioned with evens first)</code></li><li><code>nums = [1, 2, 1, 2] (Alternating odd and even integers)</code></li>
</ul>','easy',100,'python-advanced','def separate_even_odd(nums):
    pass','assert "separate_even_odd" in exec_globals
fn=exec_globals["separate_even_odd"]
def check_partition(a):
    is_even=True
    for x in a:
        if x%2!=0: is_even=False
        elif not is_even: return False
    return True
a1=[3,5,2,4,9,8]; fn(a1); assert check_partition(a1), f"Got {a1}"
a2=[1,3,5]; fn(a2); assert check_partition(a2), f"Got {a2}"
a3=[]; fn(a3); assert check_partition(a3), f"Got {a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (124,'124. Two Sum in a Sorted List (Target Sum)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums that is already sorted in non-decreasing (ascending) order, find two distinct numbers in the list that add up to a specific target number.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return the indices of these two numbers as a tuple: (index1, index2). Assume that each input has exactly one unique solution, and you are not allowed to use the same element twice. If no matching pair exists (due to bad input bounds), return (None, None).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 7, 11, 15], target = 9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 1)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 3, 4], target = 6</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(0, 2)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3], target = 10</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(None, None)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [-5, -3, -1, 2, 4], target = -4 (Target sum composed of negative sorted integers)</code></li><li><code>nums = [1, 2, 3, 3, 5], target = 6 (Target sum formed by two identical values at adjacent indices)</code></li><li><code>nums = [-10, 0, 10], target = 0 (Target sum matching exactly zero using values across the origin)</code></li>
</ul>','easy',100,'python-advanced','def two_sum_sorted(nums, target):
    pass','def ref_impl(*args):
    nums,target=args[0],args[1]
    l,r=0,len(nums)-1
    while l<r:
        s=nums[l]+nums[r]
        if s==target: return (l,r)
        elif s<target: l+=1
        else: r-=1
    return None

assert "two_sum_sorted" in exec_globals, "Function two_sum_sorted not found"
fn = exec_globals["two_sum_sorted"]
test_cases = [([2,7,11,15],9), ([1,2,3,4,6],6), ([1,2],5)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (125,'125. Container With Most Water','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of non-negative integers height of length n, where each element represents the vertical height of a wall at coordinate index i, find two vertical lines that together with the x-axis form a container that holds the maximum volume of water.Container Volume: The volume of water trapped between two lines at indices left and right is limited by the shorter line and the horizontal distance between them. Return the maximum volume area of water the container can store. If height has a length less than 2, it cannot form a container; return 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>height = [1, 8, 6, 2, 5, 4, 8, 3, 7]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>49</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>height = [1, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>height = [4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div>','medium',200,'python-advanced','def max_area(h):
    pass','def ref_impl(*args):
    h=args[0]
    l,r=0,len(h)-1
    ans=0
    while l<r:
        ans=max(ans,min(h[l],h[r])*(r-l))
        if h[l]<h[r]: l+=1
        else: r-=1
    return ans

assert "max_area" in exec_globals, "Function max_area not found"
fn = exec_globals["max_area"]
test_cases = [[1,8,6,2,5,4,8,3,7], [1,1], [4]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (126,'126. Maximum Subarray Sum (Kadane''s Algorithm)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, find the contiguous subarray which has the largest sum and return its sum.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Contiguous Subarray: A connected, unbroken sequence of elements taken directly from inside the list without skipping any elements. For example, in [1, 2, 3, 4], [2, 3] is a contiguous subarray, but [1, 3] is not.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A single element can qualify as a valid subarray. If the list is completely empty, return 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-2, 1, -3, 4, -1, 2, 1, -5, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>6</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The contiguous subarray with the largest sum is [4, -1, 2, 1]</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [-2, -3, -1, -5] (A list containing exclusively negative numbers; must return the single highest negative number, not 0)</code></li><li><code>nums = [5, -2, 5] (A list containing a small negative bridge between two large positive numbers)</code></li><li><code>nums = [1, 2, 3, 4] (A list containing entirely positive integers)</code></li>
</ul>','medium',200,'python-advanced','def max_sub_array(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    if not nums: return 0
    cur=max_s=nums[0]
    for x in nums[1:]:
        cur=max(x,cur+x)
        max_s=max(max_s,cur)
    return max_s

assert "max_sub_array" in exec_globals, "Function max_sub_array not found"
fn = exec_globals["max_sub_array"]
test_cases = [[-2,1,-3,4,-1,2,1,-5,4], [1], [5,4,-1,7,8]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (127,'127. Find All Subarrays of a List (Subarray Generation)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, find and generate every possible contiguous subarray that can be formed from the list. Return the result as a list of lists containing all the generated subarrays.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The individual subarrays can appear in any order in the output, but the interior elements of each individual subarray must preserve their original sequential placement. If the input list is empty, return an empty list [].</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[[1], [1, 2], [1, 2, 3], [2], [2, 3], [3]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[[4]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2, 3, 4] (Must generate exactly (N * (N + 1)) // 2 subarrays, which is 10 unique subarrays)</code></li><li><code>nums = [5, 5] (Handling duplicate elements correctly; the subarrays generated are separate items based on index coordinates: [[5], [5, 5], [5]])</code></li><li><code>nums = [] (Empty list boundary condition)</code></li>
</ul>','easy',100,'python-advanced','def find_subarrays(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    res=[]
    for i in range(len(nums)):
        for j in range(i+1,len(nums)+1):
            res.append(nums[i:j])
    return res

assert "find_subarrays" in exec_globals, "Function find_subarrays not found"
fn = exec_globals["find_subarrays"]
test_cases = [[1,2,3], [4], []]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (128,'128. Maximum Sum Subarray of Fixed Size k','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums and a positive integer k, calculate the maximum possible sum of any contiguous subarray that has a fixed size equal to exactly k.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Fixed Size Window: The subarray must contain exactly k items. If the total length of the input list nums is strictly less than k, it is impossible to form a window of the required size; in this case, return 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 1, 5, 1, 3, 2], k = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>9</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The subarray [5, 1, 3] has the maximum sum of 9</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 3, 4, 1, 5], k = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>7</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The subarray [3, 4] has the maximum sum of 7</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2], k = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2, 3], k = 3 (k is exactly equal to the length of the list)</code></li><li><code>nums = [-1, 4, -2, 3, -5], k = 2 (Window spans across alternating positive and negative values)</code></li><li><code>nums = [0, 0, 0, 0], k = 2 (A list containing entirely zeroes)</code></li>
</ul>','easy',100,'python-advanced','def max_sub_array_k(nums, k):
    pass','def ref_impl(*args):
    nums,k=args[0],args[1]
    if len(nums)<k or k<=0: return 0
    cur=sum(nums[:k])
    mx=cur
    for i in range(len(nums)-k):
        cur=cur-nums[i]+nums[i+k]
        mx=max(mx,cur)
    return mx

assert "max_sub_array_k" in exec_globals, "Function max_sub_array_k not found"
fn = exec_globals["max_sub_array_k"]
test_cases = [([100,200,300,400],2), ([1,4,2,10,23,3,1,0,20],4), ([2,3],3)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (129,'129. Minimum Size Subarray Sum (Variable Window Size)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of positive integers nums and a positive integer target, return the minimal length of a contiguous subarray whose sum is greater than or equal to target.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Variable Window Size: The length of the subarray is dynamic. You are looking for the shortest possible span of elements that satisfies the target condition.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If no such contiguous subarray exists within the list, return 0 instead.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>target = 7, nums = [2, 3, 1, 2, 4, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The shortest subarray meeting the condition is [4, 3] with a length of 2</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>target = 4, nums = [1, 4, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The single element [4] meets the condition instantly</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>target = 100, nums = [1, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">No subarray can sum up to 100</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2, 10, 3], target = 10 (A single element exactly matches the target value mid-list)</code></li><li><code>nums = [5], target = 5 (A single-element list that meets the target value exactly)</code></li><li><code>nums = [1, 1, 1, 1, 1, 5], target = 5 (A large number at the very end of a list of small numbers)</code></li>
</ul>','medium',200,'python-advanced','def min_sub_array_len(target, nums):
    pass','def ref_impl(*args):
    target,nums=args[0],args[1]
    l,total,ans=0,0,float("inf")
    for r in range(len(nums)):
        total+=nums[r]
        while total>=target:
            ans=min(ans,r-l+1)
            total-=nums[l]
            l+=1
    return 0 if ans==float("inf") else ans

assert "min_sub_array_len" in exec_globals, "Function min_sub_array_len not found"
fn = exec_globals["min_sub_array_len"]
test_cases = [(7,[2,3,1,2,4,3]), (4,[1,4,4]), (11,[1,1,1,1,1,1,1])]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (130,'130. Product of List Except Self','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, return an output list answer such that answer[i] is equal to the product of all the elements of nums except nums[i].</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Product Except Self: For an element at index i, its output value is the combined product of all numbers appearing before it (Prefix Product) multiplied by all numbers appearing after it (Suffix Product).</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Constraint: You must solve this without using the division operator / or //. If the list contains only 1 element, it has no outer items to multiply; return [1]. If the list is empty, return [].</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[24, 12, 8, 6]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-1, 1, 0, -3, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 0, 9, 0, 0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [4, 5, 0, 2] (A list containing exactly one zero element)</code></li><li><code>nums = [0, 2, 3, 0] (A list containing multiple zero elements)</code></li><li><code>nums = [-1, -2, -3] (A list containing negative values that flip signs based on position)</code></li>
</ul>','medium',200,'python-advanced','def product_except_self(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    n=len(nums)
    res=[1]*n
    left=1
    for i in range(n):
        res[i]=left
        left*=nums[i]
    right=1
    for i in range(n-1,-1,-1):
        res[i]*=right
        right*=nums[i]
    return res

assert "product_except_self" in exec_globals, "Function product_except_self not found"
fn = exec_globals["product_except_self"]
test_cases = [[1,2,3,4], [-1,1,0,-3,3]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (131,'131. Majority Element','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums of size n, find and return the majority element.Majority Element: The specific element that appears more than n // 2 times in the list. The problem guarantees that a majority element always exists in the input list.Your algorithm must find this element using constant O(1) extra space, meaning you cannot duplicate the list or allocate structural counters.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [3, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>3</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 2, 1, 1, 1, 2, 2]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [7]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>7</code></div>
  
</div>','easy',100,'python-advanced','def majority_element(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    cand,count=None,0
    for x in nums:
        if count==0: cand=x
        count+=1 if x==cand else -1
    return cand

assert "majority_element" in exec_globals, "Function majority_element not found"
fn = exec_globals["majority_element"]
test_cases = [[3,2,3], [2,2,1,1,1,2,2], [7]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (132,'132. Sort an Array of 0s, 1s, and 2s (Dutch National Flag)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">An unsorted list nums contains only three types of integer elements: 0, 1, and 2. Rearrange this list in-place so that all elements are sorted in ascending order (all 0s first, followed by all 1s, and ending with all 2s).Partitioning: You must sort the list in a single pass over the elements using constant O(1) extra space. You are not allowed to use Python''s built-in .sort() function or count the frequencies to rebuild the list.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 0, 2, 1, 1, 0]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [0, 0, 1, 1, 2, 2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 0, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [0, 1, 2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1]</code></div>
  
</div>','medium',200,'python-advanced','def sort_colors(nums):
    pass','assert "sort_colors" in exec_globals
fn=exec_globals["sort_colors"]
a1=[2,0,2,1,1,0]; fn(a1); assert a1==[0,0,1,1,2,2], f"Got {a1}"
a2=[2,0,1]; fn(a2); assert a2==[0,1,2], f"Got {a2}"
a3=[1]; fn(a3); assert a3==[1], f"Got {a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (133,'133. Next Permutation of a List','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, rearrange the numbers into the lexicographically next greater permutation of numbers.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Lexicographical Order: The dictionary order of numbers. For example, the permutations of [1,2,3] sorted in increasing order are [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], and [3,2,1].</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">The rearrangement must be done in-place using constant extra memory. If no greater permutation can be formed because the list is already in its maximum possible sorted state (strictly descending order), rearrange the list into its lowest possible lexicographical order (sorted completely in ascending order).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1, 3, 2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [3, 2, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1, 2, 3]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 1, 5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums becomes [1, 5, 1]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 5, 1] (Handling duplicate elements correctly during pivot search)</code></li><li><code>nums = [2, 3, 1] (The pivot point requiring modification is located at the very first index)</code></li><li><code>nums = [1, 3, 2] (Requires finding the next structural step where values change columns across multiple trailing elements)</code></li>
</ul>','medium',200,'python-advanced','def next_permutation(nums):
    pass','assert "next_permutation" in exec_globals
fn=exec_globals["next_permutation"]
a1=[1,2,3]; fn(a1); assert a1==[1,3,2], f"Got {a1}"
a2=[3,2,1]; fn(a2); assert a2==[1,2,3], f"Got {a2}"
a3=[1,1,5]; fn(a3); assert a3==[1,5,1], f"Got {a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (134,'134. Trapping Rain Water','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of non-negative integers height where each element represents the height of a vertical bar on a structural grid map (width of each bar is 1), calculate the total units of water that can be trapped within the valleys after a rainstorm.Elevation Trapping: Water is trapped on top of a bar at index i only if there are higher bars blocking it on both its far left and far right sides. The level of water trapped at index i is determined by:Water Level = \min(Max Left Height, Max Right Height) - height[i]Return the total accumulation value. If the list contains fewer than 3 bars, it cannot form a valley; return 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>height = [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>6</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>height = [4, 2, 0, 3, 2, 5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>9</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>height = [1, 2]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div>','hard',300,'python-advanced','def trap(h):
    pass','def ref_impl(*args):
    h=args[0]
    if not h: return 0
    l,r=0,len(h)-1
    lm,rm=h[l],h[r]
    ans=0
    while l<r:
        if lm<rm:
            l+=1
            lm=max(lm,h[l])
            ans+=lm-h[l]
        else:
            r-=1
            rm=max(rm,h[r])
            ans+=rm-h[r]
    return ans

assert "trap" in exec_globals, "Function trap not found"
fn = exec_globals["trap"]
test_cases = [[0,1,0,2,1,0,1,3,2,1,2,1], [4,2,0,3,2,5], [1,2]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (135,'135. Merge Sorted Lists In-Place','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">You are given two integer lists, nums1 and nums2, both sorted in non-decreasing (ascending) order. You are also given two integers, m and n, representing the exact number of elements that should be merged from nums1 and nums2 respectively.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Merge nums2 directly into nums1 so that the combined elements form a single sorted list inside nums1.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Constraint: To hold the incoming numbers, nums1 has an expanded total structural length of m + n. The first m elements denote the numbers that should be merged, and the last n positions are initialized to 0 as empty space placeholders. You must modify nums1 in-place without using a second list.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums1 = [1, 2, 3, 0, 0, 0], m = 3, nums2 = [2, 5, 6], n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums1 becomes [1, 2, 2, 3, 5, 6]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums1 = [0], m = 0, nums2 = [1], n = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums1 becomes [1]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums1 = [2, 0], m = 1, nums2 = [1], n = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>nums1 becomes [1, 2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums1 = [4, 5, 6, 0, 0, 0], m = 3; nums2 = [1, 2, 3], n = 3 (All elements in nums2 are strictly smaller than all elements in nums1)</code></li><li><code>nums1 = [1, 2, 3, 0, 0, 0], m = 3; nums2 = [4, 5, 6], n = 3 (All elements in nums2 are strictly larger than all elements in nums1)</code></li><li><code>nums1 = [0], m = 0; nums2 = [1], n = 1 (The active portion of nums1 is completely empty)</code></li>
</ul>','medium',200,'python-advanced','def merge(nums1, m, nums2, n):
    pass','assert "merge" in exec_globals
fn=exec_globals["merge"]
a1=[1,2,3,0,0,0]; fn(a1,3,[2,5,6],3); assert a1==[1,2,2,3,5,6], f"Got {a1}"
a2=[1]; fn(a2,1,[],0); assert a2==[1], f"Got {a2}"
a3=[0]; fn(a3,0,[1],1); assert a3==[1], f"Got {a3}"
exec_globals["passed_cases"]=3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (136,'136. Interval List Intersections','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given two lists of closed intervals, firstList and secondList, where each individual interval is represented as a pair [start, end]. Each list contains intervals that are already sorted in ascending order by their start times and do not overlap with other intervals in the same list.Find and return the intersection of these two interval lists.Interval Intersection: A closed interval [a, b] (with a  <=  b) represents the set of real numbers from a to b. The intersection of two intervals is the set of points that are common to both intervals (e.g., the intersection of [1, 4] and [3, 6] is [3, 4]).Return the overlapping pairs as a list of lists. If there is no overlap at all, return an empty list [].</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>firstList = [[0, 2], [5, 10], [13, 23], [24, 25]], secondList = [[1, 5], [8, 12], [15, 24], [25, 26]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[[1, 2], [5, 5], [8, 10], [15, 23], [24, 24], [25, 25]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>firstList = [[1, 3]], secondList = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>firstList = [[1, 10]], secondList = [[3, 5], [6, 8]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[[3, 5], [6, 8]]</code></div>
  
</div>','medium',200,'python-advanced','def interval_intersection(firstList, secondList):
    pass','def ref_impl(*args):
    l1,l2=args[0],args[1]
    i,j=0,0
    res=[]
    while i<len(l1) and j<len(l2):
        lo=max(l1[i][0],l2[j][0])
        hi=min(l1[i][1],l2[j][1])
        if lo<=hi: res.append([lo,hi])
        if l1[i][1]<l2[j][1]: i+=1
        else: j+=1
    return res

assert "interval_intersection" in exec_globals, "Function interval_intersection not found"
fn = exec_globals["interval_intersection"]
test_cases = [([[0,2],[5,10],[13,23],[24,25]],[[1,5],[8,12],[15,24],[25,26]]), ([[1,3]],[]), ([[1,10]],[[3,5],[6,8]])]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (137,'137. Rotate Matrix 90 Degrees Clockwise In-Place','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">You are given an n x n 2D matrix represented as a nested list of lists, where matrix[i][j] represents the element at row i and column j. Rotate the entire grid image by 90 degrees in a clockwise direction.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">In-Place Transformation: You must modify the 2D list directly within its allocated memory structure. You are not allowed to create or allocate a new second matrix to map the coordinates.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1, 2], [3, 4]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>matrix becomes [[3, 1], [4, 2]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[5, 1, 9], [2, 4, 8], [13, 3, 6]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>matrix becomes [[13, 2, 5], [3, 4, 1], [6, 8, 9]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>matrix becomes [[1]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>matrix = [[1]] (A 1x1 minimal matrix boundary case)</code></li><li><code>matrix = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]] (An even-dimensioned 4x4 grid testing nested boundary layer coordinates)</code></li><li><code>A matrix where elements along the primary diagonal are completely identical (e.g., matrix[i][i] == 5 for all i), ensuring structural transposition checks do not stall.</code></li>
</ul>','medium',200,'python-advanced','def rotate_matrix(matrix):
    pass','assert "rotate_matrix" in exec_globals
fn=exec_globals["rotate_matrix"]
m1=[[1,2,3],[4,5,6],[7,8,9]]; fn(m1); assert m1==[[7,4,1],[8,5,2],[9,6,3]], f"Got {m1}"
m2=[[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]; fn(m2); assert m2==[[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]], f"Got {m2}"
exec_globals["passed_cases"]=2
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (138,'138. Spiral Matrix Traversal','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an m x n matrix (a nested list containing m rows and n columns), return a flat 1D list containing all the elements of the matrix ordered by a spiral traversal path.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Spiral Order: Reading elements by starting from the top-left corner (0,0), moving horizontally across the first row to the right edge, turning downward along the final column to the bottom edge, turning left across the bottom row, and climbing back up the first column. This outer loop boundary then shrinks inward layer by layer until every coordinate is visited exactly once.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">If the matrix is empty, return an empty list [].</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1, 2, 3, 6, 9, 8, 7, 4, 5]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>matrix = [[1, 2, 3, 4]] (A single-row matrix layout; must terminate right after reading left-to-right without performing invalid reverse loops)</code></li><li><code>matrix = [[1], [2], [3]] (A single-column matrix layout; must move directly down without processing width loops)</code></li><li><code>matrix = [[1, 2], [3, 4]] (A simple square matrix grid)</code></li>
</ul>','medium',200,'python-advanced','def spiral_order(matrix):
    pass','def ref_impl(*args):
    matrix=args[0]
    if not matrix: return []
    res=[]
    r1,r2=0,len(matrix)-1
    c1,c2=0,len(matrix[0])-1
    while r1<=r2 and c1<=c2:
        for c in range(c1,c2+1): res.append(matrix[r1][c])
        for r in range(r1+1,r2+1): res.append(matrix[r][c2])
        if r1<r2 and c1<c2:
            for c in range(c2-1,c1,-1): res.append(matrix[r2][c])
            for r in range(r2,r1,-1): res.append(matrix[r][c1])
        r1+=1;r2-=1;c1+=1;c2-=1
    return res

assert "spiral_order" in exec_globals, "Function spiral_order not found"
fn = exec_globals["spiral_order"]
test_cases = [[[1,2,3],[4,5,6],[7,8,9]], [[1,2,3,4],[5,6,7,8],[9,10,11,12]]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (139,'139. Set Matrix Zeroes','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an m x n integer matrix, if any element inside the grid is originally equal to 0, modify the matrix in-place so that its entire corresponding row and entire corresponding column are completely filled with 0s.In-Place Flagging: You must solve this with a constant O(1) extra space footprint. You cannot maintain a separate copy of the matrix or use separate tracking lists of size m or n to mark row/column states. Instead, you must utilize the matrix''s own first row and first column as interior status indicators.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1, 1, 1], [1, 0, 1], [1, 1, 1]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>matrix becomes [[1, 0, 1], [0, 0, 0], [1, 0, 1]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[0, 1, 2, 0], [3, 4, 5, 2], [1, 3, 1, 5]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>matrix becomes [[0, 0, 0, 0], [0, 4, 5, 0], [0, 3, 1, 0]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1, 2], [3, 4]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>matrix becomes [[1, 2], [3, 4]]</code></div>
  
</div>','medium',200,'python-advanced','def set_zeroes(matrix):
    pass','assert "set_zeroes" in exec_globals
fn=exec_globals["set_zeroes"]
m1=[[1,1,1],[1,0,1],[1,1,1]]; fn(m1); assert m1==[[1,0,1],[0,0,0],[1,0,1]], f"Got {m1}"
m2=[[0,1,2,0],[3,4,5,2],[1,3,1,5]]; fn(m2); assert m2==[[0,0,0,0],[0,4,5,0],[0,3,1,0]], f"Got {m2}"
exec_globals["passed_cases"]=2
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (140,'140. Standard Binary Search Implementation','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums which is sorted in non-decreasing (ascending) order, and an integer target, search for target inside the list.If the target exists within the collection, return its corresponding index position. If the target is not present in the list, return -1.Your algorithm must search for the target using a logarithmic range reduction strategy, meaning the search space must be cut in half at each comparative step to achieve an optimal time complexity of O(\log N) instead of checking elements sequentially.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-1, 0, 3, 5, 9, 12], target = 9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>4</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-1, 0, 3, 5, 9, 12], target = 2</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [], target = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  
</div>','easy',100,'python-advanced','def binary_search(nums, target):
    pass','def ref_impl(*args):
    nums,target=args[0],args[1]
    l,r=0,len(nums)-1
    while l<=r:
        m=(l+r)//2
        if nums[m]==target: return m
        elif nums[m]<target: l=m+1
        else: r=m-1
    return -1

assert "binary_search" in exec_globals, "Function binary_search not found"
fn = exec_globals["binary_search"]
test_cases = [([-1,0,3,5,9,12],9), ([-1,0,3,5,9,12],2), ([],5), ([5],5), ([1,3],3), ([10,20,30,40],10)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 6',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (141,'141. Find Peak Element','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">A peak element in a list is an element that is strictly greater than its immediate neighbors. Given an unsorted integer list nums, find a peak element and return its index position.Boundary Assumptions: You may imagine that the elements outside the boundary limits of the list act as negative infinity. This means that if an element is at the very front or very back of the list, it only needs to be strictly greater than its single interior neighbor to qualify as a peak.If the list contains multiple peak elements, returning the index position of any of the peaks is considered correct. Your solution must run within an optimal time complexity constraint of O(\log N).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 3, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>2</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The value at index 2 is 3, which is greater than its neighbors 2 and 1</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 2, 1, 3, 5, 6, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>5</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The value at index 5 is 6, which is greater than its neighbors 5 and 4</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">A single element qualifies as a peak by default</span></div>
</div>','medium',200,'python-advanced','def find_peak_element(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    l,r=0,len(nums)-1
    while l<r:
        m=(l+r)//2
        if nums[m]>nums[m+1]: r=m
        else: l=m+1
    return l

assert "find_peak_element" in exec_globals, "Function find_peak_element not found"
fn = exec_globals["find_peak_element"]
test_cases = [[1,2,3,1], [1,2,1,3,5,6,4], [1], [1,2,3,4]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (142,'142. Search in Rotated Sorted List','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">An integer list nums is initially sorted in strictly ascending order with completely unique values. Prior to being passed to your function, the list is rotated at an unknown pivot index k (1  <=  k < len(nums)) such that the resulting array shifts its structural segments (e.g., [0,1,2,4,5,6,7] might become [4,5,6,7,0,1,2]).Given the rotated list nums and an integer target, return the index of the target if it is present in the list, or -1 if it cannot be found.Your algorithm must search for the target element within an optimal time complexity layout of O(\log N).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [4, 5, 6, 7, 0, 1, 2], target = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>4</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [4, 5, 6, 7, 0, 1, 2], target = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1], target = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>-1</code></div>
  
</div>','medium',200,'python-advanced','def search_rotated(nums, target):
    pass','def ref_impl(*args):
    nums,target=args[0],args[1]
    l,r=0,len(nums)-1
    while l<=r:
        m=(l+r)//2
        if nums[m]==target: return m
        if nums[l]<=nums[m]:
            if nums[l]<=target<nums[m]: r=m-1
            else: l=m+1
        else:
            if nums[m]<target<=nums[r]: l=m+1
            else: r=m-1
    return -1

assert "search_rotated" in exec_globals, "Function search_rotated not found"
fn = exec_globals["search_rotated"]
test_cases = [([4,5,6,7,0,1,2],0), ([4,5,6,7,0,1,2],3), ([1],0), ([3,1],1), ([5,1,3],5)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (143,'143. Next Greater Element','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers nums, find and return a new list answer of the exact same length, where answer[i] represents the next greater element for nums[i].</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Next Greater Element: The first element located to the strict right of index i that has a value larger than nums[i]. If no such element exists because you hit the right boundary or all subsequent numbers are smaller, the value for that position must be recorded as -1.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1, 3, 4, 2]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[3, 4, -1, -1]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [6, 5, 4, 3, 2, 1]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[-1, -1, -1, -1, -1, -1]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [2, 1, 5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[5, 5, -1]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>nums = [1, 2, 3, 4, 5] (A list sorted in strictly increasing order, where every single element except the last maps to its immediate right neighbor)</code></li><li><code>nums = [5, 4, 3, 2, 10] (A long descending run terminated by a massive value at the very end that resolves the entire sequence)</code></li><li><code>nums = [] (An empty list boundary case, which must return an empty list [])</code></li>
</ul>','medium',200,'python-advanced','def next_greater_element_array(nums):
    pass','def ref_impl(*args):
    nums=args[0]
    ans=[-1]*len(nums)
    st=[]
    for i in range(len(nums)):
        while st and nums[st[-1]]<nums[i]:
            ans[st.pop()]=nums[i]
        st.append(i)
    return ans

assert "next_greater_element_array" in exec_globals, "Function next_greater_element_array not found"
fn = exec_globals["next_greater_element_array"]
test_cases = [[1,3,4,2], [6,5,4,3,2,1], [2,1,5]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (144,'144. Daily Temperatures (Monotonic Decreasing Property)','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of integers temperatures representing the daily temperature records, compute and return a list answer where answer[i] is the exact number of days you would have to wait after index i to get a warmer temperature.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Lookup Offsets: You must calculate the index distance index difference (j - i) rather than recording the raw temperature value itself. If there is no future day for which this condition is met, record 0 for that position instead.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>temperatures = [73, 74, 75, 71, 69, 72, 76, 73]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1, 1, 4, 2, 1, 1, 0, 0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>temperatures = [30, 40, 50, 60]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1, 1, 1, 0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>temperatures = [30, 30, 25]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0, 0, 0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>temperatures = [89, 89, 89] (A sequence of identical temperatures; since it requires a strictly warmer day, they must all resolve to 0)</code></li><li><code>temperatures = [50, 40, 30, 60] (A multi-day drop that is completely broken and resolved by a single massive jump at the end)</code></li><li><code>temperatures = [40] (A single-element list boundary case, returning [0])</code></li>
</ul>','medium',200,'python-advanced','def daily_temperatures(temps):
    pass','def ref_impl(*args):
    t=args[0]
    ans=[0]*len(t)
    st=[]
    for i,temp in enumerate(t):
        while st and t[st[-1]]<temp:
            idx=st.pop()
            ans[idx]=i-idx
        st.append(i)
    return ans

assert "daily_temperatures" in exec_globals, "Function daily_temperatures not found"
fn = exec_globals["daily_temperatures"]
test_cases = [[73,74,75,71,69,72,76,73], [30,40,50,60], [30,30,25], [40]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (145,'145. Largest Rectangle in Histogram','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given a list of non-negative integers heights where each element represents the height of a bar in a histogram chart layout (where the horizontal width of each individual bar is exactly 1), find the largest rectangular area that can be formed within the boundaries of the histogram.Bounding Rectangle Volume: The maximum area of a rectangle spanning from index left to index right is restricted by the absolute shortest bar contained within that span multiplied by the total wide index distance:Area = \min(heights[left ... right])  ×  (right - left + 1)Return the maximum calculated area value. If the list is empty, return 0.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>heights = [2, 1, 5, 6, 2, 3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>10</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">The largest rectangle is formed by the bars 5 and 6 with a width of 2, yielding an area of 5  ×  2 = 10</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>heights = [2, 4]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>4</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>heights = []</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>0</code></div>
  
</div>','hard',300,'python-advanced','def largest_rectangle_area(heights):
    pass','def ref_impl(*args):
    heights=args[0]
    heights.append(0)
    st=[-1]
    ans=0
    for i in range(len(heights)):
        while heights[i]<heights[st[-1]]:
            h=heights[st.pop()]
            w=i-st[-1]-1
            ans=max(ans,h*w)
        st.append(i)
    heights.pop()
    return ans

assert "largest_rectangle_area" in exec_globals, "Function largest_rectangle_area not found"
fn = exec_globals["largest_rectangle_area"]
test_cases = [[2,1,5,6,2,3], [2,4], [], [1,2,3,4,5], [11,11,11]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (146,'146. Create and Access a Dictionary','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>student_dict(name, age, grade)</code> that creates and returns a dictionary with keys <code>"name"</code>, <code>"age"</code>, <code>"grade"</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Dictionaries (dicts) are Python''s key-value store. You create them with <code>{key: value}</code> syntax and access values with <code>dict[key]</code> or <code>dict.get(key)</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>name="Alice", age=18, grade="A"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"name":"Alice","age":18,"grade":"A"}</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>name="Bob", age=20, grade="B"</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"name":"Bob","age":20,"grade":"B"}</code></div>
  
</div>','easy',100,'python-advanced','def student_dict(name, age, grade):
    # Return a dict with name, age, grade
    pass','def ref_impl(*args):
    return {"name":args[0],"age":args[1],"grade":args[2]}

assert "student_dict" in exec_globals, "Function student_dict not found"
fn = exec_globals["student_dict"]
test_cases = [("Alice",18,"A"), ("Bob",20,"B"), ("X",0,"F")]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (147,'147. Dictionary Methods — keys, values, items','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>dict_info(d)</code> that takes a dictionary and returns a tuple:
<code>(sorted_keys, sorted_values, items_list)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use <code>dict.keys()</code>, <code>dict.values()</code>, <code>dict.items()</code>. Sort the keys and values for consistent comparison.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>d = {"b":2,"a":1,"c":3}</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(["a","b","c"], [1,2,3], [("a",1),("b",2),("c",3)])</code></div>
  
</div>','easy',100,'python-advanced','def dict_info(d):
    # Return (sorted_keys, sorted_values, sorted_items)
    pass','def ref_impl(*args):
    d=args[0]
    sk=sorted(d.keys())
    sv=sorted(d.values())
    si=sorted(d.items())
    return (sk,sv,si)

assert "dict_info" in exec_globals, "Function dict_info not found"
fn = exec_globals["dict_info"]
test_cases = [{"b":2,"a":1,"c":3}, {"x":10,"y":20}, {}]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (148,'148. Merge and Update Dictionaries','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>merge_dicts(d1, d2)</code> that merges two dictionaries. If a key exists in both, sum the values. Return the merged dictionary.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use <code>.update()</code> or <code>dict.get()</code> to handle overlapping keys.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>d1={"a":1,"b":2}, d2={"b":3,"c":4}</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"a":1,"b":5,"c":4}</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">"b" appears in both: 2+3=5</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>d1={"x":10}, d2={"y":20}</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"x":10,"y":20}</code></div>
  
</div>','easy',100,'python-advanced','def merge_dicts(d1, d2):
    # Merge d1 and d2, summing values for duplicate keys
    pass','def ref_impl(*args):
    d1,d2=dict(args[0]),args[1]
    for k,v in d2.items():
        d1[k]=d1.get(k,0)+v
    return d1

assert "merge_dicts" in exec_globals, "Function merge_dicts not found"
fn = exec_globals["merge_dicts"]
test_cases = [({"a":1,"b":2},{"b":3,"c":4}), ({"x":10},{"y":20}), ({},{})]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (149,'149. Frequency Counter with Dict','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>count_elements(lst)</code> that takes a list and returns a dictionary mapping each unique element to its count.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This is one of the most common dict patterns in real Python programs. You can use a plain dict with <code>.get()</code>, or use <code>collections.Counter</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = [1,2,2,3,3,3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{1:1, 2:2, 3:3}</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>lst = ["a","b","a","c","b","a"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{"a":3,"b":2,"c":1}</code></div>
  
</div>','easy',100,'python-advanced','def count_elements(lst):
    # Return frequency dict
    pass','def ref_impl(*args):
    freq={}
    for x in args[0]:
        freq[x]=freq.get(x,0)+1
    return freq

assert "count_elements" in exec_globals, "Function count_elements not found"
fn = exec_globals["count_elements"]
test_cases = [[1,2,2,3,3,3], ["a","b","a","c","b","a"], [], [5]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (150,'150. Dict Comprehension','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>squares_dict(n)</code> that uses a dict comprehension to create a dictionary mapping each integer from 1 to n to its square.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Dict comprehension syntax: <code>{key: value for var in iterable}</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">For example, n=4 → <code>{1:1, 2:4, 3:9, 4:16}</code></p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 5</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{1:1, 2:4, 3:9, 4:16, 5:25}</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 3</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>{1:1, 2:4, 3:9}</code></div>
  
</div>','easy',100,'python-advanced','def squares_dict(n):
    # Return {i: i**2 for i in 1..n} using dict comprehension
    pass','def ref_impl(*args):
    return {i:i**2 for i in range(1,args[0]+1)}

assert "squares_dict" in exec_globals, "Function squares_dict not found"
fn = exec_globals["squares_dict"]
test_cases = [5, 3, 1, 10]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (151,'151. Two Sum with Dictionary','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>two_sum(nums, target)</code> that returns the indices of the two numbers in <code>nums</code> that add up to <code>target</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use a dictionary to achieve O(n) time: for each number, check if <code>target - number</code> is already in the dict. Each input has exactly one valid solution.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums=[2,7,11,15], target=9</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0,1]</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">nums[0]+nums[1]=2+7=9</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums=[3,2,4], target=6</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[1,2]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>Each input has exactly one solution</code></li>
<li class="py-0.5"><code>You may not use the same element twice</code></li>
</ul>','medium',200,'python-advanced','def two_sum(nums, target):
    # Return [i, j] where nums[i]+nums[j]==target
    pass','def ref_impl(*args):
    nums,target=args[0],args[1]
    seen={}
    for i,n in enumerate(nums):
        complement=target-n
        if complement in seen:
            return [seen[complement],i]
        seen[n]=i

assert "two_sum" in exec_globals, "Function two_sum not found"
fn = exec_globals["two_sum"]
test_cases = [([2,7,11,15],9), ([3,2,4],6), ([3,3],6), ([1,2,3,4],5)]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (152,'152. Group Anagrams','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>group_anagrams(strs)</code> that takes a list of strings and groups them into lists of anagrams. Return the groups in any order.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Key insight: anagrams have the same sorted characters. Use <code>tuple(sorted(word))</code> as the dict key to group them.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>strs = ["eat","tea","tan","ate","nat","bat"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[["eat","tea","ate"],["tan","nat"],["bat"]]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>strs = [""]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[[""]]</code></div>
  
</div>','medium',200,'python-advanced','def group_anagrams(strs):
    # Group strings that are anagrams of each other
    pass','assert "group_anagrams" in exec_globals, "Function group_anagrams not found"
fn = exec_globals["group_anagrams"]

def normalize(result):
    return sorted([sorted(g) for g in result])

tc1 = fn(["eat","tea","tan","ate","nat","bat"])
exp1 = sorted([sorted(["eat","tea","ate"]),sorted(["tan","nat"]),sorted(["bat"])])
assert normalize(tc1) == exp1, f"Failed tc1: {tc1}"

tc2 = fn([""])
exp2 = [[""]]
assert normalize(tc2) == normalize(exp2), f"Failed tc2: {tc2}"

tc3 = fn(["a"])
assert normalize(tc3) == [["a"]], f"Failed tc3: {tc3}"

exec_globals["passed_cases"] = 3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (153,'153. Nested Dictionary — Student Records','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>top_student(records)</code> that takes a nested dictionary where each key is a student name and each value is a dict with <code>"scores"</code> (list) and <code>"grade"</code> (string). Return the name of the student with the highest average score.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">This tests navigating nested data structures — a common real-world skill.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>records = {"Alice":{"scores":[90,85,92],"grade":"A"}, "Bob":{"scores":[70,80,75],"grade":"B"}}</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Alice"</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Alice avg=89, Bob avg=75</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>At least one student in records</code></li>
</ul>','medium',200,'python-advanced','def top_student(records):
    # Return name of student with highest average score
    pass','def ref_impl(*args):
    return max(args[0],key=lambda name:sum(args[0][name]["scores"])/len(args[0][name]["scores"]))

assert "top_student" in exec_globals, "Function top_student not found"
fn = exec_globals["top_student"]
test_cases = [{"Alice":{"scores":[90,85,92],"grade":"A"},"Bob":{"scores":[70,80,75],"grade":"B"}}, {"X":{"scores":[100],"grade":"A"},"Y":{"scores":[50],"grade":"C"}}]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 2',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (154,'154. Lambda Functions','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>apply_operations(nums)</code> that uses lambda functions to perform 3 operations on a list:
1. Double each number: use <code>lambda x: x*2</code> with <code>map()</code>
2. Keep only positives: use <code>lambda x: x>0</code> with <code>filter()</code>
3. Sort by absolute value: use <code>lambda x: abs(x)</code> as key in <code>sorted()</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return a tuple: <code>(doubled, positives_only, sorted_by_abs)</code></p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [-3,1,-2,4,0]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([-6,2,-4,8,0], [1,4], [-3,-2,0,1,4])</code></div>
  
</div>','easy',100,'python-advanced','def apply_operations(nums):
    # Return (doubled, positives_only, sorted_by_abs)
    pass','def ref_impl(*args):
    n=args[0]
    d=list(map(lambda x:x*2,n))
    p=list(filter(lambda x:x>0,n))
    s=sorted(n,key=lambda x:abs(x))
    return (d,p,s)

assert "apply_operations" in exec_globals, "Function apply_operations not found"
fn = exec_globals["apply_operations"]
test_cases = [[-3,1,-2,4,0], [5,-1,3,-2], [], [0,0,0]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (155,'155. Map and Filter','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>transform_list(words)</code> that takes a list of strings and applies these transformations:
1. Convert each word to uppercase using <code>map(str.upper, words)</code>
2. Keep only words longer than 3 characters using <code>filter()</code>
3. Get the lengths of all words using <code>map(len, words)</code></p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return as a tuple: <code>(upper_words, long_words, lengths)</code></p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>words = ["hi","hello","cat","python","a"]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(["HI","HELLO","CAT","PYTHON","A"], ["hello","python"], [2,5,3,6,1])</code></div>
  
</div>','easy',100,'python-advanced','def transform_list(words):
    # Return (upper_words, long_words, lengths)
    pass','def ref_impl(*args):
    w=args[0]
    u=list(map(str.upper,w))
    l=[x for x in w if len(x)>3]
    n=list(map(len,w))
    return (u,l,n)

assert "transform_list" in exec_globals, "Function transform_list not found"
fn = exec_globals["transform_list"]
test_cases = [["hi","hello","cat","python","a"], ["x","abc","abcd"], []]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (156,'156. sorted() with Key Function','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>custom_sort(people)</code> that takes a list of tuples <code>(name, age)</code> and returns them sorted by age ascending, then by name alphabetically for ties.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Use <code>sorted()</code> with a <code>key=lambda</code> that returns a tuple — Python compares tuples element by element.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>people = [("Alice",30),("Bob",25),("Carol",30),("Dave",25)]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[("Bob",25),("Dave",25),("Alice",30),("Carol",30)]</code></div>
  
</div>','easy',100,'python-advanced','def custom_sort(people):
    # Sort by age, then by name for ties
    pass','def ref_impl(*args):
    return sorted(args[0],key=lambda x:(x[1],x[0]))

assert "custom_sort" in exec_globals, "Function custom_sort not found"
fn = exec_globals["custom_sort"]
test_cases = [[("Alice",30),("Bob",25),("Carol",30),("Dave",25)], [("Z",1),("A",1),("M",2)], []]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (157,'157. Advanced List Comprehensions','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>comprehension_advanced(matrix)</code> that takes a 2D list (matrix) and returns a tuple:
1. <code>flat_evens</code> — all even numbers from the entire matrix flattened
2. <code>row_sums</code> — list of sums of each row
3. <code>positive_coords</code> — list of <code>(row, col)</code> tuples where value > 0</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>matrix = [[1,-2,3],[4,-5,6]]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>([4,6], [2,5], [(0,0),(0,2),(1,0),(1,2)])</code></div>
  
</div>','medium',200,'python-advanced','def comprehension_advanced(matrix):
    # Return (flat_evens, row_sums, positive_coords)
    pass','def ref_impl(*args):
    m=args[0]
    fe=[x for row in m for x in row if x%2==0]
    rs=[sum(row) for row in m]
    pc=[(r,c) for r,row in enumerate(m) for c,x in enumerate(row) if x>0]
    return (fe,rs,pc)

assert "comprehension_advanced" in exec_globals, "Function comprehension_advanced not found"
fn = exec_globals["comprehension_advanced"]
test_cases = [[[1,-2,3],[4,-5,6]], [[2,4],[6,8]], [[]]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (158,'158. Generator Function','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>even_generator(n)</code> that returns a list of all even numbers from 0 to n (inclusive) using a generator expression inside <code>list()</code>.</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Generator expressions look like list comprehensions but use <code>()</code> instead of <code>[]</code>. They are memory-efficient as they generate values on-demand.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 10</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0,2,4,6,8,10]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 7</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>[0,2,4,6]</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>n >= 0</code></li>
</ul>','medium',200,'python-advanced','def even_generator(n):
    # Use a generator expression to return list of evens 0..n
    pass','def ref_impl(*args):
    return list(x for x in range(args[0]+1) if x%2==0)

assert "even_generator" in exec_globals, "Function even_generator not found"
fn = exec_globals["even_generator"]
test_cases = [10, 0, 7, 1, 20]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (159,'159. Reduce for Cumulative Operations','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>cumulative_ops(nums)</code> that uses <code>functools.reduce</code> to compute:
1. <code>product</code> — the product of all numbers (using reduce with <code>lambda a,b: a*b</code>)
2. <code>max_val</code> — the maximum value (using reduce with <code>lambda a,b: a if a>b else b</code>)</p>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Return <code>(product, max_val)</code>. Return <code>(0, None)</code> for an empty list.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [1,2,3,4,5]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(120, 5)</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">1*2*3*4*5=120, max=5</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>nums = [3]</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(3, 3)</code></div>
  
</div>','medium',200,'python-advanced','def cumulative_ops(nums):
    # Use reduce to compute product and max
    from functools import reduce
    pass','def ref_impl(*args):
    from functools import reduce
    n=args[0]
    if not n: return (0,None)
    prod=reduce(lambda a,b:a*b,n)
    mx=reduce(lambda a,b:a if a>b else b,n)
    return (prod,mx)

assert "cumulative_ops" in exec_globals, "Function cumulative_ops not found"
fn = exec_globals["cumulative_ops"]
test_cases = [[1,2,3,4,5], [3], [-1,-2,-3], [10,1,5,3]]
passed = 0
for tc in test_cases:
    if isinstance(tc, tuple):
        res = fn(*tc)
        expected = ref_impl(*tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    else:
        res = fn(tc)
        expected = ref_impl(tc)
        assert res == expected, f"Failed for {tc}:\n  got:      {res}\n  expected: {expected}"
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (160,'160. Create a Class','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Define a class <code>Animal</code> with:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>__init__(self, name, sound)</code> that stores <code>name</code> and <code>sound</code> as instance attributes</li>
  <li class="py-0.5">A method <code>speak()</code> that returns <code>f"{self.name} says {self.sound}!"</code></li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Classes are the foundation of Object-Oriented Programming. The <code>__init__</code> method is the constructor, called automatically when creating an instance.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Animal("Dog", "Woof").speak()</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Dog says Woof!"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Animal("Cat", "Meow").speak()</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Cat says Meow!"</code></div>
  
</div>','easy',100,'python-advanced','class Animal:
    def __init__(self, name, sound):
        # Store name and sound
        pass
    
    def speak(self):
        # Return the speech string
        pass','assert "Animal" in exec_globals, "Class Animal not found"
Animal = exec_globals["Animal"]
a1 = Animal("Dog", "Woof")
assert a1.name == "Dog" and a1.sound == "Woof", f"Attributes wrong: {a1.name}, {a1.sound}"
assert a1.speak() == "Dog says Woof!", f"speak() wrong: {a1.speak()}"
a2 = Animal("Cat", "Meow")
assert a2.speak() == "Cat says Meow!", f"speak() wrong: {a2.speak()}"
a3 = Animal("Duck", "Quack")
assert a3.speak() == "Duck says Quack!", f"speak() wrong: {a3.speak()}"
exec_globals["passed_cases"] = 3
exec_globals["total_cases"] = 3',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (161,'161. Class with Methods & Attributes','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Define a class <code>BankAccount</code> with:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>__init__(self, owner, balance=0)</code></li>
  <li class="py-0.5"><code>deposit(self, amount)</code> — adds to balance, returns new balance</li>
  <li class="py-0.5"><code>withdraw(self, amount)</code> — subtracts from balance if sufficient funds, else returns <code>"Insufficient funds"</code></li>
  <li class="py-0.5"><code>get_balance(self)</code> — returns current balance</li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>acc = BankAccount("Alice", 100)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>acc.deposit(50) → 150, acc.withdraw(30) → 120, acc.withdraw(200) → "Insufficient funds"</code></div>
  
</div>','easy',100,'python-advanced','class BankAccount:
    def __init__(self, owner, balance=0):
        pass
    
    def deposit(self, amount):
        pass
    
    def withdraw(self, amount):
        pass
    
    def get_balance(self):
        pass','assert "BankAccount" in exec_globals, "Class BankAccount not found"
BA = exec_globals["BankAccount"]
acc = BA("Alice", 100)
assert acc.get_balance() == 100, f"Initial balance wrong: {acc.get_balance()}"
assert acc.deposit(50) == 150, f"deposit wrong: {acc.deposit(50)}"
acc2 = BA("Bob", 200)
assert acc2.withdraw(80) == 120, f"withdraw wrong"
assert acc2.withdraw(1000) == "Insufficient funds", f"insufficient funds wrong"
acc3 = BA("Carol")
assert acc3.get_balance() == 0, f"default balance wrong"
exec_globals["passed_cases"] = 5
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (162,'162. __str__ and __repr__','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Define a class <code>Point</code> that represents a 2D coordinate with:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>__init__(self, x, y)</code></li>
  <li class="py-0.5"><code>__str__(self)</code> — returns <code>f"Point({self.x}, {self.y})"</code></li>
  <li class="py-0.5"><code>__repr__(self)</code> — returns <code>f"Point(x={self.x}, y={self.y})"</code></li>
  <li class="py-0.5"><code>distance_from_origin(self)</code> — returns <code>√(x² + y²)</code> rounded to 2 decimal places</li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans"><code>__str__</code> is used by <code>print()</code>, <code>__repr__</code> for debugging/REPL.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>p = Point(3, 4)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>str(p) → "Point(3, 4)", repr(p) → "Point(x=3, y=4)", p.distance_from_origin() → 5.0</code></div>
  
</div>','easy',100,'python-advanced','class Point:
    def __init__(self, x, y):
        pass
    
    def __str__(self):
        pass
    
    def __repr__(self):
        pass
    
    def distance_from_origin(self):
        pass','assert "Point" in exec_globals, "Class Point not found"
Point = exec_globals["Point"]
p = Point(3, 4)
assert str(p) == "Point(3, 4)", f"__str__ wrong: {str(p)}"
assert repr(p) == "Point(x=3, y=4)", f"__repr__ wrong: {repr(p)}"
assert p.distance_from_origin() == 5.0, f"distance wrong: {p.distance_from_origin()}"
p2 = Point(0, 0)
assert p2.distance_from_origin() == 0.0, f"origin distance wrong"
exec_globals["passed_cases"] = 4
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (163,'163. Inheritance','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Define a base class <code>Shape</code> with a method <code>area()</code> that returns <code>0</code>.</p>
<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Then define two subclasses that inherit from <code>Shape</code>:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>Circle(radius)</code> — <code>area()</code> returns <code>π × radius²</code> (use <code>3.14159</code>)</li>
  <li class="py-0.5"><code>Rectangle(width, height)</code> — <code>area()</code> returns <code>width × height</code></li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Inheritance lets subclasses override methods from the parent class (method overriding).</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Circle(5).area()</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>78.53975</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">3.14159 × 5² = 78.53975</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Rectangle(4, 6).area()</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>24</code></div>
  
</div>','medium',200,'python-advanced','class Shape:
    def area(self):
        return 0

class Circle(Shape):
    def __init__(self, radius):
        pass
    
    def area(self):
        pass

class Rectangle(Shape):
    def __init__(self, width, height):
        pass
    
    def area(self):
        pass','assert "Circle" in exec_globals, "Class Circle not found"
assert "Rectangle" in exec_globals, "Class Rectangle not found"
Circle = exec_globals["Circle"]
Rectangle = exec_globals["Rectangle"]
c = Circle(5)
assert abs(c.area() - 78.53975) < 0.01, f"Circle area wrong: {c.area()}"
r = Rectangle(4, 6)
assert r.area() == 24, f"Rectangle area wrong: {r.area()}"
c2 = Circle(1)
assert abs(c2.area() - 3.14159) < 0.01, f"Unit circle area wrong: {c2.area()}"
r2 = Rectangle(3, 3)
assert r2.area() == 9, f"Square area wrong"
exec_globals["passed_cases"] = 4
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (164,'164. Class vs Instance Variables','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Define a class <code>Student</code> with:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">A <strong>class variable</strong> <code>school = "PyCode Academy"</code> — shared by all instances</li>
  <li class="py-0.5">Instance variables <code>name</code> and <code>grade</code> set in <code>__init__</code></li>
  <li class="py-0.5">A <strong>class method</strong> <code>get_school(cls)</code> decorated with <code>@classmethod</code></li>
  <li class="py-0.5">A method <code>info(self)</code> that returns <code>f"{self.name} (Grade {self.grade}) at {Student.school}"</code></li>
</ul><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Student("Alice", "A").info()</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Alice (Grade A) at PyCode Academy"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Student.get_school()</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"PyCode Academy"</code></div>
  
</div>','medium',200,'python-advanced','class Student:
    school = "PyCode Academy"
    
    def __init__(self, name, grade):
        pass
    
    @classmethod
    def get_school(cls):
        pass
    
    def info(self):
        pass','assert "Student" in exec_globals, "Class Student not found"
Student = exec_globals["Student"]
s = Student("Alice", "A")
assert s.info() == "Alice (Grade A) at PyCode Academy", f"info() wrong: {s.info()}"
assert Student.get_school() == "PyCode Academy", f"get_school() wrong"
s2 = Student("Bob", "B")
assert s2.info() == "Bob (Grade B) at PyCode Academy", f"info() wrong: {s2.info()}"
assert s.school == "PyCode Academy", f"class variable wrong"
exec_globals["passed_cases"] = 4
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (165,'165. Property Decorator','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Define a class <code>Temperature</code> with:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>__init__(self, celsius)</code> that stores the temperature</li>
  <li class="py-0.5">A <code>@property</code> <code>celsius</code> that returns the value</li>
  <li class="py-0.5">A <code>@celsius.setter</code> that raises <code>ValueError</code> if value < -273.15</li>
  <li class="py-0.5">A <code>@property</code> <code>fahrenheit</code> that returns <code>celsius × 9/5 + 32</code></li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Properties let you add validation logic to attribute access.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>t = Temperature(100)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>t.celsius → 100, t.fahrenheit → 212.0</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Temperature(-300) raises ValueError</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>ValueError raised</code></div>
  
</div>','medium',200,'python-advanced','class Temperature:
    def __init__(self, celsius):
        self.celsius = celsius  # uses the setter
    
    @property
    def celsius(self):
        pass
    
    @celsius.setter
    def celsius(self, value):
        pass
    
    @property
    def fahrenheit(self):
        pass','assert "Temperature" in exec_globals, "Class Temperature not found"
Temperature = exec_globals["Temperature"]
t = Temperature(100)
assert t.celsius == 100, f"celsius wrong: {t.celsius}"
assert t.fahrenheit == 212.0, f"fahrenheit wrong: {t.fahrenheit}"
t2 = Temperature(0)
assert t2.fahrenheit == 32.0, f"0°C fahrenheit wrong: {t2.fahrenheit}"
try:
    Temperature(-300)
    assert False, "Should have raised ValueError"
except ValueError:
    pass
exec_globals["passed_cases"] = 4
exec_globals["total_cases"] = 4',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (166,'166. Dunder Methods — Making Objects Comparable','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Define a class <code>Box</code> with:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5"><code>__init__(self, length, width, height)</code></li>
  <li class="py-0.5"><code>volume(self)</code> that returns <code>l × w × h</code></li>
  <li class="py-0.5"><code>__eq__(self, other)</code> — returns True if volumes are equal</li>
  <li class="py-0.5"><code>__lt__(self, other)</code> — returns True if self volume < other volume</li>
  <li class="py-0.5"><code>__repr__(self)</code> — returns <code>f"Box({self.l}×{self.w}×{self.h})"</code></li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Dunder (double underscore) methods let you control how Python operators work on your objects.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Box(1,2,3) == Box(6,1,1)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Both have volume 6</span></div>
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>Box(1,1,1) < Box(2,2,2)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>True</code></div>
  <div><span class="text-ink/80 font-bold font-sans mr-2">Explanation:</span> <span class="text-ink font-normal font-sans">Volume 1 < 8</span></div>
</div>','medium',200,'python-advanced','class Box:
    def __init__(self, length, width, height):
        pass
    
    def volume(self):
        pass
    
    def __eq__(self, other):
        pass
    
    def __lt__(self, other):
        pass
    
    def __repr__(self):
        pass','assert "Box" in exec_globals, "Class Box not found"
Box = exec_globals["Box"]
b1 = Box(1,2,3)
assert b1.volume() == 6, f"volume wrong: {b1.volume()}"
b2 = Box(6,1,1)
assert b1 == b2, f"__eq__ wrong: {b1} == {b2} should be True"
b3 = Box(1,1,1)
assert b3 < b1, f"__lt__ wrong: {b3} < {b1} should be True"
assert not (b1 < b3), f"__lt__ wrong: {b1} < {b3} should be False"
assert isinstance(repr(b1), str), f"__repr__ should return str"
exec_globals["passed_cases"] = 5
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (167,'167. Exception Handling','<p class="mb-2 leading-relaxed text-sm font-normal text-ink font-sans">Write a function <code>safe_divide(a, b)</code> that uses <code>try/except/finally</code> to:</p>
<ul class="list-disc pl-5 mb-4 text-xs text-ink space-y-1.5 font-normal font-sans">
  <li class="py-0.5">Return <code>a / b</code> if b is non-zero</li>
  <li class="py-0.5">Catch <code>ZeroDivisionError</code> and return <code>"Error: Cannot divide by zero"</code></li>
  <li class="py-0.5">Catch <code>TypeError</code> and return <code>"Error: Invalid types"</code></li>
</ul>
<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Also write a function <code>safe_index(lst, idx)</code> that returns <code>lst[idx]</code> or <code>"Error: Index out of range"</code> for <code>IndexError</code>.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>safe_divide(10, 2)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>5.0</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>safe_divide(10, 0)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Error: Cannot divide by zero"</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>safe_index([1,2,3], 10)</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>"Error: Index out of range"</code></div>
  
</div>','medium',200,'python-advanced','def safe_divide(a, b):
    # Handle ZeroDivisionError and TypeError
    pass

def safe_index(lst, idx):
    # Handle IndexError
    pass','assert "safe_divide" in exec_globals, "Function safe_divide not found"
assert "safe_index" in exec_globals, "Function safe_index not found"
sd = exec_globals["safe_divide"]
si = exec_globals["safe_index"]
assert sd(10, 2) == 5.0, f"sd(10,2) wrong: {sd(10,2)}"
assert sd(10, 0) == "Error: Cannot divide by zero", f"ZeroDivisionError not caught"
assert sd("a", 2) == "Error: Invalid types", f"TypeError not caught"
assert si([1,2,3], 1) == 2, f"si wrong: {si([1,2,3],1)}"
assert si([1,2,3], 10) == "Error: Index out of range", f"IndexError not caught"
exec_globals["passed_cases"] = 5
exec_globals["total_cases"] = 5',NULL);

INSERT INTO public.coding_questions (id,title,description,difficulty,points,category,starter_code,verification_script,dataset_name)
VALUES (168,'168. Pascal''s Triangle','<p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">Given an integer n, print Pascal''s Triangle up to n rows. Pascal''s Triangle is a numerical triangle where each number is the sum of the two numbers directly above it.</p><p class="mb-4 leading-relaxed text-sm font-normal text-ink font-sans">To keep the shape centered and symmetric, format each row with appropriate leading spaces, and separate adjacent numbers in a row by a single space. If n is less than or equal to 0, print nothing.</p><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 1</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 4</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <div class="mt-2"><pre class="bg-surface-soft p-3.5 rounded-2xl font-mono text-xs text-ink whitespace-pre my-2 border border-hairline overflow-x-auto leading-normal select-all">1
  1 1
 1 2 1
1 3 3 1</pre></div></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 2</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 1</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>1</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Example 3</h3>
<div class="border-l-2 border-primary/40 dark:border-primary/50 pl-4 py-1.5 space-y-1.5 my-3.5 font-mono text-xs text-ink font-normal">
  <div><span class="text-ink/80 font-bold font-sans mr-2">Input:</span> <code>n = 0</code></div>
  <div><span class="text-primary font-bold font-sans mr-2">Output:</span> <code>(Empty Output)</code></div>
  
</div><h3 class="text-xs font-extrabold text-ink uppercase tracking-widest mb-2 mt-6">Constraints / Edge Cases</h3>
<ul class="list-disc pl-5 text-xs text-ink space-y-1.5 font-normal">
  <li><code>n = 1 (Solitary cell showing only the top number 1)</code></li><li><code>n = 5 (Checks proper alignment and values for higher rows)</code></li><li><code>n = -3 (Negative boundary safety check)</code></li>
</ul>','medium',200,'python-basics','def pascal_triangle(n):
    # Write your code here
    pass','def ref_impl(*args):
    n = args[0]
    if n <= 0: return ""
    lines = []
    row = [1]
    for i in range(n):
        row_str = " ".join(str(x) for x in row)
        spaces = " " * (n - 1 - i)
        lines.append(spaces + row_str)
        next_row = [1]
        for j in range(len(row) - 1):
            next_row.append(row[j] + row[j+1])
        next_row.append(1)
        row = next_row
    return "\n".join(lines)

assert "pascal_triangle" in exec_globals, "Function pascal_triangle not found"
fn = exec_globals["pascal_triangle"]

# Show live output for 2 sample sizes
print("--- YOUR PATTERN FOR n=4 ---")
try:
    fn(4)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")
print("--- YOUR PATTERN FOR n=5 ---")
try:
    fn(5)
except Exception as e:
    print(f"Error: {e}")
print("----------------------------")

def capture(func, n):
    import io, sys
    buf = io.StringIO()
    old = sys.stdout
    sys.stdout = buf
    try:
        func(n)
    finally:
        sys.stdout = old
    return buf.getvalue()

def normalize(s):
    lines = [l.rstrip() for l in s.splitlines()]
    while lines and not lines[-1]: lines.pop()
    while lines and not lines[0]: lines.pop(0)
    return lines

test_cases = [1, 3, 5, -2]
passed = 0
for tc in test_cases:
    exp = normalize(ref_impl(tc))
    got = normalize(capture(fn, tc))
    assert exp == got, f"Mismatch n={tc}\nExpected:\n" + "\n".join(exp) + "\nGot:\n" + "\n".join(got)
    passed += 1
exec_globals["passed_cases"] = passed
exec_globals["total_cases"] = 4',NULL);

COMMIT;
