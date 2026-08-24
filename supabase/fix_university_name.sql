-- Update handle_new_user trigger function to include university_name
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

-- Update existing profiles' university names
UPDATE public.profiles p
SET university_name = u.name
FROM public.universities u
WHERE p.university_id = u.id;
