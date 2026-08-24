-- ============================================================
-- POOKIZ — Multi-Tenant University & Testing Accounts Migration
-- Run this in your Supabase SQL Editor
-- ============================================================

-- 1. Create Universities Table
CREATE TABLE IF NOT EXISTS public.universities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  domain TEXT UNIQUE NOT NULL,
  logo_url TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Add columns to Profiles
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS university_id UUID REFERENCES public.universities(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS is_email_verified BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS is_testing_user BOOLEAN DEFAULT false;

-- 3. Add university_id to Groups
ALTER TABLE public.groups
ADD COLUMN IF NOT EXISTS university_id UUID REFERENCES public.universities(id) ON DELETE CASCADE;

-- 4. Create University Applications Table
CREATE TABLE IF NOT EXISTS public.university_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  domain TEXT NOT NULL,
  contact_email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Seed GLA University (Default Tenant)
INSERT INTO public.universities (name, domain, logo_url) 
VALUES ('GLA University', 'gla.ac.in', '/gla-logo.png')
ON CONFLICT (name) DO NOTHING;

-- 6. Link existing users to GLA University
UPDATE public.profiles p
SET university_id = (SELECT id FROM public.universities WHERE name = 'GLA University' LIMIT 1),
    is_email_verified = true
FROM auth.users u
WHERE p.id = u.id AND (u.email LIKE '%@gla.ac.in' OR u.email LIKE '%@test%');

-- 7. Link existing GLA University Group to GLA University
UPDATE public.groups 
SET university_id = (SELECT id FROM public.universities WHERE name = 'GLA University' LIMIT 1)
WHERE name = 'GLA University Group' AND is_system_group = true;

-- 8. Trigger to auto-create System Group on University insertion
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
  WHERE sethji = true
  ON CONFLICT DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_university_created ON public.universities;
CREATE TRIGGER on_university_created
  AFTER INSERT ON public.universities
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_university();

-- 9. Update handle_new_user trigger function to support multi-tenant logic
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  _username TEXT;
  _email TEXT;
  _domain TEXT;
  _university_id UUID;
  _univ_name TEXT;
  _is_email_verified BOOLEAN;
  _sethji BOOLEAN;
  _is_testing_user BOOLEAN;
  _anon_group_id UUID;
  _rec RECORD;
BEGIN
  -- Extract metadata and details
  _username := NEW.raw_user_meta_data->>'username';
  _sethji := COALESCE((NEW.raw_user_meta_data->>'sethji')::boolean, false);
  _is_testing_user := COALESCE((NEW.raw_user_meta_data->>'is_testing_user')::boolean, false);
  _email := NEW.email;
  
  -- Extract email domain (everything after @)
  _domain := split_part(_email, '@', 2);
  
  -- If it's a test user or email is verified immediately
  _is_email_verified := (NEW.email_confirmed_at IS NOT NULL) OR _is_testing_user;

  -- Find matching university ID
  SELECT id, name INTO _university_id, _univ_name 
  FROM public.universities 
  WHERE LOWER(domain) = LOWER(_domain) 
  LIMIT 1;

  -- Insert profile
  INSERT INTO public.profiles (id, username, university_id, university_name, is_email_verified, sethji, is_testing_user)
  VALUES (NEW.id, _username, _university_id, _univ_name, _is_email_verified, _sethji, _is_testing_user);

  -- Get system group ID for Anonymous Confession Room (common to all)
  SELECT id INTO _anon_group_id FROM public.groups WHERE name = 'Anonymous Confession Room' AND is_system_group = true LIMIT 1;
  
  -- Auto-enroll in Anonymous Confession Room
  IF _anon_group_id IS NOT NULL THEN
    INSERT INTO public.group_members (group_id, user_id, role) VALUES (_anon_group_id, NEW.id, 'member')
    ON CONFLICT DO NOTHING;
  END IF;

  -- Auto-enroll in university system groups
  IF _sethji THEN
    -- Global admins are auto-enrolled in ALL system groups in the database
    FOR _rec IN SELECT id FROM public.groups WHERE is_system_group = true LOOP
      INSERT INTO public.group_members (group_id, user_id, role) VALUES (_rec.id, NEW.id, 'member')
      ON CONFLICT DO NOTHING;
    END LOOP;
  ELSE
    -- Normal users are auto-enrolled in their university's system group
    IF _univ_name IS NOT NULL THEN
      FOR _rec IN SELECT id FROM public.groups WHERE name = _univ_name || ' Group' AND is_system_group = true LOOP
        INSERT INTO public.group_members (group_id, user_id, role) VALUES (_rec.id, NEW.id, 'member')
        ON CONFLICT DO NOTHING;
      END LOOP;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 10. Re-create handler for email confirmation updates on auth.users
CREATE OR REPLACE FUNCTION public.handle_user_email_confirmation()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.email_confirmed_at IS NOT NULL AND (OLD.email_confirmed_at IS NULL OR NEW.email_confirmed_at <> OLD.email_confirmed_at) THEN
    UPDATE public.profiles
    SET is_email_verified = true
    WHERE id = NEW.id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
CREATE TRIGGER on_auth_user_updated
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_user_email_confirmation();

-- 11. Row Level Security (RLS) Policies for Universities & Applications
ALTER TABLE public.universities ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow public read access to universities" ON public.universities;
CREATE POLICY "Allow public read access to universities"
  ON public.universities FOR SELECT
  USING (true);

ALTER TABLE public.university_applications ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Allow public read access to applications" ON public.university_applications;
CREATE POLICY "Allow public read access to applications"
  ON public.university_applications FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Allow anyone to apply for university" ON public.university_applications;
CREATE POLICY "Allow anyone to apply for university"
  ON public.university_applications FOR INSERT
  WITH CHECK (true);

