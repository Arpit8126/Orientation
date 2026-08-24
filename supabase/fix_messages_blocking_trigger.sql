-- =========================================================================
-- Fix messages table blocking trigger (Silently ignores/reverts all updates)
-- Run this in your Supabase SQL Editor.
-- =========================================================================

-- 1. Run this first to see what triggers are defined on your messages table:
-- SELECT trigger_name, action_statement, action_timing, event_manipulation
-- FROM information_schema.triggers
-- WHERE event_object_table = 'messages';

-- 2. Drop the trigger that intercepts UPDATE operations on messages.
-- It might be named 'protect_message_columns', 'prevent_message_updates',
-- or 'messages_protect_metadata' depending on how it was created.
DROP TRIGGER IF EXISTS protect_message_columns ON public.messages;
DROP TRIGGER IF EXISTS prevent_message_updates ON public.messages;
DROP TRIGGER IF EXISTS messages_protect_metadata ON public.messages;

-- Also verify if there is any custom BEFORE UPDATE trigger on public.messages
-- that reverts changes and drop it by name.
