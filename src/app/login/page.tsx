'use client'

import React, { useState, useTransition, Suspense } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import Link from 'next/link'
import Image from 'next/image'
import { createClient } from '@/lib/supabase/client'
import { loginAction } from '@/app/auth/actions'
import { Shield, Mail, Lock, Eye, EyeOff, Loader } from 'lucide-react'

function LoginForm() {
  const router = useRouter()
  const searchParams = useSearchParams()
  
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [errorMsg, setErrorMsg] = useState(searchParams.get('error') || '')
  const [isPending, startTransition] = useTransition()
  const [isGooglePending, setIsGooglePending] = useState(false)

  // Google Login Auth handler using Supabase Client
  const handleGoogleLogin = async () => {
    try {
      setIsGooglePending(true)
      const supabase = createClient()
      const origin = window.location.origin
      await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: `${origin}/auth/callback`,
        },
      })
    } catch (err: any) {
      setIsGooglePending(false)
      setErrorMsg(err.message || 'Failed to initialize Google login.')
    }
  }

  // Handle Form Submission
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMsg('')

    if (!email || !password) {
      setErrorMsg('Please enter both email and password.')
      return
    }

    startTransition(async () => {
      const result = await loginAction(email, password)
      
      if (!result.success) {
        if (result.isUnconfirmed) {
          // Redirect user to signup OTP confirmation screen
          router.push(`/signup?email=${encodeURIComponent(email)}&step=otp`)
        } else {
          setErrorMsg(result.error || 'Invalid credentials.')
        }
      } else {
        router.push('/')
        router.refresh()
      }
    })
  }

  return (
    <div className="flex flex-col lg:flex-row min-h-screen bg-background w-full">
      {/* LEFT SIDE PANEL (Desktop Only) */}
      <div className="hidden lg:flex lg:w-1/2 flex-col justify-between p-16 bg-white border-r-2 border-neutral-200 relative">
        {/* Brand header */}
        <div className="flex items-center gap-4">
          <Image src="/gla-logo.webp" alt="GLA Logo" width={140} height={140} className="object-contain flex-shrink-0" />
          <span className="font-display font-bold text-lg tracking-tight text-foreground max-w-xs leading-snug">
            GLA University Department Orientation For BCA (AIML &amp; DS) 1st Year students
          </span>
        </div>

        {/* Hero Title & Description */}
        <div className="my-auto max-w-xl pr-6">
          <h1 className="font-display text-4xl font-semibold tracking-tight text-foreground leading-[1.15] mb-6" style={{ letterSpacing: '-1px' }}>
            Your academic journey begins here.
          </h1>
          <div className="font-sans text-muted text-sm leading-relaxed mb-8 space-y-2">
            <p>Welcome to the GLA University Orientation Portal. Access event details, connect with peers, and navigate campus life digitally.</p>
            <div className="bg-neutral-50 p-4 border border-border-light rounded-lg space-y-1 mt-4">
              <p className="font-semibold text-foreground">📅 Date & Time: 19th August 2026, 10:00 AM</p>
              <p className="font-semibold text-foreground">📍 Venue: GLA University AB10 Room No. 122</p>
            </div>
          </div>

          {/* Quote Card */}
          <div className="bg-background/50 backdrop-blur-md border border-border-light rounded-xl p-6 shadow-focus-soft mb-8">
            <p className="font-sans text-foreground text-sm leading-relaxed italic mb-4">
              "The digital onboarding helped me discover clubs, modules, and peers before classes even started. An absolute game-changer!"
            </p>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-full bg-neutral-200 flex items-center justify-center font-display text-xs font-semibold text-foreground">
                AP
              </div>
              <div>
                <p className="text-sm font-semibold text-foreground leading-none">Arpit Pandey</p>
                <p className="text-xs text-muted">BCA DS Student, 2027 Batch (3rd Year)</p>
              </div>
            </div>
          </div>

          {/* Stats Bar */}
          <div className="grid grid-cols-2 gap-6 border-t border-border-light pt-6">
            <div>
              <p className="font-display text-2xl font-semibold text-foreground tracking-tight">BCA AIML</p>
              <p className="text-xs text-muted font-semibold uppercase tracking-wider mt-0.5">1st Year Session</p>
            </div>
            <div>
              <p className="font-display text-2xl font-semibold text-foreground tracking-tight">BCA DS</p>
              <p className="text-xs text-muted font-semibold uppercase tracking-wider mt-0.5">1st Year Session</p>
            </div>
          </div>
        </div>

        {/* Footer info */}
        <div className="text-xs text-muted">
          © {new Date().getFullYear()} GLA University. All rights reserved.
        </div>
      </div>

      {/* RIGHT SIDE PANEL (Interactive Form) */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 sm:p-12 md:p-16 lg:p-24 bg-white">
        <div className="w-full max-w-md flex flex-col justify-center">
          
          {/* Mobile Brand Header */}
          <div className="flex lg:hidden items-center gap-4 mb-8 pb-6 border-b border-neutral-100">
            <Image src="/gla-logo.webp" alt="GLA Logo" width={72} height={72} className="object-contain flex-shrink-0" />
            <span className="font-display font-bold text-base tracking-tight text-foreground leading-snug">
              GLA University Department Orientation For BCA (AIML &amp; DS) 1st Year students
            </span>
          </div>

          <div className="mb-8">
            <h2 className="font-display text-3xl font-semibold tracking-tight text-foreground mb-2" style={{ letterSpacing: '-0.9px' }}>
              Welcome back
            </h2>
            <p className="text-sm text-muted">
              Don&apos;t have an account?{' '}
              <Link href="/signup" className="text-foreground underline font-medium hover:text-opacity-80 decoration-neutral-400">
                Sign up
              </Link>
            </p>
          </div>

          {/* Google Authentication Button */}
          <button
            onClick={handleGoogleLogin}
            type="button"
            disabled={isPending || isGooglePending}
            className="flex items-center justify-center gap-3 w-full py-3 px-4 rounded-md border border-border-interactive bg-background text-foreground font-sans text-sm font-medium hover:bg-foreground/5 active:opacity-80 transition cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed"
          >
            {isGooglePending ? (
              <Loader className="w-4 h-4 animate-spin text-muted" />
            ) : (
              /* SVG Google Logo */
              <svg className="w-4 h-4" viewBox="0 0 24 24">
                <path
                  fill="#EA4335"
                  d="M12.24 10.285V14.4h6.887c-.648 2.41-2.519 4.114-5.186 4.114-3.513 0-6.36-2.85-6.36-6.36s2.847-6.36 6.36-6.36c1.54 0 2.943.55 4.037 1.458l3.052-3.052C18.997 2.115 15.79.914 12.24.914 6.01.914.914 6.01.914 12.24s5.096 11.326 11.326 11.326c6.12 0 11.16-4.99 11.16-11.326 0-.756-.08-1.48-.226-2.185H12.24z"
                />
              </svg>
            )}
            {isGooglePending ? 'Connecting with Google...' : 'Continue with Google'}
          </button>

          {/* Divider */}
          <div className="relative flex py-5 items-center">
            <div className="flex-grow border-t border-border-light"></div>
            <span className="flex-shrink mx-4 text-xs text-muted uppercase tracking-wider font-medium">Or email sign in</span>
            <div className="flex-grow border-t border-border-light"></div>
          </div>

          {/* Error Message */}
          {errorMsg && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-md flex items-start gap-2.5">
              <div className="w-1.5 h-1.5 rounded-full bg-red-600 mt-1.5 flex-shrink-0" />
              <span>{errorMsg}</span>
            </div>
          )}

          {/* Login Form */}
          <form onSubmit={handleSubmit} className="space-y-5">
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-foreground mb-1.5">
                Email Address
              </label>
              <div className="relative">
                <input
                  id="email"
                  type="email"
                  required
                  placeholder="name@gla.ac.in"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  disabled={isPending}
                  className="w-full bg-background text-foreground border border-border-light rounded-md py-2.5 pl-10 pr-4 text-sm placeholder-muted focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-neutral-400 transition"
                />
                <Mail className="w-4 h-4 text-muted absolute left-3 top-3.5" />
              </div>
            </div>

            <div>
              <div className="flex justify-between items-center mb-1.5">
                <label htmlFor="password" className="block text-sm font-medium text-foreground">
                  Password
                </label>
                <Link
                  href="/forgot-password"
                  className="text-xs text-muted underline hover:text-foreground transition decoration-neutral-300"
                >
                  Forgot Password?
                </Link>
              </div>
              <div className="relative">
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  required
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  disabled={isPending}
                  className="w-full bg-background text-foreground border border-border-light rounded-md py-2.5 pl-10 pr-10 text-sm placeholder-muted focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-neutral-400 transition"
                />
                <Lock className="w-4 h-4 text-muted absolute left-3 top-3.5" />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-3 text-muted hover:text-foreground cursor-pointer"
                >
                  {showPassword ? <EyeOff className="w-4.5 h-4.5" /> : <Eye className="w-4.5 h-4.5" />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              disabled={isPending}
              className="w-full py-3 bg-foreground text-btn-text-light rounded-md font-sans text-sm font-medium hover:bg-foreground/90 active:scale-[0.99] active:opacity-90 transition cursor-pointer flex items-center justify-center gap-2 shadow-btn-inset"
            >
              {isPending ? (
                <>
                  <Loader className="w-4 h-4 animate-spin" />
                  Signing in...
                </>
              ) : (
                'Sign In'
              )}
            </button>
          </form>

        </div>
      </div>
    </div>
  )
}

export default function LoginPage() {
  return (
    <Suspense fallback={
      <div className="flex items-center justify-center min-h-screen bg-background">
        <Loader className="w-8 h-8 animate-spin text-muted" />
      </div>
    }>
      <LoginForm />
    </Suspense>
  )
}
