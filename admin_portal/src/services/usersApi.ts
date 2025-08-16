import { supabaseAdmin } from '@/lib/supabase'
import type { AppUser, UserRole } from '@/types/database'

export interface CreateUserData {
  full_name: string
  nic_no: string
  email: string
  phone_no: string
  role: UserRole
}

export interface UpdateUserData {
  full_name?: string
  nic_no?: string
  email?: string
  phone_no?: string
  role?: UserRole
}

export const usersApi = {
  // Get all users
  async getAll(): Promise<AppUser[]> {
    try {
      console.log('🔍 UsersApi.getAll called...')
      
      const { data, error } = await supabaseAdmin
        .from('app_user')
        .select('*')
        .order('created_at', { ascending: false })

      if (error) {
        console.error('❌ Error fetching users:', error)
        console.error('❌ Error details:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        })
        throw new Error(error.message)
      }

      console.log('✅ Users query successful!')
      console.log('📊 Users found:', data?.length || 0)
      if (data && data.length > 0) {
        console.log('📋 Sample user:', data[0])
      }

      return data || []
    } catch (error) {
      console.error('❌ Users fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch users')
    }
  },

  // Get users by role
  async getByRole(role: UserRole): Promise<AppUser[]> {
    try {
      console.log('🔍 UsersApi.getByRole called with role:', role)
      
      const { data, error } = await supabaseAdmin
        .from('app_user')
        .select('*')
        .eq('role', role)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('❌ Error fetching users by role:', error)
        throw new Error(error.message)
      }

      console.log('✅ Users by role query successful!')
      console.log('📊 Users found:', data?.length || 0)

      return data || []
    } catch (error) {
      console.error('❌ Users by role fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch users by role')
    }
  },

  // Get user by ID
  async getById(id: number): Promise<AppUser | null> {
    try {
      const { data, error } = await supabaseAdmin
        .from('app_user')
        .select('*')
        .eq('user_id', id)
        .single()

      if (error) {
        if (error.code === 'PGRST116') {
          return null
        }
        console.error('❌ Error fetching user by ID:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('❌ User by ID fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch user')
    }
  },

  // Create a new user
  async create(userData: CreateUserData): Promise<AppUser> {
    try {
      console.log('🔍 UsersApi.create called with:', userData)
      
      const { data, error } = await supabaseAdmin
        .from('app_user')
        .insert(userData)
        .select()
        .single()

      if (error) {
        console.error('❌ Error creating user:', error)
        console.error('❌ Error details:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        })
        throw new Error(error.message)
      }

      console.log('✅ User created successfully:', data)
      return data
    } catch (error) {
      console.error('❌ User creation error:', error)
      throw error instanceof Error ? error : new Error('Failed to create user')
    }
  },

  // Update a user
  async update(id: number, updateData: UpdateUserData): Promise<AppUser> {
    try {
      console.log('🔍 UsersApi.update called with ID:', id, 'Data:', updateData)
      
      const { data, error } = await supabaseAdmin
        .from('app_user')
        .update(updateData)
        .eq('user_id', id)
        .select()
        .single()

      if (error) {
        console.error('❌ Error updating user:', error)
        throw new Error(error.message)
      }

      console.log('✅ User updated successfully:', data)
      return data
    } catch (error) {
      console.error('❌ User update error:', error)
      throw error instanceof Error ? error : new Error('Failed to update user')
    }
  },

  // Delete a user
  async delete(id: number): Promise<void> {
    try {
      console.log('🔍 UsersApi.delete called with ID:', id)
      
      const { error } = await supabaseAdmin
        .from('app_user')
        .delete()
        .eq('user_id', id)

      if (error) {
        console.error('❌ Error deleting user:', error)
        throw new Error(error.message)
      }

      console.log('✅ User deleted successfully')
    } catch (error) {
      console.error('❌ User deletion error:', error)
      throw error instanceof Error ? error : new Error('Failed to delete user')
    }
  },

  // Search users by name or email
  async search(query: string): Promise<AppUser[]> {
    try {
      console.log('🔍 UsersApi.search called with query:', query)
      
      const { data, error } = await supabaseAdmin
        .from('app_user')
        .select('*')
        .or(`full_name.ilike.%${query}%,email.ilike.%${query}%,nic_no.ilike.%${query}%`)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('❌ Error searching users:', error)
        throw new Error(error.message)
      }

      console.log('✅ User search successful!')
      console.log('📊 Users found:', data?.length || 0)

      return data || []
    } catch (error) {
      console.error('❌ User search error:', error)
      throw error instanceof Error ? error : new Error('Failed to search users')
    }
  }
}
