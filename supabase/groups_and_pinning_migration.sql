-- 1. Add rules and font styling columns to groups table
ALTER TABLE groups 
ADD COLUMN IF NOT EXISTS rules TEXT,
ADD COLUMN IF NOT EXISTS font_theme VARCHAR(100) DEFAULT 'default';

-- 2. Create pinned_messages table
CREATE TABLE IF NOT EXISTS pinned_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES messages(id) ON DELETE CASCADE,
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    pinned_by UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT unique_group_message_pin UNIQUE (message_id)
);

-- 3. Enable Realtime replication for pinned_messages
ALTER PUBLICATION supabase_realtime ADD TABLE pinned_messages;
