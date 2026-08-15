import { NextResponse } from 'next/server'
import { updateTeamScore, addTeam, removeTeam, assignStudentTeam, activateBuzzerQuestion, deactivateBuzzer, bulkAssignTeams, assignTeamLeader, removeTeamLeader } from '@/lib/db'
import { createClient } from '@/lib/supabase/server'

export async function POST(request: Request) {
  try {
    // Authenticate the user and check if they are the admin
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user || !user.email) {
      return NextResponse.json({ success: false, error: 'Access denied. Unauthorized request.' }, { status: 403 })
    }

    const { data: profile } = await supabase.from('profiles').select('is_admin').eq('id', user.id).single()

    const ADMIN_EMAILS = ['admin@gla.ac.in']
    const isAdmin = profile?.is_admin || ADMIN_EMAILS.includes(user.email.toLowerCase())

    if (!isAdmin) {
      return NextResponse.json({ success: false, error: 'Access denied. Unauthorized request.' }, { status: 403 })
    }

    const body = await request.json()
    const { action } = body

    if (action === 'update_score') {
      const { teamName, game, score } = body
      if (!teamName || !game) {
        return NextResponse.json({ success: false, error: 'Missing teamName or game.' }, { status: 400 })
      }
      await updateTeamScore(teamName, game, Number(score))
      return NextResponse.json({ success: true })
    } 
    
    else if (action === 'activate_question') {
      const { gameName, questionId, durationMinutes } = body
      if (!gameName || !questionId) {
        return NextResponse.json({ success: false, error: 'Missing gameName or questionId.' }, { status: 400 })
      }
      // Pass the optional upload duration for Prompt Image Creation game
      await activateBuzzerQuestion(
        gameName, 
        questionId, 
        durationMinutes ? Number(durationMinutes) : undefined
      )
      return NextResponse.json({ success: true })
    } 
    
    else if (action === 'deactivate_buzzer') {
      await deactivateBuzzer()
      return NextResponse.json({ success: true })
    } 

    else if (action === 'set_prompt_times') {
      const { startTime, endTime } = body // HH:MM strings
      if (!startTime || !endTime) {
        return NextResponse.json({ success: false, error: 'Missing startTime or endTime.' }, { status: 400 })
      }
      const { createClient: createAdminClient } = await import('@supabase/supabase-js')
      const supabaseAdmin = createAdminClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.SUPABASE_SERVICE_ROLE_KEY!
      )
      const { error } = await supabaseAdmin
        .from('buzzer_state')
        .update({
          prompt_image_start_time: startTime,
          prompt_image_end_time: endTime,
          active_game: 'Prompt image creation',
          updated_at: new Date().toISOString()
        })
        .eq('id', 'active')
      if (error) throw error
      // Notify SSE clients
      const { notifyClients } = await import('@/lib/db')
      notifyClients()
      return NextResponse.json({ success: true })
    } 
    
    else if (action === 'add_team') {
      const { teamName } = body
      if (!teamName) {
        return NextResponse.json({ success: false, error: 'Missing team name.' }, { status: 400 })
      }
      await addTeam(teamName)
      return NextResponse.json({ success: true })
    } 
    
    else if (action === 'remove_team') {
      const { teamName } = body
      if (!teamName) {
        return NextResponse.json({ success: false, error: 'Missing team name.' }, { status: 400 })
      }
      await removeTeam(teamName)
      return NextResponse.json({ success: true })
    } 
    
    else if (action === 'move_student') {
      const { studentId, teamName } = body
      if (!studentId) {
        return NextResponse.json({ success: false, error: 'Missing student ID.' }, { status: 400 })
      }
      await assignStudentTeam(studentId, teamName || null)
      return NextResponse.json({ success: true })
    } 
    
    else if (action === 'bulk_assign_teams') {
      const { assignments } = body // Expected: array of { email: string, team: string }
      if (!Array.isArray(assignments)) {
        return NextResponse.json({ success: false, error: 'Assignments list must be an array.' }, { status: 400 })
      }
      const count = await bulkAssignTeams(assignments)
      return NextResponse.json({ success: true, count })
    } 
    
    else if (action === 'assign_leader') {
      const { studentId, teamName } = body
      if (!studentId || !teamName) {
        return NextResponse.json({ success: false, error: 'Missing studentId or teamName.' }, { status: 400 })
      }
      await assignTeamLeader(studentId, teamName)
      return NextResponse.json({ success: true })
    }
    
    else if (action === 'remove_leader') {
      const { studentId } = body
      if (!studentId) {
        return NextResponse.json({ success: false, error: 'Missing studentId.' }, { status: 400 })
      }
      await removeTeamLeader(studentId)
      return NextResponse.json({ success: true })
    }
    
    else {
      return NextResponse.json({ success: false, error: 'Unknown action request.' }, { status: 400 })
    }
  } catch (err: any) {
    console.error('Error in admin command endpoint:', err)
    return NextResponse.json({ success: false, error: err.message || 'Error processing request' }, { status: 500 })
  }
}
export const dynamic = 'force-dynamic'
