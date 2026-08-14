'use client'

import React, { useState, useRef, useEffect, useTransition, Suspense } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import Link from 'next/link'
import Image from 'next/image'
import { createClient } from '@/lib/supabase/client'
import { signUpAction, resendOtpAction } from '@/app/auth/actions'
import { Shield, Mail, Lock, User, Eye, EyeOff, Loader, CheckCircle2 } from 'lucide-react'

function SignupForm() {
  const router = useRouter()
  const searchParams = useSearchParams()
  
  // View states: 'register' or 'otp'
  const [view, setView] = useState<'register' | 'otp'>('register')
  
  // Form states
  const [fullName, setFullName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  
  // OTP states
  const [otp, setOtp] = useState<string[]>(Array(8).fill(''))
  const [timer, setTimer] = useState(0)
  
  // Status states
  const [errorMsg, setErrorMsg] = useState('')
  const [successMsg, setSuccessMsg] = useState('')
  const [isPending, startTransition] = useTransition()
  const [isGooglePending, setIsGooglePending] = useState(false)
  
  // Input references for the 8-digit OTP boxes
  const otpRefs = useRef<(HTMLInputElement | null)[]>([])

  // If redirecting from login due to unconfirmed email, load OTP view
  useEffect(() => {
    const stepParam = searchParams.get('step')
    const emailParam = searchParams.get('email')
    if (stepParam === 'otp' && emailParam) {
      setEmail(emailParam)
      setView('otp')
      setTimer(60) // Start the 1-minute countdown
    }
  }, [searchParams])

  // Resend Timer Countdown Effect
  useEffect(() => {
    if (timer <= 0) return
    const interval = setInterval(() => {
      setTimer((prev) => prev - 1)
    }, 1000)
    return () => clearInterval(interval)
  }, [timer])

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

  // Handle Initial Registration Submission
  const handleRegisterSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMsg('')
    setSuccessMsg('')

    if (!email || !password || !confirmPassword) {
      setErrorMsg('Please fill in all fields.')
      return
    }

    if (password !== confirmPassword) {
      setErrorMsg('Passwords do not match. Please try again.')
      return
    }

    startTransition(async () => {
      const result = await signUpAction(email, password)

      if (!result.success) {
        setErrorMsg(result.error || 'Failed to sign up.')
      } else {
        // Switch to OTP view
        setView('otp')
        setTimer(60)
        setSuccessMsg('Registration successful! Please check your email for the verification code.')
      }
    })
  }

  // Handle Resending OTP
  const handleResendOtp = () => {
    if (timer > 0) return
    setErrorMsg('')
    setSuccessMsg('')

    startTransition(async () => {
      const result = await resendOtpAction(email)
      if (result.success) {
        setTimer(60)
        setSuccessMsg('A new 8-digit verification code has been sent to your email.')
      } else {
        setErrorMsg(result.error || 'Failed to resend verification code.')
      }
    })
  }

  // Handle OTP Input Typing
  const handleOtpChange = (index: number, val: string) => {
    // Only accept single digit numbers
    const cleanVal = val.replace(/[^0-9]/g, '')
    if (cleanVal.length > 1) return

    const newOtp = [...otp]
    newOtp[index] = cleanVal
    setOtp(newOtp)
    setErrorMsg('')

    // Auto-focus next box if digit entered
    if (cleanVal !== '' && index < 7) {
      otpRefs.current[index + 1]?.focus()
    }
  }

  // Handle OTP Backspace Key
  const handleOtpKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Backspace') {
      if (otp[index] === '' && index > 0) {
        const newOtp = [...otp]
        newOtp[index - 1] = ''
        setOtp(newOtp)
        otpRefs.current[index - 1]?.focus()
      } else {
        const newOtp = [...otp]
        newOtp[index] = ''
        setOtp(newOtp)
      }
      setErrorMsg('')
    }
  }

  // Handle OTP Paste
  const handleOtpPaste = (e: React.ClipboardEvent<HTMLInputElement>) => {
    e.preventDefault()
    const pastedText = e.clipboardData.getData('text').trim()
    const digits = pastedText.replace(/[^0-9]/g, '').slice(0, 8)
    
    if (digits.length === 8) {
      const newOtp = digits.split('')
      setOtp(newOtp)
      setErrorMsg('')
      // Focus the last input box
      otpRefs.current[7]?.focus()
    }
  }

  // Handle OTP Verification Submission
  const handleVerifyOtpSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMsg('')
    
    const otpCode = otp.join('')
    if (otpCode.length !== 8) {
      setErrorMsg('Please enter all 8 digits.')
      return
    }

    startTransition(async () => {
      const supabase = createClient()
      const { data, error } = await supabase.auth.verifyOtp({
        email,
        token: otpCode,
        type: 'signup'
      })

      if (error) {
        setErrorMsg(error.message || 'OTP verification failed.')
      } else {
        setSuccessMsg('Email successfully verified!')
        setTimeout(() => {
          router.push('/')
          router.refresh()
        }, 1500)
      }
    })
  }

  return (
    <div className="flex flex-col lg:flex-row min-h-screen bg-background w-full">
      {/* LEFT SIDE PANEL (Desktop Only) */}
      <div className="hidden lg:flex lg:w-1/2 flex-col justify-between p-16 bg-white border-r border-neutral-300 relative">
        <div className="flex items-center gap-4">
          <Image src="/gla-logo.webp" alt="GLA Logo" width={140} height={140} className="object-contain flex-shrink-0" />
          <span className="font-display font-bold text-lg tracking-tight text-foreground max-w-xs leading-snug">
            GLA University Department Orientation For BCA (AIML & DS) 1st Year students
          </span>
        </div>

        <div className="my-auto max-w-xl pr-6">
          <h1 className="font-display text-4xl font-semibold tracking-tight text-foreground leading-[1.15] mb-6" style={{ letterSpacing: '-1px' }}>
            {view === 'register' ? 'Join the next generation of scholars.' : 'Protecting your academic credentials.'}
          </h1>
          <div className="font-sans text-muted text-sm leading-relaxed mb-8 space-y-2">
            <p>
              {view === 'register' 
                ? 'Create your orientation account and unlock modules, event details, and digital student groups.'
                : 'We have dispatched an 8-digit verification code to confirm your email address. It helps keep your account secure.'}
            </p>
            <div className="bg-neutral-50 p-4 border border-border-light rounded-lg space-y-1 mt-4">
              <p className="font-semibold text-foreground">📅 Date & Time: 19th August 2026, 10:00 AM</p>
              <p className="font-semibold text-foreground">📍 Venue: GLA University AB10 Room No. 122</p>
            </div>
          </div>

          {/* Testimonial Quote Card */}
          <div className="bg-background/50 backdrop-blur-md border border-border-light rounded-xl p-6 shadow-focus-soft mb-8">
            <p className="font-sans text-foreground text-sm leading-relaxed italic mb-4">
              "Signing up took less than two minutes. The OTP verification ensures that all communication lands safely in your student inbox."
            </p>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-full bg-neutral-200 flex items-center justify-center font-display text-xs font-semibold text-foreground">
                RM
              </div>
              <div>
                <p className="text-sm font-semibold text-foreground leading-none">Rishabh Mishra</p>
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

        <div className="text-xs text-muted">
          © {new Date().getFullYear()} GLA University. All rights reserved.
        </div>
      </div>

      {/* RIGHT SIDE PANEL (Interactive Form) */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8 sm:p-12 md:p-16 lg:p-24 bg-white">
        <div className="w-full max-w-md flex flex-col justify-center">
          
          <div className="flex lg:hidden items-center gap-4 mb-8 pb-6 border-b border-neutral-100">
            <Image src="/gla-logo.webp" alt="GLA Logo" width={72} height={72} className="object-contain flex-shrink-0" />
            <span className="font-display font-bold text-base tracking-tight text-foreground leading-snug">
              GLA University Department Orientation For BCA (AIML &amp; DS) 1st Year students
            </span>
          </div>

          {/* Status Notifications */}
          {errorMsg && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-md flex items-start gap-2.5">
              <div className="w-1.5 h-1.5 rounded-full bg-red-600 mt-1.5 flex-shrink-0" />
              <span>{errorMsg}</span>
            </div>
          )}

          {successMsg && (
            <div className="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 text-sm rounded-md flex items-start gap-2.5">
              <CheckCircle2 className="w-4 h-4 text-green-600 flex-shrink-0 mt-0.5" />
              <span>{successMsg}</span>
            </div>
          )}

          {/* VIEW: REGISTER / ACCOUNT CREATION */}
          {view === 'register' && (
            <>
              <div className="mb-8">
                <h2 className="font-display text-3xl font-semibold tracking-tight text-foreground mb-2" style={{ letterSpacing: '-0.9px' }}>
                  Create an account
                </h2>
                <p className="text-sm text-muted">
                  Already have an account?{' '}
                  <Link href="/login" className="text-foreground underline font-medium hover:text-opacity-80 decoration-neutral-400">
                    Sign in
                  </Link>
                </p>
              </div>

              {/* Google Register */}
              <button
                onClick={handleGoogleLogin}
                type="button"
                disabled={isPending || isGooglePending}
                className="flex items-center justify-center gap-3 w-full py-3 px-4 rounded-md border border-border-interactive bg-background text-foreground font-sans text-sm font-medium hover:bg-foreground/5 active:opacity-80 transition cursor-pointer disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {isGooglePending ? (
                  <Loader className="w-4 h-4 animate-spin text-muted" />
                ) : (
                  <svg className="w-4 h-4" viewBox="0 0 24 24">
                    <path
                      fill="#EA4335"
                      d="M12.24 10.285V14.4h6.887c-.648 2.41-2.519 4.114-5.186 4.114-3.513 0-6.36-2.85-6.36-6.36s2.847-6.36 6.36-6.36c1.54 0 2.943.55 4.037 1.458l3.052-3.052C18.997 2.115 15.79.914 12.24.914 6.01.914.914 6.01.914 12.24s5.096 11.326 11.326 11.326c6.12 0 11.16-4.99 11.16-11.326 0-.756-.08-1.48-.226-2.185H12.24z"
                    />
                  </svg>
                )}
                {isGooglePending ? 'Connecting with Google...' : 'Continue with Google'}
              </button>

              <div className="relative flex py-5 items-center">
                <div className="flex-grow border-t border-border-light"></div>
                <span className="flex-shrink mx-4 text-xs text-muted uppercase tracking-wider font-medium">Or register with email</span>
                <div className="flex-grow border-t border-border-light"></div>
              </div>

              <form onSubmit={handleRegisterSubmit} className="space-y-5">
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
                  <label htmlFor="password" className="block text-sm font-medium text-foreground mb-1.5">
                    Password
                  </label>
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

                <div>
                  <label htmlFor="confirmPassword" className="block text-sm font-medium text-foreground mb-1.5">
                    Confirm Password
                  </label>
                  <div className="relative">
                    <input
                      id="confirmPassword"
                      type={showConfirmPassword ? 'text' : 'password'}
                      required
                      placeholder="Re-enter your password"
                      value={confirmPassword}
                      onChange={(e) => setConfirmPassword(e.target.value)}
                      disabled={isPending}
                      className={`w-full bg-background text-foreground border rounded-md py-2.5 pl-10 pr-10 text-sm placeholder-muted focus:outline-none focus:ring-2 focus:ring-blue-500/30 transition ${
                        confirmPassword && password !== confirmPassword
                          ? 'border-red-400 focus:border-red-400'
                          : confirmPassword && password === confirmPassword
                          ? 'border-emerald-400 focus:border-emerald-400'
                          : 'border-border-light focus:border-neutral-400'
                      }`}
                    />
                    <Lock className="w-4 h-4 text-muted absolute left-3 top-3.5" />
                    <button
                      type="button"
                      onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      className="absolute right-3 top-3 text-muted hover:text-foreground cursor-pointer"
                    >
                      {showConfirmPassword ? <EyeOff className="w-4.5 h-4.5" /> : <Eye className="w-4.5 h-4.5" />}
                    </button>
                  </div>
                  {confirmPassword && password !== confirmPassword && (
                    <p className="text-xs text-red-500 mt-1.5 font-medium">Passwords do not match</p>
                  )}
                  {confirmPassword && password === confirmPassword && (
                    <p className="text-xs text-emerald-600 mt-1.5 font-medium">✓ Passwords match</p>
                  )}
                </div>

                <button
                  type="submit"
                  disabled={isPending}
                  className="w-full py-3 bg-foreground text-btn-text-light rounded-md font-sans text-sm font-medium hover:bg-foreground/90 active:scale-[0.99] active:opacity-90 transition cursor-pointer flex items-center justify-center gap-2 shadow-btn-inset"
                >
                  {isPending ? (
                    <>
                      <Loader className="w-4 h-4 animate-spin" />
                      Creating Account...
                    </>
                  ) : (
                    'Register'
                  )}
                </button>
              </form>
            </>
          )}

          {/* VIEW: 8-DIGIT OTP VERIFICATION */}
          {view === 'otp' && (
            <>
              <div className="mb-8">
                <h2 className="font-display text-3xl font-semibold tracking-tight text-foreground mb-2" style={{ letterSpacing: '-0.9px' }}>
                  Verify your email
                </h2>
                <p className="text-sm text-muted">
                  We sent an 8-digit verification code to <span className="font-semibold text-foreground">{email}</span>.
                </p>
              </div>

              <form onSubmit={handleVerifyOtpSubmit} className="space-y-6">
                <div>
                  <label className="block text-sm font-medium text-foreground mb-3 text-center">
                    Enter 8-digit Verification Code
                  </label>
                  
                  {/* OTP 8-box grid */}
                  <div className="grid grid-cols-8 gap-2 max-w-sm mx-auto">
                    {otp.map((digit, idx) => (
                      <input
                        key={idx}
                        ref={(el) => {
                          otpRefs.current[idx] = el
                        }}
                        type="text"
                        inputMode="numeric"
                        maxLength={1}
                        value={digit}
                        onChange={(e) => handleOtpChange(idx, e.target.value)}
                        onKeyDown={(e) => handleOtpKeyDown(idx, e)}
                        onPaste={handleOtpPaste}
                        disabled={isPending}
                        className="w-full aspect-square text-center font-display text-lg sm:text-xl font-bold bg-background text-foreground border-2 border-neutral-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-blue-600 transition shadow-sm"
                      />
                    ))}
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
                      Verifying...
                    </>
                  ) : (
                    'Verify Account'
                  )}
                </button>
              </form>

              {/* Resend Timer / Resend OTP Action */}
              <div className="mt-8 text-center text-sm text-muted">
                {timer > 0 ? (
                  <p>
                    Didn&apos;t receive the code? Resend in{' '}
                    <span className="font-semibold text-foreground">{timer}s</span>
                  </p>
                ) : (
                  <p>
                    Didn&apos;t receive the code?{' '}
                    <button
                      onClick={handleResendOtp}
                      disabled={isPending}
                      className="text-foreground underline font-semibold hover:text-opacity-80 decoration-neutral-400 cursor-pointer"
                    >
                      Send again
                    </button>
                  </p>
                )}
              </div>

              <div className="mt-6 text-center">
                <button
                  type="button"
                  onClick={() => {
                    setView('register')
                    setErrorMsg('')
                    setSuccessMsg('')
                  }}
                  className="text-xs text-muted underline hover:text-foreground decoration-neutral-300"
                >
                  Back to Registration
                </button>
              </div>
            </>
          )}

        </div>
      </div>
    </div>
  )
}

export default function SignupPage() {
  return (
    <Suspense fallback={
      <div className="flex items-center justify-center min-h-screen bg-background">
        <Loader className="w-8 h-8 animate-spin text-muted" />
      </div>
    }>
      <SignupForm />
    </Suspense>
  )
}
