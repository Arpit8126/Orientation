-- =========================================================================
-- Fix messages update policy (Allows marking messages as read)
-- Run this in your Supabase SQL Editor.
-- =========================================================================

-- 1. Create policy to allow recipients to update messages (to set read_at status)
DROP POLICY IF EXISTS "Recipient can mark messages as read" ON public.messages;
CREATE POLICY "Recipient can mark messages as read" ON public.messages 
    FOR UPDATE TO authenticated 
    USING (recipient_id = auth.uid())
    WITH CHECK (recipient_id = auth.uid());
