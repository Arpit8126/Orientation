-- =========================================================================
-- Fix Database Triggers for renamed admin column (sethji)
-- Run this in your Supabase SQL Editor to resolve the profiles update error.
-- =========================================================================

-- 1. Update protect_profile_system_columns() trigger function
CREATE OR REPLACE FUNCTION public.protect_profile_system_columns()
RETURNS TRIGGER AS $$
BEGIN
  -- Forcefully revert any unauthorized client changes to critical system flags
  NEW.id = OLD.id; -- Cannot steal someone else's profile row
  NEW.sethji = OLD.sethji; -- Cannot make themselves admin (renamed from is_global_admin)
  NEW.is_banned = OLD.is_banned; -- Banned users cannot unban themselves
  NEW.is_email_verified = OLD.is_email_verified; -- Cannot fake verification status
  NEW.is_testing_user = OLD.is_testing_user; -- Cannot toggle testing flag
  NEW.university_id = OLD.university_id; -- Cannot maliciously change assigned university ID
  NEW.created_at = OLD.created_at; -- Keep base timestamps secure

  -- Safe user-editable columns (like username, bio, avatar_url, full_name, allow_calls, etc.) are allowed to pass through
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Update handle_new_university() trigger function
CREATE OR REPLACE FUNCTION public.handle_new_university()
RETURNS TRIGGER AS $$
DECLARE
  _group_id UUID;
BEGIN
  -- 1. Create a system group for the new university
  INSERT INTO public.groups (name, bio, description, privacy_type, is_system_group, avatar_url, university_id)
  VALUES (
    NEW.name || ' Group',
    'Official ' || NEW.name || ' community hub',
    'Welcome to the official ' || NEW.name || ' group. Connect with fellow students, share updates, and stay informed about campus life.',
    'public',
    true,
    NEW.logo_url,
    NEW.id
  )
  RETURNING id INTO _group_id;

  -- 2. Automatically enroll all global admins in this new system group
  INSERT INTO public.group_members (group_id, user_id, role)
  SELECT _group_id, id, 'member'
  FROM public.profiles
  WHERE sethji = true -- (renamed from is_global_admin)
  ON CONFLICT DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
