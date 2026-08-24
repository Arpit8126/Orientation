-- =========================================================================
-- Fix Friends Table Update Policy & Trigger (Secure Chat Themes)
-- Run this in your Supabase SQL Editor to secure the friendships updates.
-- =========================================================================

-- 1. Drop existing policies to prevent conflicts
DROP POLICY IF EXISTS "Users can update their friendships" ON public.friends;
DROP POLICY IF EXISTS "Users can update their friend requests" ON public.friends;
DROP POLICY IF EXISTS "Secure contextual friendship updates" ON public.friends;

-- 2. Create the update policy that allows both friends to run updates
CREATE POLICY "Users can update their friendships" ON public.friends
  FOR UPDATE TO authenticated
  USING (user_id_1 = auth.uid() OR user_id_2 = auth.uid())
  WITH CHECK (user_id_1 = auth.uid() OR user_id_2 = auth.uid());

-- 3. Create a BEFORE UPDATE database trigger function to protect business logic
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

-- 4. Bind trigger to friends table
DROP TRIGGER IF EXISTS trg_protect_friends_status ON public.friends;
CREATE TRIGGER trg_protect_friends_status
  BEFORE UPDATE ON public.friends
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_friends_status();
