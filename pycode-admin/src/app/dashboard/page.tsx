'use client'

import React, { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { ShieldAlert, CheckCircle, XCircle, LogOut, Eye, FileText, Image as ImageIcon, AlertCircle, Sun, Moon } from 'lucide-react'

export default function AdminDashboardPage() {
  const router = useRouter()
  const supabase = createClient() as any

  const [applications, setApplications] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [theme, setTheme] = useState<'dark' | 'light'>('dark')

  useEffect(() => {
    const isLight = !document.documentElement.classList.contains('dark')
    setTheme(isLight ? 'light' : 'dark')
  }, [])

  const toggleTheme = () => {
    if (theme === 'dark') {
      document.documentElement.classList.remove('dark')
      localStorage.setItem('theme', 'light')
      setTheme('light')
    } else {
      document.documentElement.classList.add('dark')
      localStorage.setItem('theme', 'dark')
      setTheme('dark')
    }
  }

  // Modals / Inputs
  const [selectedApp, setSelectedApp] = useState<any>(null)
  const [rejectionNotes, setRejectionNotes] = useState('')
  const [showRejectForm, setShowRejectForm] = useState(false)
  const [processingId, setProcessingId] = useState<string | null>(null)

  const loadApplications = async () => {
    setLoading(true)
    try {
      const { data, error } = await supabase
        .from('teacher_applications')
        .select('*')
        .eq('status', 'pending')
        .order('created_at', { ascending: true })

      if (!error && data) {
        setApplications(data)
      }
    } catch (err) {
      console.error("Failed to load applications:", err)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    loadApplications()
  }, [])

  const handleLogout = async () => {
    await supabase.auth.signOut()
    router.push('/login')
  }

  // Deletes the ID image from storage bucket to maintain student data privacy
  const cleanupStorageFile = async (url: string) => {
    try {
      // Extract file path from public URL
      // E.g. https://.../storage/v1/object/public/teacher-ids/ids/filename.png
      if (url.includes('/teacher-ids/')) {
        const parts = url.split('/teacher-ids/')
        const filePath = parts[1]
        if (filePath) {
          const { error } = await supabase.storage
            .from('teacher-ids')
            .remove([filePath])
          
          if (error) {
            console.error("Failed to delete storage file:", error.message)
          }
        }
      }
    } catch (err) {
      console.error("Error during storage file deletion:", err)
    }
  }

  const handleApprove = async (app: any) => {
    if (!confirm(`Are you sure you want to APPROVE ${app.full_name}?`)) return

    setProcessingId(app.user_id)

    try {
      // Call server-side API that uses service role key to bypass RLS
      const res = await fetch('/api/applications/approve', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id: app.user_id, id_card_url: app.id_card_url })
      })

      const result = await res.json()
      if (!res.ok) throw new Error(result.error || 'Approval failed')

      // Reload applications list
      await loadApplications()
    } catch (err: any) {
      alert(`Approval failed: ${err.message}`)
    } finally {
      setProcessingId(null)
    }
  }

  const handleReject = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!selectedApp) return

    setProcessingId(selectedApp.user_id)

    try {
      // 1. Update application status with rejection notes
      const { error: appErr } = await supabase
        .from('teacher_applications')
        .update({
          status: 'rejected',
          rejection_notes: rejectionNotes.trim()
        })
        .eq('user_id', selectedApp.user_id)

      if (appErr) throw appErr

      // 2. Remove uploaded ID document
      if (selectedApp.id_card_url) {
        await cleanupStorageFile(selectedApp.id_card_url)
      }

      // Reset modals
      setSelectedApp(null)
      setShowRejectForm(false)
      setRejectionNotes('')

      // Reload applications list
      await loadApplications()
    } catch (err: any) {
      alert(`Rejection failed: ${err.message}`)
    } finally {
      setProcessingId(null)
    }
  }

  return (
    <div className="min-h-screen bg-canvas text-ink font-sans flex flex-col select-none">
      {/* Header bar */}
      <header className="h-16 border-b border-hairline bg-canvas px-8 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-xl bg-primary flex items-center justify-center text-on-primary">
            <ShieldAlert className="w-4 h-4" />
          </div>
          <span className="font-extrabold text-sm tracking-tight text-ink">PyCode Admin Console</span>
        </div>

        <div className="flex items-center gap-3">
          <button
            onClick={toggleTheme}
            className="p-2 rounded-full border border-hairline bg-canvas hover:bg-surface-soft text-gray-500 hover:text-ink cursor-pointer transition-colors"
            title="Toggle Theme"
          >
            {theme === 'dark' ? <Sun className="w-4 h-4" /> : <Moon className="w-4 h-4" />}
          </button>

          <button
            onClick={handleLogout}
            className="px-4 py-2 rounded-full border border-hairline bg-canvas text-xs font-bold text-ink cursor-pointer hover:bg-surface-soft transition-colors flex items-center gap-1.5"
          >
            <LogOut className="w-3.5 h-3.5 text-gray-500" />
            Sign Out
          </button>
        </div>
      </header>

      {/* Main Grid */}
      <main className="flex-1 p-8 max-w-6xl w-full mx-auto space-y-6">
        <div>
          <h1 className="text-2xl font-extrabold tracking-tight text-ink">Pending Teacher Approvals</h1>
          <p className="text-gray-500 text-xs mt-1 font-light">Inspect institutional ID documents and grant verified teacher privileges</p>
        </div>

        {/* Selected ID View Popup Modal */}
        {selectedApp && !showRejectForm && (
          <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="max-w-lg w-full bg-canvas border border-hairline rounded-3xl p-6 relative shadow-[0_4px_16px_rgba(0,0,0,0.06)] animate-scale-in text-ink">
              <button
                onClick={() => setSelectedApp(null)}
                className="absolute top-5 right-5 text-gray-400 hover:text-ink p-1 rounded-lg hover:bg-surface-soft"
              >
                <XCircle className="w-5 h-5" />
              </button>

              <h3 className="text-sm font-bold text-ink mb-4 flex items-center gap-2">
                <ImageIcon className="w-4 h-4 text-primary" />
                Teacher ID Card View
              </h3>

              <div className="bg-block-navy border border-white/10 rounded-2xl overflow-hidden p-2 mb-6">
                <img
                  src={selectedApp.id_card_url}
                  alt="Teacher ID document"
                  className="max-h-[300px] w-full object-contain rounded-lg"
                />
              </div>

              <div className="flex gap-3 justify-end">
                <button
                  onClick={() => setShowRejectForm(true)}
                  className="px-5 py-2.5 rounded-full bg-block-pink border border-red-200 text-red-800 hover:opacity-90 text-xs font-bold cursor-pointer transition-colors"
                >
                  Reject Application
                </button>
                <button
                  onClick={() => {
                    const target = selectedApp
                    setSelectedApp(null)
                    handleApprove(target)
                  }}
                  className="px-5 py-2.5 rounded-full bg-block-mint border border-emerald-250 text-emerald-800 hover:opacity-90 text-xs font-bold cursor-pointer transition-colors"
                >
                  Approve Application
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Rejection Notes Form Dialog Modal */}
        {showRejectForm && selectedApp && (
          <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="max-w-md w-full bg-canvas border border-hairline rounded-3xl p-6 relative shadow-[0_4px_16px_rgba(0,0,0,0.06)] animate-scale-in text-ink">
              <button
                onClick={() => {
                  setShowRejectForm(false)
                  setSelectedApp(null)
                }}
                className="absolute top-5 right-5 text-gray-400 hover:text-ink p-1 rounded-lg hover:bg-surface-soft"
              >
                <XCircle className="w-5 h-5" />
              </button>

              <h3 className="text-sm font-bold text-ink mb-4 flex items-center gap-2">
                <FileText className="w-4 h-4 text-red-650" />
                Reason for Rejection
              </h3>

              <form onSubmit={handleReject} className="space-y-4">
                <div>
                  <label className="block text-[10px] font-semibold text-gray-400 mb-1.5 uppercase tracking-wider font-mono">Provide notes to student</label>
                  <textarea
                    value={rejectionNotes}
                    onChange={(e) => setRejectionNotes(e.target.value)}
                    placeholder="The uploaded image is blurry and text is unreadable. Please upload a clear photo of your ID card."
                    rows={4}
                    className="w-full px-3 py-2 bg-canvas border border-hairline rounded-xl text-xs placeholder-gray-400 focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary text-ink resize-none font-light"
                    required
                  />
                </div>

                <div className="flex gap-3 justify-end">
                  <button
                    type="button"
                    onClick={() => setShowRejectForm(false)}
                    className="px-5 py-2.5 rounded-full bg-surface-soft border border-hairline text-gray-500 hover:text-ink text-xs font-bold cursor-pointer"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2.5 rounded-full bg-red-650 hover:bg-red-700 text-white text-xs font-bold cursor-pointer"
                  >
                    Confirm Rejection
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Pending list table */}
        <div className="border border-hairline bg-canvas rounded-3xl overflow-hidden shadow-[0_4px_16px_rgba(0,0,0,0.06)]">
          {loading ? (
            <div className="py-20 text-center flex flex-col items-center justify-center gap-3 text-gray-500">
              <div className="w-8 h-8 border-4 border-t-primary border-r-transparent border-b-transparent border-l-transparent rounded-full animate-spin"></div>
              <p className="text-xs font-light">Fetching pending records...</p>
            </div>
          ) : applications.length === 0 ? (
            <div className="py-20 text-center text-gray-500">
              <CheckCircle className="w-12 h-12 mx-auto mb-3 text-emerald-500/20" />
              <p className="text-sm font-bold text-ink">All caught up!</p>
              <p className="text-xs text-gray-500 mt-1 font-light">No teacher verification requests are pending review.</p>
            </div>
          ) : (
            <div className="overflow-x-auto text-xs">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="bg-surface-soft text-gray-500 border-b border-hairline font-mono text-[9px] uppercase tracking-wider font-semibold">
                    <th className="px-6 py-4">Name</th>
                    <th className="px-6 py-4">Institution</th>
                    <th className="px-6 py-4">ID Card</th>
                    <th className="px-6 py-4 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-hairline">
                  {applications.map((app) => {
                    const isProcessing = processingId === app.user_id
                    return (
                      <tr key={app.user_id} className="hover:bg-surface-soft transition-colors">
                        <td className="px-6 py-4 font-bold text-ink">
                          {app.full_name}
                        </td>
                        <td className="px-6 py-4 text-gray-500 font-light">
                          {app.institution}
                        </td>
                        <td className="px-6 py-4">
                          <button
                            onClick={() => setSelectedApp(app)}
                            className="text-primary hover:underline flex items-center gap-1 cursor-pointer font-semibold"
                          >
                            <Eye className="w-3.5 h-3.5" />
                            Inspect Image
                          </button>
                        </td>
                        <td className="px-6 py-4 text-right space-x-3">
                          <button
                            onClick={() => {
                              setSelectedApp(app)
                              setShowRejectForm(true)
                            }}
                            disabled={isProcessing}
                            className="px-3.5 py-1.5 rounded-full bg-block-pink border border-red-200 text-red-800 hover:opacity-90 text-xs font-bold cursor-pointer disabled:opacity-50"
                          >
                            Reject
                          </button>

                          <button
                            onClick={() => handleApprove(app)}
                            disabled={isProcessing}
                            className="px-3.5 py-1.5 rounded-full bg-block-mint border border-emerald-250 text-emerald-800 hover:opacity-90 text-xs font-bold cursor-pointer disabled:opacity-50"
                          >
                            Approve
                          </button>
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </main>
    </div>
  )
}
