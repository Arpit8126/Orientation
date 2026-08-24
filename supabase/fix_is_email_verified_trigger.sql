-- =========================================================================
-- Fix is_email_verified trigger lock and update existing stuck profiles
-- Run this in your Supabase SQL Editor.
-- =========================================================================

-- 1. Re-create protect_profile_system_columns() trigger function with SECURITY DEFINER
-- and allow is_email_verified to change if confirmed in auth.users.
CREATE OR REPLACE FUNCTION public.protect_profile_system_columns()
RETURNS TRIGGER AS $$
BEGIN
  -- Forcefully revert any unauthorized client changes to critical system flags
  NEW.id = OLD.id; -- Cannot steal someone else's profile row
  NEW.sethji = OLD.sethji; -- Cannot make themselves admin
  NEW.is_banned = OLD.is_banned; -- Banned users cannot unban themselves
  NEW.is_testing_user = OLD.is_testing_user; -- Cannot toggle testing flag
  NEW.university_id = OLD.university_id; -- Cannot maliciously change assigned university ID
  NEW.created_at = OLD.created_at; -- Keep base timestamps secure

  -- Allow is_email_verified to change ONLY if it matches their auth.users confirmation status
  IF NEW.is_email_verified <> OLD.is_email_verified THEN
    -- Verify against actual auth.users record
    IF NOT EXISTS (
      SELECT 1 FROM auth.users 
      WHERE id = NEW.id AND email_confirmed_at IS NOT NULL
    ) THEN
      NEW.is_email_verified = OLD.is_email_verified; -- Revert if not confirmed in auth.users
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Repair any existing verified users whose profiles are stuck with is_email_verified = false
UPDATE public.profiles p
SET is_email_verified = true
FROM auth.users u
WHERE p.id = u.id 
  AND u.email_confirmed_at IS NOT NULL 
  AND p.is_email_verified = false;
