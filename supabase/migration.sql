-- ============================================================
-- POOKIZ — University Social Network
-- Complete PostgreSQL Migration Script
-- Run this in Supabase SQL Editor
-- ============================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- 1. CREATE TABLES (First step to prevent reference errors)
-- ============================================================

-- PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160),
  avatar_url TEXT DEFAULT '',
  university_name TEXT DEFAULT 'GLA University',
  course TEXT DEFAULT '',
  dob DATE,
  city TEXT DEFAULT '',
  is_banned BOOLEAN DEFAULT false,
  sethji BOOLEAN DEFAULT false,
  is_onboarded BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- GROUPS TABLE
CREATE TABLE IF NOT EXISTS public.groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  bio TEXT DEFAULT '' CHECK (char_length(bio) <= 160),
  description TEXT DEFAULT '',
  creator_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  privacy_type TEXT NOT NULL DEFAULT 'public' CHECK (privacy_type IN ('public', 'university_only', 'password_protected')),
  password_hash TEXT,
  is_system_group BOOLEAN DEFAULT false,
  avatar_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- GROUP MEMBERS TABLE
CREATE TABLE IF NOT EXISTS public.group_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  group_id UUID NOT NULL REFERENCES public.groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('member', 'mod', 'coadmin', 'admin')),
  is_group_banned BOOLEAN DEFAULT false,
  joined_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(group_id, user_id)
);

-- MESSAGES TABLE
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
  message_text TEXT NOT NULL CHECK (char_length(message_text) <= 1000),
  is_anonymous BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT message_target CHECK (
    (recipient_id IS NOT NULL AND group_id IS NULL) OR
    (recipient_id IS NULL AND group_id IS NOT NULL)
  )
);

-- FRIENDS TABLE
CREATE TABLE IF NOT EXISTS public.friends (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id_1 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  user_id_2 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted')),
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT no_self_friend CHECK (user_id_1 != user_id_2),
  UNIQUE(user_id_1, user_id_2)
);

-- BLOCKS TABLE
CREATE TABLE IF NOT EXISTS public.blocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  blocker_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  blocked_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT no_self_block CHECK (blocker_id != blocked_id),
  UNIQUE(blocker_id, blocked_id)
);

