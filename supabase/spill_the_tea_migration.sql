-- ============================================================
-- Spill the Tea ☕ (Public Campus Stories & Gossip Network)
-- Complete Egress-Optimized & Security-Hardened Script
-- ============================================================

-- 1. Tea Posts Table
CREATE TABLE IF NOT EXISTS public.tea_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  content TEXT NOT NULL,
  media_url TEXT DEFAULT NULL,
  is_anonymous BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for fast sorting by newest and tracking authored items
CREATE INDEX IF NOT EXISTS idx_tea_posts_created_at ON public.tea_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_tea_posts_author_id ON public.tea_posts(author_id);

-- 2. Tea Aura Votes (+1 / -1)
CREATE TABLE IF NOT EXISTS public.tea_aura_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  vote_type INT NOT NULL CHECK (vote_type IN (1, -1)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_tea_aura_votes_post_id ON public.tea_aura_votes(post_id);

-- 3. Tea Pinned Reaction Poll Votes
CREATE TABLE IF NOT EXISTS public.tea_poll_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  reaction_type TEXT NOT NULL CHECK (reaction_type IN ('spill_more', 'too_hot', 'cap_fake', 'dead')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_tea_poll_votes_post_id ON public.tea_poll_votes(post_id);

-- 4. Tea Comments Table
CREATE TABLE IF NOT EXISTS public.tea_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id UUID NOT NULL REFERENCES public.tea_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES public.tea_comments(id) ON DELETE CASCADE,
  comment_text TEXT NOT NULL,
  is_pinned BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tea_comments_post_id ON public.tea_comments(post_id);

-- ============================================================
-- ENABLE ROW-LEVEL SECURITY (RLS)
-- ============================================================
ALTER TABLE public.tea_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_aura_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_poll_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tea_comments ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- DEFINE RLS SECURITY POLICIES
-- ============================================================

-- Public READ policies for all users, guests & search engine crawlers
CREATE POLICY "Public tea_posts read" ON public.tea_posts FOR SELECT USING (true);
CREATE POLICY "Public tea_aura_votes read" ON public.tea_aura_votes FOR SELECT USING (true);
CREATE POLICY "Public tea_poll_votes read" ON public.tea_poll_votes FOR SELECT USING (true);
CREATE POLICY "Public tea_comments read" ON public.tea_comments FOR SELECT USING (true);

-- Authenticated WRITE policies for Posts (Strict identity enforcement: author_id MUST equal auth.uid())
DROP POLICY IF EXISTS "Auth tea_posts insert" ON public.tea_posts;
CREATE POLICY "Auth tea_posts insert" ON public.tea_posts FOR INSERT 
  WITH CHECK (auth.role() = 'authenticated' AND author_id = auth.uid());

DROP POLICY IF EXISTS "Auth tea_posts delete" ON public.tea_posts;
CREATE POLICY "Auth tea_posts delete" ON public.tea_posts FOR DELETE USING (auth.uid() = author_id);

-- Hardened Interaction Policies (WITH CHECK enforces strict identity constraints during toggle/upsert writes)
CREATE POLICY "Auth tea_aura_votes write" ON public.tea_aura_votes FOR ALL 
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Auth tea_poll_votes write" ON public.tea_poll_votes FOR ALL 
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Authenticated WRITE policies for Comments
CREATE POLICY "Auth tea_comments insert" ON public.tea_comments FOR INSERT WITH CHECK (auth.uid() = author_id);
CREATE POLICY "Auth tea_comments delete" ON public.tea_comments FOR DELETE USING (auth.uid() = author_id);

-- ============================================================
-- RPC FUNCTION FOR DEMOGRAPHIC BREAKDOWN (SYNTAX REFACTORED)
-- ============================================================
CREATE OR REPLACE FUNCTION get_tea_analytics(target_post_id UUID)
RETURNS TABLE (
    general_users INT,
    own_uni INT,
    other_uni INT,
    teachers INT
) AS $$
DECLARE
    author_university_id UUID;
BEGIN
    -- Dynamically extract the posting author's university alignment
    SELECT p.university_id INTO author_university_id
    FROM public.tea_posts tp
    JOIN public.profiles p ON tp.author_id = p.id
    WHERE tp.id = target_post_id;

    RETURN QUERY
    WITH interactors AS (
        SELECT user_id FROM public.tea_aura_votes WHERE post_id = target_post_id
        UNION
        SELECT user_id FROM public.tea_poll_votes WHERE post_id = target_post_id
        UNION
        SELECT author_id AS user_id FROM public.tea_comments WHERE post_id = target_post_id
    )
    SELECT 
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = false AND p.university_id IS NULL))::INT, 0) AS general_users,
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = false AND author_university_id IS NOT NULL AND p.university_id = author_university_id))::INT, 0) AS own_uni,
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = false AND p.university_id IS NOT NULL AND (author_university_id IS NULL OR p.university_id != author_university_id)))::INT, 0) AS other_uni,
        COALESCE((COUNT(*) FILTER (WHERE p.is_teacher = true))::INT, 0) AS teachers
    FROM interactors i
    JOIN public.profiles p ON i.user_id = p.id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
