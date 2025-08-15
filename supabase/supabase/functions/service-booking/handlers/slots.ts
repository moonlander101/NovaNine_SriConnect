import type { Request, Response } from 'npm:@types/express@4.17.17'
import { supabase } from '../../_shared/supabaseAdmin.ts'

// Database table interfaces matching the schema
interface TimeSlot {
  timeslot_id?: number
  service_id: number
  start_time: string // TIMESTAMP WITH TIME ZONE
  end_time: string   // TIMESTAMP WITH TIME ZONE
  remaining_appointments: number // INTEGER DEFAULT 1
  status?: 'Pending' | 'Available'
  created_at?: string // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
}

interface SlotUpdateData {
  service_id?: number
  start_time?: string
  end_time?: string
  remaining_appointments?: number
  status?: 'Pending' | 'Available'
}

// GET /slots - Get all slots with optional filters
export async function getSlots(req: Request, res: Response) {
  try {
    const { service_id, status, date, limit = '50' } = req.query

    let query = supabase
      .from('time_slot')
      .select(`
        *,
        service:service_id (
          title,
          department:department_id (
            title
          )
        )
      `)
      .order('start_time', { ascending: true })
      .limit(parseInt(limit as string))

    // Apply filters
    if (service_id) {
      query = query.eq('service_id', service_id)
    }

    if (status) {
      query = query.eq('status', status)
    }

    if (date) {
      const startOfDay = new Date(date as string)
      startOfDay.setHours(0, 0, 0, 0)
      const endOfDay = new Date(date as string)
      endOfDay.setHours(23, 59, 59, 999)
      
      query = query
        .gte('start_time', startOfDay.toISOString())
        .lte('start_time', endOfDay.toISOString())
    }

    const { data, error } = await query

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    return res.status(200).json({ 
      data,
      count: data?.length || 0
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// GET /slots/:id - Get specific slot
export async function getSlotById(req: Request, res: Response) {
  try {
    const { id: timeslotId } = req.params

    const { data, error } = await supabase
      .from('time_slot')
      .select(`
        *,
        service:service_id (
          title,
          description,
          department:department_id (
            title,
            description
          )
        ),
        appointments:appointment (
          appointment_id,
          status,
          citizen:citizen_id (
            full_name,
            email
          ),
          officer:officer_id (
            full_name,
            email
          )
        )
      `)
      .eq('timeslot_id', timeslotId)
      .single()

    if (error) {
      return res.status(404).json({ error: error.message })
    }

    return res.status(200).json({ data })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// PUT /slots/:id - Update slot status or remaining appointments
export async function updateSlot(req: Request, res: Response) {
  try {
    const { id: timeslotId } = req.params
    const body: SlotUpdateData = req.body

    // Build update object with only provided fields
    const updateData: Partial<TimeSlot> = {}
    
    if (body.status !== undefined) {
      if (!['Pending', 'Available'].includes(body.status)) {
        return res.status(400).json({ error: 'Invalid status. Must be Pending or Available' })
      }
      updateData.status = body.status
    }

    if (body.remaining_appointments !== undefined) {
      if (body.remaining_appointments < 0) {
        return res.status(400).json({ error: 'Remaining appointments cannot be negative' })
      }
      updateData.remaining_appointments = body.remaining_appointments
    }

    if (body.start_time !== undefined) {
      updateData.start_time = body.start_time
    }

    if (body.end_time !== undefined) {
      updateData.end_time = body.end_time
    }

    // Validate time logic if both times are being updated
    if (updateData.start_time && updateData.end_time) {
      const startTime = new Date(updateData.start_time)
      const endTime = new Date(updateData.end_time)
      
      if (startTime >= endTime) {
        return res.status(400).json({ error: 'End time must be after start time' })
      }
    }

    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({ error: 'No valid fields to update' })
    }

    const { data, error } = await supabase
      .from('time_slot')
      .update(updateData)
      .eq('timeslot_id', timeslotId)
      .select()
      .single()

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    if (!data) {
      return res.status(404).json({ error: 'Time slot not found' })
    }

    return res.status(200).json({ 
      message: 'Time slot updated successfully',
      data 
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// GET /slots/available - Get available slots for booking
export async function getAvailableSlots(req: Request, res: Response) {
  try {
    const { service_id, from_date, to_date } = req.query

    let query = supabase
      .from('time_slot')
      .select(`
        *,
        service:service_id (
          title,
          department:department_id (
            title
          )
        )
      `)
      .eq('status', 'Available')
      .gt('remaining_appointments', 0)
      .gte('start_time', new Date().toISOString()) // Only future slots
      .order('start_time', { ascending: true })

    if (service_id) {
      query = query.eq('service_id', service_id)
    }

    if (from_date) {
      query = query.gte('start_time', from_date as string)
    }

    if (to_date) {
      query = query.lte('start_time', to_date as string)
    }

    const { data, error } = await query

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    return res.status(200).json({ 
      data,
      count: data?.length || 0
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}