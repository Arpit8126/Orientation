-- ============================================================
-- Spill the Tea Follow & Save Feature Migration
-- Run this script in your Supabase SQL Editor
-- ============================================================

-- 1. Create Follows Table
CREATE TABLE IF NOT EXISTS public.follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(follower_id, following_id)
);

-- Enable RLS for Follows
ALTER TABLE public.follows ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public follows read" ON public.follows;
CREATE POLICY "Public follows read" ON public.follows FOR SELECT USING (true);

DROP POLICY IF EXISTS "Auth follows insert" ON public.follows;
CREATE POLICY "Auth follows insert" ON public.follows FOR INSERT WITH CHECK (auth.uid() = follower_id);

DROP POLICY IF EXISTS "Auth follows delete" ON public.follows;
CREATE POLICY "Auth follows delete" ON public.follows FOR DELETE USING (auth.uid() = follower_id);

-- Create Indexes for fast lookup
CREATE INDEX IF NOT EXISTS idx_follows_follower ON public.follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_follows_following ON public.follows(following_id);


-- 2. Create Tea Saved Posts Table
CREATE TABLE IF NOT EXISTS public.tea_saved_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

-- Enable RLS for Saved posts
ALTER TABLE public.tea_saved_posts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public tea_saved_posts read" ON public.tea_saved_posts;
CREATE POLICY "Public tea_saved_posts read" ON public.tea_saved_posts FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Auth tea_saved_posts write" ON public.tea_saved_posts;
CREATE POLICY "Auth tea_saved_posts write" ON public.tea_saved_posts FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Create Indexes
CREATE INDEX IF NOT EXISTS idx_tea_saved_posts_user ON public.tea_saved_posts(user_id);


-- 3. Create Tea Seen Posts Table
CREATE TABLE IF NOT EXISTS public.tea_seen_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

-- Enable RLS for Seen posts
ALTER TABLE public.tea_seen_posts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public tea_seen_posts read" ON public.tea_seen_posts;
CREATE POLICY "Public tea_seen_posts read" ON public.tea_seen_posts FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Auth tea_seen_posts write" ON public.tea_seen_posts;
CREATE POLICY "Auth tea_seen_posts write" ON public.tea_seen_posts FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Create Indexes
CREATE INDEX IF NOT EXISTS idx_tea_seen_posts_user ON public.tea_seen_posts(user_id);


-- 4. Create Trigger to handle automatic follows from friendship status updates (Hardened)
CREATE OR REPLACE FUNCTION public.handle_follows_from_friendship()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    IF NEW.status = 'accepted' THEN
      -- Insert reciprocal follows if they do not exist
      INSERT INTO public.follows (follower_id, following_id)
      VALUES (NEW.user_id_1, NEW.user_id_2)
      ON CONFLICT (follower_id, following_id) DO NOTHING;

      INSERT INTO public.follows (follower_id, following_id)
      VALUES (NEW.user_id_2, NEW.user_id_1)
      ON CONFLICT (follower_id, following_id) DO NOTHING;
    END IF;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    -- Clean up follows if friendship is deleted/unfriended
    DELETE FROM public.follows
    WHERE (follower_id = OLD.user_id_1 AND following_id = OLD.user_id_2)
       OR (follower_id = OLD.user_id_2 AND following_id = OLD.user_id_1);
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Attach trigger
DROP TRIGGER IF EXISTS trigger_handle_follows_from_friendship ON public.friends;
CREATE TRIGGER trigger_handle_follows_from_friendship
AFTER INSERT OR UPDATE OR DELETE ON public.friends
FOR EACH ROW EXECUTE FUNCTION public.handle_follows_from_friendship();


-- 5. Retroactive Sync: Make all current accepted friends follow each other
INSERT INTO public.follows (follower_id, following_id)
SELECT user_id_1, user_id_2
FROM public.friends
WHERE status = 'accepted'
ON CONFLICT (follower_id, following_id) DO NOTHING;

INSERT INTO public.follows (follower_id, following_id)
SELECT user_id_2, user_id_1
FROM public.friends
WHERE status = 'accepted'
ON CONFLICT (follower_id, following_id) DO NOTHING;
