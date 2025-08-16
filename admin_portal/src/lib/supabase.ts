import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseServiceKey = import.meta.env.VITE_SUPABASE_SERVICE_KEY
const key = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error('Missing Supabase environment variables for admin client')
}

export const supabaseAdmin = createClient(supabaseUrl, key, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})