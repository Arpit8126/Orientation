-- =========================================================================
-- Fix Leaderboard RLS Policy for quiz_attempts
-- Run this in your Supabase SQL Editor to allow students to view the quiz leaderboard
-- after the quiz timeframe has ended.
-- =========================================================================

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
