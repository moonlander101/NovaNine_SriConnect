import { supabaseAdmin } from '@/lib/supabase'
import type { TimeSlot, Service, TimeslotStatus } from '@/types/database'

export interface TimeSlotWithService extends TimeSlot {
  service?: Service
}

export interface CreateTimeSlotData {
  service_id: number
  start_time: string
  end_time: string
  remaining_appointments: number
  status: TimeslotStatus
}

export interface UpdateTimeSlotData {
  service_id?: number
  start_time?: string
  end_time?: string
  remaining_appointments?: number
  status?: TimeslotStatus
}

export const timeSlotsApi = {
  // Test connection with simple query
  async testConnection(): Promise<boolean> {
    try {
      console.log('🧪 Testing Supabase connection...')
      
      // Test time_slot table access
      const { data: timeSlotData, error: timeSlotError } = await supabaseAdmin
        .from('time_slot')
        .select('timeslot_id')
        .limit(1)

      if (timeSlotError) {
        console.error('❌ Time slot table test failed:', timeSlotError)
        return false
      }

      console.log('✅ Time slot table accessible!')
      
      // Test appointment table access
      const { data: appointmentData, error: appointmentError } = await supabaseAdmin
        .from('appointment')
        .select('appointment_id')
        .limit(1)

      if (appointmentError) {
        console.error('❌ Appointment table test failed:', appointmentError)
        console.error('❌ This might be the source of the appointment count issues')
        return false
      }

      console.log('✅ Appointment table also accessible!')
      console.log('✅ All connection tests successful!')
      return true
    } catch (error) {
      console.error('❌ Connection test error:', error)
      return false
    }
  },

  // Get all time slots with service information
  async getAll(): Promise<TimeSlotWithService[]> {
    try {
      const { data, error } = await supabaseAdmin
        .from('time_slot')
        .select(`
          *,
          service (
            service_id,
            title,
            description,
            department_id,
            created_at,
            updated_at
          )
        `)
        .order('start_time', { ascending: true })

      if (error) {
        console.error('Error fetching time slots:', error)
        throw new Error(error.message)
      }

      return data || []
    } catch (error) {
      console.error('Time slots fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch time slots')
    }
  },

  // Get time slots by date range
  async getByDateRange(startDate: string, endDate: string): Promise<TimeSlotWithService[]> {
    try {
      console.log('🔍 TimeSlotsApi.getByDateRange called with:', { startDate, endDate })
      console.log('🔗 Using supabaseAdmin client with RLS bypass...')
      
      const { data, error } = await supabaseAdmin
        .from('time_slot')
        .select(`
          *,
          service (
            service_id,
            title,
            description,
            department_id,
            created_at,
            updated_at
          )
        `)
        .gte('start_time', startDate)
        .lte('start_time', endDate)
        .order('start_time', { ascending: true })

      if (error) {
        console.error('❌ Error fetching time slots by date range:', error)
        console.error('❌ Error details:', {
          message: error.message,
          details: error.details,
          hint: error.hint,
          code: error.code
        })
        throw new Error(error.message)
      }

      console.log('✅ Time slots by date range query successful!')
      console.log('📊 Records found:', data?.length || 0)
      return data || []
    } catch (error) {
      console.error('Time slots by date range fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch time slots by date range')
    }
  },

  // Get time slots by service
  async getByService(serviceId: number): Promise<TimeSlotWithService[]> {
    try {
      const { data, error } = await supabaseAdmin
        .from('time_slot')
        .select(`
          *,
          service (
            service_id,
            title,
            description,
            department_id,
            created_at,
            updated_at
          )
        `)
        .eq('service_id', serviceId)
        .order('start_time', { ascending: true })

      if (error) {
        console.error('Error fetching time slots by service:', error)
        throw new Error(error.message)
      }

      return data || []
    } catch (error) {
      console.error('Time slots by service fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch time slots by service')
    }
  },

  // Get time slot by ID
  async getById(id: number): Promise<TimeSlotWithService | null> {
    try {
      const { data, error } = await supabaseAdmin
        .from('time_slot')
        .select(`
          *,
          service (
            service_id,
            title,
            description,
            department_id,
            created_at,
            updated_at
          )
        `)
        .eq('timeslot_id', id)
        .single()

      if (error) {
        if (error.code === 'PGRST116') {
          return null
        }
        console.error('Error fetching time slot by ID:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('Time slot by ID fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch time slot')
    }
  },

  // Create a new time slot
  async create(timeSlotData: CreateTimeSlotData): Promise<TimeSlot> {
    try {
      const { data, error } = await supabaseAdmin
        .from('time_slot')
        .insert(timeSlotData)
        .select()
        .single()

      if (error) {
        console.error('Error creating time slot:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('Time slot creation error:', error)
      throw error instanceof Error ? error : new Error('Failed to create time slot')
    }
  },

  // Update a time slot
  async update(id: number, updateData: UpdateTimeSlotData): Promise<TimeSlot> {
    try {
      const { data, error } = await supabaseAdmin
        .from('time_slot')
        .update(updateData)
        .eq('timeslot_id', id)
        .select()
        .single()

      if (error) {
        console.error('Error updating time slot:', error)
        throw new Error(error.message)
      }

      return data
    } catch (error) {
      console.error('Time slot update error:', error)
      throw error instanceof Error ? error : new Error('Failed to update time slot')
    }
  },

  // Delete a time slot
  async delete(id: number): Promise<void> {
    try {
      const { error } = await supabaseAdmin
        .from('time_slot')
        .delete()
        .eq('timeslot_id', id)

      if (error) {
        console.error('Error deleting time slot:', error)
        throw new Error(error.message)
      }
    } catch (error) {
      console.error('Time slot deletion error:', error)
      throw error instanceof Error ? error : new Error('Failed to delete time slot')
    }
  },

  // Get appointment count for a time slot
  async getAppointmentCount(timeSlotId: number): Promise<number> {
    try {
      console.log('🔍 Getting appointment count for timeslot:', timeSlotId)
      
      // Try with the alternative spelling first
      const { count, error } = await supabaseAdmin
        .from('appointment')
        .select('*', { count: 'exact', head: true })
        .eq('timeslot_id', timeSlotId)
        .neq('status', 'Canceled')  // Changed from 'Cancelled' to 'Canceled'

      if (error) {
        console.error('❌ Error fetching appointment count with "Canceled":', error)
        
        // If that fails, try without the status filter to see all appointments
        console.log('🔄 Trying without status filter...')
        const { data: allAppointments, error: noFilterError } = await supabaseAdmin
          .from('appointment')
          .select('appointment_id, status')
          .eq('timeslot_id', timeSlotId)
        
        if (noFilterError) {
          console.error('❌ Query without filter also failed:', noFilterError)
          throw new Error(noFilterError.message)
        }
        
        console.log('✅ All appointments for timeslot:', allAppointments)
        
        // Filter out cancelled appointments manually (try different possible values)
        const activeAppointments = allAppointments?.filter(
          apt => apt.status !== 'Cancelled' && 
                 apt.status !== 'Canceled' && 
                 apt.status !== 'CANCELLED' &&
                 apt.status !== 'CANCELED'
        ) || []
        
        const manualCount = activeAppointments.length
        console.log('✅ Manual count (excluding cancelled):', manualCount)
        return manualCount
      }

      console.log('✅ Appointment count successful:', count)
      return count || 0
    } catch (error) {
      console.error('❌ Appointment count fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch appointment count')
    }
  },

  // Get time slots with appointment counts
  async getAllWithAppointmentCounts(): Promise<(TimeSlotWithService & { currentBookings: number })[]> {
    try {
      const timeSlots = await this.getAll()
      
      const timeSlotsWithCounts = await Promise.all(
        timeSlots.map(async (slot) => {
          const currentBookings = await this.getAppointmentCount(slot.timeslot_id)
          return {
            ...slot,
            currentBookings
          }
        })
      )

      return timeSlotsWithCounts
    } catch (error) {
      console.error('Time slots with counts fetch error:', error)
      throw error instanceof Error ? error : new Error('Failed to fetch time slots with appointment counts')
    }
  }
}
