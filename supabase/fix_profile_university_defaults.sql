-- ============================================================
-- POOKIZ — Fix Profile University Defaults & Email Verification Cleanups
-- Run this in your Supabase SQL Editor
-- ============================================================

-- 1. Drop the default constraint of GLA University on profiles.university_name
ALTER TABLE public.profiles ALTER COLUMN university_name DROP DEFAULT;

-- 2. Clear out 'GLA University' default values for profiles that have university_id IS NULL
UPDATE public.profiles p
SET university_name = NULL
WHERE p.university_id IS NULL AND p.university_name = 'GLA University';

-- 3. Sync university_name for users who have a university_id set
UPDATE public.profiles p
SET university_name = u.name
FROM public.universities u
WHERE p.university_id = u.id;

-- 4. Clean up is_email_verified for unverified users (excluding test accounts)
UPDATE public.profiles p
SET is_email_verified = false
FROM auth.users u
WHERE p.id = u.id AND u.email_confirmed_at IS NULL AND p.is_testing_user = false;
