import { createClient } from '@supabase/supabase-js'

// Initialize the database admin client using service role key
let adminClient: any = null

export function getAdminClient() {
  if (!adminClient) {
    if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error('Missing Supabase environment variables for database operations')
    }
    adminClient = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY,
      {
        auth: {
          persistSession: false,
          autoRefreshToken: false
        }
      }
    )
  }
  return adminClient
}

// Interfaces
export interface StudentProfile {
  id: string
  email: string
  fullName: string | null
  teamName: string | null
  surveyCompleted: boolean
  surveyAnswers: any | null
  registeredAt: string
  isAdmin: boolean
  isLeader: boolean
}

export interface TeamScore {
  teamName: string
  game1: number
  game2: number
  game3: number
  game4: number
  game5: number
  total: number
}

export interface BuzzerRank {
  rank: number
  teamName: string
  userName: string
  pressedAt: string
}

export interface BuzzerState {
  activeGame: string | null
  activeQuestion: string | null
  isActive: boolean
  buzzedByUserId: string | null
  buzzedByName: string | null
  buzzedByTeam: string | null
  promptImageStartTime: string | null
  promptImageEndTime: string | null
}

export interface TeamUpload {
  rank: number
  teamName: string
  imageUrl: string
  uploadedAt: string
}

export const DEFAULT_TEAMS = [
  'Transformer', 'CNN', 'RNN', 'LLM', 'Agentic AI',
  'Linear Regression', 'Logistic Regression', 'RAG', 'SVM',
  'Random Forest', 'XGBoost', 'LangChain', 'LlamaIndex',
  'Hugging Face', 'Ollama', 'PyTorch', 'TensorFlow', 'vLLM'
]

// SSE client stream controllers
const globalSse = global as any
if (!globalSse._sseClients) {
  globalSse._sseClients = new Set<ReadableStreamDefaultController>()
}
export const sseClients = globalSse._sseClients as Set<ReadableStreamDefaultController>

// Push notifications to clients
export function notifyClients() {
  const encoder = new TextEncoder()
  const data = encoder.encode('data: update\n\n')
  sseClients.forEach((controller) => {
    try {
      controller.enqueue(data)
    } catch (e) {
      sseClients.delete(controller)
    }
  })
}

// 1. Fetch Leaderboard and auto-seed if empty
export async function getLeaderboard(): Promise<TeamScore[]> {
  const admin = getAdminClient()
  const { data, error } = await admin.from('leaderboard').select('*')
  if (error) throw error

  if (!data || data.length === 0) {
    // Auto-seed the default 18 teams
    const payload = DEFAULT_TEAMS.map((teamName) => ({
      team_name: teamName,
      game_1: 0, game_2: 0, game_3: 0, game_4: 0, game_5: 0,
      total: 0
    }))
    const { error: seedErr } = await admin.from('leaderboard').insert(payload)
    if (seedErr) throw seedErr
    
    return payload.map((t: any) => ({
      teamName: t.team_name,
      game1: t.game_1, game2: t.game_2, game3: t.game_3, game4: t.game_4, game5: t.game_5,
      total: t.total
    }))
  }

  return data.map((t: any) => ({
    teamName: t.team_name,
    game1: t.game_1, game2: t.game_2, game3: t.game_3, game4: t.game_4, game5: t.game_5,
    total: t.total
  }))
}

// 2. Fetch active Buzzer State and seed default row if empty
export async function getBuzzerState(): Promise<BuzzerState> {
  const admin = getAdminClient()
  const { data, error } = await admin.from('buzzer_state').select('*').eq('id', 'active').maybeSingle()

  if (error) throw error

  if (!data) {
    // Seed default state
    const defaultState = {
      id: 'active',
      active_game: 'guess the song',
      active_question: 'Q1',
      is_active: false,
      buzzed_by_user_id: null,
      buzzed_by_name: null,
      buzzed_by_team: null,
      prompt_image_start_time: null,
      prompt_image_end_time: null,
      updated_at: new Date().toISOString()
    }
    const { error: seedErr } = await admin.from('buzzer_state').insert(defaultState)
    if (seedErr) throw seedErr

    return {
      activeGame: defaultState.active_game,
      activeQuestion: defaultState.active_question,
      isActive: defaultState.is_active,
      buzzedByUserId: defaultState.buzzed_by_user_id,
      buzzedByName: defaultState.buzzed_by_name,
      buzzedByTeam: defaultState.buzzed_by_team,
      promptImageStartTime: defaultState.prompt_image_start_time,
      promptImageEndTime: defaultState.prompt_image_end_time
    }
  }

  return {
    activeGame: data.active_game,
    activeQuestion: data.active_question,
    isActive: data.is_active,
    buzzedByUserId: data.buzzed_by_user_id,
    buzzedByName: data.buzzed_by_name,
    buzzedByTeam: data.buzzed_by_team,
    promptImageStartTime: data.prompt_image_start_time,
    promptImageEndTime: data.prompt_image_end_time
  }
}

