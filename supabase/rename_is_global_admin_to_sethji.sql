BEGIN;

-- =========================================================================
-- 1. Rename column in public.profiles table
-- =========================================================================
ALTER TABLE public.profiles RENAME COLUMN is_global_admin TO sethji;

-- =========================================================================
-- 2. Update the RLS Policy for feedback admin access
-- =========================================================================
DROP POLICY IF EXISTS "Global admins can view all feedbacks" ON public.feedbacks;
CREATE POLICY "Global admins can view all feedbacks" ON public.feedbacks
    FOR SELECT TO authenticated USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND sethji = true
        )
    );

-- =========================================================================
-- 3. Update RLS Policies for active calls
-- =========================================================================
DROP POLICY IF EXISTS "Global admins can view all calls" ON public.active_calls;
CREATE POLICY "Global admins can view all calls" ON public.active_calls
    FOR SELECT TO authenticated USING (
        EXISTS (
            SELECT 1 FROM public.profiles 
            WHERE id = auth.uid() AND sethji = true
        )
    );

-- =========================================================================
-- 4. Update the handle_new_user() trigger function (Exploit Loop Closed)
-- =========================================================================
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
  -- Extract basic user metadata safely
  _username := NEW.raw_user_meta_data->>'username';
  _is_testing_user := COALESCE((NEW.raw_user_meta_data->>'is_testing_user')::boolean, false);
  _email := NEW.email;
  
  -- 🔒 SECURITY FIX: Force all new accounts to false. 
  -- No client can pass a parameter to make themselves an admin during sign-up.
  _sethji := false; 
  
  -- Extract email domain
  _domain := split_part(_email, '@', 2);
  
  -- Verify emails instantly for testing routes if applicable
  _is_email_verified := (NEW.email_confirmed_at IS NOT NULL) OR _is_testing_user;

  -- Find matching university ID based on domain
  SELECT id, name INTO _university_id, _univ_name 
  FROM public.universities 
  WHERE LOWER(domain) = LOWER(_domain) 
  LIMIT 1;

  -- Insert profile securely with hardcoded default false admin status
  INSERT INTO public.profiles (id, username, university_id, university_name, is_email_verified, sethji, is_testing_user)
  VALUES (NEW.id, _username, _university_id, _univ_name, _is_email_verified, _sethji, _is_testing_user);

  -- Auto-enroll in global system spaces
  SELECT id INTO _anon_group_id FROM public.groups WHERE name = 'Anonymous Confession Room' AND is_system_group = true LIMIT 1;
  
  IF _anon_group_id IS NOT NULL THEN
    INSERT INTO public.group_members (group_id, user_id, role) VALUES (_anon_group_id, NEW.id, 'member')
    ON CONFLICT DO NOTHING;
  END IF;

  -- Auto-enroll in corresponding university spaces
  IF _univ_name IS NOT NULL THEN
    FOR _rec IN SELECT id FROM public.groups WHERE name = _univ_name || ' Group' AND is_system_group = true LOOP
      INSERT INTO public.group_members (group_id, user_id, role) VALUES (_rec.id, NEW.id, 'member')
      ON CONFLICT DO NOTHING;
    END LOOP;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMIT;
