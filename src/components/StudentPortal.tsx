'use client'

import React, { useState, useEffect, useRef } from 'react'
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import { saveStudentSurveyAction, signOutAction } from '@/app/auth/actions'
import { Shield, CheckCircle2, AlertCircle, LogOut, Trophy, Zap, RefreshCw, Upload, Image as ImageIcon, Clock } from 'lucide-react'

interface StudentProfile {
  id: string
  email: string
  fullName: string | null
  teamName: string | null
  surveyCompleted: boolean
  surveyAnswers: any | null
}

interface TeamScore {
  teamName: string
  game1: number
  game2: number
  game3: number
  game4: number
  game5: number
  total: number
}

interface BuzzerRank {
  rank: number
  teamName: string
  userName: string
  pressedAt: string
}

interface BuzzerState {
  activeGame: string | null
  activeQuestion: string | null
  isActive: boolean
  buzzedByUserId: string | null
  buzzedByName: string | null
  buzzedByTeam: string | null
  promptImageStartTime: string | null
  promptImageEndTime: string | null
}

interface TeamUpload {
  rank: number
  teamName: string
  imageUrl: string
  uploadedAt: string
}

interface StudentPortalProps {
  initialProfile: StudentProfile
}

export default function StudentPortal({ initialProfile }: StudentPortalProps) {
  const router = useRouter()
  
  // Tab views: 'leaderboard' or 'buzzer'
  const [activeTab, setActiveTab] = useState<'leaderboard' | 'buzzer'>('leaderboard')
  
  // Real-time states
  const [profile, setProfile] = useState<StudentProfile>(initialProfile)
  const [leaderboard, setLeaderboard] = useState<TeamScore[]>([])
  const [buzzerState, setBuzzerState] = useState<BuzzerState>({
    activeGame: null,
    activeQuestion: null,
    isActive: false,
    buzzedByUserId: null,
    buzzedByName: null,
    buzzedByTeam: null,
    promptImageStartTime: null,
    promptImageEndTime: null
  })
  const [buzzerRanks, setBuzzerRanks] = useState<BuzzerRank[]>([])
  const [teamUploads, setTeamUploads] = useState<TeamUpload[]>([])
  const [teamMembers, setTeamMembers] = useState<{ id: string; fullName: string | null; email: string }[]>([])

  // Image upload states
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [uploadLoading, setUploadLoading] = useState(false)
  const [uploadError, setUploadError] = useState('')
  const [uploadSuccess, setUploadSuccess] = useState('')

  // Timer states
  const [timeRemaining, setTimeRemaining] = useState(0)

  // Form states
  const [fullNameInput, setFullNameInput] = useState('')
  const [surveyAnswers, setSurveyAnswers] = useState<Record<string, string[]>>({
    goals: [],
    hobbies: [],
    relaxation: [],
    workingStyle: [],
    interests: []
  })
  const [teamDescription, setTeamDescription] = useState('')
  
  // Status states
  const [errorMsg, setErrorMsg] = useState('')
  const [successMsg, setSuccessMsg] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)
  const [buzzLoading, setBuzzLoading] = useState(false)
  const [buzzError, setBuzzError] = useState('')

  // Input references for the 8-digit OTP boxes (placeholder in this view)
  const otpRefs = useRef<(HTMLInputElement | null)[]>([])

  // 1. Server-Sent Events (SSE) for Real-Time Updates
  useEffect(() => {
    if (!profile.surveyCompleted) return // Do not connect to SSE when filling out survey

    const eventSource = new EventSource('/api/realtime')

    const refreshState = async () => {
      try {
        const res = await fetch('/api/game-state')
        const data = await res.json()
        if (data.success) {
          if (data.profile) setProfile(data.profile)
          if (data.leaderboard) setLeaderboard(data.leaderboard)
          if (data.buzzerState) setBuzzerState(data.buzzerState)
          if (data.buzzerRanks) setBuzzerRanks(data.buzzerRanks)
          if (data.teamUploads) setTeamUploads(data.teamUploads)
          if (data.teamMembers) setTeamMembers(data.teamMembers)
        }
      } catch (err) {
        console.error('Error fetching game state:', err)
      }
    }

    refreshState()

    eventSource.onmessage = (event) => {
      if (event.data === 'update') {
        refreshState()
      }
    }

    return () => {
      eventSource.close()
    }
  }, [profile.surveyCompleted])

  // 2. Countdown timer effect for Prompt Image Upload
  useEffect(() => {
    if (buzzerState.activeGame !== 'Prompt image creation' || !buzzerState.promptImageEndTime) {
      setTimeRemaining(0)
      return
    }

    const calculateRemaining = () => {
      const end = new Date(buzzerState.promptImageEndTime!).getTime()
      const now = Date.now()
      return Math.max(0, Math.floor((end - now) / 1000))
    }

    setTimeRemaining(calculateRemaining())

    const timerInterval = setInterval(() => {
      const rem = calculateRemaining()
      setTimeRemaining(rem)
      if (rem <= 0) {
        clearInterval(timerInterval)
      }
    }, 1000)

    return () => clearInterval(timerInterval)
  }, [buzzerState.activeGame, buzzerState.promptImageEndTime])

  // Handle Logout
  const handleLogout = async () => {
    await signOutAction()
    router.push('/login')
    router.refresh()
  }

  // Handle survey selection (Max 2 choices)
  const handleSurveyOptionClick = (questionKey: string, option: string) => {
    const currentSelections = surveyAnswers[questionKey] || []
    if (currentSelections.includes(option)) {
      setSurveyAnswers({
        ...surveyAnswers,
        [questionKey]: currentSelections.filter((o) => o !== option)
      })
    } else {
      if (currentSelections.length >= 2) return
      setSurveyAnswers({
        ...surveyAnswers,
        [questionKey]: [...currentSelections, option]
      })
    }
    setErrorMsg('')
  }

  // Handle Survey Form Submission
  const handleSurveySubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setErrorMsg('')
    setSuccessMsg('')

    if (!fullNameInput.trim()) {
      setErrorMsg('Full Name is mandatory.')
      return
    }

    const questionsKeys = ['goals', 'hobbies', 'relaxation', 'workingStyle', 'interests']
    const hasUnanswered = questionsKeys.some((k) => !surveyAnswers[k] || surveyAnswers[k].length === 0)
    if (hasUnanswered) {
      setErrorMsg('Please select at least 1 option for all questions. Answering all questions is compulsory.')
      return
    }

    if (!teamDescription.trim()) {
      setErrorMsg('Please describe what you are looking for in your team members.')
      return
    }

    if (teamDescription.length > 200) {
      setErrorMsg('Team description cannot exceed 200 characters.')
      return
    }

    setIsSubmitting(true)

    try {
      const fullPayload = {
        ...surveyAnswers,
        teamDescription: teamDescription.trim()
      }

      const result = await saveStudentSurveyAction(fullNameInput.trim(), fullPayload)
      if (result.success) {
        setSuccessMsg('Your registration details and survey answers have been successfully saved!')
        const res = await fetch('/api/game-state')
        const data = await res.json()
        if (data.success && data.profile) {
          setProfile(data.profile)
        }
      } else {
        setErrorMsg(result.error || 'Failed to submit registration details.')
      }
    } catch (err: any) {
      setErrorMsg(err.message || 'An error occurred during submission.')
    } finally {
      setIsSubmitting(false)
    }
  }

  // Handle Student Pressing the Buzzer
  const handlePressBuzzer = async () => {
    setBuzzLoading(true)
    setBuzzError('')

    try {
      const res = await fetch('/api/buzz', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
      })
      const data = await res.json()

      if (!data.success) {
        setBuzzError(data.error || 'Failed to buzz.')
      }
    } catch (err: any) {
      setBuzzError('Error submitting buzz action.')
    } finally {
      setBuzzLoading(false)
    }
  }

  // Handle image upload submission
  const handleImageUpload = async (e: React.FormEvent) => {
    e.preventDefault()
    setUploadError('')
    setUploadSuccess('')

    if (!selectedFile) {
      setUploadError('Please select an image file first.')
      return
    }

    // Size check
    const MAX_SIZE = 30 * 1024 * 1024 // 30MB
    if (selectedFile.size > MAX_SIZE) {
      setUploadError('File size exceeds the 30MB limit.')
      return
    }

    setUploadLoading(true)
    const formData = new FormData()
    formData.append('file', selectedFile)

    try {
      const res = await fetch('/api/upload', {
        method: 'POST',
        body: formData
      })
      const data = await res.json()

      if (data.success) {
        setUploadSuccess('Image successfully uploaded! Ranks have been updated.')
        setSelectedFile(null)
        // Refresh uploads
        const stateRes = await fetch('/api/game-state')
        const stateData = await stateRes.json()
        if (stateData.success && stateData.teamUploads) {
          setTeamUploads(stateData.teamUploads)
        }
      } else {
        setUploadError(data.error || 'Upload failed.')
      }
    } catch (err: any) {
      setUploadError('An error occurred during file upload.')
    } finally {
      setUploadLoading(false)
    }
  }

  // Helper variables
  const isSurveyComplete = profile.surveyCompleted
  const hasTeam = !!profile.teamName
  const myTeam = profile.teamName || ''
  const myTeamBuzz = buzzerRanks.find((r) => r.teamName.toLowerCase() === myTeam.toLowerCase())
  const myTeamUpload = teamUploads.find((u) => u.teamName.toLowerCase() === myTeam.toLowerCase())

  // Questions configuration
  const surveyQuestions = [
    {
      key: 'goals',
      title: 'What are your primary goals for your time at GLA University?',
      options: [
        'Learn advanced programming & AI systems',
        'Academic Excellence & High GPA',
        'Placement in top companies & Networking',
        'Participate in sports, clubs & cultural events',
        'Building startups & entrepreneurship ventures',
        'Pursuing research papers & higher education (MS/PhD)',
        'Contributing to open-source software packages'
      ]
    },
    {
      key: 'hobbies',
      title: 'What are your favorite hobbies?',
      options: [
        'Coding & Solving puzzles',
        'Reading books & Writing blogs',
        'Video gaming & Tech tinkering',
        'Music, Singing, Dancing & Creative Arts',
        'Outdoor sports & Gym training',
        'Photography & Filmmaking',
        'Cooking & exploring culinary arts',
        'Traveling & backpacking'
      ]
    },
    {
      key: 'relaxation',
      title: 'Are you a mountain or beach person, or something else?',
      options: [
        'Mountain person (Loves peace, hiking, calm)',
        'Beach person (Loves energy, travel, beach spots)',
        'Cozy room person (Likes singing, listening to music, reading)',
        'Dance floor person (Energetic beat lover, performer)',
        'Coffee shop thinker (Loves working with a brew)',
        'Museum/history explorer (Loves learning about culture)'
      ]
    },
    {
      key: 'workingStyle',
      title: 'How would you describe your working style?',
      options: [
        'Self-driven (Deep individual execution)',
        'Collaborative (Thrives on team brainstorming)',
        'Pragmatic (Gets hands dirty immediately)',
        'Strategic (Carefully plans before execution)',
        'Creative (Explores wild out-of-the-box approaches)',
        'Organized (Obsesses over deadlines & task management)'
      ]
    },
    {
      key: 'interests',
      title: 'What interests you the most about BCA (AIML & DS)?',
      options: [
        'Building Machine Learning models',
        'Analyzing massive datasets & graphs',
        'Deploying generative AI agents',
        'General software development & systems coding',
        'Natural Language Processing & Chatbots',
        'Computer Vision & Robotics systems',
        'Cloud infrastructure for big data pipelines'
      ]
    }
  ]

  // Render State 1: Survey Form View
  if (!isSurveyComplete) {
    return (
      <div className="min-h-screen bg-neutral-50 flex flex-col justify-between">
        {/* Navigation */}
        <header className="sticky top-0 z-50 bg-white/80 backdrop-blur border-b border-neutral-200/60 shadow-sm">
          <div className="w-full px-4 sm:px-8 py-3 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Image 
                src="/gla-logo.webp" 
                alt="GLA Logo" 
                width={120} 
                height={120} 
                className="object-contain w-24 sm:w-32 h-auto max-h-16 sm:max-h-24" 
              />
              <div className="hidden md:flex flex-col">
                <span className="font-display font-bold text-xl sm:text-2xl tracking-tight text-foreground leading-none">
                  GLA University
                </span>
                <span className="text-[10px] sm:text-xs text-muted font-semibold mt-1">
                  Department Orientation Program 2026
                </span>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center gap-1.5 px-4 py-2 border border-neutral-300 rounded-lg text-xs font-bold text-foreground hover:bg-black/5 transition cursor-pointer shadow-sm"
            >
              <LogOut className="w-3.5 h-3.5" /> Logout
            </button>
          </div>
        </header>

        {/* Content */}
        <main className="max-w-4xl mx-auto px-6 py-12 flex-grow w-full">
          <div className="text-center mb-12">
            <h1 className="font-display text-3xl sm:text-4xl font-extrabold tracking-tight text-foreground mb-3">
              BCA (AIML & DS) Orientation 2026
            </h1>
            <p className="text-xs sm:text-sm text-muted font-bold uppercase tracking-wider">
              19th August 10:00 AM • GLA University
            </p>
          </div>

          <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md">
            <h2 className="font-display text-xl sm:text-2xl font-bold text-foreground mb-4 pb-3 border-b border-neutral-100">
              Registration & Team Profiling
            </h2>
            <p className="text-sm text-muted mb-8 leading-relaxed">
              Complete your profile setup below. Answering all questions is compulsory. The details provided here will help us assign you to groups with like-minded students to play team games and win prizes!
            </p>

            {errorMsg && (
              <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-lg flex items-start gap-2.5 shadow-sm">
                <AlertCircle className="w-4 h-4 text-red-600 flex-shrink-0 mt-0.5" />
                <span>{errorMsg}</span>
              </div>
            )}

            {successMsg && (
              <div className="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 text-sm rounded-lg flex items-start gap-2.5 shadow-sm">
                <CheckCircle2 className="w-4 h-4 text-green-600 flex-shrink-0 mt-0.5" />
                <span>{successMsg}</span>
              </div>
            )}

            <form onSubmit={handleSurveySubmit} className="space-y-10">
              {/* Full Name Input */}
              <div className="bg-neutral-50/50 p-6 rounded-xl border border-neutral-200 space-y-4">
                <div className="flex items-center gap-3">
                  <div className="w-6 h-6 rounded-full bg-neutral-200 text-neutral-700 flex items-center justify-center font-bold text-xs flex-shrink-0">
                    !
                  </div>
                  <label className="block text-sm font-bold text-foreground">
                    Full Name <span className="text-red-500">*</span>
                  </label>
                </div>
                <input
                  type="text"
                  required
                  placeholder="e.g. Arpit Pandey"
                  value={fullNameInput}
                  onChange={(e) => setFullNameInput(e.target.value)}
                  className="w-full bg-white border-2 border-neutral-300 rounded-lg py-3 px-4 text-sm placeholder-neutral-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-600 transition shadow-sm font-medium"
                />
                <p className="text-[11px] text-red-600 font-bold flex items-center gap-1.5">
                  ⚠️ This cannot be changed later. Please enter your name carefully.
                </p>
              </div>

              {/* Questions */}
              {surveyQuestions.map((q, idx) => (
                <div key={q.key} className="space-y-4">
                  <div className="flex items-start gap-4">
                    <div className="w-8 h-8 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center font-bold text-sm flex-shrink-0 mt-0.5 shadow-sm">
                      {idx + 1}
                    </div>
                    <div className="space-y-0.5">
                      <h4 className="text-sm sm:text-base font-bold text-foreground leading-snug">
                        {q.title}
                      </h4>
                      <p className="text-[11px] text-muted font-medium">Select at most 2 options</p>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pl-0 sm:pl-12">
                    {q.options.map((opt) => {
                      const isSelected = (surveyAnswers[q.key] || []).includes(opt)
                      return (
                        <button
                          key={opt}
                          type="button"
                          onClick={() => handleSurveyOptionClick(q.key, opt)}
                          className={`w-full text-left p-5 rounded-xl border-2 text-xs sm:text-sm font-medium transition duration-200 cursor-pointer flex items-center justify-between gap-3 ${
                            isSelected
                              ? 'border-blue-600 bg-blue-50/70 text-blue-900 shadow-md shadow-blue-500/5'
                              : 'border-neutral-200 bg-white text-foreground hover:border-neutral-300 hover:bg-neutral-50/40 shadow-sm'
                          }`}
                        >
                          <span>{opt}</span>
                          {isSelected ? (
                            <span className="w-5 h-5 rounded-full bg-blue-600 text-white flex items-center justify-center text-[10px] font-bold flex-shrink-0">
                              ✓
                            </span>
                          ) : (
                            <span className="w-5 h-5 rounded-full border-2 border-neutral-300 flex-shrink-0" />
                          )}
                        </button>
                      )
                    })}
                  </div>
                </div>
              ))}

              {/* Team Description Textarea */}
              <div className="space-y-4 border-t border-neutral-100 pt-8">
                <div className="flex items-start gap-4">
                  <div className="w-8 h-8 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center font-bold text-sm flex-shrink-0 mt-0.5">
                    ✎
                  </div>
                  <div className="space-y-0.5">
                    <label className="block text-sm sm:text-base font-bold text-foreground">
                      Describe what you are looking for in your team members <span className="text-red-500">*</span>
                    </label>
                    <p className="text-[11px] text-muted font-medium">Compulsory for complete registration</p>
                  </div>
                </div>
                
                <div className="pl-0 sm:pl-12 space-y-2">
                  <textarea
                    required
                    rows={5}
                    maxLength={200}
                    placeholder="e.g. Someone hardworking, curious, and a good team player..."
                    value={teamDescription}
                    onChange={(e) => setTeamDescription(e.target.value)}
                    className="w-full bg-white border-2 border-neutral-300 rounded-lg py-3 px-4 text-sm placeholder-neutral-400 focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-600 transition shadow-sm font-medium resize-none"
                  />
                  <div className="flex justify-end text-xs text-muted font-medium">
                    <span className={teamDescription.length > 200 ? 'text-red-500 font-bold' : ''}>
                      {teamDescription.length}/200 characters
                    </span>
                  </div>
                </div>
              </div>

              <div className="pl-0 sm:pl-12 pt-4">
                <button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full py-4 bg-foreground text-btn-text-light rounded-xl font-sans text-sm font-bold hover:bg-foreground/95 active:scale-[0.99] transition shadow-btn-inset flex items-center justify-center gap-2 cursor-pointer"
                >
                  {isSubmitting ? (
                    <>
                      <RefreshCw className="w-4 h-4 animate-spin" /> Submitting survey...
                    </>
                  ) : (
                    'Complete Registration & Submit Survey'
                  )}
                </button>
              </div>
            </form>
          </div>
        </main>

        {/* Footer */}
        <footer className="py-6 border-t border-border-light text-center text-xs text-muted bg-white">
          © {new Date().getFullYear()} GLA University. BCA Orientation.
        </footer>
      </div>
    )
  }

  // Render State 2: Profile completed but team unassigned (Pending State)
  if (isSurveyComplete && !hasTeam) {
    return (
      <div className="min-h-screen bg-neutral-50 flex flex-col justify-between">
        {/* Navigation */}
        <header className="sticky top-0 z-50 bg-white/80 backdrop-blur border-b border-neutral-200/60 shadow-sm">
          <div className="w-full px-4 sm:px-8 py-3 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Image 
                src="/gla-logo.webp" 
                alt="GLA Logo" 
                width={120} 
                height={120} 
                className="object-contain w-24 sm:w-32 h-auto max-h-16 sm:max-h-24" 
              />
              <div className="hidden md:flex flex-col">
                <span className="font-display font-bold text-xl sm:text-2xl tracking-tight text-foreground leading-none">
                  GLA University
                </span>
                <span className="text-[10px] sm:text-xs text-muted font-semibold mt-1">
                  Department Orientation Program 2026
                </span>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center gap-1.5 px-4 py-2 border border-neutral-300 rounded-lg text-xs font-bold text-foreground hover:bg-black/5 transition cursor-pointer shadow-sm"
            >
              <LogOut className="w-3.5 h-3.5" /> Logout
            </button>
          </div>
        </header>

        {/* Content */}
        <main className="max-w-2xl mx-auto px-6 py-16 flex-grow flex flex-col items-center justify-center w-full">
          <div className="bg-white border border-neutral-200/80 rounded-2xl p-8 sm:p-10 shadow-md flex flex-col items-center text-center">
            <div className="w-16 h-16 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center mb-6 shadow-sm">
              <Shield className="w-8 h-8" />
            </div>

            <h1 className="font-display text-2xl sm:text-3xl font-extrabold tracking-tight text-foreground mb-2">
              Registration Complete!
            </h1>
            <p className="text-xs text-muted font-bold uppercase tracking-wider mb-6">
              BCA (AIML & DS) 1st Year Orientation 2026
            </p>

            <div className="border-t border-neutral-100 pt-6 w-full">
              <h3 className="text-base font-bold text-foreground mb-3">Team Allocation Pending</h3>
              <p className="text-sm text-muted leading-relaxed">
                Your profiling survey answers have been recorded successfully. Your team assignment is currently being processed by the administration. As soon as you are assigned, your dashboard will activate and you will be notified.
              </p>
              <div className="mt-6 bg-blue-50/50 p-4 border border-blue-100 rounded-xl text-xs font-semibold text-blue-900 leading-relaxed">
                📢 Your team will be assigned to you on the day of orientation, so stay tuned!
              </div>
            </div>
          </div>
        </main>

        {/* Footer */}
        <footer className="py-6 border-t border-border-light text-center text-xs text-muted bg-white">
          © {new Date().getFullYear()} GLA University. BCA Orientation.
        </footer>
      </div>
    )
  }

  // Render State 3: Survey complete and team assigned (Main Dashboard)
  return (
    <div className="min-h-screen bg-[#fcfbf9] flex flex-col justify-between">
      {/* Sticky Header Wrapper - Responsive layout */}
      <header className="sticky top-0 z-50 bg-white border-b border-neutral-200/80 shadow-md">
        {/* Main row */}
        <div className="w-full max-w-7xl mx-auto px-4 sm:px-8 py-3.5 flex items-center justify-between gap-4">
          {/* Left: Brand logo */}
          <div className="flex items-center gap-3 flex-shrink-0">
            <Image 
              src="/gla-logo.webp" 
              alt="GLA Logo" 
              width={120} 
              height={120} 
              className="object-contain w-20 sm:w-28 h-auto max-h-11 sm:max-h-16" 
            />
            <div className="hidden md:flex flex-col">
              <span className="font-display font-extrabold text-base sm:text-lg text-foreground tracking-tight leading-none">
                GLA University
              </span>
              <span className="text-[10px] text-muted font-bold mt-1">
                BCA Orientation 2026
              </span>
            </div>
          </div>

          {/* Center: Segmented Controls Switcher - Hidden on mobile, shown on sm screens and up */}
          <div className="hidden sm:flex bg-neutral-100 p-1 rounded-xl gap-1 flex-shrink-0 shadow-inner">
            <button
              onClick={() => setActiveTab('buzzer')}
              className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all duration-200 cursor-pointer flex items-center gap-2 ${
                activeTab === 'buzzer'
                  ? 'bg-white text-blue-600 shadow-sm border border-neutral-200/30'
                  : 'text-neutral-500 hover:text-foreground'
              }`}
            >
              <Zap className="w-4 h-4" />
              <span>Buzzer</span>
            </button>
            <button
              onClick={() => setActiveTab('leaderboard')}
              className={`px-4 py-2 rounded-lg text-xs sm:text-sm font-bold transition-all duration-200 cursor-pointer flex items-center gap-2 ${
                activeTab === 'leaderboard'
                  ? 'bg-white text-blue-600 shadow-sm border border-neutral-200/30'
                  : 'text-neutral-500 hover:text-foreground'
              }`}
            >
              <Trophy className="w-4 h-4" />
              <span>Leaderboard</span>
            </button>
          </div>

          {/* Right: Team info & Logout */}
          <div className="flex items-center gap-2.5 flex-shrink-0">
            <div className="px-3.5 py-1.5 bg-neutral-100 text-neutral-800 border border-neutral-200/80 rounded-full text-xs font-bold tracking-tight shadow-sm max-w-[150px] sm:max-w-none truncate">
              {profile.teamName}
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center justify-center p-2 border border-neutral-200 rounded-full text-foreground hover:bg-neutral-50 transition cursor-pointer shadow-sm"
              title="Logout"
            >
              <LogOut className="w-4 h-4" />
            </button>
          </div>
        </div>

        {/* Mobile segmented controls switcher - Hidden on sm screens and up */}
        <div className="sm:hidden w-full bg-white px-4 pb-3 flex justify-center">
          <div className="w-full max-w-sm bg-neutral-100 p-1 rounded-xl flex gap-1 shadow-inner">
            <button
              onClick={() => setActiveTab('buzzer')}
              className={`flex-1 py-2 rounded-lg text-xs font-bold transition-all duration-200 cursor-pointer flex items-center justify-center gap-1.5 ${
                activeTab === 'buzzer'
                  ? 'bg-white text-blue-600 shadow-sm border border-neutral-200/30'
                  : 'text-neutral-500 hover:text-foreground'
              }`}
            >
              <Zap className="w-3.5 h-3.5" />
              <span>Buzzer</span>
            </button>
            <button
              onClick={() => setActiveTab('leaderboard')}
              className={`flex-1 py-2 rounded-lg text-xs font-bold transition-all duration-200 cursor-pointer flex items-center justify-center gap-1.5 ${
                activeTab === 'leaderboard'
                  ? 'bg-white text-blue-600 shadow-sm border border-neutral-200/30'
                  : 'text-neutral-500 hover:text-foreground'
              }`}
            >
              <Trophy className="w-3.5 h-3.5" />
              <span>Leaderboard</span>
            </button>
          </div>
        </div>
      </header>

      {/* Dashboard Body */}
      <main className="w-full mx-auto px-4 sm:px-6 py-8 flex-grow">
        
        {/* Active Tab 1: Interactive Buzzer View */}
        {activeTab === 'buzzer' && (
          <div className="max-w-7xl mx-auto animate-fade-in">
            
            {/* Condition 1: Continue the Story Game (No Buzzer - Centered Layout) */}
            {buzzerState.activeGame === 'continue the story' ? (
              <div className="max-w-2xl mx-auto bg-white border border-neutral-200/80 rounded-2xl p-8 sm:p-12 shadow-md text-center space-y-4">
                <div className="w-16 h-16 rounded-full bg-neutral-100 flex items-center justify-center mx-auto text-3xl">
                  📖
                </div>
                <h3 className="font-display text-xl font-bold text-foreground">Continue the Story</h3>
                <p className="text-sm text-muted leading-relaxed">
                  No buzzer is required for this activity. Please follow along and listen to the storyteller on screen!
                </p>
                <div className="p-4 bg-blue-50/50 border border-blue-100 rounded-xl text-xs font-semibold text-blue-900">
                  💡 Teams will present their stories live when prompted by the orientation instructor.
                </div>
              </div>
            ) : buzzerState.activeGame === 'Prompt image creation' ? (
              
              /* Condition 2: Prompt Image Creation Game (File Uploads) - Two-Column Layout */
              <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                {/* Left Column: Image Submission */}
                <div className="lg:col-span-7 space-y-6">
                  <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md space-y-6">
                    <div className="flex justify-between items-center pb-4 border-b border-neutral-100">
                      <h3 className="font-display text-lg sm:text-xl font-bold text-foreground flex items-center gap-2">
                        <ImageIcon className="w-5 h-5 text-foreground" /> Image Submission
                      </h3>
                      <span className={`px-2.5 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider ${
                        timeRemaining > 0 ? 'bg-green-50 text-green-700 animate-pulse' : 'bg-red-50 text-red-700'
                      }`}>
                        {timeRemaining > 0 ? 'Active' : 'Closed'}
                      </span>
                    </div>

                    <div className="bg-neutral-50 p-5 rounded-xl border border-neutral-200">
                      <p className="text-[10px] text-muted uppercase tracking-wider font-bold">Active Game</p>
                      <h4 className="font-display text-lg font-bold text-foreground mt-0.5 capitalize">
                        Prompt Image Creation — {buzzerState.activeQuestion || 'Q1'}
                      </h4>
                    </div>

                    {/* Timer Display */}
                    {timeRemaining > 0 ? (
                      <div className="flex items-center justify-center gap-2 text-green-700 font-bold text-sm bg-green-50 p-4 rounded-xl border border-green-200">
                        <Clock className="w-4 h-4 text-green-600 animate-spin" />
                        <span>
                          Upload Open: {Math.floor(timeRemaining / 60)}m {timeRemaining % 60}s remaining
                        </span>
                      </div>
                    ) : (
                      <div className="flex items-center justify-center gap-2 text-red-700 font-bold text-sm bg-red-50 p-4 rounded-xl border border-red-200">
                        <Clock className="w-4 h-4 text-red-600" />
                        <span>Upload Period Closed</span>
                      </div>
                    )}

                    {/* Upload Form */}
                    {timeRemaining > 0 ? (
                      <form onSubmit={handleImageUpload} className="space-y-4">
                        {uploadError && (
                          <div className="p-4 bg-red-50 border border-red-200 text-red-700 text-xs rounded-xl flex items-start gap-2 shadow-sm">
                            <AlertCircle className="w-4 h-4 text-red-600 flex-shrink-0 mt-0.5" />
                            <span>{uploadError}</span>
                          </div>
                        )}
                        {uploadSuccess && (
                          <div className="p-4 bg-green-50 border border-green-200 text-green-700 text-xs rounded-xl flex items-start gap-2 shadow-sm">
                            <CheckCircle2 className="w-4 h-4 text-green-600 flex-shrink-0 mt-0.5" />
                            <span>{uploadSuccess}</span>
                          </div>
                        )}

                        <div className="border-2 border-dashed border-neutral-300 rounded-xl p-6 hover:bg-neutral-50/50 transition text-center cursor-pointer relative">
                          <input
                            type="file"
                            accept="image/*"
                            onChange={(e) => {
                              if (e.target.files && e.target.files[0]) {
                                setSelectedFile(e.target.files[0])
                              }
                            }}
                            className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                          />
                          <Upload className="w-8 h-8 text-muted mx-auto mb-2" />
                          <p className="text-xs font-bold text-foreground">
                            {selectedFile ? selectedFile.name : 'Choose image file or Drag & Drop'}
                          </p>
                          <p className="text-[10px] text-muted mt-1">PNG, JPG, WEBP or GIF (Max 30MB)</p>
                        </div>

                        <button
                          type="submit"
                          disabled={uploadLoading || !selectedFile}
                          className={`w-full py-3.5 rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 ${
                            !selectedFile
                              ? 'bg-neutral-100 text-neutral-400 border border-neutral-200 cursor-not-allowed'
                              : 'bg-foreground text-btn-text-light shadow-btn-inset cursor-pointer hover:opacity-90 active:scale-[0.99]'
                          }`}
                        >
                          {uploadLoading ? (
                            <>
                              <RefreshCw className="w-3.5 h-3.5 animate-spin" /> Uploading image...
                            </>
                          ) : (
                            'Upload / Update Image'
                          )}
                        </button>
                      </form>
                    ) : null}

                    {/* Team submission preview */}
                    <div className="border-t border-neutral-100 pt-6">
                      <h5 className="text-xs font-bold text-muted uppercase tracking-wider mb-3">Our Team Submission</h5>
                      {myTeamUpload ? (
                        <div className="space-y-2">
                          <div className="border border-neutral-200 rounded-xl overflow-hidden max-h-64 relative flex justify-center bg-black/5">
                            <img
                              src={myTeamUpload.imageUrl}
                              alt="Team prompt generation"
                              className="object-contain max-h-64"
                            />
                          </div>
                          <p className="text-[10px] text-muted text-center">
                            Uploaded at: {new Date(myTeamUpload.uploadedAt).toLocaleTimeString()}
                          </p>
                        </div>
                      ) : (
                        <p className="text-xs text-muted italic text-center py-6 bg-neutral-50 rounded-xl border border-neutral-200 border-dashed">
                          No image submitted by your team yet.
                        </p>
                      )}
                    </div>
                  </div>
                </div>

                {/* Right Column: Submissions rankings */}
                <div className="lg:col-span-5 space-y-6">
                  <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md">
                    <h4 className="text-sm font-bold text-foreground mb-4">Submission Order (Ranks)</h4>
                    {teamUploads.length === 0 ? (
                      <p className="text-xs text-muted text-center py-6">No uploads recorded yet.</p>
                    ) : (
                      <div className="space-y-2 max-h-96 overflow-y-auto">
                        {teamUploads.map((log) => {
                          const isMyTeam = log.teamName.toLowerCase() === myTeam.toLowerCase()
                          return (
                            <div
                              key={log.teamName}
                              className={`p-3 rounded-xl border text-xs flex justify-between items-center ${
                                isMyTeam
                                  ? 'bg-amber-50 border-amber-200 font-semibold text-amber-900'
                                  : log.rank === 1
                                  ? 'bg-yellow-50 border-yellow-200 text-yellow-800'
                                  : 'bg-neutral-50 border-neutral-200 text-foreground'
                              }`}
                            >
                              <div className="flex items-center gap-2">
                                <span className="font-semibold px-2 py-0.5 bg-neutral-200 rounded-md">#{log.rank}</span>
                                <span className="font-display font-medium">{log.teamName}</span>
                              </div>
                              <a
                                href={log.imageUrl}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="text-[10px] text-foreground underline decoration-neutral-400 font-semibold"
                              >
                                View Image
                              </a>
                            </div>
                          )
                        })}
                      </div>
                    )}
                  </div>
                </div>
              </div>
            ) : (
              
              /* Condition 3: Normal Buzz Games (guess the song, etc.) - Two-Column Layout */
              <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                {/* Left Column: Interactive Buzzer Card */}
                <div className="lg:col-span-7 space-y-6">
                  <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md text-center">
                    
                    {/* Header Bar */}
                    <div className="flex justify-between items-center pb-4 border-b border-neutral-100 mb-6">
                      <h3 className="font-display text-lg font-bold text-foreground flex items-center gap-2">
                        <Zap className="w-5 h-5 text-blue-600" /> Interactive Buzzer
                      </h3>
                      <span className={`px-2.5 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider ${
                        buzzerState.isActive ? 'bg-green-50 text-green-700 animate-pulse' : 'bg-red-50 text-red-700'
                      }`}>
                        {buzzerState.isActive ? 'Active' : 'Locked'}
                      </span>
                    </div>

                    {/* Active Question Info Panel */}
                    <div className="mb-8 bg-neutral-50 p-5 rounded-xl border border-neutral-200">
                      <p className="text-[10px] text-muted uppercase tracking-wider font-bold">Active Game</p>
                      <h4 className="font-display text-lg font-black text-foreground capitalize mt-1">
                        {buzzerState.activeGame || 'No Active Game'}
                      </h4>
                      <div className="mt-2 text-xs text-blue-700 font-bold bg-blue-50/80 inline-block px-3 py-1 rounded-md border border-blue-200">
                        Question: {buzzerState.activeQuestion || 'None'}
                      </div>
                    </div>

                    {/* 3D Dome Buzzer Button */}
                    <div className="flex justify-center py-6">
                      {/* Heavy Metallic Bezel Ring */}
                      <div className="relative w-56 h-56 rounded-full bg-gradient-to-b from-neutral-200 via-neutral-150 to-neutral-350 p-3.5 shadow-[0_12px_24px_rgba(0,0,0,0.15),inset_0_2px_5px_rgba(255,255,255,0.6)] flex items-center justify-center border border-neutral-250">
                        {/* Matte Inner Bezel */}
                        <div className="relative w-full h-full rounded-full bg-gradient-to-b from-neutral-100 via-neutral-200 to-neutral-50 p-2.5 shadow-inner flex items-center justify-center">
                          {/* Crimson Dome Button */}
                          <button
                            onClick={handlePressBuzzer}
                            disabled={!buzzerState.isActive || !!myTeamBuzz || buzzLoading}
                            className={`w-40 h-40 rounded-full flex flex-col items-center justify-center transition-all duration-150 relative overflow-hidden select-none outline-none group ${
                              !buzzerState.isActive
                                ? 'bg-gradient-to-b from-red-800/80 via-red-900 to-red-950 border-t-2 border-red-900/30 shadow-[inset_0_4px_8px_rgba(0,0,0,0.6),inset_0_-8px_16px_rgba(0,0,0,0.8)] cursor-not-allowed text-red-200/40'
                                : myTeamBuzz
                                ? 'bg-gradient-to-b from-amber-400 via-amber-500 to-amber-600 border-t-2 border-white/30 shadow-[inset_0_4px_6px_rgba(255,255,255,0.3),inset_0_-8px_16px_rgba(0,0,0,0.4),0_0_25px_rgba(245,158,11,0.4)] cursor-not-allowed text-white'
                                : 'bg-gradient-to-b from-red-500 via-red-600 to-red-800 hover:from-red-400 hover:via-red-500 hover:to-red-700 cursor-pointer border-t-2 border-white/40 shadow-[inset_0_6px_10px_rgba(255,255,255,0.3),inset_0_-10px_20px_rgba(0,0,0,0.5),0_12px_24px_rgba(239,68,68,0.25),0_0_35px_rgba(239,68,68,0.4)] active:translate-y-1.5 active:shadow-[inset_0_10px_20px_rgba(0,0,0,0.6),0_3px_6px_rgba(0,0,0,0.2)] active:scale-[0.96]'
                            }`}
                          >
                            {/* Curved reflection glossy highlight - visible only when active */}
                            {buzzerState.isActive && (
                              <div className="absolute top-1.5 left-5 right-5 h-8 bg-gradient-to-b from-white/35 to-transparent rounded-full pointer-events-none" />
                            )}
                            
                            {/* Glowing internal bulb pulsing effect */}
                            {buzzerState.isActive && !myTeamBuzz && (
                              <div className="absolute inset-0 bg-red-400/5 animate-pulse rounded-full pointer-events-none" />
                            )}

                            <Zap className={`w-12 h-12 mb-1 drop-shadow-[0_2px_4px_rgba(0,0,0,0.25)] ${
                              !buzzerState.isActive ? 'text-red-200/30' : 'text-white'
                            }`} />
                            <span className={`text-xs sm:text-sm font-black uppercase tracking-widest font-display drop-shadow-[0_2px_3px_rgba(0,0,0,0.3)] ${
                              !buzzerState.isActive ? 'text-red-200/30' : 'text-white'
                            }`}>
                              {buzzLoading ? '...' : myTeamBuzz ? 'Buzzed' : 'Buzz!'}
                            </span>
                          </button>
                        </div>
                      </div>
                    </div>

                    {/* Status Info Footer */}
                    <div className="mt-6 border-t border-neutral-100 pt-6 text-sm">
                      {myTeamBuzz ? (
                        <div className="p-3.5 bg-amber-50 text-amber-800 border border-amber-200 rounded-xl text-xs font-bold leading-relaxed">
                          🔒 Buzzer Locked: You/Teammate ({myTeamBuzz.userName}) pressed the buzzer!
                        </div>
                      ) : buzzerState.isActive ? (
                        <p className="text-xs text-green-700 font-bold animate-pulse">
                          🟢 Buzzer is active! Hit it first to secure your team rank.
                        </p>
                      ) : (
                        <p className="text-xs text-muted font-semibold">
                          🔴 Buzzer is deactivated. Wait for the admin to activate the next question.
                        </p>
                      )}
                    </div>
                  </div>
                </div>

                {/* Right Column: Buzzer Log list */}
                <div className="lg:col-span-5 space-y-6">
                  <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md">
                    <h4 className="text-sm font-bold text-foreground mb-4">Buzz Order (This Question)</h4>
                    
                    {buzzerRanks.length === 0 ? (
                      <p className="text-xs text-muted text-center py-6">No buzzes recorded yet.</p>
                    ) : (
                      <div className="space-y-2 max-h-96 overflow-y-auto">
                        {buzzerRanks.map((log) => {
                          const isMyTeam = log.teamName.toLowerCase() === myTeam.toLowerCase()
                          return (
                            <div
                              key={log.teamName}
                              className={`p-3 rounded-xl border text-xs flex justify-between items-center ${
                                isMyTeam
                                  ? 'bg-amber-50 border-amber-200 font-semibold text-amber-900'
                                  : log.rank === 1
                                  ? 'bg-yellow-50 border-yellow-200 text-yellow-800'
                                  : 'bg-neutral-50 border-neutral-200 text-foreground'
                              }`}
                            >
                              <div className="flex items-center gap-2">
                                <span className="font-semibold px-2 py-0.5 bg-neutral-200 rounded-md">#{log.rank}</span>
                                <span className="font-display font-medium">{log.teamName}</span>
                              </div>
                              <span className="text-muted font-normal text-[10px]">
                                Pressed by: <span className="font-semibold text-foreground">{log.userName}</span>
                              </span>
                            </div>
                          )
                        })}
                      </div>
                    )}
                  </div>
                </div>
              </div>
            )}

          </div>
        )}

        {/* Active Tab 2: Live Leaderboard View */}
        {activeTab === 'leaderboard' && (
          <div className="max-w-4xl mx-auto space-y-6 animate-fade-in">
            <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md">
              <div className="flex justify-between items-center mb-6 pb-4 border-b border-neutral-100">
                <h3 className="font-display text-lg sm:text-xl font-bold text-foreground flex items-center gap-2">
                  <Trophy className="w-5 h-5 text-amber-600" /> Live Leaderboard
                </h3>
                <span className="px-2.5 py-0.5 rounded bg-amber-50 text-[10px] font-bold text-amber-700 uppercase tracking-wider">
                  Realtime
                </span>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-sm text-left border-collapse">
                  <thead>
                    <tr className="border-b border-neutral-200 text-xs text-muted uppercase font-bold">
                      <th className="py-3.5 px-2">Rank</th>
                      <th className="py-3.5 px-4">Team</th>
                      <th className="py-3.5 px-2 text-center">G1</th>
                      <th className="py-3.5 px-2 text-center">G2</th>
                      <th className="py-3.5 px-2 text-center">G3</th>
                      <th className="py-3.5 px-2 text-center">G4</th>
                      <th className="py-3.5 px-2 text-center">G5</th>
                      <th className="py-3.5 px-4 text-right">Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {leaderboard.map((team, idx) => {
                      const isMyTeam = team.teamName.toLowerCase() === myTeam.toLowerCase()
                      return (
                        <tr
                          key={team.teamName}
                          className={`border-b border-neutral-100 hover:bg-neutral-50/50 transition ${
                            isMyTeam ? 'bg-amber-50/40 font-bold border-l-2 border-l-amber-500' : ''
                          }`}
                        >
                          <td className="py-4 px-2 font-bold text-foreground">
                            {idx + 1}
                            {idx === 0 && ' 👑'}
                          </td>
                          <td className="py-4 px-4">
                            <span className="flex items-center gap-1.5 font-semibold text-foreground whitespace-nowrap">
                              {team.teamName}
                              {isMyTeam && (
                                <span className="text-[9px] bg-foreground text-btn-text-light px-2 py-0.5 rounded-full font-bold">
                                  You
                                </span>
                              )}
                            </span>
                          </td>
                          <td className="py-4 px-2 text-center text-muted font-medium">{team.game1}</td>
                          <td className="py-4 px-2 text-center text-muted font-medium">{team.game2}</td>
                          <td className="py-4 px-2 text-center text-muted font-medium">{team.game3}</td>
                          <td className="py-4 px-2 text-center text-muted font-medium">{team.game4}</td>
                          <td className="py-4 px-2 text-center text-muted font-medium">{team.game5}</td>
                          <td className="py-4 px-4 text-right font-display font-extrabold text-foreground">
                            {team.total}
                          </td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
            </div>

            {teamMembers.length > 0 && (
              <div className="bg-white border border-neutral-200/80 rounded-2xl p-6 sm:p-10 shadow-md">
                <h4 className="text-sm sm:text-base font-bold text-foreground mb-4">My Team Members ({profile.teamName})</h4>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {teamMembers.map((m) => (
                    <div key={m.id} className="p-4 bg-neutral-50/50 rounded-xl border border-neutral-200 flex flex-col">
                      <span className="text-sm font-bold text-foreground">{m.fullName || 'Registered Student'}</span>
                      <span className="text-xs text-muted mt-1">{m.email}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </main>

      {/* Footer */}
      <footer className="py-6 border-t border-border-light text-center text-xs text-muted bg-white">
        © {new Date().getFullYear()} GLA University. BCA Orientation.
      </footer>
    </div>
  )
}
