-- =========================================================================
-- Unified Schema Migration for PyCode Project
-- Run this script inside the SQL Editor of your NEW Supabase Database.
-- =========================================================================

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Create Universities Table
CREATE TABLE IF NOT EXISTS public.universities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  domain TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Create Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY, -- Maps directly to auth.users.id
  username TEXT UNIQUE NOT NULL,
  full_name TEXT DEFAULT NULL,
  bio TEXT DEFAULT NULL,
  avatar_url TEXT DEFAULT NULL,
  is_banned BOOLEAN DEFAULT false,
  sethji BOOLEAN DEFAULT false, -- Set true manually for Admin users
  is_onboarded BOOLEAN DEFAULT false,
  is_teacher BOOLEAN DEFAULT false,
  teacher_id_card_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Automatic Profile Creation Trigger on Sign Up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, is_onboarded)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'username', 'user_' || substr(new.id::text, 1, 8)),
    false
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 4. Create Teacher Applications Table
CREATE TABLE IF NOT EXISTS public.teacher_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  institution TEXT NOT NULL,
  id_card_url TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  rejection_notes TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Create Quizzes Table
CREATE TABLE IF NOT EXISTS public.quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  creator_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  is_teacher_quiz BOOLEAN DEFAULT false,
  scope TEXT NOT NULL DEFAULT 'all' CHECK (scope IN ('all', 'university', 'private')),
  university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
  difficulty TEXT DEFAULT 'easy' CHECK (difficulty IN ('easy', 'moderate', 'hard')),
  required_inputs JSONB DEFAULT '[]'::jsonb,
  password_hash TEXT DEFAULT NULL,
  questions JSONB DEFAULT '[]'::jsonb,
  is_coding_quiz BOOLEAN DEFAULT false,
  coding_question_ids INTEGER[] DEFAULT '{}',
  duration_minutes INTEGER DEFAULT 60,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. Create Quiz Attempts Table
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID REFERENCES public.quizzes(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  answers JSONB DEFAULT '{}'::jsonb,
  student_details JSONB DEFAULT '{}'::jsonb,
  score INTEGER DEFAULT 0,
  score_percentage INTEGER DEFAULT 0,
  is_disqualified BOOLEAN DEFAULT false,
  warnings_count INTEGER DEFAULT 0,
  started_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ DEFAULT NULL
);

-- 7. Create Coding Questions Table
CREATE TABLE IF NOT EXISTS public.coding_questions (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  points INTEGER NOT NULL DEFAULT 100,
  category TEXT NOT NULL CHECK (category IN ('python-basics', 'python-advanced', 'numpy', 'pandas', 'matplotlib-seaborn')),
  starter_code TEXT NOT NULL,
  verification_script TEXT NOT NULL,
  dataset_name TEXT DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. Create Coding Submissions Table
CREATE TABLE IF NOT EXISTS public.coding_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  question_id INTEGER NOT NULL REFERENCES public.coding_questions(id) ON DELETE CASCADE,
  quiz_attempt_id UUID REFERENCES public.quiz_attempts(id) ON DELETE CASCADE,
  submitted_code TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('accepted', 'wrong_answer', 'runtime_error', 'timeout')),
  score_points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 9. Enable Row Level Security (RLS)
ALTER TABLE public.universities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teacher_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coding_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.coding_submissions ENABLE ROW LEVEL SECURITY;

-- 10. Configure Base RLS Policies
CREATE POLICY "Allow public select for universities" ON public.universities FOR SELECT USING (true);
CREATE POLICY "Allow public select for profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Allow update for owners on profiles" ON public.profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Allow select for teachers/admins/owners on applications" ON public.teacher_applications FOR SELECT TO authenticated
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND sethji = true));
CREATE POLICY "Allow insert for authenticated users on applications" ON public.teacher_applications FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Allow update for admins on applications" ON public.teacher_applications FOR UPDATE TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND sethji = true));

CREATE POLICY "Allow select for all authenticated on quizzes" ON public.quizzes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow write for teachers/admins on quizzes" ON public.quizzes FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND (is_teacher = true OR sethji = true)));

CREATE POLICY "Allow select/write for owners on attempts" ON public.quiz_attempts FOR ALL TO authenticated
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND (is_teacher = true OR sethji = true)));
CREATE POLICY "Allow select/write for teachers/admins on attempts" ON public.quiz_attempts FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND (is_teacher = true OR sethji = true)));

CREATE POLICY "Allow select for all authenticated on coding_questions" ON public.coding_questions FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow write for teachers/admins on coding_questions" ON public.coding_questions FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND (is_teacher = true OR sethji = true)));

CREATE POLICY "Allow select/write for owners on coding_submissions" ON public.coding_submissions FOR ALL TO authenticated
  USING (auth.uid() = user_id OR EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND (is_teacher = true OR sethji = true)));

-- 11. Create check_email_exists Helper Function (Security Definer)
CREATE OR REPLACE FUNCTION public.check_email_exists(email_to_check TEXT)
RETURNS BOOLEAN
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM auth.users WHERE email = LOWER(TRIM(email_to_check))
  );
END;
$$ LANGUAGE plpgsql;

-- 12. Create get_email_by_username Helper Function (Security Definer)
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
