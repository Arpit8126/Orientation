-- =========================================================================
-- Increase message length check constraint limit for CodeShastra AI
-- Run this in your Supabase SQL Editor.
-- =========================================================================

-- 1. Drop the existing check constraint
ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_message_text_check;

-- 2. Add a check constraint that restricts normal messages to 1000 characters,
-- but allows Cartel Cypher AI (d2a14a8c-9d93-491d-8b96-b978276d8305)
-- and CodeShastra AI (c0de5ba5-72a1-4a8c-b978-26b0ae6b4428) to send longer messages.
ALTER TABLE public.messages ADD CONSTRAINT messages_message_text_check 
CHECK (
  char_length(message_text) <= 1000 
  OR 
  sender_id = 'd2a14a8c-9d93-491d-8b96-b978276d8305'
  OR
  sender_id = 'c0de5ba5-72a1-4a8c-b978-26b0ae6b4428'
);
