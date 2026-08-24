-- =========================================================================
-- SQL Migration: Create teacher-ids Storage Bucket
-- Run this in: Supabase Dashboard → SQL Editor (Project: vakuhpkhebcswrcsuwsh)
-- =========================================================================

-- 1. Create the teacher-ids storage bucket (public so URLs are accessible)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'teacher-ids',
  'teacher-ids',
  true,
  10485760,   -- 10 MB limit per file
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

-- 2. Allow authenticated teachers to upload their own ID
CREATE POLICY "Authenticated users can upload teacher IDs"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'teacher-ids');

-- 3. Allow public read access (so admins can view submitted IDs via public URL)
CREATE POLICY "Public read access for teacher IDs"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'teacher-ids');

-- 4. Allow authenticated users to update/replace their own uploads
CREATE POLICY "Authenticated users can update teacher IDs"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'teacher-ids');

-- 5. Allow authenticated users to delete their own uploads
CREATE POLICY "Authenticated users can delete teacher IDs"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'teacher-ids');
