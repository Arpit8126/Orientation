'use client'

import React, { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'

export default function LoginPage() {
  const router = useRouter()
  const supabase = createClient() as any
  
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    let targetEmail = email.trim()

    // Support logging in by username (admin accounts also support username log in)
    if (!targetEmail.includes('@')) {
      try {
        const res = await fetch(`/api/auth/username-email?username=${encodeURIComponent(targetEmail.toLowerCase())}`)
        const data = await res.json()
        if (res.ok && data.email) {
          targetEmail = data.email
        } else {
          setError(data.error || 'Failed to resolve admin credentials.')
          setLoading(false)
          return
        }
      } catch (err) {
        setError('Error resolving login details. Please login with email.')
        setLoading(false)
        return
      }
    }

    const { data: authData, error: signInError } = await supabase.auth.signInWithPassword({
      email: targetEmail,
      password,
    })

    if (signInError) {
      setError(signInError.message)
      setLoading(false)
      return
    }

    if (authData.user) {
      // Query profiles table to ensure user is an administrator (sethji = true)
      const { data: profile, error: profileErr } = await supabase
        .from('profiles')
        .select('sethji')
        .eq('id', authData.user.id)
        .single()

      if (profileErr || !profile?.sethji) {
        await supabase.auth.signOut()
        setError('Access Denied: You do not have administrator permissions.')
        setLoading(false)
        return
      }
    }

    router.push('/dashboard')
  }

  return (
    <div className="min-h-screen bg-canvas flex items-center justify-center font-sans text-ink px-4">
      <div className="max-w-md w-full p-8 rounded-3xl bg-canvas border border-hairline shadow-[0_4px_16px_rgba(0,0,0,0.06)] animate-slide-up">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-extrabold tracking-tight text-ink font-sans">
            PyCode Admin
          </h1>
          <p className="text-gray-500 text-sm mt-2 font-light">Verify teacher applications and manage portal databases</p>
        </div>

        {error && (
          <div className="mb-4 p-3 rounded-xl bg-block-coral border border-hairline text-ink text-sm animate-scale-in">
            {error}
          </div>
        )}

        <form onSubmit={handleLogin} className="space-y-5">
          <div>
            <label className="block text-xs font-semibold text-gray-400 mb-1.5 uppercase tracking-wider font-mono">Admin Email or Username</label>
            <input
              type="text"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="e.g. admin_pookiz"
              className="w-full px-4 py-2.5 bg-canvas border border-hairline rounded-xl text-ink placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary transition-all text-sm font-light"
              required
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-400 mb-1.5 uppercase tracking-wider font-mono">Secret Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="••••••••"
              className="w-full px-4 py-2.5 bg-canvas border border-hairline rounded-xl text-ink placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary transition-all text-sm font-light"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 rounded-full bg-primary hover:opacity-90 text-on-primary font-semibold transition-all text-sm cursor-pointer disabled:opacity-50"
          >
            {loading ? 'Authenticating...' : 'Enter Console'}
          </button>
        </form>
      </div>
    </div>
  )
}
