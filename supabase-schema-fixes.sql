-- ========================================================
-- GLA University Orientation Program 2026
-- Supabase SQL Database Bootstrap & RLS Public Overrides
-- ========================================================
-- Run this unified script in your Supabase Project SQL Editor.
-- It creates all tables if missing, seeds default data, and configures public access overrides.

-- 1. Create Profiles Table (Linked to auth.users)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  email text not null,
  full_name text default null,
  team_name text default null,
  survey_completed boolean default false not null,
  survey_answers jsonb default null,
  registered_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Create Leaderboard Table (Teams score registry)
create table if not exists public.leaderboard (
  team_name text primary key,
  game_1 integer default 0 not null,
  game_2 integer default 0 not null,
  game_3 integer default 0 not null,
  game_4 integer default 0 not null,
  game_5 integer default 0 not null,
  total integer default 0 not null
);

-- 3. Create Buzzer State Table (Tracks active question)
create table if not exists public.buzzer_state (
  id text primary key default 'active',
  active_game text default 'guess the song',
  active_question text default 'Q1',
  is_active boolean default false not null,
  buzzed_by_user_id uuid references public.profiles(id) on delete set null,
  buzzed_by_name text default null,
  buzzed_by_team text default null,
  prompt_image_start_time timestamp with time zone default null,
  prompt_image_end_time timestamp with time zone default null,
  updated_at timestamp with time zone default timezone('utc'::text, now())
);

-- 4. Create Buzzer Ranks Table (Log of team clicks for the active question)
create table if not exists public.buzzer_ranks (
  team_name text primary key,
  rank integer not null,
  user_name text not null,
  pressed_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 5. Create Team Uploads Table (Tracks prompt game image submissions)
create table if not exists public.team_uploads (
  team_name text primary key references public.leaderboard(team_name) on delete cascade,
  image_url text not null,
  uploaded_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- ========================================================
-- Enable Row Level Security (RLS) on all tables
-- ========================================================
alter table public.profiles enable row level security;
alter table public.leaderboard enable row level security;
alter table public.buzzer_state enable row level security;
alter table public.buzzer_ranks enable row level security;
alter table public.team_uploads enable row level security;

-- ========================================================
-- Setup RLS Policies (Allow full public/anonymous writes)
-- ========================================================

-- Profiles Overrides
drop policy if exists "Allow authenticated users to read their own profile" on public.profiles;
drop policy if exists "Allow authenticated users to update their own profile" on public.profiles;
drop policy if exists "Allow authenticated users to insert their own profile" on public.profiles;
drop policy if exists "Allow public read access to profiles" on public.profiles;
drop policy if exists "Allow public insert access to profiles" on public.profiles;
drop policy if exists "Allow public update access to profiles" on public.profiles;
drop policy if exists "Allow public delete access to profiles" on public.profiles;

create policy "Allow public read access to profiles" on public.profiles for select using (true);
create policy "Allow public insert access to profiles" on public.profiles for insert with check (true);
create policy "Allow public update access to profiles" on public.profiles for update using (true);
create policy "Allow public delete access to profiles" on public.profiles for delete using (true);

-- Leaderboard Overrides
drop policy if exists "Allow public read access to leaderboard" on public.leaderboard;
drop policy if exists "Allow public insert access to leaderboard" on public.leaderboard;
drop policy if exists "Allow public update access to leaderboard" on public.leaderboard;
drop policy if exists "Allow public delete access to leaderboard" on public.leaderboard;

create policy "Allow public read access to leaderboard" on public.leaderboard for select using (true);
create policy "Allow public insert access to leaderboard" on public.leaderboard for insert with check (true);
create policy "Allow public update access to leaderboard" on public.leaderboard for update using (true);
create policy "Allow public delete access to leaderboard" on public.leaderboard for delete using (true);

-- Buzzer State Overrides
drop policy if exists "Allow public read access to buzzer_state" on public.buzzer_state;
drop policy if exists "Allow public insert access to buzzer_state" on public.buzzer_state;
drop policy if exists "Allow public update access to buzzer_state" on public.buzzer_state;
drop policy if exists "Allow public delete access to buzzer_state" on public.buzzer_state;

create policy "Allow public read access to buzzer_state" on public.buzzer_state for select using (true);
create policy "Allow public insert access to buzzer_state" on public.buzzer_state for insert with check (true);
create policy "Allow public update access to buzzer_state" on public.buzzer_state for update using (true);
create policy "Allow public delete access to buzzer_state" on public.buzzer_state for delete using (true);

-- Buzzer Ranks Overrides
drop policy if exists "Allow public read access to buzzer_ranks" on public.buzzer_ranks;
drop policy if exists "Allow public insert access to buzzer_ranks" on public.buzzer_ranks;
drop policy if exists "Allow public update access to buzzer_ranks" on public.buzzer_ranks;
drop policy if exists "Allow public delete access to buzzer_ranks" on public.buzzer_ranks;

create policy "Allow public read access to buzzer_ranks" on public.buzzer_ranks for select using (true);
create policy "Allow public insert access to buzzer_ranks" on public.buzzer_ranks for insert with check (true);
create policy "Allow public update access to buzzer_ranks" on public.buzzer_ranks for update using (true);
create policy "Allow public delete access to buzzer_ranks" on public.buzzer_ranks for delete using (true);

-- Team Uploads Overrides
drop policy if exists "Allow public read access to team_uploads" on public.team_uploads;
drop policy if exists "Allow public insert access to team_uploads" on public.team_uploads;
drop policy if exists "Allow public update access to team_uploads" on public.team_uploads;
drop policy if exists "Allow public delete access to team_uploads" on public.team_uploads;

create policy "Allow public read access to team_uploads" on public.team_uploads for select using (true);
create policy "Allow public insert access to team_uploads" on public.team_uploads for insert with check (true);
create policy "Allow public update access to team_uploads" on public.team_uploads for update using (true);
create policy "Allow public delete access to team_uploads" on public.team_uploads for delete using (true);

-- ========================================================
-- Seed Initial Records (If not exists)
-- ========================================================

-- Seed the 18 default teams
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

-- Seed default buzzer state row
insert into public.buzzer_state (id, active_game, active_question, is_active, buzzed_by_user_id, buzzed_by_name, buzzed_by_team) values
  ('active', 'guess the song', 'Q1', false, null, null, null)
on conflict (id) do nothing;
