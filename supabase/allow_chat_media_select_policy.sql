-- ============================================================
-- Allow Public Select Access to 'chat-media' Storage Bucket
-- Run this in your Supabase SQL Editor if RLS is enabled on storage.objects
-- ============================================================

DROP POLICY IF EXISTS "Public chat-media access" ON storage.objects;

CREATE POLICY "Public chat-media access"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'chat-media');
