import { NextResponse } from 'next/server'
import { getOrCreateStudent, getBuzzerState, uploadTeamImage } from '@/lib/db'
import { createClient } from '@/lib/supabase/server'

export async function POST(request: Request) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return NextResponse.json({ success: false, error: 'Unauthorized user session.' }, { status: 401 })
    }

    // Retrieve profile details to check team assignment
    const profile = await getOrCreateStudent(user.id, user.email || '')

    if (!profile || !profile.fullName) {
      return NextResponse.json({ success: false, error: 'Please set your full name and register first.' }, { status: 400 })
    }

    if (!profile.teamName) {
      return NextResponse.json({ success: false, error: 'You are not assigned to any team yet.' }, { status: 400 })
    }

    // Verify if the active game is Prompt Image Creation and that the timer is open
    const bState = await getBuzzerState()
    if (bState.activeGame !== 'Prompt image creation') {
      return NextResponse.json({ success: false, error: 'Image uploads are not open for this game.' }, { status: 400 })
    }

    const now = new Date()
    const start = bState.promptImageStartTime ? new Date(bState.promptImageStartTime) : null
    const end = bState.promptImageEndTime ? new Date(bState.promptImageEndTime) : null

    if (!start || !end || now < start || now > end) {
      return NextResponse.json({ success: false, error: 'Upload period is not active or has expired.' }, { status: 400 })
    }

    // Parse files from FormData
    const formData = await request.formData()
    const file = formData.get('file') as File | null

    if (!file) {
      return NextResponse.json({ success: false, error: 'No image file found in payload.' }, { status: 400 })
    }

    // Enforce 30MB size limit
    const MAX_SIZE = 30 * 1024 * 1024 // 30MB
    if (file.size > MAX_SIZE) {
      return NextResponse.json({ success: false, error: 'File size exceeds the 30MB limit.' }, { status: 400 })
    }

    // Validate MIME types
    const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif']
    if (!ALLOWED_TYPES.includes(file.type)) {
      return NextResponse.json({ success: false, error: 'Invalid file format. Only JPEG, PNG, WEBP, or GIF are allowed.' }, { status: 400 })
    }

    // Convert file to buffer
    const arrayBuffer = await file.arrayBuffer()
    const fileBuffer = Buffer.from(arrayBuffer)
    const fileExt = file.name.split('.').pop() || 'png'

    // Upload to storage bucket and update records
    const imageUrl = await uploadTeamImage(profile.teamName, fileBuffer, fileExt, file.type)

    return NextResponse.json({ success: true, imageUrl })
  } catch (err: any) {
    console.error('Error handling upload endpoint:', err)
    return NextResponse.json({ success: false, error: err.message || 'Error processing image upload' }, { status: 500 })
  }
}
export const dynamic = 'force-dynamic'
export const maxDuration = 60 // Allow longer timeout for large file uploads
