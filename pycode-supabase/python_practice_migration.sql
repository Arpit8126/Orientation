BEGIN;

-- =========================================================================
-- 1. Create coding_questions table
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.coding_questions (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  points INTEGER NOT NULL DEFAULT 100,
  category TEXT NOT NULL CHECK (category IN ('python-basics', 'python-advanced', 'numpy', 'pandas', 'matplotlib-seaborn')),
  starter_code TEXT NOT NULL,
  verification_script TEXT NOT NULL, -- Hidden validation python code
  dataset_name TEXT DEFAULT NULL, -- Null if none, e.g. 'titanic.csv', 'superstore.csv'
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =========================================================================
-- 2. Create coding_submissions table
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.coding_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE, -- Nullable for guest runs
  question_id INTEGER NOT NULL REFERENCES public.coding_questions(id) ON DELETE CASCADE,
  quiz_attempt_id UUID REFERENCES public.quiz_attempts(id) ON DELETE CASCADE, -- Nullable for practice
  code TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('accepted', 'wrong_answer', 'runtime_error', 'timeout')),
  output TEXT,
  passed_cases INTEGER NOT NULL DEFAULT 0,
  total_cases INTEGER NOT NULL DEFAULT 0,
  visualization_base64 TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =========================================================================
-- 3. Modify teacher_applications to add rejection_notes
-- =========================================================================
ALTER TABLE public.teacher_applications
  ADD COLUMN IF NOT EXISTS rejection_notes TEXT DEFAULT '';

-- =========================================================================
-- 4. Modify quizzes to add coding quiz support
-- =========================================================================
ALTER TABLE public.quizzes
  ADD COLUMN IF NOT EXISTS is_coding_quiz BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS coding_question_ids INTEGER[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS duration_minutes INTEGER DEFAULT 60;

-- =========================================================================
-- 5. Enable Row Level Security (RLS)
-- =========================================================================
ALTER TABLE public.coding_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coding_submissions ENABLE ROW LEVEL SECURITY;

-- =========================================================================
-- 6. RLS Policies
-- =========================================================================

-- --- CODING QUESTIONS POLICIES ---

-- Allow read access to questions for authenticated users (both students and teachers)
DROP POLICY IF EXISTS "Allow select for authenticated users" ON public.coding_questions;
CREATE POLICY "Allow select for authenticated users"
  ON public.coding_questions FOR SELECT TO authenticated
  USING (true);

-- Allow write/update/delete access ONLY for teachers or admins
DROP POLICY IF EXISTS "Allow write for teachers/admins" ON public.coding_questions;
CREATE POLICY "Allow write for teachers/admins"
  ON public.coding_questions FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND (is_teacher = true OR sethji = true)
    )
  );

-- --- CODING SUBMISSIONS POLICIES ---

-- Students can read their own submissions
-- Teachers can read submissions for quizzes they created
DROP POLICY IF EXISTS "Allow select for owner and quiz creator" ON public.coding_submissions;
CREATE POLICY "Allow select for owner and quiz creator"
  ON public.coding_submissions FOR SELECT TO authenticated
  USING (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.quiz_attempts qa
      JOIN public.quizzes q ON q.id = qa.quiz_id
      WHERE qa.id = coding_submissions.quiz_attempt_id
      AND q.creator_id = auth.uid()
    )
  );

-- Allow students to insert their own submissions
DROP POLICY IF EXISTS "Allow insert for owner" ON public.coding_submissions;
CREATE POLICY "Allow insert for owner"
  ON public.coding_submissions FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

-- =========================================================================
-- 7. Add get_email_by_username helper (Security Definer)
-- =========================================================================
CREATE OR REPLACE FUNCTION public.get_email_by_username(username_to_search TEXT)
RETURNS TEXT
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
  resolved_email TEXT;
BEGIN
  SELECT email INTO resolved_email
  FROM auth.users u
  JOIN public.profiles p ON p.id = u.id
  WHERE p.username = LOWER(TRIM(username_to_search));
  
  RETURN resolved_email;
END;
$$ LANGUAGE plpgsql;

COMMIT;
