'use client'

import React, { useState, useEffect, useTransition, useRef } from 'react'
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import { signOutAction } from '@/app/auth/actions'
import { createClient } from '@/lib/supabase/client'
import { Shield, Trophy, Zap, Users, Download, Upload, LogOut, CheckCircle2, AlertCircle, Plus, Trash2, Search, ListOrdered, Clock, Image as ImageIcon, RefreshCw } from 'lucide-react'

interface StudentProfile {
  id: string
  email: string
  fullName: string | null
  teamName: string | null
  surveyCompleted: boolean
  surveyAnswers: any | null
  registeredAt: string
  isLeader?: boolean
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

export default function AdminPortal() {
  const router = useRouter()
  const [isPending, startTransition] = useTransition()

  // Tab views: 'leaderboard', 'control', 'teams', 'team-formation', 'uploads'
  const [activeTab, setActiveTab] = useState<'leaderboard' | 'control' | 'teams' | 'team-formation' | 'uploads'>('leaderboard')
  
  // Leaderboard sub-tabs: 'update-scores' | 'live-view'
  const [leaderboardSubTab, setLeaderboardSubTab] = useState<'update-scores' | 'live-view'>('update-scores')

  // Teams sub-tabs: 'overview' | 'manage-teams' | 'transfer-student'
  const [teamsSubTab, setTeamsSubTab] = useState<'overview' | 'manage-teams' | 'transfer-student'>('overview')

  // Real-time states
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
  const [studentsList, setStudentsList] = useState<StudentProfile[]>([])

  // State for adding team
  const [newTeamName, setNewTeamName] = useState('')
  
  // State for search and add student
  const [searchQuery, setSearchQuery] = useState('')
  const [searchedStudents, setSearchedStudents] = useState<StudentProfile[]>([])
  const [selectedDestinationTeam, setSelectedDestinationTeam] = useState('')
  const [teamDropdownOpen, setTeamDropdownOpen] = useState(false)
  const [lightboxImage, setLightboxImage] = useState<{ url: string; teamName: string } | null>(null)

  // State for bulk assignments
  const [bulkAssignmentsJson, setBulkAssignmentsJson] = useState('')
  const [bulkSuccessMsg, setBulkSuccessMsg] = useState('')
  const [bulkErrorMsg, setBulkErrorMsg] = useState('')
  const [isActivating, setIsActivating] = useState(false)
  const [isApplyingBulk, setIsApplyingBulk] = useState(false)
  const [assigningLeaders, setAssigningLeaders] = useState<Record<string, boolean>>({})

  // Control Panel Active states
  const [selectedGame, setSelectedGame] = useState('guess the song')
  const [selectedQuestion, setSelectedQuestion] = useState('Q1')

  // Prompt Image Creation timing UI states
  const [promptStartInput, setPromptStartInput] = useState('') // HH:MM format
  const [promptEndInput, setPromptEndInput] = useState('') // HH:MM format
  const [promptSaving, setPromptSaving] = useState(false)
  const [promptSaveMsg, setPromptSaveMsg] = useState('')

  // Score editing states (raw string values per game field per team, so typing works naturally)
  const [editingScores, setEditingScores] = useState<Record<string, Record<string, string>>>({})
  const [savingTeams, setSavingTeams] = useState<Record<string, boolean>>({})
  const [isUpdatingAll, setIsUpdatingAll] = useState(false)
  const [updateAllDone, setUpdateAllDone] = useState(false)

  // Buzzer history logs state
  const [buzzerLogs, setBuzzerLogs] = useState<{ id: number; game_name: string; question_id: string; team_name: string; rank: number; user_name: string; pressed_at: string }[]>([])
  
  // Fetch buzzer history logs
  const fetchBuzzerLogs = async () => {
    try {
      const supabase = createClient()
      const { data, error } = await supabase
        .from('buzzer_logs')
        .select('*')
        .order('id', { ascending: false })
        .limit(100)
      if (error) throw error
      if (data) setBuzzerLogs(data)
    } catch (err) {
      console.error('Error fetching buzzer logs:', err)
    }
  }


  // Fetch all database states
  const refreshState = async () => {
    try {
      const res = await fetch('/api/game-state')
      const data = await res.json()
      if (data.success) {
        if (data.leaderboard) setLeaderboard(data.leaderboard)
        if (data.buzzerState) setBuzzerState(data.buzzerState)
        if (data.buzzerRanks) setBuzzerRanks(data.buzzerRanks)
        if (data.teamUploads) setTeamUploads(data.teamUploads)
        if (data.studentsList) setStudentsList(data.studentsList)
      }
    } catch (err) {
      console.error('Error fetching admin data:', err)
    }
  }

  // Supabase Realtime Connection for instant database updates
  useEffect(() => {
    refreshState()
    fetchBuzzerLogs()

    const supabase = createClient()
    const channel = supabase
      .channel('schema-db-changes-admin')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'buzzer_state' }, () => {
        refreshState()
      })
      .on('postgres_changes', { event: '*', schema: 'public', table: 'buzzer_ranks' }, () => {
        refreshState()
      })
      .on('postgres_changes', { event: '*', schema: 'public', table: 'team_uploads' }, () => {
        refreshState()
      })
      .on('postgres_changes', { event: '*', schema: 'public', table: 'buzzer_logs' }, () => {
        fetchBuzzerLogs()
      })
      .subscribe()

    // Safety Fallback: Poll every 4 seconds in case firewalls block WebSockets
    const fallbackPoll = setInterval(() => {
      refreshState()
      fetchBuzzerLogs()
    }, 4000)

    return () => {
      supabase.removeChannel(channel)
      clearInterval(fallbackPoll)
    }
  }, [])

  // Handle Logout
  const handleLogout = async () => {
    await signOutAction()
    router.push('/login')
    router.refresh()
  }

  // Trigger score update server action
  const handleScoreSave = async (teamName: string, gameField: string, score: number) => {
    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'update_score',
          teamName,
          game: gameField,
          score
        })
      })
      const data = await res.json()
      if (data.success) {
        setEditingScores((prev) => {
          const next = { ...prev }
          if (next[teamName]) delete next[teamName][gameField]
          return next
        })
        refreshState()
      }
    } catch (err) {
      alert('Error updating score')
    }
  }

  // Save all modified scores for a specific team row at once
  const handleSaveTeamRow = async (teamName: string) => {
    const localEdits = editingScores[teamName]
    if (!localEdits || Object.keys(localEdits).length === 0) return

    setSavingTeams((prev) => ({ ...prev, [teamName]: true }))
    try {
      // Save each modified field in parallel
      const promises = Object.entries(localEdits).map(([gameField, score]) => {
        return fetch('/api/admin', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            action: 'update_score',
            teamName,
            game: gameField,
            score: Number(score)
          })
        })
      })
      await Promise.all(promises)

      // Clear local edits for this team
      setEditingScores((prev) => {
        const next = { ...prev }
        delete next[teamName]
        return next
      })
      refreshState()
    } catch (err) {
      alert('Error saving scores for ' + teamName)
    } finally {
      setSavingTeams((prev) => ({ ...prev, [teamName]: false }))
    }
  }

  // Save all teams with pending edits at once
  const handleUpdateAll = async () => {
    const teamsWithEdits = Object.keys(editingScores).filter(
      (teamName) => Object.keys(editingScores[teamName]).length > 0
    )
    if (teamsWithEdits.length === 0) return
    setIsUpdatingAll(true)
    setUpdateAllDone(false)
    try {
      await Promise.all(teamsWithEdits.map((teamName) => handleSaveTeamRow(teamName)))
      setUpdateAllDone(true)
      setTimeout(() => setUpdateAllDone(false), 2000)
    } finally {
      setIsUpdatingAll(false)
    }
  }

  // Handle local change to team score input — store as raw string so typing works naturally
  const handleLocalScoreChange = (teamName: string, gameField: string, val: string) => {
    setEditingScores((prev) => ({
      ...prev,
      [teamName]: {
        ...prev[teamName],
        [gameField]: val // store raw string, convert to number only on save
      }
    }))
  }

  // Control: Activate question / upload timer
  const handleActivateQuestion = async () => {
    setIsActivating(true)
    try {
      const isPromptGame = selectedGame === 'Prompt image creation'
      const payload: any = {
        action: 'activate_question',
        gameName: selectedGame,
        questionId: selectedQuestion
      }

      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      })
      const data = await res.json()
      if (data.success) {
        refreshState()
      }
    } catch (err) {
      alert('Error activating question')
    } finally {
      setIsActivating(false)
    }
  }

  // Control: Close/lock buzzer or uploads
  const handleDeactivateBuzzer = async () => {
    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'deactivate_buzzer' })
      })
      const data = await res.json()
      if (data.success) {
        refreshState()
      }
    } catch (err) {
      alert('Error deactivating buzzer')
    }
  }

  // Teams: Add new team
  const handleAddTeam = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!newTeamName.trim()) return

    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'add_team',
          teamName: newTeamName.trim()
        })
      })
      const data = await res.json()
      if (data.success) {
        setNewTeamName('')
        refreshState()
      } else {
        alert(data.error || 'Failed to add team')
      }
    } catch (err) {
      alert('Error adding team')
    }
  }

  // Teams: Remove team
  const handleRemoveTeam = async (teamName: string) => {
    if (!confirm(`Are you sure you want to remove the team "${teamName}"? All its assigned students will be unassigned.`)) return

    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'remove_team',
          teamName
        })
      })
      const data = await res.json()
      if (data.success) {
        refreshState()
      }
    } catch (err) {
      alert('Error removing team')
    }
  }

  // Teams: Move student to another team
  const handleMoveStudent = async (studentId: string, teamName: string | null) => {
    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'move_student',
          studentId,
          teamName
        })
      })
      const data = await res.json()
      if (data.success) {
        refreshState()
      }
    } catch (err) {
      alert('Error transferring student')
    }
  }

  // Teams: Assign student as team leader
  const handleAssignLeader = async (studentId: string, teamName: string) => {
    setAssigningLeaders((prev) => ({ ...prev, [studentId]: true }))
    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'assign_leader',
          studentId,
          teamName
        })
      })
      const data = await res.json()
      if (data.success) {
        // Refresh local student search if we are currently searching
        if (searchQuery.trim()) {
          setSearchedStudents((prev) =>
            prev.map((s) => {
              if (s.id === studentId) return { ...s, isLeader: true }
              if (s.teamName?.toLowerCase() === teamName.toLowerCase() && s.id !== studentId) {
                return { ...s, isLeader: false }
              }
              return s
            })
          )
        }
        refreshState()
      } else {
        alert(data.error || 'Failed to assign team leader')
      }
    } catch (err) {
      alert('Error assigning team leader')
    } finally {
      setAssigningLeaders((prev) => ({ ...prev, [studentId]: false }))
    }
  }

  // Teams: Remove team leader role from a student
  const handleRemoveLeader = async (studentId: string) => {
    setAssigningLeaders((prev) => ({ ...prev, [studentId]: true }))
    try {
      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'remove_leader',
          studentId
        })
      })
      const data = await res.json()
      if (data.success) {
        if (searchQuery.trim()) {
          setSearchedStudents((prev) =>
            prev.map((s) => (s.id === studentId ? { ...s, isLeader: false } : s))
          )
        }
        refreshState()
      } else {
        alert(data.error || 'Failed to remove team leader')
      }
    } catch (err) {
      alert('Error removing team leader')
    } finally {
      setAssigningLeaders((prev) => ({ ...prev, [studentId]: false }))
    }
  }

  // Teams Search & Add Members
  const handleSearchStudents = (e: React.FormEvent) => {
    e.preventDefault()
    if (!searchQuery.trim()) {
      setSearchedStudents([])
      return
    }
    const q = searchQuery.toLowerCase()
    const matches = studentsList.filter(
      (s) =>
        s.fullName?.toLowerCase().includes(q) ||
        s.email?.toLowerCase().includes(q)
    )
    setSearchedStudents(matches)
  }

  // Team Formation: Download survey logs as JSON
  const handleDownloadJson = () => {
    const dataStr = 'data:text/json;charset=utf-8,' + encodeURIComponent(JSON.stringify(studentsList, null, 2))
    const downloadAnchor = document.createElement('a')
    downloadAnchor.setAttribute('href', dataStr)
    downloadAnchor.setAttribute('download', 'survey_submissions.json')
    document.body.appendChild(downloadAnchor)
    downloadAnchor.click()
    downloadAnchor.remove()
  }

  // Team Formation: Apply bulk assignments uploaded in JSON format
  const handleApplyBulkAssignments = async () => {
    setBulkErrorMsg('')
    setBulkSuccessMsg('')

    if (!bulkAssignmentsJson.trim()) {
      setBulkErrorMsg('Please paste the JSON assignments content first.')
      return
    }

    setIsApplyingBulk(true)
    try {
      const assignments = JSON.parse(bulkAssignmentsJson)
      if (!Array.isArray(assignments)) {
        setBulkErrorMsg('Invalid format. JSON must be an array of { email: string, team: string } objects.')
        return
      }

      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'bulk_assign_teams',
          assignments
        })
      })
      const data = await res.json()

      if (data.success) {
        setBulkSuccessMsg(`Successfully assigned ${data.count} students to their teams!`)
        setBulkAssignmentsJson('')
        refreshState()
      } else {
        setBulkErrorMsg(data.error || 'Failed to apply assignments.')
      }
    } catch (err: any) {
      setBulkErrorMsg('Failed to parse JSON. Please check spelling, brackets, and quotes.')
    } finally {
      setIsApplyingBulk(false)
    }
  }

  const gamesList = [
    'guess the song',
    'dont say yes or no',
    'only wrong answer',
    'Prompt image creation'
  ]

  const questionList = Array.from({ length: 10 }, (_, i) => `Q${i + 1}`)

  // Save custom start and end times for Prompt Image Creation game
  const handleSavePromptTimes = async () => {
    if (!promptStartInput || !promptEndInput) {
      setPromptSaveMsg('Please select both a start time and end time.')
      return
    }
    setPromptSaving(true)
    setPromptSaveMsg('')
    try {
      const parseLocalTimeInput = (timeStr: string) => {
        const [hours, minutes] = timeStr.split(':').map(Number)
        const d = new Date()
        d.setHours(hours, minutes, 0, 0)
        return d.toISOString()
      }

      const res = await fetch('/api/admin', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          action: 'set_prompt_times',
          startTime: parseLocalTimeInput(promptStartInput),
          endTime: parseLocalTimeInput(promptEndInput)
        })
      })
      const data = await res.json()
      if (data.success) {
        setPromptSaveMsg('Times updated! Students can now see the upload window.')
        refreshState()
      } else {
        setPromptSaveMsg('Error: ' + (data.error || 'Failed to save times.'))
      }
    } catch (err) {
      setPromptSaveMsg('Network error saving times.')
    } finally {
      setPromptSaving(false)
    }
  }

  const isSelectedQuestionActive = buzzerState.isActive &&
    buzzerState.activeGame === selectedGame &&
    buzzerState.activeQuestion === selectedQuestion;

  const filteredHistoryRanks = (() => {
    const filtered = buzzerLogs.filter(
      (log) => log.game_name.toLowerCase() === selectedGame.toLowerCase() &&
               log.question_id.toLowerCase() === selectedQuestion.toLowerCase()
    );
    const uniqueTeams: Record<string, typeof filtered[0]> = {};
    // Since buzzerLogs is fetched ORDER BY id DESC, the first one we find is the latest attempt
    filtered.forEach((item) => {
      const key = item.team_name.toLowerCase();
      if (!uniqueTeams[key]) {
        uniqueTeams[key] = item;
      }
    });
    return Object.values(uniqueTeams).sort((a, b) => a.rank - b.rank);
  })();

  return (
    <div className="min-h-screen bg-neutral-50 flex flex-col justify-between">
      
      {/* Navigation Header */}
      <header className="sticky top-0 z-50 bg-white/90 backdrop-blur border-b border-neutral-200/80 shadow-sm">
        <div className="w-full px-4 sm:px-8 py-2 flex items-center justify-between">
          {/* Logo — matches student portal */}
          <div className="flex items-center gap-3">
            <Image
              src="/gla-logo.webp"
              alt="GLA Logo"
              width={120}
              height={120}
              className="object-contain w-20 sm:w-28 h-auto max-h-16 sm:max-h-20"
            />
            <div className="hidden md:flex flex-col">
              <span className="font-display font-extrabold text-lg sm:text-xl text-foreground leading-none">
                GLA University Admin
              </span>
              <span className="text-[11px] text-muted font-semibold mt-1">
                BCA Orientation 2026
              </span>
            </div>
          </div>

          {/* Nav + Logout */}
          <div className="flex items-center gap-4">
            <nav className="flex items-center gap-1">
              <button
                onClick={() => setActiveTab('leaderboard')}
                className={`flex items-center gap-1.5 px-3 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  activeTab === 'leaderboard' ? 'bg-foreground text-btn-text-light shadow-btn-inset' : 'text-muted hover:text-foreground'
                }`}
              >
                <Trophy className="w-3.5 h-3.5" /> Leaderboard
              </button>
              <button
                onClick={() => setActiveTab('control')}
                className={`flex items-center gap-1.5 px-3 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  activeTab === 'control' ? 'bg-foreground text-btn-text-light shadow-btn-inset' : 'text-muted hover:text-foreground'
                }`}
              >
                <Zap className="w-3.5 h-3.5" /> Control Panel
              </button>
              <button
                onClick={() => setActiveTab('teams')}
                className={`flex items-center gap-1.5 px-3 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  activeTab === 'teams' ? 'bg-foreground text-btn-text-light shadow-btn-inset' : 'text-muted hover:text-foreground'
                }`}
              >
                <Users className="w-3.5 h-3.5" /> Teams
              </button>
              <button
                onClick={() => setActiveTab('team-formation')}
                className={`flex items-center gap-1.5 px-3 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  activeTab === 'team-formation' ? 'bg-foreground text-btn-text-light shadow-btn-inset' : 'text-muted hover:text-foreground'
                }`}
              >
                <ListOrdered className="w-3.5 h-3.5" /> Formation Desk
              </button>
              <button
                onClick={() => setActiveTab('uploads')}
                className={`flex items-center gap-1.5 px-3 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  activeTab === 'uploads' ? 'bg-foreground text-btn-text-light shadow-btn-inset' : 'text-muted hover:text-foreground'
                }`}
              >
                <ImageIcon className="w-3.5 h-3.5" /> Uploaded Images
              </button>
            </nav>

            <button
              onClick={handleLogout}
              className="flex items-center gap-1.5 px-3 py-1.5 border border-neutral-300 rounded-lg text-xs font-bold text-foreground hover:bg-black/5 transition cursor-pointer shadow-sm"
            >
              <LogOut className="w-3.5 h-3.5" /> Logout
            </button>
          </div>
        </div>
      </header>

      {/* Main Workspace */}
      <main className="max-w-7xl w-full mx-auto px-6 py-8 flex-grow">

        {/* TAB 1: LEADERBOARD MANAGER */}
        {activeTab === 'leaderboard' && (
          <div className="space-y-6">
            <div className="flex gap-2 border-b border-neutral-200 pb-4">
              <button
                onClick={() => setLeaderboardSubTab('update-scores')}
                className={`px-4 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  leaderboardSubTab === 'update-scores' ? 'bg-white text-blue-600 shadow-sm border border-neutral-200' : 'text-muted hover:text-foreground'
                }`}
              >
                Update Team Scores
              </button>
              <button
                onClick={() => setLeaderboardSubTab('live-view')}
                className={`px-4 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  leaderboardSubTab === 'live-view' ? 'bg-white text-blue-600 shadow-sm border border-neutral-200' : 'text-muted hover:text-foreground'
                }`}
              >
                Live Leaderboard Preview
              </button>
            </div>

            {leaderboardSubTab === 'update-scores' && (
              <div className="bg-white border border-neutral-200 rounded-2xl p-8 shadow-md">
                <div className="flex items-start justify-between gap-4 mb-4">
                  <div>
                    <h3 className="font-display text-lg font-bold text-foreground">Edit Game Scores</h3>
                    <p className="text-sm text-muted mt-1">Modify team scores for games 1-5. Input scores locally and click <strong>Update</strong> to save changes live.</p>
                  </div>
                  {(Object.keys(editingScores).filter((t) => Object.keys(editingScores[t]).length > 0).length > 1 || isUpdatingAll || updateAllDone) && (
                    <button
                      onClick={handleUpdateAll}
                      disabled={isUpdatingAll}
                      className={`flex-shrink-0 flex items-center gap-2 px-4 py-2.5 text-xs font-black rounded-xl shadow-sm transition cursor-pointer ${
                        updateAllDone
                          ? 'bg-emerald-500 text-white cursor-default'
                          : isUpdatingAll
                          ? 'bg-blue-400 text-white cursor-not-allowed'
                          : 'bg-blue-600 hover:bg-blue-700 text-white'
                      }`}
                    >
                      {updateAllDone ? (
                        <>
                          <svg xmlns="http://www.w3.org/2000/svg" className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                          </svg>
                          All Saved!
                        </>
                      ) : isUpdatingAll ? (
                        <>
                          <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                          Saving...
                        </>
                      ) : (
                        <>
                          <RefreshCw className="w-3.5 h-3.5" />
                          Update All ({Object.keys(editingScores).filter((t) => Object.keys(editingScores[t]).length > 0).length})
                        </>
                      )}
                    </button>
                  )}
                </div>

                <div className="overflow-x-auto">
                  <table className="w-full text-sm text-left border-collapse">
                    <thead>
                      <tr className="border-b border-neutral-200 text-xs text-muted uppercase font-bold">
                        <th className="py-3 px-4">Team Name</th>
                        <th className="py-3 px-2 text-center w-24">Game 1</th>
                        <th className="py-3 px-2 text-center w-24">Game 2</th>
                        <th className="py-3 px-2 text-center w-24">Game 3</th>
                        <th className="py-3 px-2 text-center w-24">Game 4</th>
                        <th className="py-3 px-2 text-center w-24">Game 5</th>
                        <th className="py-3 px-4 text-center">Total Score</th>
                        <th className="py-3 px-4 text-right">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      {[...leaderboard]
                        .sort((a, b) => {
                          const edA = editingScores[a.teamName] || {}
                          const edB = editingScores[b.teamName] || {}
                          const totA = Number(edA.game1 ?? a.game1) + Number(edA.game2 ?? a.game2) + Number(edA.game3 ?? a.game3) + Number(edA.game4 ?? a.game4) + Number(edA.game5 ?? a.game5)
                          const totB = Number(edB.game1 ?? b.game1) + Number(edB.game2 ?? b.game2) + Number(edB.game3 ?? b.game3) + Number(edB.game4 ?? b.game4) + Number(edB.game5 ?? b.game5)
                          return totB - totA
                        })
                        .map((team) => {
                        const localEdits = editingScores[team.teamName] || {}
                        // Show raw string while editing, fall back to team's saved number
                        const g1 = localEdits.game1 !== undefined ? localEdits.game1 : String(team.game1)
                        const g2 = localEdits.game2 !== undefined ? localEdits.game2 : String(team.game2)
                        const g3 = localEdits.game3 !== undefined ? localEdits.game3 : String(team.game3)
                        const g4 = localEdits.game4 !== undefined ? localEdits.game4 : String(team.game4)
                        const g5 = localEdits.game5 !== undefined ? localEdits.game5 : String(team.game5)
                        
                        const displayTotal = Number(g1 || 0) + Number(g2 || 0) + Number(g3 || 0) + Number(g4 || 0) + Number(g5 || 0)
                        const hasEdits = Object.keys(localEdits).length > 0

                        return (
                          <tr key={team.teamName} className="border-b border-neutral-100 hover:bg-neutral-50/50 transition">
                            <td className="py-3 px-4 font-semibold text-foreground">{team.teamName}</td>
                            
                            <td className="py-2 px-2 text-center">
                              <input
                                type="text"
                                inputMode="numeric"
                                pattern="[0-9]*"
                                value={g1}
                                onFocus={(e) => e.target.select()}
                                onChange={(e) => handleLocalScoreChange(team.teamName, 'game1', e.target.value)}
                                className="w-16 text-center border border-neutral-200 rounded p-1 text-xs focus:ring-1 focus:ring-blue-500 bg-white"
                              />
                            </td>

                            <td className="py-2 px-2 text-center">
                              <input
                                type="text"
                                inputMode="numeric"
                                pattern="[0-9]*"
                                value={g2}
                                onFocus={(e) => e.target.select()}
                                onChange={(e) => handleLocalScoreChange(team.teamName, 'game2', e.target.value)}
                                className="w-16 text-center border border-neutral-200 rounded p-1 text-xs focus:ring-1 focus:ring-blue-500 bg-white"
                              />
                            </td>

                            <td className="py-2 px-2 text-center">
                              <input
                                type="text"
                                inputMode="numeric"
                                pattern="[0-9]*"
                                value={g3}
                                onFocus={(e) => e.target.select()}
                                onChange={(e) => handleLocalScoreChange(team.teamName, 'game3', e.target.value)}
                                className="w-16 text-center border border-neutral-200 rounded p-1 text-xs focus:ring-1 focus:ring-blue-500 bg-white"
                              />
                            </td>

                            <td className="py-2 px-2 text-center">
                              <input
                                type="text"
                                inputMode="numeric"
                                pattern="[0-9]*"
                                value={g4}
                                onFocus={(e) => e.target.select()}
                                onChange={(e) => handleLocalScoreChange(team.teamName, 'game4', e.target.value)}
                                className="w-16 text-center border border-neutral-200 rounded p-1 text-xs focus:ring-1 focus:ring-blue-500 bg-white"
                              />
                            </td>

                            <td className="py-2 px-2 text-center">
                              <input
                                type="text"
                                inputMode="numeric"
                                pattern="[0-9]*"
                                value={g5}
                                onFocus={(e) => e.target.select()}
                                onChange={(e) => handleLocalScoreChange(team.teamName, 'game5', e.target.value)}
                                className="w-16 text-center border border-neutral-200 rounded p-1 text-xs focus:ring-1 focus:ring-blue-500 bg-white"
                              />
                            </td>

                            <td className="py-3 px-4 text-center font-display font-black text-foreground">
                              {displayTotal}
                            </td>

                            <td className="py-2 px-4 text-right">
                              <button
                                onClick={() => handleSaveTeamRow(team.teamName)}
                                disabled={!hasEdits || savingTeams[team.teamName]}
                                className={`px-3 py-1.5 rounded-lg text-xs font-bold transition flex items-center justify-center gap-1.5 cursor-pointer ml-auto ${
                                  hasEdits
                                    ? 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm'
                                    : 'bg-neutral-50 text-neutral-400 border border-neutral-200/60 cursor-not-allowed'
                                }`}
                              >
                                {savingTeams[team.teamName] ? (
                                  <RefreshCw className="w-3.5 h-3.5 animate-spin" />
                                ) : (
                                  'Update'
                                )}
                              </button>
                            </td>
                          </tr>
                        )
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {leaderboardSubTab === 'live-view' && (
              <div className="bg-white border border-neutral-200 rounded-2xl p-8 shadow-md">
                <div className="flex items-center justify-between mb-6">
                  <div>
                    <h3 className="font-display text-lg font-black text-foreground">Real-Time Leaderboard View</h3>
                    <p className="text-xs text-muted mt-0.5">Live standings — refreshed from database</p>
                  </div>
                  <button
                    onClick={refreshState}
                    className="flex items-center gap-1.5 px-3 py-1.5 bg-neutral-100 hover:bg-neutral-200 border border-neutral-200 rounded-lg text-xs font-bold text-foreground transition cursor-pointer"
                  >
                    <RefreshCw className="w-3.5 h-3.5" /> Refresh
                  </button>
                </div>
                
                <div className="overflow-x-auto">
                  <table className="w-full text-sm text-left border-collapse">
                    <thead>
                      <tr className="border-b-2 border-neutral-200 text-[11px] text-muted uppercase font-black tracking-wider">
                        <th className="py-3 px-4">Rank</th>
                        <th className="py-3 px-4">Team</th>
                        <th className="py-3 px-3 text-center">Game 1</th>
                        <th className="py-3 px-3 text-center">Game 2</th>
                        <th className="py-3 px-3 text-center">Game 3</th>
                        <th className="py-3 px-3 text-center">Game 4</th>
                        <th className="py-3 px-3 text-center">Game 5</th>
                        <th className="py-3 px-4 text-right">Total</th>
                      </tr>
                    </thead>
                    <tbody>
                      {[...leaderboard]
                        .map((team) => ({
                          ...team,
                          computedTotal: team.game1 + team.game2 + team.game3 + team.game4 + team.game5
                        }))
                        .sort((a, b) => b.computedTotal - a.computedTotal)
                        .map((team, idx) => {
                        const rank = idx + 1
                        const isFirst = rank === 1
                        const isSecond = rank === 2
                        const isThird = rank === 3
                        return (
                          <tr
                            key={team.teamName}
                            className={`border-b transition ${
                              isFirst
                                ? 'border-amber-100 bg-gradient-to-r from-amber-50 to-white'
                                : isSecond
                                ? 'border-slate-100 bg-gradient-to-r from-slate-50 to-white'
                                : isThird
                                ? 'border-orange-100 bg-gradient-to-r from-orange-50/40 to-white'
                                : 'border-neutral-100 hover:bg-neutral-50/50'
                            }`}
                          >
                            <td className="py-3.5 px-4">
                              <span className={`inline-flex items-center justify-center w-7 h-7 rounded-full text-xs font-black ${
                                isFirst ? 'bg-amber-500 text-white' :
                                isSecond ? 'bg-slate-400 text-white' :
                                isThird ? 'bg-orange-400 text-white' :
                                'bg-neutral-100 text-neutral-600'
                              }`}>
                                {rank}
                              </span>
                            </td>
                            <td className={`py-3.5 px-4 font-extrabold ${isFirst ? 'text-amber-950' : 'text-foreground'}`}>
                              {team.teamName}
                            </td>
                            <td className="py-3.5 px-3 text-center text-sm text-neutral-600 font-medium">{team.game1}</td>
                            <td className="py-3.5 px-3 text-center text-sm text-neutral-600 font-medium">{team.game2}</td>
                            <td className="py-3.5 px-3 text-center text-sm text-neutral-600 font-medium">{team.game3}</td>
                            <td className="py-3.5 px-3 text-center text-sm text-neutral-600 font-medium">{team.game4}</td>
                            <td className="py-3.5 px-3 text-center text-sm text-neutral-600 font-medium">{team.game5}</td>
                            <td className={`py-3.5 px-4 text-right font-display font-black text-lg ${isFirst ? 'text-amber-700' : 'text-foreground'}`}>
                              {team.computedTotal}
                            </td>
                          </tr>
                        )
                      })}
                    </tbody>
                  </table>
                </div>
              </div>
            )}
          </div>
        )}

        {/* TAB 2: BUZZER & GAME CONTROL PANEL */}
        {activeTab === 'control' && (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            {/* Left Column: Side Controls (Game Activity, Question selectors & activator) */}
            <div className="lg:col-span-5 space-y-6">
              
              {/* Game Activity Selector Card */}
              <div className="bg-white border border-neutral-200 rounded-2xl p-5 shadow-md">
                <h3 className="text-xs font-bold text-muted uppercase tracking-wider mb-3 pl-1">Select Game Activity</h3>
                <div className="space-y-1">
                  {gamesList.map((g) => (
                    <button
                      key={g}
                      onClick={() => {
                        setSelectedGame(g)
                        setSelectedQuestion('Q1')
                      }}
                      className={`w-full text-left px-4 py-2.5 rounded-xl text-xs font-bold transition cursor-pointer capitalize ${
                        selectedGame === g
                          ? 'bg-foreground text-btn-text-light shadow-btn-inset'
                          : 'text-foreground hover:bg-neutral-50'
                      }`}
                    >
                      {g}
                    </button>
                  ))}
                </div>
              </div>

              {/* Question / Round selector Card - only shown for buzzer games */}
              {selectedGame !== 'Prompt image creation' && (
                <div className="bg-white border border-neutral-200 rounded-2xl p-5 shadow-md">
                  <h3 className="text-xs font-bold text-muted uppercase tracking-wider mb-3 pl-1">Question / Round</h3>
                  <div className="grid grid-cols-5 gap-1.5">
                    {questionList.map((q) => (
                      <button
                        key={q}
                        onClick={() => setSelectedQuestion(q)}
                        className={`py-2 rounded-lg text-xs font-bold text-center border transition cursor-pointer ${
                          selectedQuestion === q
                            ? 'bg-neutral-200 text-foreground border-neutral-300'
                            : 'bg-white border-neutral-200 text-foreground hover:bg-neutral-50'
                        }`}
                      >
                        {q}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Game Controller Card */}
              <div className="bg-white border border-neutral-200 rounded-2xl p-6 shadow-md">
                <div className="border-b border-neutral-100 pb-4 mb-4">
                  <span className="text-[10px] bg-neutral-100 border border-neutral-200 px-2 py-0.5 rounded font-bold uppercase tracking-wider">
                    {selectedGame}
                  </span>
                  <h2 className="font-display text-xl font-black text-foreground mt-2">
                    {selectedGame === 'Prompt image creation' ? 'Set Upload Window' : `Active Controls: ${selectedQuestion}`}
                  </h2>
                </div>

                {/* Game specific layout */}
                {selectedGame === 'Prompt image creation' ? (
                  <div className="space-y-5">
                    <p className="text-xs text-muted">
                      Set the upload window time and click <strong>Update</strong> to push it live to student portals.
                    </p>

                    <div className="grid grid-cols-2 gap-4">
                      {/* Start Time */}
                      <div className="space-y-1.5">
                        <label className="block text-xs font-bold text-foreground">Start Time</label>
                        <input
                          type="time"
                          value={promptStartInput}
                          onChange={(e) => setPromptStartInput(e.target.value)}
                          className="w-full bg-white border border-neutral-200 rounded-lg px-3 py-2 text-sm font-semibold text-foreground focus:ring-2 focus:ring-blue-500 focus:outline-none"
                        />
                      </div>

                      {/* End Time */}
                      <div className="space-y-1.5">
                        <label className="block text-xs font-bold text-foreground">End Time</label>
                        <input
                          type="time"
                          value={promptEndInput}
                          onChange={(e) => setPromptEndInput(e.target.value)}
                          className="w-full bg-white border border-neutral-200 rounded-lg px-3 py-2 text-sm font-semibold text-foreground focus:ring-2 focus:ring-blue-500 focus:outline-none"
                        />
                      </div>
                    </div>

                    <button
                      onClick={handleSavePromptTimes}
                      disabled={promptSaving || !promptStartInput || !promptEndInput}
                      className={`w-full py-3 rounded-xl text-sm font-black uppercase tracking-wider transition flex items-center justify-center gap-2 cursor-pointer ${
                        promptSaving || !promptStartInput || !promptEndInput
                          ? 'bg-neutral-100 text-neutral-400 border border-neutral-200 cursor-not-allowed'
                          : 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm'
                      }`}
                    >
                      {promptSaving ? <RefreshCw className="w-4 h-4 animate-spin" /> : <Clock className="w-4 h-4" />}
                      {promptSaving ? 'Updating...' : 'Update Upload Window'}
                    </button>

                    {promptSaveMsg && (
                      <p className={`text-xs font-semibold text-center px-3 py-2 rounded-lg ${
                        promptSaveMsg.startsWith('Error') ? 'bg-red-50 text-red-700' : 'bg-green-50 text-green-700'
                      }`}>
                        {promptSaveMsg}
                      </p>
                    )}

                    {/* Show current saved times if any */}
                    {(buzzerState.promptImageStartTime || buzzerState.promptImageEndTime) && (
                      <div className="bg-blue-50 border border-blue-200 rounded-xl p-3 space-y-1">
                        <p className="text-[10px] font-bold text-blue-700 uppercase tracking-widest">Currently Live</p>
                        <div className="flex gap-4 text-xs font-semibold text-blue-900">
                          <span>Start: <span className="font-black">{buzzerState.promptImageStartTime ? new Date(`1970-01-01T${buzzerState.promptImageStartTime}`).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'}) : '—'}</span></span>
                          <span>End: <span className="font-black">{buzzerState.promptImageEndTime ? new Date(`1970-01-01T${buzzerState.promptImageEndTime}`).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'}) : '—'}</span></span>
                        </div>
                      </div>
                    )}
                  </div>
                ) : (
                  <div className="space-y-4">
                    <button
                      onClick={handleActivateQuestion}
                      disabled={isActivating || isSelectedQuestionActive || filteredHistoryRanks.length > 0}
                      className={`w-full py-4 rounded-xl text-sm font-black uppercase tracking-wider transition-all duration-200 cursor-pointer shadow-md flex items-center justify-center gap-2 border ${
                        isActivating
                          ? 'bg-neutral-100 text-neutral-400 border-neutral-200 cursor-not-allowed'
                          : isSelectedQuestionActive
                          ? 'bg-green-600 border-green-700 text-white cursor-not-allowed'
                          : filteredHistoryRanks.length > 0
                          ? 'bg-neutral-200 border-neutral-300 text-neutral-400 cursor-not-allowed'
                          : 'bg-red-600 border-red-700 hover:bg-red-500 text-white'
                      }`}
                    >
                      {isActivating ? (
                        <RefreshCw className="w-4 h-4 animate-spin" />
                      ) : isSelectedQuestionActive ? (
                        <Zap className="w-4 h-4 text-green-200 fill-green-200 animate-pulse" />
                      ) : filteredHistoryRanks.length > 0 ? (
                        <Shield className="w-4 h-4 text-neutral-400" />
                      ) : (
                        <Zap className="w-4 h-4" />
                      )}
                      {isActivating
                        ? 'Processing...'
                        : isSelectedQuestionActive
                        ? '🟢 Buzzer is Armed (Active)'
                        : filteredHistoryRanks.length > 0
                        ? '🔒 Round Completed'
                        : `Activate Buzzer for ${selectedQuestion}`}
                    </button>
                    {isSelectedQuestionActive && (
                      <p className="text-[10px] text-green-700 font-semibold text-center animate-pulse">
                        Waiting for student buzz... it will log sequentially.
                      </p>
                    )}
                  </div>
                )}
              </div>

            </div>

            {/* Right Column: Dedicated Projector Board (Buzz Order) */}
            <div className="lg:col-span-7 space-y-6">
              
              <div className="bg-white border border-neutral-200 rounded-2xl p-6 sm:p-10 shadow-md">
                
                {/* Projector Title Header */}
                <div className="flex justify-between items-center pb-4 border-b border-neutral-100 mb-6">
                  <div>
                    <span className="text-[10px] bg-amber-50 text-amber-700 border border-amber-200 px-2 py-0.5 rounded font-bold uppercase tracking-widest">
                      Live Projector View
                    </span>
                    <h3 className="font-display text-lg sm:text-xl font-black text-foreground mt-1 tracking-tight">
                      Buzzer Rank Standings
                    </h3>
                  </div>
                  <span className={`px-2.5 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider ${
                    isSelectedQuestionActive ? 'bg-green-50 text-green-700 animate-pulse' : 'bg-red-50 text-red-700'
                  }`}>
                    {isSelectedQuestionActive ? 'Buzzer Active' : 'Buzzer Locked'}
                  </span>
                </div>

                {/* Main ranks container */}
                {selectedGame === 'Prompt image creation' ? (
                  /* Prompt image rankings list */
                  <div>
                    {teamUploads.length === 0 ? (
                      <div className="text-center py-16 bg-neutral-50 rounded-2xl border border-neutral-200 border-dashed">
                        <ImageIcon className="w-10 h-10 text-muted mx-auto mb-2 opacity-40" />
                        <p className="text-sm font-bold text-muted">No Image Submissions Yet</p>
                        <p className="text-xs text-muted/80 mt-0.5">Waiting for teams to upload their designs...</p>
                      </div>
                    ) : (
                      <div className="space-y-3">
                        {teamUploads.map((log) => {
                          const isFirst = log.rank === 1
                          return (
                            <div
                              key={log.teamName}
                              className={`p-4 rounded-xl border transition-all duration-200 ${
                                isFirst
                                  ? 'bg-gradient-to-r from-amber-500/10 via-yellow-500/5 to-transparent border-2 border-amber-500/60 shadow-md'
                                  : 'bg-neutral-50 border-neutral-200 text-foreground'
                              }`}
                            >
                              <div className="flex justify-between items-center">
                                <div className="flex items-center gap-3">
                                  <span className={`font-black text-sm px-2.5 py-1 rounded-lg ${
                                    isFirst ? 'bg-amber-500 text-white shadow-sm' : 'bg-neutral-200 text-neutral-800'
                                  }`}>
                                    #{log.rank}
                                  </span>
                                  <span className={`font-display font-extrabold ${isFirst ? 'text-xl text-amber-950' : 'text-sm text-foreground'}`}>
                                    {log.teamName}
                                  </span>
                                </div>
                                <div className="flex items-center gap-3">
                                  <span className="text-[10px] text-muted">
                                    {new Date(log.uploadedAt).toLocaleTimeString()}
                                  </span>
                                  <a
                                    href={log.imageUrl}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="px-2.5 py-1 bg-white border border-neutral-200 hover:bg-neutral-50 text-[10px] text-foreground rounded-lg font-bold shadow-sm"
                                  >
                                    View Image
                                  </a>
                                </div>
                              </div>
                            </div>
                          )
                        })}
                      </div>
                    )}
                  </div>
                ) : (
                  /* Standard Buzzer Game rankings */
                  <div>
                    {isSelectedQuestionActive ? (
                      buzzerRanks.length === 0 ? (
                        <div className="text-center py-16 bg-neutral-50 rounded-2xl border border-neutral-200 border-dashed animate-fade-in">
                          <Zap className="w-10 h-10 text-muted mx-auto mb-2 opacity-40" />
                          <p className="text-sm font-bold text-muted">Buzzer is Clear</p>
                          <p className="text-xs text-muted/80 mt-0.5">Waiting for student team action...</p>
                        </div>
                      ) : (
                        <div className="space-y-4 animate-fade-in">
                          {buzzerRanks.map((log) => {
                            const isFirst = log.rank === 1
                            const isSecond = log.rank === 2
                            const isThird = log.rank === 3
                            return (
                              <div
                                key={log.teamName}
                                className={`transition-all duration-200 ${
                                  isFirst
                                    ? 'bg-gradient-to-r from-amber-500/10 via-yellow-500/5 to-transparent border-2 border-amber-500/60 rounded-2xl p-6 relative overflow-hidden shadow-md animate-fade-in'
                                    : isSecond
                                    ? 'bg-slate-50/80 border border-slate-300 rounded-xl p-4 flex items-center justify-between shadow-sm animate-fade-in'
                                    : isThird
                                    ? 'bg-orange-50/40 border border-orange-200 rounded-xl p-4 flex items-center justify-between shadow-sm animate-fade-in'
                                    : 'bg-neutral-50/60 border border-neutral-200 rounded-xl p-3.5 flex items-center justify-between'
                                }`}
                              >
                                {isFirst ? (
                                  <div className="flex items-center gap-4">
                                    <div className="w-14 h-14 rounded-full bg-gradient-to-b from-amber-400 to-amber-600 flex items-center justify-center text-white text-2xl font-black shadow-lg">
                                      👑
                                    </div>
                                    <div>
                                      <div className="flex items-center gap-2">
                                        <span className="text-[10px] text-amber-700 font-bold uppercase tracking-widest">
                                          Fastest Buzz
                                        </span>
                                      </div>
                                      <h4 className="font-display text-2xl sm:text-3xl font-black text-amber-950 tracking-tight mt-0.5">
                                        {log.teamName}
                                      </h4>
                                      <p className="text-[10px] text-amber-900/70 font-semibold mt-1">
                                        Buzzed by: <span className="font-bold text-amber-950">{log.userName}</span>
                                      </p>
                                    </div>
                                  </div>
                                ) : (
                                  <div className="flex justify-between items-center w-full">
                                    <div className="flex items-center gap-3">
                                      <span className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold ${
                                        isSecond ? 'bg-slate-300 text-slate-800' : isThird ? 'bg-orange-300 text-orange-800' : 'bg-neutral-200 text-neutral-600'
                                      }`}>
                                        #{log.rank}
                                      </span>
                                      <span className={`font-display font-extrabold text-foreground ${isSecond ? 'text-lg' : 'text-base'}`}>
                                        {log.teamName}
                                      </span>
                                    </div>
                                    <span className="text-[10px] text-muted font-medium">
                                      Buzzed by: <span className="font-semibold text-foreground">{log.userName}</span>
                                    </span>
                                  </div>
                                )}
                              </div>
                            )
                          })}
                        </div>
                      )
                    ) : (
                      /* Past standings from logs */
                      filteredHistoryRanks.length === 0 ? (
                        <div className="text-center py-16 bg-neutral-50 rounded-2xl border border-neutral-200 border-dashed animate-fade-in">
                          <Zap className="w-10 h-10 text-muted mx-auto mb-2 opacity-40" />
                          <p className="text-sm font-bold text-muted">No History for this Question</p>
                          <p className="text-xs text-muted/80 mt-0.5">Click "Activate Buzzer" to arm this question.</p>
                        </div>
                      ) : (
                        <div className="space-y-4 animate-fade-in">
                          <div className="bg-amber-50 border border-amber-200 text-[10px] text-amber-800 font-bold px-3 py-2 rounded-xl text-center mb-2">
                            📜 Viewing Past Standings (Historical Record)
                          </div>
                          {filteredHistoryRanks.map((log) => {
                            const isFirst = log.rank === 1
                            const isSecond = log.rank === 2
                            const isThird = log.rank === 3
                            return (
                              <div
                                key={log.id}
                                className={`transition-all duration-200 ${
                                  isFirst
                                    ? 'bg-gradient-to-r from-amber-500/10 via-yellow-500/5 to-transparent border-2 border-amber-500/60 rounded-2xl p-6 relative overflow-hidden shadow-md animate-fade-in'
                                    : isSecond
                                    ? 'bg-slate-50/80 border border-slate-300 rounded-xl p-4 flex items-center justify-between shadow-sm animate-fade-in'
                                    : isThird
                                    ? 'bg-orange-50/40 border border-orange-200 rounded-xl p-4 flex items-center justify-between shadow-sm animate-fade-in'
                                    : 'bg-neutral-50/60 border border-neutral-200 rounded-xl p-3.5 flex items-center justify-between'
                                }`}
                              >
                                {isFirst ? (
                                  <div className="flex items-center gap-4">
                                    <div className="w-14 h-14 rounded-full bg-gradient-to-b from-amber-400 to-amber-600 flex items-center justify-center text-white text-2xl font-black shadow-lg">
                                      👑
                                    </div>
                                    <div>
                                      <div className="flex items-center gap-2">
                                        <span className="text-[10px] text-amber-700 font-bold uppercase tracking-widest">
                                          Fastest Buzz
                                        </span>
                                      </div>
                                      <h4 className="font-display text-2xl sm:text-3xl font-black text-amber-950 tracking-tight mt-0.5">
                                        {log.team_name}
                                      </h4>
                                      <p className="text-[10px] text-amber-900/70 font-semibold mt-1">
                                        Buzzed by: <span className="font-bold text-amber-950">{log.user_name}</span>
                                      </p>
                                    </div>
                                  </div>
                                ) : (
                                  <div className="flex justify-between items-center w-full">
                                    <div className="flex items-center gap-3">
                                      <span className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold ${
                                        isSecond ? 'bg-slate-300 text-slate-800' : isThird ? 'bg-orange-300 text-orange-800' : 'bg-neutral-200 text-neutral-600'
                                      }`}>
                                        #{log.rank}
                                      </span>
                                      <span className={`font-display font-extrabold text-foreground ${isSecond ? 'text-lg' : 'text-base'}`}>
                                        {log.team_name}
                                      </span>
                                    </div>
                                    <span className="text-[10px] text-muted font-medium">
                                      Buzzed by: <span className="font-semibold text-foreground">{log.user_name}</span>
                                    </span>
                                  </div>
                                )}
                              </div>
                            )
                          })}
                        </div>
                      )
                    )}
                  </div>
                )}

              </div>

              
            </div>

          </div>
        )}

        {/* TAB 3: TEAMS MANAGER */}
        {activeTab === 'teams' && (
          <div className="space-y-6">
            {/* Sub-tabs */}
            <div className="flex gap-2 border-b border-neutral-200 pb-4">
              <button
                onClick={() => setTeamsSubTab('overview')}
                className={`px-4 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  teamsSubTab === 'overview' ? 'bg-white text-blue-600 shadow-sm border border-neutral-200' : 'text-muted hover:text-foreground'
                }`}
              >
                Teams Overview
              </button>
              <button
                onClick={() => setTeamsSubTab('manage-teams')}
                className={`px-4 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  teamsSubTab === 'manage-teams' ? 'bg-white text-blue-600 shadow-sm border border-neutral-200' : 'text-muted hover:text-foreground'
                }`}
              >
                Add / Remove Teams
              </button>
              <button
                onClick={() => setTeamsSubTab('transfer-student')}
                className={`px-4 py-2 text-xs font-bold rounded-lg transition cursor-pointer ${
                  teamsSubTab === 'transfer-student' ? 'bg-white text-blue-600 shadow-sm border border-neutral-200' : 'text-muted hover:text-foreground'
                }`}
              >
                Transfer Student
              </button>
            </div>

            {/* SUBTAB: Teams Overview */}
            {teamsSubTab === 'overview' && (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                {leaderboard.map((teamScore) => {
                  const members = studentsList.filter(
                    (s) => s.teamName?.toLowerCase() === teamScore.teamName.toLowerCase()
                  )
                  return (
                    <div key={teamScore.teamName} className="bg-slate-50/60 border border-slate-200 rounded-2xl shadow-[0_8px_30px_rgb(0,0,0,0.02)] overflow-hidden flex flex-col transition hover:shadow-[0_12px_30px_rgb(0,0,0,0.05)]">
                      {/* Card Header */}
                      <div className="px-5 py-4 bg-gradient-to-r from-slate-100 to-slate-200/50 flex items-center justify-between gap-3 border-b border-slate-200">
                        <h4 className="font-display font-extrabold text-slate-800 text-sm leading-tight tracking-tight">{teamScore.teamName}</h4>
                        <span className={`text-[10px] font-black px-2.5 py-1 rounded-full flex-shrink-0 shadow-sm ${
                          members.length > 0
                            ? 'bg-blue-100 text-blue-700 border border-blue-200/50'
                            : 'bg-slate-200/60 text-slate-500 border border-slate-300/30'
                        }`}>
                          {members.length} {members.length === 1 ? 'Member' : 'Members'}
                        </span>
                      </div>

                      {/* Members List */}
                      <div className="p-4 flex-1">
                        {members.length === 0 ? (
                          <div className="py-10 flex flex-col items-center justify-center gap-2 border-2 border-dashed border-slate-200 rounded-xl bg-slate-100/40">
                            <Users className="w-6 h-6 text-slate-450" />
                            <p className="text-[11px] text-slate-500 font-bold tracking-tight">No members yet</p>
                          </div>
                        ) : (
                          <div className="space-y-3">
                            {members.map((m) => {
                              const isLeader = m.isLeader || false
                              return (
                                <div key={m.id} className={`rounded-xl border overflow-hidden transition-all duration-200 shadow-sm ${
                                  isLeader 
                                    ? 'border-amber-300 bg-gradient-to-br from-amber-50 via-yellow-50/20 to-white hover:shadow-md' 
                                    : 'border-blue-200 bg-gradient-to-br from-blue-50/40 via-neutral-50/20 to-white hover:border-blue-300 hover:shadow-md'
                                }`}>
                                  <div className="px-3.5 py-3 flex justify-between items-start gap-3">
                                    <div className="min-w-0 flex-1">
                                      <p className="text-xs font-extrabold text-neutral-800 truncate flex items-center gap-1.5">
                                        {isLeader && <Shield className="w-3.5 h-3.5 text-amber-500 fill-amber-400 flex-shrink-0 animate-pulse" />}
                                        <span className={isLeader ? 'text-amber-950 font-black' : 'text-neutral-900'}>{m.fullName || 'Student'}</span>
                                      </p>
                                      <p className={`text-[10px] truncate mt-1 ${isLeader ? 'text-amber-800/80 font-medium' : 'text-neutral-500'}`}>{m.email}</p>
                                    </div>
                                    <button
                                      onClick={() => isLeader ? handleRemoveLeader(m.id) : handleAssignLeader(m.id, m.teamName || '')}
                                      disabled={assigningLeaders[m.id]}
                                      className={`px-2.5 py-1.5 rounded-lg text-[9px] font-black uppercase cursor-pointer tracking-wider transition-all duration-150 flex-shrink-0 ${
                                        assigningLeaders[m.id]
                                          ? 'bg-neutral-100 text-neutral-400 cursor-wait'
                                          : isLeader 
                                          ? 'bg-amber-500 hover:bg-amber-600 text-white shadow-sm border border-amber-600' 
                                          : 'bg-white hover:bg-blue-600 hover:text-white text-blue-700 border border-blue-200 shadow-sm'
                                      }`}
                                    >
                                      {assigningLeaders[m.id] ? '...' : isLeader ? 'Leader ✓' : 'Promote'}
                                    </button>
                                  </div>
                                  <div className={`px-3.5 py-2.5 border-t flex items-center gap-2 ${
                                    isLeader ? 'bg-amber-100/20 border-amber-200/40' : 'bg-blue-50/20 border-blue-100/40'
                                  }`}>
                                    <span className={`text-[9px] font-black uppercase tracking-wider flex-shrink-0 ${
                                      isLeader ? 'text-amber-700' : 'text-blue-700'
                                    }`}>Move to:</span>
                                    <select
                                      value={m.teamName || ''}
                                      onChange={(e) => handleMoveStudent(m.id, e.target.value || null)}
                                      className="flex-1 text-[10px] bg-white border border-neutral-200 hover:border-neutral-350 rounded-lg px-2 py-1.5 focus:outline-none focus:ring-1 focus:ring-blue-500 font-bold text-neutral-700 cursor-pointer shadow-sm transition"
                                    >
                                      <option value="">-- Unassigned --</option>
                                      {leaderboard.map((t) => (
                                        <option key={t.teamName} value={t.teamName}>{t.teamName}</option>
                                      ))}
                                    </select>
                                  </div>
                                </div>
                              )
                            })}
                          </div>
                        )}
                      </div>
                    </div>
                  )
                })}
              </div>
            )}

            {/* SUBTAB: Add / Remove Teams */}
            {teamsSubTab === 'manage-teams' && (
              <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
                
                <div className="lg:col-span-5 bg-white border border-neutral-200 rounded-2xl p-6 shadow-md">
                  <div className="mb-5">
                    <h4 className="font-display font-black text-foreground text-base">Create New Team</h4>
                    <p className="text-xs text-muted mt-0.5">Add a new team to the registry and leaderboard.</p>
                  </div>
                  <form onSubmit={handleAddTeam} className="space-y-4">
                    <div>
                      <label className="block text-xs font-bold text-muted uppercase tracking-wider mb-1.5">
                        Team Name
                      </label>
                      <input
                        type="text"
                        required
                        placeholder="e.g. Transformer"
                        value={newTeamName}
                        onChange={(e) => setNewTeamName(e.target.value)}
                        className="w-full bg-white border border-neutral-200 rounded-xl py-2.5 px-3 text-sm placeholder-neutral-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    </div>
                    <button
                      type="submit"
                      className="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-black transition flex items-center justify-center gap-2 cursor-pointer shadow-sm"
                    >
                      <Plus className="w-4 h-4" /> Add Team
                    </button>
                  </form>
                </div>

                <div className="lg:col-span-7 bg-white border border-neutral-200 rounded-2xl p-6 shadow-md">
                  <div className="flex items-center justify-between mb-5">
                    <div>
                      <h4 className="font-display font-black text-foreground text-base">Teams Registry</h4>
                      <p className="text-xs text-muted mt-0.5">{leaderboard.length} teams registered</p>
                    </div>
                  </div>
                  <div className="grid grid-cols-2 gap-2.5 max-h-96 overflow-y-auto pr-1">
                    {leaderboard.map((t) => {
                      const memberCount = studentsList.filter(
                        (s) => s.teamName?.toLowerCase() === t.teamName.toLowerCase()
                      ).length
                      return (
                        <div
                          key={t.teamName}
                          className="p-3 bg-neutral-50 border border-neutral-200 rounded-xl flex items-center justify-between gap-2 group hover:border-red-200 hover:bg-red-50/30 transition"
                        >
                          <div className="flex items-center gap-2 min-w-0">
                            <span className="text-xs font-bold text-foreground truncate">{t.teamName}</span>
                            <span className={`text-[9px] font-black px-1.5 py-0.5 rounded-full flex-shrink-0 ${
                              memberCount > 0 ? 'bg-blue-50 text-blue-600' : 'bg-neutral-100 text-neutral-400'
                            }`}>
                              {memberCount}
                            </span>
                          </div>
                          <button
                            onClick={() => handleRemoveTeam(t.teamName)}
                            className="p-1.5 text-neutral-400 group-hover:text-red-600 hover:bg-red-100 rounded-lg transition cursor-pointer flex-shrink-0"
                            title="Remove Team"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      )
                    })}
                  </div>
                </div>

              </div>
            )}

            {/* SUBTAB: Transfer Student */}
            {teamsSubTab === 'transfer-student' && (
              <div className="max-w-2xl mx-auto">
                <div className="bg-white border border-neutral-200 rounded-2xl p-8 shadow-md">
                  <div className="mb-6">
                    <h4 className="font-display font-black text-lg text-foreground">Search & Assign Member</h4>
                    <p className="text-xs text-muted mt-1">Search by name or email, then assign or transfer to any team.</p>
                  </div>

                  <div className="space-y-6">
                    {/* Step 1: Destination team — collapsible dropdown */}
                    <div className="relative">
                      <label className="block text-xs font-bold text-muted uppercase tracking-wider mb-2">
                        1. Select Destination Team
                      </label>

                      {/* Trigger button */}
                      <button
                        type="button"
                        onClick={() => setTeamDropdownOpen(!teamDropdownOpen)}
                        className={`w-full flex items-center justify-between px-4 py-3 border rounded-xl text-sm font-semibold transition cursor-pointer ${
                          selectedDestinationTeam
                            ? 'bg-blue-600 text-white border-blue-600'
                            : 'bg-white text-neutral-500 border-neutral-200 hover:border-neutral-300'
                        }`}
                      >
                        <span>
                          {selectedDestinationTeam
                            ? (() => {
                                const mc = studentsList.filter(
                                  (s) => s.teamName?.toLowerCase() === selectedDestinationTeam.toLowerCase()
                                ).length
                                return `${selectedDestinationTeam}  ·  ${mc} member${mc !== 1 ? 's' : ''}`
                              })()
                            : 'Choose a team...'}
                        </span>
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          className={`w-4 h-4 flex-shrink-0 transition-transform duration-200 ${teamDropdownOpen ? 'rotate-180' : ''}`}
                          fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}
                        >
                          <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
                        </svg>
                      </button>

                      {/* Dropdown panel */}
                      {teamDropdownOpen && (
                        <div className="absolute top-full left-0 right-0 mt-1.5 bg-white border border-neutral-200 rounded-xl shadow-lg z-20 overflow-hidden">
                          <div className="max-h-52 overflow-y-auto divide-y divide-neutral-100">
                            {leaderboard.map((t) => {
                              const mc = studentsList.filter(
                                (s) => s.teamName?.toLowerCase() === t.teamName.toLowerCase()
                              ).length
                              return (
                                <button
                                  key={t.teamName}
                                  type="button"
                                  onClick={() => {
                                    setSelectedDestinationTeam(t.teamName)
                                    setTeamDropdownOpen(false)
                                  }}
                                  className={`w-full text-left px-4 py-2.5 text-sm font-semibold transition cursor-pointer flex items-center justify-between gap-2 ${
                                    selectedDestinationTeam === t.teamName
                                      ? 'bg-blue-50 text-blue-700'
                                      : 'text-foreground hover:bg-neutral-50'
                                  }`}
                                >
                                  <span className="truncate">{t.teamName}</span>
                                  <div className="flex items-center gap-2 flex-shrink-0">
                                    <span className={`text-[9px] font-black px-1.5 py-0.5 rounded-full ${
                                      selectedDestinationTeam === t.teamName
                                        ? 'bg-blue-100 text-blue-600'
                                        : mc > 0 ? 'bg-neutral-100 text-neutral-500' : 'bg-neutral-50 text-neutral-400'
                                    }`}>
                                      {mc} {mc === 1 ? 'member' : 'members'}
                                    </span>
                                    {selectedDestinationTeam === t.teamName && (
                                      <svg xmlns="http://www.w3.org/2000/svg" className="w-3.5 h-3.5 text-blue-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={3}>
                                        <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                                      </svg>
                                    )}
                                  </div>
                                </button>
                              )
                            })}
                          </div>
                          {selectedDestinationTeam && (
                            <div className="border-t border-neutral-100 px-4 py-2 bg-neutral-50 flex justify-end">
                              <button
                                type="button"
                                onClick={() => { setSelectedDestinationTeam(''); setTeamDropdownOpen(false) }}
                                className="text-[10px] text-red-500 hover:text-red-700 font-bold cursor-pointer"
                              >
                                Clear selection
                              </button>
                            </div>
                          )}
                        </div>
                      )}
                    </div>

                    {/* Step 2: Search */}
                    <div>
                      <label className="block text-xs font-bold text-muted uppercase tracking-wider mb-2">
                        2. Search Student Profile
                      </label>
                      <form onSubmit={handleSearchStudents} className="flex gap-2">
                        <div className="relative flex-grow">
                          <input
                            type="text"
                            required
                            placeholder="Search by full name or email..."
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            className="w-full bg-white border border-neutral-200 rounded-xl py-2.5 pl-10 pr-4 text-sm placeholder-neutral-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                          <Search className="w-4 h-4 text-muted absolute left-3.5 top-3" />
                        </div>
                        <button
                          type="submit"
                          className="px-5 py-2.5 bg-foreground hover:opacity-90 text-btn-text-light rounded-xl text-xs font-black shadow-btn-inset cursor-pointer transition"
                        >
                          Search
                        </button>
                      </form>
                    </div>

                    {/* Results */}
                    <div className="border-t border-neutral-100 pt-5">
                      <h5 className="text-xs font-bold text-muted uppercase tracking-wider mb-4">Search Results</h5>
                      
                      {searchedStudents.length === 0 ? (
                        <div className="text-center py-10 bg-white rounded-2xl border border-dashed border-neutral-200">
                          <Search className="w-7 h-7 text-neutral-300 mx-auto mb-2" />
                          <p className="text-xs text-muted font-bold">No matching students found</p>
                          <p className="text-[10px] text-muted/60 mt-0.5">Try searching by full name or email</p>
                        </div>
                      ) : (
                        <div className="space-y-3">
                          {searchedStudents.map((s) => {
                            const isInSelectedTeam = s.teamName?.toLowerCase() === selectedDestinationTeam.toLowerCase()
                            const isLeader = s.isLeader || false
                            const hasTeam = !!s.teamName
                            return (
                              <div
                                key={s.id}
                                className={`rounded-2xl border overflow-hidden transition ${
                                  isInSelectedTeam ? 'border-emerald-200' : 'border-neutral-200'
                                }`}
                              >
                                {/* Top color bar */}
                                <div className={`h-1 w-full ${
                                  isInSelectedTeam ? 'bg-emerald-500' : 'bg-blue-500'
                                }`} />
                                <div className={`px-4 py-3.5 flex justify-between items-center gap-4 ${
                                  isInSelectedTeam ? 'bg-emerald-50/50' : 'bg-white'
                                }`}>
                                  <div>
                                    <p className="text-sm font-extrabold text-foreground">{s.fullName || 'Registered Student'}</p>
                                    <p className="text-[11px] text-muted mt-0.5">{s.email}</p>
                                    <div className="flex items-center gap-1.5 mt-1.5">
                                      <span className="text-[9px] font-black text-muted uppercase tracking-wider">Current Team:</span>
                                      <span className={`text-[10px] font-black px-2 py-0.5 rounded-full ${
                                        isInSelectedTeam
                                          ? 'bg-emerald-100 text-emerald-700'
                                          : s.teamName
                                          ? 'bg-neutral-100 text-neutral-700'
                                          : 'bg-red-50 text-red-500'
                                      }`}>
                                        {s.teamName || 'Unassigned'}
                                      </span>
                                      {hasTeam && (
                                        <span className={`text-[10px] font-black px-2 py-0.5 rounded-full flex items-center gap-1 ${
                                          isLeader ? 'bg-amber-100 text-amber-700' : 'bg-neutral-100 text-neutral-400'
                                        }`}>
                                          {isLeader && <Shield className="w-2.5 h-2.5 fill-amber-500 text-amber-500" />}
                                          <span>{isLeader ? 'Leader' : 'Regular Member'}</span>
                                        </span>
                                      )}
                                    </div>
                                  </div>

                                  <div className="flex items-center gap-2 flex-shrink-0">
                                    {hasTeam && (
                                      <button
                                        onClick={() => isLeader ? handleRemoveLeader(s.id) : handleAssignLeader(s.id, s.teamName || '')}
                                        disabled={assigningLeaders[s.id]}
                                        className={`px-3 py-2.5 rounded-xl font-black text-xs transition cursor-pointer ${
                                          assigningLeaders[s.id]
                                            ? 'bg-neutral-100 text-neutral-400 cursor-wait'
                                            : isLeader
                                            ? 'bg-amber-100 hover:bg-amber-200 text-amber-800'
                                            : 'bg-neutral-100 hover:bg-neutral-200 text-neutral-700 border border-neutral-200/50'
                                        }`}
                                      >
                                        {assigningLeaders[s.id] ? 'Updating...' : isLeader ? 'Remove Leader' : 'Make Leader'}
                                      </button>
                                    )}
                                    <button
                                      onClick={() => handleMoveStudent(s.id, selectedDestinationTeam || null)}
                                      disabled={!selectedDestinationTeam || isInSelectedTeam}
                                      className={`px-4 py-2.5 rounded-xl font-black text-xs transition cursor-pointer ${
                                        !selectedDestinationTeam
                                          ? 'bg-neutral-100 text-neutral-400 cursor-not-allowed'
                                          : isInSelectedTeam
                                          ? 'bg-emerald-100 text-emerald-700 border border-emerald-200 cursor-default'
                                          : 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm'
                                      }`}
                                    >
                                      {isInSelectedTeam ? '✓ Added' : s.teamName ? 'Transfer →' : 'Add to Team'}
                                    </button>
                                  </div>
                                </div>
                              </div>
                            )
                          })}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>
            )}

          </div>
        )}

        {/* TAB 4: TEAM FORMATION & BULK ASSIGNMENTS */}
        {activeTab === 'team-formation' && (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            
            <div className="lg:col-span-7 space-y-4">
              <div className="flex justify-between items-center">
                <div>
                  <h3 className="font-display font-black text-foreground">Registered Students</h3>
                  <p className="text-xs text-muted mt-0.5">{studentsList.length} students signed up</p>
                </div>
                <button
                  onClick={handleDownloadJson}
                  className="flex items-center gap-1.5 px-3 py-2 bg-white border border-neutral-200 hover:bg-neutral-50 text-foreground text-xs font-bold rounded-xl shadow-sm cursor-pointer transition"
                >
                  <Download className="w-3.5 h-3.5" /> Download Survey JSON
                </button>
              </div>

              <div className="bg-white border border-neutral-200 rounded-2xl shadow-md max-h-[520px] overflow-y-auto">
                {studentsList.length === 0 ? (
                  <div className="text-center py-16">
                    <Users className="w-10 h-10 text-neutral-300 mx-auto mb-2" />
                    <p className="text-sm font-bold text-muted">No students registered yet</p>
                  </div>
                ) : (
                  <div className="divide-y divide-neutral-100">
                    {studentsList.map((s, idx) => (
                      <div key={s.id} className="px-5 py-3.5 flex justify-between items-center hover:bg-neutral-50/60 transition">
                        <div className="flex items-center gap-3">
                          <span className="text-[10px] font-black text-neutral-400 w-6 text-right flex-shrink-0">#{idx + 1}</span>
                          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-blue-400 to-indigo-500 flex items-center justify-center text-white text-[10px] font-black flex-shrink-0">
                            {(s.fullName || 'S').charAt(0).toUpperCase()}
                          </div>
                          <div>
                            <p className="text-xs font-bold text-foreground">{s.fullName || 'Registered Student'}</p>
                            <p className="text-[10px] text-muted">{s.email}</p>
                          </div>
                        </div>
                        <span className={`text-[9px] font-black px-2.5 py-1 rounded-full flex-shrink-0 ${
                          s.teamName ? 'bg-blue-50 text-blue-700 border border-blue-200' : 'bg-red-50 text-red-600 border border-red-200'
                        }`}>
                          {s.teamName ? s.teamName : 'Unassigned'}
                        </span>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>

            <div className="lg:col-span-5 space-y-4">
              <div>
                <h3 className="font-display font-black text-foreground">Bulk Assignment</h3>
                <p className="text-xs text-muted mt-0.5">Paste JSON to assign multiple students at once.</p>
              </div>
              
              <div className="bg-white border border-neutral-200 rounded-2xl p-6 shadow-md">
                {bulkErrorMsg && (
                  <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 text-xs rounded-xl flex items-start gap-2">
                    <AlertCircle className="w-4 h-4 text-red-600 flex-shrink-0 mt-0.5" />
                    <span>{bulkErrorMsg}</span>
                  </div>
                )}

                {bulkSuccessMsg && (
                  <div className="mb-4 p-3 bg-green-50 border border-green-200 text-green-700 text-xs rounded-xl flex items-start gap-2">
                    <CheckCircle2 className="w-4 h-4 text-green-600 flex-shrink-0 mt-0.5" />
                    <span>{bulkSuccessMsg}</span>
                  </div>
                )}

                <div className="space-y-4">
                  <div>
                    <label className="block text-[10px] font-bold text-muted uppercase tracking-wider mb-2">
                      JSON Format: Array of {'{'}email, team{'}'}
                    </label>
                    <textarea
                      rows={10}
                      value={bulkAssignmentsJson}
                      onChange={(e) => setBulkAssignmentsJson(e.target.value)}
                      placeholder={JSON.stringify(
                        [
                          { email: 'student1@gla.ac.in', team: 'Transformer' },
                          { email: 'student2@gla.ac.in', team: 'CNN' }
                        ],
                        null,
                        2
                      )}
                      className="w-full bg-neutral-50 border border-neutral-200 rounded-xl p-3 text-xs font-mono text-neutral-700 placeholder-neutral-400 focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none"
                    />
                  </div>

                  <button
                    onClick={handleApplyBulkAssignments}
                    disabled={isApplyingBulk || !bulkAssignmentsJson.trim()}
                    className={`w-full py-3 rounded-xl text-sm font-black transition flex items-center justify-center gap-2 cursor-pointer ${
                      isApplyingBulk || !bulkAssignmentsJson.trim()
                        ? 'bg-neutral-100 text-neutral-400 border border-neutral-200 cursor-not-allowed'
                        : 'bg-foreground hover:opacity-90 text-btn-text-light shadow-btn-inset'
                    }`}
                  >
                    {isApplyingBulk ? <RefreshCw className="w-4 h-4 animate-spin" /> : <Upload className="w-4 h-4" />}
                    {isApplyingBulk ? 'Applying...' : 'Apply Mappings'}
                  </button>
                </div>
              </div>
            </div>

          </div>
        )}

        {/* TAB 5: UPLOADED IMAGES */}
        {activeTab === 'uploads' && (
          <div className="space-y-6">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="font-display font-black text-foreground text-lg">Uploaded Images</h2>
                <p className="text-xs text-muted mt-0.5">
                  {teamUploads.length > 0
                    ? `${teamUploads.length} team${teamUploads.length === 1 ? '' : 's'} submitted — ranked by upload time`
                    : 'No images uploaded yet'}
                </p>
              </div>
              <button
                onClick={refreshState}
                className="flex items-center gap-1.5 px-3 py-2 bg-white border border-neutral-200 rounded-xl text-xs font-bold hover:bg-neutral-50 transition cursor-pointer"
              >
                <RefreshCw className="w-3.5 h-3.5" /> Refresh
              </button>
            </div>

            {teamUploads.length === 0 ? (
              <div className="bg-white border border-dashed border-neutral-300 rounded-2xl py-20 text-center">
                <ImageIcon className="w-12 h-12 text-neutral-300 mx-auto mb-3" />
                <p className="text-sm font-bold text-muted">No images uploaded yet</p>
                <p className="text-xs text-muted/70 mt-1">Teams will appear here once they submit their prompt images</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-5">
                {teamUploads.map((upload) => (
                  <div
                    key={upload.teamName}
                    className="group bg-white border border-neutral-200 rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition cursor-pointer"
                    onClick={() => setLightboxImage({ url: upload.imageUrl, teamName: upload.teamName })}
                  >
                    {/* Rank badge */}
                    <div className="relative">
                      <div className="aspect-video bg-neutral-100 overflow-hidden">
                        <img
                          src={upload.imageUrl}
                          alt={`${upload.teamName} submission`}
                          className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                        />
                      </div>
                      <div className={`absolute top-2 left-2 w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black shadow-md ${
                        upload.rank === 1
                          ? 'bg-yellow-400 text-yellow-900'
                          : upload.rank === 2
                          ? 'bg-neutral-300 text-neutral-700'
                          : upload.rank === 3
                          ? 'bg-orange-400 text-orange-900'
                          : 'bg-white text-neutral-600 border border-neutral-200'
                      }`}>
                        #{upload.rank}
                      </div>
                      {/* Expand icon on hover */}
                      <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition flex items-center justify-center">
                        <div className="opacity-0 group-hover:opacity-100 transition bg-white/90 rounded-full p-2">
                          <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4 text-neutral-800" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                            <path strokeLinecap="round" strokeLinejoin="round" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4" />
                          </svg>
                        </div>
                      </div>
                    </div>

                    {/* Card footer */}
                    <div className="px-4 py-3">
                      <p className="text-xs font-extrabold text-foreground truncate">{upload.teamName}</p>
                      <p className="text-[10px] text-muted mt-0.5">
                        {new Date(upload.uploadedAt).toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit' })}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

      </main>

      {/* Fullscreen Lightbox */}
      {lightboxImage && (
        <div
          className="fixed inset-0 z-[100] bg-black/90 flex flex-col items-center justify-center p-4"
          onClick={() => setLightboxImage(null)}
        >
          {/* Header bar */}
          <div
            className="w-full max-w-5xl flex items-center justify-between mb-3 px-1"
            onClick={(e) => e.stopPropagation()}
          >
            <div>
              <p className="text-white font-extrabold text-lg">{lightboxImage.teamName}</p>
              <p className="text-white/60 text-xs mt-0.5">Click anywhere outside or press ✕ to close</p>
            </div>
            <button
              onClick={() => setLightboxImage(null)}
              className="w-9 h-9 bg-white/10 hover:bg-white/20 border border-white/20 rounded-full flex items-center justify-center text-white transition cursor-pointer"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          {/* Image */}
          <div
            className="w-full max-w-5xl max-h-[80vh] flex items-center justify-center"
            onClick={(e) => e.stopPropagation()}
          >
            <img
              src={lightboxImage.url}
              alt={lightboxImage.teamName}
              className="max-w-full max-h-[80vh] rounded-2xl shadow-2xl object-contain"
            />
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="py-5 border-t border-neutral-200 text-center text-xs text-muted bg-white">
        © {new Date().getFullYear()} GLA University. BCA Orientation Admin Console.
      </footer>
    </div>
  )
}