// 3. Fetch Buzzer Ranks list
export async function getBuzzerRanks(): Promise<BuzzerRank[]> {
  const admin = getAdminClient()
  const { data, error } = await admin.from('buzzer_ranks').select('*').order('rank', { ascending: true })
  if (error) throw error

  return (data || []).map((r: any) => ({
    rank: r.rank,
    teamName: r.team_name,
    userName: r.user_name,
    pressedAt: r.pressed_at
  }))
}

// 4. Fetch Students Profiles List
export async function getStudentsList(): Promise<StudentProfile[]> {
  const admin = getAdminClient()
  const { data, error } = await admin.from('profiles').select('*').order('registered_at', { ascending: true })
  if (error) throw error

  const ADMIN_EMAILS = ['admin@gla.ac.in']

  return (data || [])
    .filter((s: any) => !s.is_admin && !ADMIN_EMAILS.includes(s.email.toLowerCase()))
    .map((s: any) => ({
      id: s.id,
      email: s.email,
      fullName: s.full_name,
      teamName: s.team_name,
      surveyCompleted: s.survey_completed,
      surveyAnswers: s.survey_answers,
      registeredAt: s.registered_at,
      isAdmin: s.is_admin || false,
      isLeader: s.is_leader || false
    }))
}

// 5. Get student profile, initializing a new row if absent
export async function getOrCreateStudent(id: string, email: string): Promise<StudentProfile> {
  const admin = getAdminClient()
  const { data, error } = await admin.from('profiles').select('*').eq('id', id).maybeSingle()

  if (error) throw error

  if (!data) {
    const newStudent = {
      id,
      email,
      full_name: null,
      team_name: null,
      survey_completed: false,
      survey_answers: null,
      registered_at: new Date().toISOString(),
      is_admin: false,
      is_leader: false
    }
    const { error: seedErr } = await admin.from('profiles').upsert(newStudent, { onConflict: 'id', ignoreDuplicates: true })
    if (seedErr) throw seedErr

    return {
      id: newStudent.id,
      email: newStudent.email,
      fullName: newStudent.full_name,
      teamName: newStudent.team_name,
      surveyCompleted: newStudent.survey_completed,
      surveyAnswers: newStudent.survey_answers,
      registeredAt: newStudent.registered_at,
      isAdmin: newStudent.is_admin,
      isLeader: newStudent.is_leader
    }
  }

  return {
    id: data.id,
    email: data.email,
    fullName: data.full_name,
    teamName: data.team_name,
    surveyCompleted: data.survey_completed,
    surveyAnswers: data.survey_answers,
    registeredAt: data.registered_at,
    isAdmin: data.is_admin || false,
    isLeader: data.is_leader || false
  }
}

// 6. Save registration details & survey responses
export async function saveStudentSurvey(id: string, fullName: string, surveyAnswers: any): Promise<void> {
  const admin = getAdminClient()
  const { error } = await admin.from('profiles').update({
    full_name: fullName,
    survey_answers: surveyAnswers,
    survey_completed: true
  }).eq('id', id)

  if (error) throw error
  notifyClients()
}

// 7. Change/assign student team
export async function assignStudentTeam(id: string, teamName: string | null): Promise<void> {
  const admin = getAdminClient()
  const { error } = await admin.from('profiles').update({
    team_name: teamName
  }).eq('id', id)

  if (error) throw error
  notifyClients()
}

