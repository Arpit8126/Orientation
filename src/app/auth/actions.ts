'use server'

import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'
import { saveStudentSurvey } from '@/lib/db'

export async function signUpAction(email: string, password: string, fullName: string = '') {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: {
          full_name: fullName,
        },
      },
    })

    if (error) {
      return { success: false, error: error.message }
    }

    return { 
      success: true, 
      user: data.user,
      session: data.session,
    }
  } catch (err: any) {
    return { success: false, error: err.message || 'An unexpected error occurred.' }
  }
}

export async function loginAction(email: string, password: string) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })

    if (error) {
      if (error.message.toLowerCase().includes('confirm') || error.message.toLowerCase().includes('verified')) {
        return { success: false, isUnconfirmed: true, error: error.message }
      }
      return { success: false, error: error.message }
    }

    return { success: true, user: data.user }
  } catch (err: any) {
    return { success: false, error: err.message || 'An unexpected error occurred.' }
  }
}

export async function resendOtpAction(email: string) {
  try {
    const supabase = await createClient()
    const { error } = await supabase.auth.resend({
      type: 'signup',
      email: email,
    })

    if (error) {
      return { success: false, error: error.message }
    }

    return { success: true }
  } catch (err: any) {
    return { success: false, error: err.message || 'An unexpected error occurred.' }
  }
}

export async function forgotPasswordAction(email: string, origin: string) {
  try {
    const adminClient = createAdminClient()
    
    // Retrieve users list using Admin API
    const { data, error: adminError } = await adminClient.auth.admin.listUsers()
    if (adminError) {
      console.error('Admin API error listing users:', adminError)
      return { success: false, error: 'Error checking email status. Please try again later.' }
    }

    const user = data.users.find(u => u.email?.toLowerCase() === email.toLowerCase())
    
    if (!user || !user.email_confirmed_at) {
      return { success: false, error: 'This email is not registered with us.' }
    }

    // Send recovery password email
    const supabase = await createClient()
    const { error: resetError } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${origin}/auth/callback?next=/reset-password`,
    })

    if (resetError) {
      return { success: false, error: resetError.message }
    }

    return { success: true, message: 'Password reset link has been successfully sent to your email.' }
  } catch (err: any) {
    return { success: false, error: err.message || 'An unexpected error occurred.' }
  }
}

export async function updatePasswordAction(password: string) {
  try {
    const supabase = await createClient()
    const { error } = await supabase.auth.updateUser({
      password,
    })

    if (error) {
      return { success: false, error: error.message }
    }

    return { success: true }
  } catch (err: any) {
    return { success: false, error: err.message || 'An unexpected error occurred.' }
  }
}

export async function signOutAction() {
  try {
    const supabase = await createClient()
    await supabase.auth.signOut()
    return { success: true }
  } catch (err: any) {
    return { success: false, error: err.message || 'An unexpected error occurred.' }
  }
}

// NEW Server Action: Save student survey answers
export async function saveStudentSurveyAction(fullName: string, surveyAnswers: any) {
  try {
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      return { success: false, error: 'Unauthorized user session.' }
    }

    saveStudentSurvey(user.id, fullName, surveyAnswers)
    return { success: true }
  } catch (err: any) {
    return { success: false, error: err.message || 'Failed to save orientation survey.' }
  }
}
