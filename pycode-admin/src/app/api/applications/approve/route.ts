import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabase/admin'

// POST /api/applications/approve
// Body: { user_id, id_card_url }
// Uses service role key to bypass RLS and set is_teacher = true
export async function POST(req: NextRequest) {
  try {
    const { user_id, id_card_url } = await req.json()

    if (!user_id) {
      return NextResponse.json({ error: 'user_id is required' }, { status: 400 })
    }

    const supabase = createAdminClient() as any

    // 1. Update application status to approved
    const { error: appErr } = await supabase
      .from('teacher_applications')
      .update({ status: 'approved' })
      .eq('user_id', user_id)

    if (appErr) throw new Error(`Application update failed: ${appErr.message}`)

    // 2. Grant is_teacher = true in profiles (bypasses RLS via service role)
    const { error: profileErr } = await supabase
      .from('profiles')
      .update({ is_teacher: true })
      .eq('id', user_id)

    if (profileErr) throw new Error(`Profile update failed: ${profileErr.message}`)

    // 3. Clean up the ID card image from storage
    if (id_card_url && id_card_url.includes('/teacher-ids/')) {
      const parts = id_card_url.split('/teacher-ids/')
      const filePath = parts[1]
      if (filePath) {
        await supabase.storage.from('teacher-ids').remove([filePath])
      }
    }

    return NextResponse.json({ success: true })
  } catch (err: any) {
    console.error('[approve] Error:', err.message)
    return NextResponse.json({ error: err.message }, { status: 500 })
  }
}
