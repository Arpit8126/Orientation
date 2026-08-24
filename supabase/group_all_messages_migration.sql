-- Add All Messages notification columns to notification_preferences
ALTER TABLE public.notification_preferences 
ADD COLUMN IF NOT EXISTS notify_all_messages BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE public.notification_preferences
ADD COLUMN IF NOT EXISTS notify_all_messages_website BOOLEAN NOT NULL DEFAULT FALSE;
