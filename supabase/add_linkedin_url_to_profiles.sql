-- Migration to add linkedin_url to profiles table to allow users to showcase their professional profiles
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS linkedin_url TEXT DEFAULT NULL;