// 8. Update scores for a specific team and game
export async function updateTeamScore(teamName: string, gameField: string, score: number): Promise<void> {
  const admin = getAdminClient()
  const { data: teamRow, error: fetchErr } = await admin.from('leaderboard').select('*').eq('team_name', teamName).maybeSingle()
  if (fetchErr) throw fetchErr

  if (teamRow) {
    const updatePayload: any = {}
    const dbField = gameField === 'game1' ? 'game_1' :
                    gameField === 'game2' ? 'game_2' :
                    gameField === 'game3' ? 'game_3' :
                    gameField === 'game4' ? 'game_4' : 'game_5'
    updatePayload[dbField] = score

    const g1 = dbField === 'game_1' ? score : teamRow.game_1
    const g2 = dbField === 'game_2' ? score : teamRow.game_2
    const g3 = dbField === 'game_3' ? score : teamRow.game_3
    const g4 = dbField === 'game_4' ? score : teamRow.game_4
    const g5 = dbField === 'game_5' ? score : teamRow.game_5
    
    updatePayload.total = Number(g1) + Number(g2) + Number(g3) + Number(g4) + Number(g5)

    const { error: updateErr } = await admin.from('leaderboard').update(updatePayload).eq('team_name', teamName)
    if (updateErr) throw updateErr
    
    notifyClients()
  }
}

// 9. Add a new team
export async function addTeam(teamName: string): Promise<void> {
  const admin = getAdminClient()
  const { error } = await admin.from('leaderboard').insert({
    team_name: teamName,
    game_1: 0, game_2: 0, game_3: 0, game_4: 0, game_5: 0,
    total: 0
  })

  if (error) throw error
  notifyClients()
}

// 10. Remove a team (and unassign members)
export async function removeTeam(teamName: string): Promise<void> {
  const admin = getAdminClient()
  
  // Delete from leaderboard
  const { error: deleteErr } = await admin.from('leaderboard').delete().eq('team_name', teamName)
  if (deleteErr) throw deleteErr

  // Unassign members
  const { error: updateErr } = await admin.from('profiles').update({ team_name: null }).eq('team_name', teamName)
  if (updateErr) throw updateErr

  notifyClients()
}

// 11. Activate buzzer question controls
export async function activateBuzzerQuestion(gameName: string, questionId: string, durationMinutes?: number): Promise<void> {
  const admin = getAdminClient()
  
  const startTime = gameName === 'Prompt image creation' ? new Date().toISOString() : null
  const endTime = gameName === 'Prompt image creation' && durationMinutes 
    ? new Date(Date.now() + durationMinutes * 60000).toISOString() 
    : null

  // Reset the active buzzer status
  const { error: updateErr } = await admin.from('buzzer_state').update({
    active_game: gameName,
    active_question: questionId,
    is_active: gameName !== 'Prompt image creation' && gameName !== 'continue the story',
    buzzed_by_user_id: null,
    buzzed_by_name: null,
    buzzed_by_team: null,
    prompt_image_start_time: startTime,
    prompt_image_end_time: endTime,
    updated_at: new Date().toISOString()
  }).eq('id', 'active')

  if (updateErr) throw updateErr

  // Clear buzzer ranks list
  const { error: clearErr } = await admin.from('buzzer_ranks').delete().neq('team_name', '')
  if (clearErr) throw clearErr

  // If starting Prompt Image Creation game, clear previous uploads
  if (gameName === 'Prompt image creation') {
    const { error: clearUploadsErr } = await admin.from('team_uploads').delete().neq('team_name', '')
    if (clearUploadsErr) throw clearUploadsErr
  }

  notifyClients()
}

// 12. Deactivate/lock buzzer clicks
export async function deactivateBuzzer(): Promise<void> {
  const admin = getAdminClient()
  const { error } = await admin.from('buzzer_state').update({
    is_active: false
  }).eq('id', 'active')

  if (error) throw error
  notifyClients()
}

// 13. Process student team buzzer pressing
export async function buzzTeam(userId: string, fullName: string, teamName: string): Promise<{ success: boolean; rank?: number; error?: string }> {
  const admin = getAdminClient()

  // Call the atomic Postgres RPC function to prevent race conditions and rank duplication
  const { data, error } = await admin.rpc('buzz_team_atomic', {
    p_user_id: userId,
    p_full_name: fullName,
    p_team_name: teamName
  })

  if (error) {
    console.error('Buzzer RPC error:', error)
    return { success: false, error: error.message || 'Database error during buzzer click.' }
  }

  const result = data?.[0]
  if (!result || !result.success) {
    return { success: false, error: result?.error_message || 'Failed to buzz.' }
  }

  notifyClients()
  return { success: true, rank: result.rank }
}

