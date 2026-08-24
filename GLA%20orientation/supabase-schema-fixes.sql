-- ========================================================
-- GLA University Orientation Program 2026
-- Supabase SQL Database Schema RLS Fixes
-- ========================================================
-- Run this script in your Supabase Project SQL Editor to add the insert policy for profiles.

-- Add RLS policy to allow users to insert their own profile on login/verification
create policy "Allow authenticated users to insert their own profile" on public.profiles
  for insert with check (auth.uid() = id);
