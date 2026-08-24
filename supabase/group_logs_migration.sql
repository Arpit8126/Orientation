-- Create group_logs table
CREATE TABLE IF NOT EXISTS public.group_logs (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE,
    action_performer_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    target_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    action_type VARCHAR(50) NOT NULL, -- e.g., 'message_deleted', 'staff_deleted_message', 'staff_removed', 'admin_created', 'coadmin_created', 'mod_created', 'banned', 'unbanned', 'group_edited'
    deleted_message_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS
ALTER TABLE public.group_logs ENABLE ROW LEVEL SECURITY;

-- Allow reading logs for staff members (admin, coadmin, mod)
DROP POLICY IF EXISTS "Allow staff to read group logs" ON public.group_logs;
CREATE POLICY "Allow staff to read group logs" ON public.group_logs
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.group_members
            WHERE group_members.group_id = group_logs.group_id
              AND group_members.user_id = auth.uid()
              AND group_members.role IN ('admin', 'coadmin', 'mod')
        )
    );

-- Allow inserting logs for staff members (so client actions can insert)
DROP POLICY IF EXISTS "Allow anyone to insert group logs" ON public.group_logs;
DROP POLICY IF EXISTS "Allow staff to insert group logs" ON public.group_logs;
CREATE POLICY "Allow staff to insert group logs" ON public.group_logs
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.group_members
            WHERE group_members.group_id = group_logs.group_id
              AND group_members.user_id = auth.uid()
              AND group_members.role IN ('admin', 'coadmin', 'mod')
        )
    );

-- Disallow updating and deleting logs completely (even for admin/creator)
DROP POLICY IF EXISTS "Disallow updates" ON public.group_logs;
CREATE POLICY "Disallow updates" ON public.group_logs FOR UPDATE USING (false);

DROP POLICY IF EXISTS "Disallow deletes" ON public.group_logs;
CREATE POLICY "Disallow deletes" ON public.group_logs FOR DELETE USING (false);

-- Trigger to automatically log message deletions (user deleting their own message, or staff deleting user's message)
CREATE OR REPLACE FUNCTION public.log_message_deletion()
RETURNS TRIGGER AS $$
DECLARE
    v_group_id UUID;
    v_performer_id UUID;
    v_action_type VARCHAR(50);
BEGIN
    -- Only log group messages
    IF OLD.group_id IS NOT NULL THEN
        v_performer_id := auth.uid();
        
        -- If performer is the sender, it's a self-delete. Otherwise, it's staff deletion
        IF v_performer_id = OLD.sender_id THEN
            v_action_type := 'message_deleted';
        ELSE
            v_action_type := 'staff_deleted_message';
        END IF;

        INSERT INTO public.group_logs (
            group_id,
            action_performer_id,
            target_user_id,
            action_type,
            deleted_message_text
        ) VALUES (
            OLD.group_id,
            v_performer_id,
            OLD.sender_id,
            v_action_type,
            OLD.message_text
        );
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop trigger if exists and recreate
DROP TRIGGER IF EXISTS on_message_deleted ON public.messages;
CREATE TRIGGER on_message_deleted
    BEFORE DELETE ON public.messages
    FOR EACH ROW
    EXECUTE FUNCTION public.log_message_deletion();
