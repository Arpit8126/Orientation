-- =========================================================================
-- Migration: Add check_email_exists security definer RPC
-- Run this in your Supabase SQL Editor.
-- =========================================================================

CREATE OR REPLACE FUNCTION public.check_email_exists(email_to_check TEXT)
RETURNS BOOLEAN
SECURITY DEFINER
SET search_path = public, auth
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM auth.users WHERE email = LOWER(TRIM(email_to_check))
  );
END;
$$ LANGUAGE plpgsql;
