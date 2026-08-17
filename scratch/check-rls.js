const fs = require('fs')
const path = require('path')
const { createClient } = require('@supabase/supabase-js')

// Parse .env manually
try {
  const envContent = fs.readFileSync(path.join(__dirname, '../.env'), 'utf8')
  envContent.split('\n').forEach(line => {
    const trimmed = line.trim()
    if (!trimmed || trimmed.startsWith('#')) return
    const firstEq = trimmed.indexOf('=')
    if (firstEq === -1) return
    const key = trimmed.slice(0, firstEq).trim()
    let val = trimmed.slice(firstEq + 1).trim()
    if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'"))) {
      val = val.slice(1, -1)
    }
    process.env[key] = val
  })
} catch (e) {
  console.log('Error reading .env file:', e.message)
}

async function main() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY

  if (!url || !key) {
    console.error('Missing env vars')
    process.exit(1)
  }

  const supabase = createClient(url, key)

  console.log('Checking tables RLS policies...')
  try {
    const { data: policies, error } = await supabase.rpc('get_policies') // wait, RPC might not exist
    if (error) {
      // If RPC doesn't exist, select directly using sql
      console.log('Direct query pg_policies...')
      const { data, error: sqlErr } = await supabase.from('profiles').select('id').limit(1) // dummy
      console.log('Dummy select status:', sqlErr ? sqlErr.message : 'OK')
      
      // Let's run raw SQL query via postgrest if we can or check RLS on tables:
      // Actually we can just run a query using service role key to inspect pg_tables.
      // But we can check if select works using the anon key!
      console.log('Testing select using ANON key...')
      const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
      const anonClient = createClient(url, anonKey)
      
      const t1 = await anonClient.from('buzzer_state').select('*').limit(1)
      console.log('buzzer_state select:', t1.error ? t1.error.message : 'SUCCESS: ' + JSON.stringify(t1.data))
      
      const t2 = await anonClient.from('buzzer_ranks').select('*').limit(1)
      console.log('buzzer_ranks select:', t2.error ? t2.error.message : 'SUCCESS: ' + JSON.stringify(t2.data))

      const t3 = await anonClient.from('team_uploads').select('*').limit(1)
      console.log('team_uploads select:', t3.error ? t3.error.message : 'SUCCESS: ' + JSON.stringify(t3.data))
    }
  } catch (err) {
    console.error('Diagnostic failed:', err)
  }
}

main()
