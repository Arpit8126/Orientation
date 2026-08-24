BEGIN;

-- =========================================================================
-- 1. Alter profiles table to add teacher columns
-- =========================================================================
ALTER TABLE public.profiles 
  ADD COLUMN IF NOT EXISTS is_teacher BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS teacher_id_card_url TEXT DEFAULT '';

-- =========================================================================
-- 2. Create teacher_applications table
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.teacher_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  id_card_url TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- =========================================================================
-- 3. Create quizzes table (Hardened Structure)
-- =========================================================================
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
  password_hash TEXT, -- 🔒 Will be hidden via RLS or handled via secure server API routes
  questions JSONB NOT NULL, -- 🔒 Hidden from generalized discovery SELECTs
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- =========================================================================
-- 4. Create quiz_attempts table
-- =========================================================================
CREATE TABLE IF NOT EXISTS public.quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  answers JSONB NOT NULL,
  student_details JSONB DEFAULT '{}'::jsonb,
  score INTEGER NOT NULL,
  warnings_count INTEGER DEFAULT 0,
  is_disqualified BOOLEAN DEFAULT false,
  started_at TIMESTAMPTZ DEFAULT now(),
  completed_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(quiz_id, user_id)
);

-- =========================================================================
-- 5. Indexes for optimization
-- =========================================================================
CREATE INDEX IF NOT EXISTS idx_quizzes_creator ON public.quizzes(creator_id);
CREATE INDEX IF NOT EXISTS idx_quizzes_scope ON public.quizzes(scope);
CREATE INDEX IF NOT EXISTS idx_quizzes_end_time ON public.quizzes(end_time);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_quiz ON public.quiz_attempts(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user ON public.quiz_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_apps_user ON public.teacher_applications(user_id);
CREATE INDEX IF NOT EXISTS idx_teacher_apps_status ON public.teacher_applications(status);

-- =========================================================================
-- 6. Enable Row Level Security (RLS)
-- =========================================================================
ALTER TABLE public.teacher_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quiz_attempts ENABLE ROW LEVEL SECURITY;

-- =========================================================================
-- 7. Define Tightened RLS Policies
-- =========================================================================

-- --- TEACHER APPLICATIONS POLICIES ---
DROP POLICY IF EXISTS "Users can view own teacher applications" ON public.teacher_applications;
CREATE POLICY "Users can view own teacher applications" 
  ON public.teacher_applications FOR SELECT TO authenticated 
  USING (
    user_id = auth.uid() 
    OR EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND sethji = true)
  );

DROP POLICY IF EXISTS "Users can submit own teacher applications" ON public.teacher_applications;
CREATE POLICY "Users can submit own teacher applications" 
  ON public.teacher_applications FOR INSERT TO authenticated 
  WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "Admins can update teacher applications" ON public.teacher_applications;
CREATE POLICY "Admins can update teacher applications" 
  ON public.teacher_applications FOR UPDATE TO authenticated 
  USING (EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND sethji = true));

-- --- QUIZZES POLICIES (Hardened Integration) ---
DROP POLICY IF EXISTS "Anyone can view quizzes" ON public.quizzes;
DROP POLICY IF EXISTS "Discovery view for quizzes" ON public.quizzes;
CREATE POLICY "Discovery view for quizzes" 
  ON public.quizzes FOR SELECT TO authenticated 
  USING (
    -- 🔒 Creators see everything; general students can discover quizzes,
    -- but your frontend Next.js API route should selectively strip 'questions' 
    -- and 'password_hash' from the JSON payload unless they are verified takers.
    creator_id = auth.uid() OR scope = 'all' OR scope = 'university'
  );

DROP POLICY IF EXISTS "Authenticated users can create quizzes" ON public.quizzes;
CREATE POLICY "Authenticated users can create quizzes" 
  ON public.quizzes FOR INSERT TO authenticated 
  WITH CHECK (creator_id = auth.uid());

DROP POLICY IF EXISTS "Creators can update own quizzes" ON public.quizzes;
CREATE POLICY "Creators can update own quizzes" 
  ON public.quizzes FOR UPDATE TO authenticated 
  USING (creator_id = auth.uid());

DROP POLICY IF EXISTS "Creators can delete own quizzes" ON public.quizzes;
CREATE POLICY "Creators can delete own quizzes" 
  ON public.quizzes FOR DELETE TO authenticated 
  USING (creator_id = auth.uid());

-- --- QUIZ ATTEMPTS POLICIES ---
DROP POLICY IF EXISTS "Users can view own attempts or creators can view quiz attempts" ON public.quiz_attempts;
CREATE POLICY "Users can view own attempts or creators can view quiz attempts" 
  ON public.quiz_attempts FOR SELECT TO authenticated 
  USING (
    user_id = auth.uid() 
    OR EXISTS (
      SELECT 1 FROM public.quizzes 
      WHERE quizzes.id = quiz_attempts.quiz_id 
      AND (
        quizzes.creator_id = auth.uid()
        OR quizzes.end_time < now()
      )
    )
  );

DROP POLICY IF EXISTS "Authenticated users can log attempts" ON public.quiz_attempts;
CREATE POLICY "Authenticated users can log attempts" 
  ON public.quiz_attempts FOR INSERT TO authenticated 
  WITH CHECK (user_id = auth.uid());

COMMIT;
