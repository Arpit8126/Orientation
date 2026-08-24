-- ============================================================
-- Repair Database Schema & RLS Policies for 'tea_comments'
-- Run this in your Supabase SQL Editor to unify columns & policy rules
-- ============================================================

-- 1. Drop existing policies to prevent conflicts
DROP POLICY IF EXISTS "Auth tea_comments insert" ON public.tea_comments;
DROP POLICY IF EXISTS "Auth tea_comments delete" ON public.tea_comments;
DROP POLICY IF EXISTS "Public tea_comments read" ON public.tea_comments;

-- 2. Conditionally rename 'author_id' to 'user_id' if it exists in the schema
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_schema = 'public' 
      AND table_name = 'tea_comments' 
      AND column_name = 'author_id'
  ) THEN
    ALTER TABLE public.tea_comments RENAME COLUMN author_id TO user_id;
  END IF;
END $$;

-- 3. Ensure 'is_pinned' and 'parent_id' columns exist on tea_comments
ALTER TABLE public.tea_comments ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE public.tea_comments ADD COLUMN IF NOT EXISTS parent_id UUID REFERENCES public.tea_comments(id) ON DELETE CASCADE;

-- 4. Re-create the correct policies referencing 'user_id'
CREATE POLICY "Public tea_comments read" 
  ON public.tea_comments FOR SELECT 
  USING (true);

CREATE POLICY "Auth tea_comments insert" 
  ON public.tea_comments FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Auth tea_comments delete" 
  ON public.tea_comments FOR DELETE 
  USING (auth.uid() = user_id);
