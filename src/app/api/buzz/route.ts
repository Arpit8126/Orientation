import { NextResponse } from 'next/server'
import { getOrCreateStudent, buzzTeam } from '@/lib/db'
import { createClient } from '@/lib/supabase/server'

export async function POST(request: Request) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ success: false, error: 'Unauthorized user.' }, { status: 401 })
    }

    // Retrieve profile details asynchronously from Supabase
    const profile = await getOrCreateStudent(user.id, user.email || '')

    if (!profile || !profile.fullName) {
      return NextResponse.json({ success: false, error: 'Please set your full name and register first.' }, { status: 400 })
    }

    if (!profile.teamName) {
      return NextResponse.json({ success: false, error: 'You are not assigned to any team yet.' }, { status: 400 })
    }

    // Call buzzTeam helper which checks locks and writes to Supabase
    const result = await buzzTeam(user.id, profile.fullName, profile.teamName)

    if (!result.success) {
      return NextResponse.json({ success: false, error: result.error || 'Failed to buzz.' }, { status: 400 })
    }

    return NextResponse.json({ success: true, rank: result.rank })
  } catch (err: any) {
    console.error('Error in buzz endpoint:', err)
    return NextResponse.json({ success: false, error: err.message || 'Error processing buzz' }, { status: 500 })
  }
}
export const dynamic = 'force-dynamic'
