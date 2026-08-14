import React from 'react'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { getOrCreateStudent } from '@/lib/db'
import StudentPortal from '@/components/StudentPortal'
import AdminPortal from '@/components/AdminPortal'

export default async function Home() {
  // Retrieve the authenticated user session from Supabase
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()

  // Redirect to login if user session is absent
  if (!user) {
    redirect('/login')
  }

  // Check if the user is an administrator
  const ADMIN_EMAILS = ['admin@gla.ac.in']
  const isAdmin = !!user.email && ADMIN_EMAILS.includes(user.email.toLowerCase())

  if (isAdmin) {
    return <AdminPortal />
  }

  // Otherwise, load Student Portal
  // Fetch or initialize student record in our local JSON DB
  const profile = await getOrCreateStudent(user.id, user.email || '')

  return <StudentPortal initialProfile={profile} />
}

export const dynamic = 'force-dynamic'
