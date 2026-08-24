import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'
import { isNetworkError } from './networkError'

export async function updateSession(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) =>
            request.cookies.set(name, value)
          )
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  let user = null
  let profile = null
  let isNetError = false

  try {
    const {
      data: { user: fetchedUser },
      error: authError,
    } = await supabase.auth.getUser()

    if (authError && isNetworkError(authError)) {
      isNetError = true
    } else if (fetchedUser) {
      user = fetchedUser
      const { data: fetchedProfile } = await supabase
        .from('profiles')
        .select('sethji')
        .eq('id', user.id)
        .single()
      profile = fetchedProfile
    }
  } catch (err) {
    if (isNetworkError(err)) {
      isNetError = true
    }
  }

  if (isNetError) {
    return supabaseResponse
  }

  const isAuthPage = request.nextUrl.pathname.startsWith('/login')

  // Unauthenticated users -> Redirect to login
  if (!user && !isAuthPage) {
    const url = request.nextUrl.clone()
    url.pathname = '/login'
    return NextResponse.redirect(url)
  }

  // Authenticated admin users -> Redirect away from login to dashboard
  if (user && isAuthPage) {
    const url = request.nextUrl.clone()
    url.pathname = '/dashboard'
    return NextResponse.redirect(url)
  }

  // Authenticated non-admin users -> Block access
  if (user && !isAuthPage) {
    const isAdmin = profile?.sethji || false
    if (!isAdmin) {
      // Direct unauthorized user to standard access denied layout
      return new NextResponse('Access Forbidden: Admin credentials required.', { status: 403 })
    }
  }

  return supabaseResponse
}
