-- =======================================================
-- GLA University Orientation Program 2026
-- Supabase SQL Database Schema Updates (Story & Prompt Game)
-- =======================================================
-- Run this script in your Supabase Project SQL Editor to add required updates.

-- 1. Create team_uploads Table (Tracks prompt game image submissions)
create table if not exists public.team_uploads (
  team_name text primary key references public.leaderboard(team_name) on delete cascade,
  image_url text not null,
  uploaded_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table public.team_uploads enable row level security;

-- Setup RLS Policies for Team Uploads (Allow anyone to read)
create policy "Allow public read access to team_uploads" on public.team_uploads
  for select using (true);

-- 2. Alter buzzer_state Table (Add start/end timer columns for prompt game)
alter table public.buzzer_state 
  add column if not exists prompt_image_start_time timestamp with time zone default null,
  add column if not exists prompt_image_end_time timestamp with time zone default null;