// 13.1 Assign team leader in database (demoting current leader of this team)
export async function assignTeamLeader(studentId: string, teamName: string): Promise<void> {
  const admin = getAdminClient()
  
  // Demote any student currently marked as leader for this specific team
  const { error: demoteError } = await admin
    .from('profiles')
    .update({ is_leader: false })
    .eq('team_name', teamName)
    
  if (demoteError) throw demoteError

  // Promote the chosen student to leader
  const { error: promoteError } = await admin
    .from('profiles')
    .update({ is_leader: true })
    .eq('id', studentId)
    
  if (promoteError) throw promoteError

  notifyClients()
}

// 13.2 Remove team leader role from a student
export async function removeTeamLeader(studentId: string): Promise<void> {
  const admin = getAdminClient()
  const { error } = await admin
    .from('profiles')
    .update({ is_leader: false })
    .eq('id', studentId)
    
  if (error) throw error

  notifyClients()
}

// 14. Bulk assign teams to students in Supabase
export async function bulkAssignTeams(assignments: { email: string; team: string }[]): Promise<number> {
  const admin = getAdminClient()
  let count = 0
  for (const assignment of assignments) {
    if (!assignment.email || !assignment.team) continue
    const { error } = await admin
      .from('profiles')
      .update({ team_name: assignment.team })
      .eq('email', assignment.email.toLowerCase())
    
    if (!error) {
      count++
    }
  }

  if (count > 0) {
    notifyClients()
  }
  return count
}

// 15. Create Storage Bucket for Prompt Images if missing
export async function createBucketPromptImages() {
  const admin = getAdminClient()
  try {
    const { data: buckets, error } = await admin.storage.listBuckets()
    if (error) throw error
    const exists = buckets?.some((b: any) => b.name === 'prompt_images')
    if (!exists) {
      await admin.storage.createBucket('prompt_images', {
        public: true,
        allowedMimeTypes: ['image/jpeg', 'image/png', 'image/webp', 'image/gif'],
        fileSizeLimit: 31457280 // 30MB
      })
    }
  } catch (err) {
    console.error('Error verifying storage bucket:', err)
  }
}

// 16. Get Ranked Team Submissions for Prompt Image game
export async function getTeamUploads(): Promise<TeamUpload[]> {
  const admin = getAdminClient()
  const { data, error } = await admin
    .from('team_uploads')
    .select('*')
    .order('uploaded_at', { ascending: true })
  
  if (error) throw error

  return (data || []).map((u: any, idx: number) => ({
    rank: idx + 1,
    teamName: u.team_name,
    imageUrl: u.image_url,
    uploadedAt: u.uploaded_at
  }))
}

// 17. Upload image file to Supabase storage bucket and update db records
export async function uploadTeamImage(
  teamName: string,
  fileBuffer: Buffer,
  fileExt: string,
  contentType: string
): Promise<string> {
  const admin = getAdminClient()
  
  // Ensure the storage bucket exists
  await createBucketPromptImages()

  // Use a timestamp in filename to bust cache and force timestamp updates
  const cleanedTeam = teamName.replace(/\s+/g, '_')
  const filename = `teams/${cleanedTeam}_${Date.now()}.${fileExt}`

  // Upload file buffer directly
  const { error: uploadErr } = await admin.storage
    .from('prompt_images')
    .upload(filename, fileBuffer, {
      contentType,
      upsert: true
    })

  if (uploadErr) {
    console.error('Bucket upload error:', uploadErr)
    throw new Error('Failed to upload image file to storage bucket')
  }

  // Obtain the public access URL
  const { data: urlData } = admin.storage.from('prompt_images').getPublicUrl(filename)
  const publicUrl = urlData.publicUrl

  // Upsert the team upload record, resetting uploaded_at to now() to update ranking order
  const { error: dbErr } = await admin.from('team_uploads').upsert({
    team_name: teamName,
    image_url: publicUrl,
    uploaded_at: new Date().toISOString()
  })

  if (dbErr) {
    console.error('Database write error during upload:', dbErr)
    throw new Error('Failed to save image metadata in database')
  }

  notifyClients()
  return publicUrl
}
