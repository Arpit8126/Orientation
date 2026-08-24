-- =========================================================================
-- SQL Migration: Fix Database Schema Permissions
-- Run this script inside the SQL Editor of your Supabase Database (vakuhpkhebcswrcsuwsh).
-- =========================================================================

-- 1. Grant all privileges on all tables in public schema to all roles
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres, service_role, authenticated, anon;

-- 2. Grant all privileges on all sequences (auto-increment columns) in public schema
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres, service_role, authenticated, anon;

-- 3. Grant all privileges on all functions/RPCs in public schema
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO postgres, service_role, authenticated, anon;

-- 4. Enable default privileges for future tables, sequences and functions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO postgres, service_role, authenticated, anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres, service_role, authenticated, anon;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres, service_role, authenticated, anon;
