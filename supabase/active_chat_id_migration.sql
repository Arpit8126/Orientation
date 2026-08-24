-- Migration to add active_chat_id to profiles table to track which chat the user is actively viewing
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS active_chat_id TEXT DEFAULT NULL;
