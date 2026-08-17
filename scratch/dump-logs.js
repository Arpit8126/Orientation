const fs = require('fs')
const path = require('path')
const { createClient } = require('@supabase/supabase-js')

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
} catch (e) {}

async function main() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY
  const supabase = createClient(url, key)
  
  const { data, error } = await supabase.from('buzzer_logs').select('*')
  console.log('--- buzzer_logs ---')
  console.log(JSON.stringify(data, null, 2))
}
main()
