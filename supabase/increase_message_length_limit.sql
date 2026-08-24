-- =========================================================================
-- Increase message length check constraint limit ONLY for Cartel Cypher AI
-- Run this in your Supabase SQL Editor.
-- =========================================================================

-- 1. Drop the existing check constraint
ALTER TABLE public.messages DROP CONSTRAINT IF EXISTS messages_message_text_check;

-- 2. Add a check constraint that restricts normal messages to 1000 characters,
-- but allows the Cartel Cypher AI bot user (UUID: d2a14a8c-9d93-491d-8b96-b978276d8305) to send longer messages.
ALTER TABLE public.messages ADD CONSTRAINT messages_message_text_check 
CHECK (
  char_length(message_text) <= 1000 
  OR 
  sender_id = 'd2a14a8c-9d93-491d-8b96-b978276d8305'
);