-- REPORTS TABLE
CREATE TABLE IF NOT EXISTS public.reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reporter_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reported_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recipient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_broadcast BOOLEAN DEFAULT false,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- 2. CREATE INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_profiles_username ON public.profiles(username);
CREATE INDEX IF NOT EXISTS idx_profiles_is_banned ON public.profiles(is_banned);
CREATE INDEX IF NOT EXISTS idx_groups_privacy ON public.groups(privacy_type);
CREATE INDEX IF NOT EXISTS idx_groups_system ON public.groups(is_system_group);
CREATE INDEX IF NOT EXISTS idx_gm_group ON public.group_members(group_id);
CREATE INDEX IF NOT EXISTS idx_gm_user ON public.group_members(user_id);
CREATE INDEX IF NOT EXISTS idx_gm_role ON public.group_members(role);
CREATE INDEX IF NOT EXISTS idx_messages_group ON public.messages(group_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_sender ON public.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_messages_recipient ON public.messages(recipient_id);
CREATE INDEX IF NOT EXISTS idx_messages_dm ON public.messages(sender_id, recipient_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_friends_user1 ON public.friends(user_id_1, status);
CREATE INDEX IF NOT EXISTS idx_friends_user2 ON public.friends(user_id_2, status);
CREATE INDEX IF NOT EXISTS idx_blocks_blocker ON public.blocks(blocker_id);
CREATE INDEX IF NOT EXISTS idx_blocks_blocked ON public.blocks(blocked_id);
CREATE INDEX IF NOT EXISTS idx_reports_status ON public.reports(status);
CREATE INDEX IF NOT EXISTS idx_reports_reporter ON public.reports(reporter_id);
CREATE INDEX IF NOT EXISTS idx_notif_recipient ON public.notifications(recipient_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notif_broadcast ON public.notifications(is_broadcast, created_at DESC);

-- ============================================================
-- 3. ENABLE ROW LEVEL SECURITY & DEFINE POLICIES
-- ============================================================

-- Profiles Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view non-banned profiles" ON public.profiles FOR SELECT USING (is_banned = false OR id = (SELECT auth.uid()));
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (id = (SELECT auth.uid())) WITH CHECK (id = (SELECT auth.uid()));
CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK (id = (SELECT auth.uid()));

-- Groups Security
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view public groups" ON public.groups FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create groups" ON public.groups FOR INSERT TO authenticated WITH CHECK (creator_id = (SELECT auth.uid()));
CREATE POLICY "Group admins can update groups" ON public.groups FOR UPDATE TO authenticated USING (
  creator_id = (SELECT auth.uid())
  OR EXISTS (
    SELECT 1 FROM public.group_members
    WHERE group_id = groups.id
    AND user_id = (SELECT auth.uid())
    AND role IN ('admin', 'coadmin', 'mod')
  )
);

-- Group Members Security
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Members can view group memberships" ON public.group_members FOR SELECT TO authenticated USING (true);
CREATE POLICY "Authenticated can join groups" ON public.group_members FOR INSERT TO authenticated WITH CHECK (user_id = (SELECT auth.uid()));
CREATE POLICY "Staff can update memberships" ON public.group_members FOR UPDATE TO authenticated USING (
  EXISTS (
    SELECT 1 FROM public.group_members gm
    WHERE gm.group_id = group_members.group_id
    AND gm.user_id = (SELECT auth.uid())
    AND gm.role IN ('admin', 'coadmin', 'mod')
  )
);
CREATE POLICY "Admins can remove members" ON public.group_members FOR DELETE TO authenticated USING (
  user_id = (SELECT auth.uid())
  OR EXISTS (
    SELECT 1 FROM public.group_members gm
    WHERE gm.group_id = group_members.group_id
    AND gm.user_id = (SELECT auth.uid())
    AND gm.role IN ('admin', 'coadmin')
  )
);

-- Messages Security
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view group messages they belong to" ON public.messages FOR SELECT TO authenticated USING (
  (group_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM public.group_members
    WHERE group_id = messages.group_id
    AND user_id = (SELECT auth.uid())
    AND is_group_banned = false
  ))
  OR (recipient_id IS NOT NULL AND (
    sender_id = (SELECT auth.uid()) OR recipient_id = (SELECT auth.uid())
  ))
);
CREATE POLICY "Members can send group messages" ON public.messages FOR INSERT TO authenticated WITH CHECK (
  sender_id = (SELECT auth.uid())
  AND (
    (group_id IS NOT NULL AND EXISTS (
      SELECT 1 FROM public.group_members
      WHERE group_id = messages.group_id
      AND user_id = (SELECT auth.uid())
      AND is_group_banned = false
    ))
    OR (recipient_id IS NOT NULL AND sender_id = (SELECT auth.uid()))
  )
);

-- Friends Security
ALTER TABLE public.friends ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their friendships" ON public.friends FOR SELECT TO authenticated USING (status = 'accepted' OR user_id_1 = (SELECT auth.uid()) OR user_id_2 = (SELECT auth.uid()));
CREATE POLICY "Users can send friend requests" ON public.friends FOR INSERT TO authenticated WITH CHECK (user_id_1 = (SELECT auth.uid()));
CREATE POLICY "Users can update their friend requests" ON public.friends FOR UPDATE TO authenticated USING (user_id_1 = (SELECT auth.uid()) OR user_id_2 = (SELECT auth.uid()));
CREATE POLICY "Users can remove friendships" ON public.friends FOR DELETE TO authenticated USING (user_id_1 = (SELECT auth.uid()) OR user_id_2 = (SELECT auth.uid()));

-- Blocks Security
ALTER TABLE public.blocks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their blocks" ON public.blocks FOR SELECT TO authenticated USING (blocker_id = (SELECT auth.uid()) OR blocked_id = (SELECT auth.uid()));
CREATE POLICY "Users can block others" ON public.blocks FOR INSERT TO authenticated WITH CHECK (blocker_id = (SELECT auth.uid()));
CREATE POLICY "Users can unblock" ON public.blocks FOR DELETE TO authenticated USING (blocker_id = (SELECT auth.uid()));

-- Reports Security
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can submit reports" ON public.reports FOR INSERT TO authenticated WITH CHECK (reporter_id = (SELECT auth.uid()));
CREATE POLICY "Users can view own reports" ON public.reports FOR SELECT TO authenticated USING (
  reporter_id = (SELECT auth.uid())
  OR EXISTS (
    SELECT 1 FROM public.profiles WHERE id = (SELECT auth.uid()) AND sethji = true
  )
);
CREATE POLICY "Admins can update reports" ON public.reports FOR UPDATE TO authenticated USING (
  EXISTS (
    SELECT 1 FROM public.profiles WHERE id = (SELECT auth.uid()) AND sethji = true
  )
);

-- Notifications Security
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT TO authenticated USING (recipient_id = (SELECT auth.uid()) OR is_broadcast = true);
CREATE POLICY "Users can update own notification read status" ON public.notifications FOR UPDATE TO authenticated USING (recipient_id = (SELECT auth.uid()));
CREATE POLICY "Admins can insert notifications" ON public.notifications FOR INSERT TO authenticated WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.profiles WHERE id = (SELECT auth.uid()) AND sethji = true
  )
  OR recipient_id = (SELECT auth.uid())
  OR title = 'Tagged in Message'
);

