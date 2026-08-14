-- ==========================================
-- GLA University Orientation Program 2026
-- Supabase SQL Database Schema Migration
-- ==========================================
-- Run this script in your Supabase Project SQL Editor to bootstrap the database.

-- 1. Profiles Table (Linked to auth.users)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text not null,
  full_name text default null,
  team_name text default null,
  survey_completed boolean default false not null,
  survey_answers jsonb default null,
  registered_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table public.profiles enable row level security;

-- Setup RLS Policies for Profiles
create policy "Allow authenticated users to read their own profile" on public.profiles
  for select using (auth.uid() = id);

create policy "Allow authenticated users to update their own profile" on public.profiles
  for update using (auth.uid() = id);

-- 2. Leaderboard Table (Teams score registry)
create table if not exists public.leaderboard (
  team_name text primary key,
  game_1 integer default 0 not null,
  game_2 integer default 0 not null,
  game_3 integer default 0 not null,
  game_4 integer default 0 not null,
  game_5 integer default 0 not null,
  total integer default 0 not null
);

-- Enable Row Level Security (RLS)
alter table public.leaderboard enable row level security;

-- Setup RLS Policies for Leaderboard (Allow anyone to read)
create policy "Allow public read access to leaderboard" on public.leaderboard
  for select using (true);

-- Seed the 18 default teams into the leaderboard
insert into public.leaderboard (team_name, game_1, game_2, game_3, game_4, game_5, total) values
  ('Transformer', 0, 0, 0, 0, 0, 0),
  ('CNN', 0, 0, 0, 0, 0, 0),
  ('RNN', 0, 0, 0, 0, 0, 0),
  ('LLM', 0, 0, 0, 0, 0, 0),
  ('Agentic AI', 0, 0, 0, 0, 0, 0),
  ('Linear Regression', 0, 0, 0, 0, 0, 0),
  ('Logistic Regression', 0, 0, 0, 0, 0, 0),
  ('RAG', 0, 0, 0, 0, 0, 0),
  ('SVM', 0, 0, 0, 0, 0, 0),
  ('Random Forest', 0, 0, 0, 0, 0, 0),
  ('XGBoost', 0, 0, 0, 0, 0, 0),
  ('LangChain', 0, 0, 0, 0, 0, 0),
  ('LlamaIndex', 0, 0, 0, 0, 0, 0),
  ('Hugging Face', 0, 0, 0, 0, 0, 0),
  ('Ollama', 0, 0, 0, 0, 0, 0),
  ('PyTorch', 0, 0, 0, 0, 0, 0),
  ('TensorFlow', 0, 0, 0, 0, 0, 0),
  ('vLLM', 0, 0, 0, 0, 0, 0)
on conflict (team_name) do nothing;

-- 3. Buzzer State Table (Tracks active question)
create table if not exists public.buzzer_state (
  id text primary key default 'active',
  active_game text default 'guess the song',
  active_question text default 'Q1',
  is_active boolean default false not null,
  buzzed_by_user_id uuid references public.profiles(id) on delete set null,
  buzzed_by_name text default null,
  buzzed_by_team text default null,
  prompt_image_start_time text default null,  -- HH:MM format, set by admin
  prompt_image_end_time text default null,    -- HH:MM format, set by admin
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- Enable Row Level Security (RLS)
alter table public.buzzer_state enable row level security;

-- Setup RLS Policies for Buzzer State (Allow anyone to read)
create policy "Allow public read access to buzzer_state" on public.buzzer_state
  for select using (true);

-- Seed default active buzzer state row
insert into public.buzzer_state (id, active_game, active_question, is_active, buzzed_by_user_id, buzzed_by_name, buzzed_by_team) values
  ('active', 'guess the song', 'Q1', false, null, null, null)
on conflict (id) do nothing;

-- 4. Buzzer Ranks Table (Log of team clicks for the active question)
create table if not exists public.buzzer_ranks (
  team_name text primary key,
  rank integer not null,
  user_name text not null,
  pressed_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table public.buzzer_ranks enable row level security;

-- Setup RLS Policies for Buzzer Ranks (Allow anyone to read)
create policy "Allow public read access to buzzer_ranks" on public.buzzer_ranks
  for select using (true);

-- Note: The server-side API endpoints use the service role key to perform writes
-- (insert, update, delete) to bypassing RLS safely. No write policies are needed.
