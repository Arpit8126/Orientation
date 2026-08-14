import { NextResponse } from 'next/server'
import { getLeaderboard, getBuzzerState, getBuzzerRanks, getStudentsList, getOrCreateStudent, getTeamUploads } from '@/lib/db'
import { createClient } from '@/lib/supabase/server'

export async function GET(request: Request) {
  try {
    // Authenticate user to provide personal details (profile, team mates)
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()
    
    // Fetch state details concurrently in parallel from Supabase to optimize latency
    const [leaderboard, buzzerState, buzzerRanks, studentsList, teamUploads] = await Promise.all([
      getLeaderboard(),
      getBuzzerState(),
      getBuzzerRanks(),
      getStudentsList(),
      getTeamUploads()
    ])

    // Sort leaderboard in descending order by total score
    const sortedLeaderboard = [...leaderboard].sort((a, b) => b.total - a.total)

    let studentProfile = null
    let teamMembers: any[] = []

    if (user) {
      // Find or initialize profile details for the user in Supabase
      studentProfile = await getOrCreateStudent(user.id, user.email || '')

      if (studentProfile.teamName) {
        // Collect all members belonging to this team
        const targetTeam = studentProfile.teamName.toLowerCase()
        teamMembers = studentsList
          .filter((s) => s.teamName?.toLowerCase() === targetTeam)
          .map((s) => ({
            id: s.id,
            fullName: s.fullName,
            email: s.email
          }))
      }
    }

    // Return current system state including team uploads
    return NextResponse.json({
      success: true,
      leaderboard: sortedLeaderboard,
      buzzerState,
      buzzerRanks,
      teamUploads,
      profile: studentProfile,
      teamMembers,
      studentsList
    })
  } catch (err: any) {
    console.error('Error fetching game-state:', err)
    return NextResponse.json({ success: false, error: err.message || 'Error loading status' }, { status: 500 })
  }
}
export const dynamic = 'force-dynamic'