-- ============================================================
-- 4. FUNCTIONS & TRIGGERS
-- ============================================================

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  _username TEXT;
  _gla_group_id UUID;
  _anon_group_id UUID;
BEGIN
  -- Extract username from raw_user_meta_data
  _username := NEW.raw_user_meta_data->>'username';

  -- Insert profile
  INSERT INTO public.profiles (id, username)
  VALUES (NEW.id, _username);

  -- Get system group IDs
  SELECT id INTO _gla_group_id FROM public.groups WHERE name = 'GLA University Group' AND is_system_group = true LIMIT 1;
  SELECT id INTO _anon_group_id FROM public.groups WHERE name = 'Anonymous Group' AND is_system_group = true LIMIT 1;

  -- Auto-enroll in system groups
  IF _gla_group_id IS NOT NULL THEN
    INSERT INTO public.group_members (group_id, user_id, role) VALUES (_gla_group_id, NEW.id, 'member')
    ON CONFLICT DO NOTHING;
  END IF;

  IF _anon_group_id IS NOT NULL THEN
    INSERT INTO public.group_members (group_id, user_id, role) VALUES (_anon_group_id, NEW.id, 'member')
    ON CONFLICT DO NOTHING;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop existing trigger if exists
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS groups_updated_at ON public.groups;
CREATE TRIGGER groups_updated_at
  BEFORE UPDATE ON public.groups
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ============================================================
-- 5. SEED SYSTEM GROUPS
-- ============================================================
INSERT INTO public.groups (name, bio, description, privacy_type, is_system_group, avatar_url)
VALUES
  ('GLA University Group', 'Official GLA University community hub', 'Welcome to the official GLA University group. Connect with fellow students, share updates, and stay informed about campus life.', 'public', true, '/gla-logo.png'),
  ('Anonymous Group', 'Share your thoughts anonymously', 'A safe space to share confessions, thoughts, and feelings without revealing your identity. Be respectful and kind.', 'public', true, '/anonymous-logo.png')
ON CONFLICT DO NOTHING;

UPDATE public.groups
SET avatar_url = '/gla-logo.png'
WHERE name = 'GLA University Group' AND is_system_group = true AND (avatar_url IS NULL OR avatar_url = '');

UPDATE public.groups
SET avatar_url = '/anonymous-logo.png'
WHERE name = 'Anonymous Group' AND is_system_group = true AND (avatar_url IS NULL OR avatar_url = '');

-- ============================================================
-- 6. STORAGE BUCKET POLICIES
-- ============================================================
-- NOTE: Create an 'avatars' bucket in Supabase Dashboard -> Storage
-- Then run these policies:

-- Allow public read access to avatars
CREATE POLICY "Public avatar access"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

-- Users can upload their own avatar
CREATE POLICY "Users can upload own avatar"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can update their own avatar
CREATE POLICY "Users can update own avatar"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Users can delete their own avatar
CREATE POLICY "Users can delete own avatar"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- ============================================================
-- 7. ENABLE REALTIME
-- ============================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;
ALTER PUBLICATION supabase_realtime ADD TABLE public.group_members;
ALTER PUBLICATION supabase_realtime ADD TABLE public.friends;

-- ============================================================
-- 8. MESSAGE NOTIFICATION TRIGGERS
-- ============================================================

-- Trigger function to automatically notify on new direct message
CREATE OR REPLACE FUNCTION public.handle_new_message_notification()
RETURNS TRIGGER AS $$
DECLARE
  _sender_username TEXT;
BEGIN
  -- Only trigger for direct messages (where recipient_id is not null)
  IF NEW.recipient_id IS NOT NULL THEN
    SELECT username INTO _sender_username FROM public.profiles WHERE id = NEW.sender_id;
    
    INSERT INTO public.notifications (recipient_id, title, content, is_broadcast)
    VALUES (
      NEW.recipient_id,
      'New Message',
      '@' || COALESCE(_sender_username, 'Someone') || ' has sent you a new message.',
      false
    );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger definition
DROP TRIGGER IF EXISTS on_new_message_notification ON public.messages;
CREATE TRIGGER on_new_message_notification
  AFTER INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_message_notification();

