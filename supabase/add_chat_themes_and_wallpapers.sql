-- =========================================================================
-- Add Chat Themes & Wallpapers Schema Modifications
-- Run this in your Supabase SQL Editor.
-- =========================================================================

-- 1. Add theme column to public.friends (Shared DM Theme)
ALTER TABLE public.friends ADD COLUMN IF NOT EXISTS theme TEXT DEFAULT NULL;

-- 2. Add theme and wallpaper columns to public.groups (Shared Group settings)
ALTER TABLE public.groups ADD COLUMN IF NOT EXISTS theme TEXT DEFAULT NULL;
ALTER TABLE public.groups ADD COLUMN IF NOT EXISTS wallpaper_url TEXT DEFAULT NULL;

-- 3. Add default_wallpaper column to public.profiles (Central user preference)
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS default_wallpaper TEXT DEFAULT NULL;

-- 4. Create public.user_chat_settings (For personal overrides like DM wallpapers or System Group settings)
CREATE TABLE IF NOT EXISTS public.user_chat_settings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  chat_type TEXT NOT NULL CHECK (chat_type IN ('dm', 'group')),
  chat_id UUID NOT NULL, -- friends.id for DMs, groups.id for Groups
  theme TEXT DEFAULT NULL, -- Personal override (used in system groups)
  wallpaper_url TEXT DEFAULT NULL, -- Personal wallpaper override (used in DMs)
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, chat_type, chat_id)
);

-- Enable RLS and define policy
ALTER TABLE public.user_chat_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users can manage own chat settings" ON public.user_chat_settings;
CREATE POLICY "Users can manage own chat settings" ON public.user_chat_settings
  FOR ALL TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Enable Realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_chat_settings;

-- 5. Fix friends table UPDATE policy and add trigger to allow theme changes while preventing self-acceptance exploit
DROP POLICY IF EXISTS "Users can update their friend requests" ON public.friends;
DROP POLICY IF EXISTS "Users can update their friendships" ON public.friends;

CREATE POLICY "Users can update their friendships" ON public.friends
  FOR UPDATE TO authenticated
  USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid())
  WITH CHECK (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

CREATE OR REPLACE FUNCTION public.protect_friends_status()
RETURNS TRIGGER AS $$
BEGIN
  -- Prevent changing friendship members (hijack protection)
  IF NEW.user_id_1 <> OLD.user_id_1 OR NEW.user_id_2 <> OLD.user_id_2 THEN
    RAISE EXCEPTION 'Cannot modify friend user IDs';
  END IF;

  -- Prevent reverting accepted friendship back to pending
  IF OLD.status = 'accepted' AND NEW.status = 'pending' THEN
    RAISE EXCEPTION 'Cannot revert an accepted friendship back to pending';
  END IF;

  -- Only user_id_2 (recipient) can accept a pending request (blocks self-acceptance exploit)
  IF NEW.status = 'accepted' AND OLD.status = 'pending' THEN
    IF auth.uid() <> OLD.user_id_2 THEN
      RAISE EXCEPTION 'Only the recipient can accept a friend request';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trg_protect_friends_status ON public.friends;
CREATE TRIGGER trg_protect_friends_status
  BEFORE UPDATE ON public.friends
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_friends_status();


