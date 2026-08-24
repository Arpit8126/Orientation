-- 1. Add is_email_verified column to profiles table if it doesn't exist
ALTER TABLE public.profiles 
ADD COLUMN IF NOT EXISTS is_email_verified BOOLEAN DEFAULT false;

-- 2. Update existing verified users
UPDATE public.profiles
SET is_email_verified = true
FROM auth.users
WHERE public.profiles.id = auth.users.id 
  AND auth.users.email_confirmed_at IS NOT NULL;

-- 3. Recreate/Update handle_new_user() trigger function to include is_email_verified
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  _username TEXT;
  _gla_group_id UUID;
  _anon_group_id UUID;
BEGIN
  -- Extract username from raw_user_meta_data
  _username := NEW.raw_user_meta_data->>'username';

  -- Insert profile, setting is_email_verified depending on whether email is confirmed
  INSERT INTO public.profiles (id, username, is_email_verified)
  VALUES (NEW.id, _username, (NEW.email_confirmed_at IS NOT NULL));

  -- Get system group IDs
  SELECT id INTO _gla_group_id FROM public.groups WHERE name = 'GLA University Group' AND is_system_group = true LIMIT 1;
  SELECT id INTO _anon_group_id FROM public.groups WHERE name = 'Anonymous Confession Room' AND is_system_group = true LIMIT 1;

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

-- 4. Create trigger function to handle user email confirmation on UPDATE
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

-- 5. Drop existing trigger if it exists, then create it
DROP TRIGGER IF EXISTS on_auth_user_updated ON auth.users;
CREATE TRIGGER on_auth_user_updated
  AFTER UPDATE ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_user_email_confirmation();
