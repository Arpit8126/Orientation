-- 1. Grant base SQL permissions to the public roles (anon and authenticated)
GRANT SELECT ON public.coding_questions TO anon, authenticated;
GRANT SELECT ON public.quizzes TO anon, authenticated;

-- Grant attempts and submissions access so guest attempts can be registered
GRANT SELECT, INSERT, UPDATE ON public.quiz_attempts TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON public.coding_submissions TO anon, authenticated;

-- 2. Drop existing policies to prevent "already exists" errors
DROP POLICY IF EXISTS "Allow select for all authenticated on coding_questions" ON public.coding_questions;
DROP POLICY IF EXISTS "Allow public select for coding_questions" ON public.coding_questions;

DROP POLICY IF EXISTS "Allow select for all authenticated on quizzes" ON public.quizzes;
DROP POLICY IF EXISTS "Allow public select for quizzes" ON public.quizzes;

-- 3. Create public select policies for everyone (including guest users)
CREATE POLICY "Allow public select for coding_questions" ON public.coding_questions FOR SELECT USING (true);
CREATE POLICY "Allow public select for quizzes" ON public.quizzes FOR SELECT USING (true);
