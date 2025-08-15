// Idea is to not use this and just use the adminClient, then enforce access cntrl in handlers, kinda like regular backends. Ill keep this for later use if needed


import { createClient } from 'npm:@supabase/supabase-js@2'
import { supabase as adminClient } from "./supabaseAdmin.ts"

// Default client with anon key (respects RLS)
export const supabase = createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_ANON_KEY') ?? ''
)

export const createClientwithToken = (authToken?: string) => {
  const client = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    {
      auth: {
        autoRefreshToken: false,
        persistSession: false
      },
      global: {
        headers: authToken ? {
          Authorization: `Bearer ${authToken}`
        } : {}
      }
    }
  )
  
  return client
}

export const getUserFromToken = async (token: string) => {
  const client = adminClient
  const { data: { user }, error } = await client.auth.getUser(token)
  return { user, error }
}

// Helper function to extract JWT from request header  
export const extractUserToken = (req: { get?: (name: string) => string | undefined, headers?: { authorization?: string } }): string | null => {
  const authHeader = req.get?.('Authorization') || req.headers?.authorization
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return null
  }
  return authHeader.substring(7)
}

// Helper to get user role from database using auth mapping
export const getUserAppData = async (_token: string, authUserId: string) => {
  const client = adminClient

  const {data: authData, error: authError} = await client
    .from('user_auth')
    .select("user_id")
    .eq('auth_user_id', authUserId)
    .single()
  console.log(authData)
  
  if (authError || !authData) {
    console.error('Error fetching user mapping:', authError)
    console.error('Auth user ID:', authUserId)
    return { role: null, userId: null, fullName: null, error: authError }
  }

  // Then get the user details from app_user table
  const { data: userData, error: userError } = await client
    .from('app_user')
    .select('role, user_id, full_name')
    .eq('user_id', authData.user_id)
    .single()
  
  if (userError || !userData) {
    console.error('Error fetching user details:', userError)
    console.error('User ID:', authData.user_id)
    return { role: null, userId: null, fullName: null, error: userError }
  }
  
  console.log('Found user details:', userData)
  
  return { 
    role: userData.role, 
    userId: userData.user_id, 
    fullName: userData.full_name, 
    error: null 
  }
}