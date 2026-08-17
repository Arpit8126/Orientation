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
    // strip quotes
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
    console.error('Missing env vars. URL:', url, 'KEY:', key ? 'FOUND' : 'MISSING')
    process.exit(1)
  }

  const supabase = createClient(url, key)

  console.log('Testing listBuckets...')
  try {
    const { data: buckets, error } = await supabase.storage.listBuckets()
    if (error) throw error
    console.log('Buckets:', buckets)

    const exists = buckets?.some(b => b.name === 'prompt_images')
    if (!exists) {
      console.log('Creating prompt_images bucket...')
      const { data, error: createErr } = await supabase.storage.createBucket('prompt_images', {
        public: true
      })
      if (createErr) throw createErr
      console.log('Bucket created:', data)
    } else {
      console.log('Bucket prompt_images already exists.')
    }
  } catch (err) {
    console.error('Storage test failed:', err)
  }
}

main()
