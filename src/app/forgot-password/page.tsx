'use client'

import React, { useState, useTransition } from 'react'
import Link from 'next/link'
import Image from 'next/image'
import { forgotPasswordAction } from '@/app/auth/actions'
import { Mail, ArrowLeft, Loader, CheckCircle2 } from 'lucide-react'

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState('')
  const [errorMsg, setErrorMsg] = useState('')
  const [successMsg, setSuccessMsg] = useState('')
  const [isPending, startTransition] = useTransition()

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMsg('')
    setSuccessMsg('')

    if (!email) {
      setErrorMsg('Please enter your email address.')
      return
    }

    startTransition(async () => {
      // Get the absolute origin for redirection link
      const origin = window.location.origin
      const result = await forgotPasswordAction(email, origin)

      if (result.success) {
        setSuccessMsg(result.message || 'Password reset link sent!')
      } else {
        setErrorMsg(result.error || 'Failed to request password reset.')
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
            Recover access to your account.
          </h1>
          <p className="font-sans text-muted text-lg leading-relaxed mb-10">
            Provide your registered email address to verify status and receive secure link instructions to reset your login credentials.
          </p>

          <div className="bg-background/50 backdrop-blur-md border border-border-light rounded-xl p-6 shadow-focus-soft mb-12">
            <p className="font-sans text-foreground text-base leading-relaxed italic mb-4">
              "Account recovery checks your active registration status before generating outbound links, preventing unnecessary spam."
            </p>
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-full bg-neutral-200 flex items-center justify-center font-display text-xs font-semibold text-foreground">
                AD
              </div>
              <div>
                <p className="text-sm font-semibold text-foreground leading-none">Admin Services</p>
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
              Forgot password?
            </h2>
            <p className="text-sm text-muted">
              Enter your email address and we will check our records to send reset instructions.
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

          {/* Forgot Password Form */}
          <form onSubmit={handleSubmit} className="space-y-6">
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

            <button
              type="submit"
              disabled={isPending}
              className="w-full py-3 bg-foreground text-btn-text-light rounded-md font-sans text-sm font-medium hover:bg-foreground/90 active:scale-[0.99] active:opacity-90 transition cursor-pointer flex items-center justify-center gap-2 shadow-btn-inset"
            >
              {isPending ? (
                <>
                  <Loader className="w-4 h-4 animate-spin" />
                  Sending email...
                </>
              ) : (
                'Send Reset Instructions'
              )}
            </button>
          </form>

          <div className="mt-8 text-center">
            <Link
              href="/login"
              className="inline-flex items-center gap-2 text-sm text-muted hover:text-foreground transition underline decoration-neutral-300"
            >
              <ArrowLeft className="w-4 h-4" />
              Back to Sign In
            </Link>
          </div>

        </div>
      </div>
    </div>
  )
}
