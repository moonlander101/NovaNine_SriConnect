import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const key = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl) {
  throw new Error('Missing Supabase environment variables')
}

export const supabaseAdmin = createClient(supabaseUrl, key, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})