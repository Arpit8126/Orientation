-- =========================================================================
-- Guest and Unverified Account Database Restrictions Trigger
-- 
-- Run this script in the Supabase SQL Editor to enforce that unverified
-- or guest users cannot send messages, block, or report anyone on the database level.
-- =========================================================================

-- 1. Enforce email verification for message inserts
CREATE OR REPLACE FUNCTION public.check_message_sender_verified()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = NEW.sender_id AND is_email_verified = true
  ) THEN
    RAISE EXCEPTION 'Please verify your email by going in profile section first to send messages.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_message_insert_verify ON public.messages;
CREATE TRIGGER on_message_insert_verify
  BEFORE INSERT ON public.messages
  FOR EACH ROW
  EXECUTE FUNCTION public.check_message_sender_verified();

-- 2. Enforce email verification for blocks
CREATE OR REPLACE FUNCTION public.check_blocker_verified()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = NEW.blocker_id AND is_email_verified = true
  ) THEN
    RAISE EXCEPTION 'Please verify your email first to block users.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_block_insert_verify ON public.blocks;
CREATE TRIGGER on_block_insert_verify
  BEFORE INSERT ON public.blocks
  FOR EACH ROW
  EXECUTE FUNCTION public.check_blocker_verified();

-- 3. Enforce email verification for reports
CREATE OR REPLACE FUNCTION public.check_reporter_verified()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = NEW.reporter_id AND is_email_verified = true
  ) THEN
    RAISE EXCEPTION 'Please verify your email first to report users.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_report_insert_verify ON public.reports;
CREATE TRIGGER on_report_insert_verify
  BEFORE INSERT ON public.reports
  FOR EACH ROW
  EXECUTE FUNCTION public.check_reporter_verified();
