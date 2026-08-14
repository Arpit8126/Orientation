'use client'

import React, { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { updatePasswordAction } from '@/app/auth/actions'
import Image from 'next/image'
import { Lock, Eye, EyeOff, Loader, CheckCircle2 } from 'lucide-react'

export default function ResetPasswordPage() {
  const router = useRouter()
  
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [errorMsg, setErrorMsg] = useState('')
  const [successMsg, setSuccessMsg] = useState('')
  const [isPending, startTransition] = useTransition()

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMsg('')
    setSuccessMsg('')

    if (!password || !confirmPassword) {
      setErrorMsg('Please fill in all fields.')
      return
    }

    if (password.length < 6) {
      setErrorMsg('Password must be at least 6 characters long.')
      return
    }

    if (password !== confirmPassword) {
      setErrorMsg('Passwords do not match.')
      return
    }

    startTransition(async () => {
      const result = await updatePasswordAction(password)

      if (result.success) {
        setSuccessMsg('Your password has been reset successfully!')
        setTimeout(() => {
          router.push('/')
          router.refresh()
        }, 2000)
      } else {
        setErrorMsg(result.error || 'Failed to reset password. The link may have expired.')
      }
    })
  }

  return (
    <div className="flex flex-col lg:flex-row min-h-screen bg-background w-full">
      {/* LEFT SIDE PANEL (Desktop Only) */}
      <div className="hidden lg:flex lg:w-1/2 flex-col justify-between p-16 bg-white border-r-2 border-neutral-200 relative">
        <div className="flex items-center gap-4">
          <Image src="/gla-logo.webp" alt="GLA Logo" width={140} height={140} className="object-contain flex-shrink-0" />
          <span className="font-display font-bold text-lg tracking-tight text-foreground max-w-xs leading-snug">
            GLA University Department Orientation For BCA (AIML &amp; DS) 1st Year students
          </span>
        </div>

        <div className="my-auto max-w-xl pr-6">
          <h1 className="font-display text-5xl font-semibold tracking-tight text-foreground leading-[1.1] mb-6" style={{ letterSpacing: '-1.5px' }}>
            Set a new secure password.
          </h1>
          <p className="font-sans text-muted text-lg leading-relaxed mb-10">
            Please choose a strong password that you do not use on other platforms. Your security is our priority.
          </p>

          <div className="bg-background/50 backdrop-blur-md border border-border-light rounded-xl p-6 shadow-focus-soft mb-12">
            <p className="font-sans text-foreground text-base leading-relaxed italic mb-4">
              "We utilize modern cryptographic standards to secure your student credentials on GLA University networks."
            </p>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-full bg-neutral-200 flex items-center justify-center font-display text-xs font-semibold text-foreground">
                IT
              </div>
              <div>
                <p className="text-sm font-semibold text-foreground leading-none">IT Security Office</p>
                <p className="text-xs text-muted">GLA University Systems</p>
              </div>
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

          <div className="mb-8">
            <h2 className="font-display text-3xl font-semibold tracking-tight text-foreground mb-2" style={{ letterSpacing: '-0.9px' }}>
              Reset password
            </h2>
            <p className="text-sm text-muted">
              Choose a strong password containing at least 6 characters.
            </p>
          </div>

          {/* Status Messages */}
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

          {/* Reset Password Form */}
          <form onSubmit={handleSubmit} className="space-y-5">
            <div>
              <label htmlFor="password" className="block text-sm font-medium text-foreground mb-1.5">
                New Password
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
                Confirm New Password
              </label>
              <div className="relative">
                <input
                  id="confirmPassword"
                  type={showPassword ? 'text' : 'password'}
                  required
                  placeholder="••••••••"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  disabled={isPending}
                  className="w-full bg-background text-foreground border border-border-light rounded-md py-2.5 pl-10 pr-10 text-sm placeholder-muted focus:outline-none focus:ring-2 focus:ring-blue-500/30 focus:border-neutral-400 transition"
                />
                <Lock className="w-4 h-4 text-muted absolute left-3 top-3.5" />
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
                  Updating password...
                </>
              ) : (
                'Save Password'
              )}
            </button>
          </form>

        </div>
      </div>
    </div>
  )
}
