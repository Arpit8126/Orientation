-- ============================================================
-- POOKIZ — Feedback and Message Reactions Migration Script
-- Run this in your Supabase SQL Editor
-- ============================================================

-- 1. Create Feedbacks Table
CREATE TABLE IF NOT EXISTS public.feedbacks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS for Feedbacks
ALTER TABLE public.feedbacks ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Feedbacks
DROP POLICY IF EXISTS "Users can insert own feedback" ON public.feedbacks;
CREATE POLICY "Users can insert own feedback" ON public.feedbacks 
  FOR INSERT TO authenticated WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "Admins can view all feedback" ON public.feedbacks;
CREATE POLICY "Admins can view all feedback" ON public.feedbacks
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.profiles 
      WHERE id = (SELECT auth.uid()) 
      AND sethji = true
    )
  );

-- 2. Create Message Reactions Table (Unique per user/message)
CREATE TABLE IF NOT EXISTS public.message_reactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_id UUID NOT NULL REFERENCES public.messages(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  emoji TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(message_id, user_id)
);

-- Enable RLS for Message Reactions
ALTER TABLE public.message_reactions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Message Reactions
DROP POLICY IF EXISTS "Anyone can view message reactions" ON public.message_reactions;
CREATE POLICY "Anyone can view message reactions" ON public.message_reactions
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Users can insert own reaction" ON public.message_reactions;
CREATE POLICY "Users can insert own reaction" ON public.message_reactions
  FOR INSERT TO authenticated WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "Users can update own reaction" ON public.message_reactions;
CREATE POLICY "Users can update own reaction" ON public.message_reactions
  FOR UPDATE TO authenticated USING (user_id = (SELECT auth.uid())) WITH CHECK (user_id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "Users can delete own reaction" ON public.message_reactions;
CREATE POLICY "Users can delete own reaction" ON public.message_reactions
  FOR DELETE TO authenticated USING (user_id = (SELECT auth.uid()));

-- 3. Enable Realtime publication for these tables
ALTER PUBLICATION supabase_realtime ADD TABLE public.feedbacks;
ALTER PUBLICATION supabase_realtime ADD TABLE public.message_reactions;
