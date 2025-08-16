import { supabaseAdmin } from '@/lib/supabase'
import type { Service, Department } from '@/types/database'

export interface ServiceWithDepartment extends Service {
  department?: Department
}

export interface CreateServiceData {
  department_id: number
  title: string
  description?: string
}

export interface UpdateServiceData {
  department_id?: number
  title?: string
  description?: string
}

export const servicesApi = {
  // Get all services with department information
  async getAll(): Promise<ServiceWithDepartment[]> {
    try {
      console.log('🔍 ServicesApi.getAll called...')
      
      const { data, error } = await supabaseAdmin
        .from('service')
        .select(`
          *,
          department (
            department_id,
            title,
            description,
            email,
            phone_no,
            created_at,
            updated_at
          )
        `)
        .order('title', { ascending: true })

      if (error) {
        console.error('❌ Error fetching services:', error)
        console.error('❌ Error details:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        })
        throw new Error(error.message)
      }

      console.log('✅ Services query successful!')
      console.log('📊 Services found:', data?.length || 0)
      if (data && data.length > 0) {
        console.log('📋 Sample service:', data[0])
      }

      return data || []
    } catch (error) {
      console.error('Services fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch services')
    }
  },

  // Get service by ID
  async getById(id: number): Promise<ServiceWithDepartment | null> {
    try {
      const { data, error } = await supabaseAdmin
        .from('service')
        .select(`
          *,
          department (
            department_id,
            title,
            description,
            email,
            phone_no,
            created_at,
            updated_at
          )
        `)
        .eq('service_id', id)
        .single()

      if (error) {
        if (error.code === 'PGRST116') {
          return null
        }
        console.error('Error fetching service by ID:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('Service by ID fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch service')
    }
  },

  // Get services by department
  async getByDepartment(departmentId: number): Promise<ServiceWithDepartment[]> {
    try {
      const { data, error } = await supabaseAdmin
        .from('service')
        .select(`
          *,
          department (
            department_id,
            title,
            description,
            email,
            phone_no,
            created_at,
            updated_at
          )
        `)
        .eq('department_id', departmentId)
        .order('title', { ascending: true })

      if (error) {
        console.error('Error fetching services by department:', error)
        throw new Error(error.message)
      }

      return data || []
    } catch (error) {
      console.error('Services by department fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch services by department')
    }
  },

  // Create a new service
  async create(serviceData: CreateServiceData): Promise<Service> {
    try {
      const { data, error } = await supabaseAdmin
        .from('service')
        .insert(serviceData)
        .select()
        .single()

      if (error) {
        console.error('Error creating service:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('Service creation error:', error)
      throw error instanceof Error ? error : new Error('Failed to create service')
    }
  },

  // Update a service
  async update(id: number, updateData: UpdateServiceData): Promise<Service> {
    try {
      const { data, error } = await supabaseAdmin
        .from('service')
        .update(updateData)
        .eq('service_id', id)
        .select()
        .single()

      if (error) {
        console.error('Error updating service:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('Service update error:', error)
      throw error instanceof Error ? error : new Error('Failed to update service')
    }
  },

  // Delete a service
  async delete(id: number): Promise<void> {
    try {
      const { error } = await supabaseAdmin
        .from('service')
        .delete()
        .eq('service_id', id)

      if (error) {
        console.error('Error deleting service:', error)
        throw new Error(error.message)
      }
    } catch (error) {
      console.error('Service deletion error:', error)
      throw error instanceof Error ? error : new Error('Failed to delete service')
    }
  },

  // Get all departments
  async getDepartments(): Promise<Department[]> {
    try {
      const { data, error } = await supabaseAdmin
        .from('department')
        .select('*')
        .order('title')

      if (error) {
        console.error('Error fetching departments:', error)
        throw new Error(error.message)
      }

      return data || []
    } catch (error) {
      console.error('Departments fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch departments')
    }
  }
}
