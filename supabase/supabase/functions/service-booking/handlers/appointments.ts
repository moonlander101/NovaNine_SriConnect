import type { Request, Response } from 'npm:@types/express@4.17.17'
import { getUserFromToken, getUserAppData } from '../../_shared/supabaseClient.ts'
import { extractUserToken } from "../../_shared/utils.ts"
import { supabase as adminClient } from '../../_shared/supabaseAdmin.ts'
import { AppointmentCreateData, Appointment } from "../../_shared/types.ts"

// POST /appointments - Create a new appointment booking
export async function createAppointment(req: Request, res: Response) {
  try {
    const body: AppointmentCreateData = req.body
    
    // Extract user token for authentication
    const token = extractUserToken(req)
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' })
    }

    // Verify user and get role
    const { user, error: userError } = await getUserFromToken(token)
    if (userError || !user) {
      return res.status(401).json({ error: 'Invalid token' })
    }

    const { role, userId, error: roleError } = await getUserAppData(token, user.id)
    if (roleError) {
      return res.status(500).json({ error: 'Failed to get user role' })
    }
    
    // Validate required fields
    if (!body.service_id || !body.timeslot_id) {
      return res.status(400).json({ 
        error: 'service_id and timeslot_id are required' 
      })
    }

    // Build appointment data based on user role
    const appointmentData: Partial<Appointment> = {
      service_id: body.service_id,
      timeslot_id: body.timeslot_id,
    }

    if (role === 'Citizen') {
      // For citizens, set citizen_id to current user, no officer_id
      appointmentData.citizen_id = userId
      appointmentData.officer_id = null
    } else if (role === 'Admin') {
      // For admins, they can specify citizen_id in the request body
      if (!body.citizen_id) {
        return res.status(400).json({ 
          error: 'citizen_id is required when booking for others' 
        })
      }
      appointmentData.citizen_id = body.citizen_id
      appointmentData.officer_id = body.officer_id ? body.officer_id : null;
    } else {
      return res.status(403).json({ error: 'Access denied' })
    }
    console.log(appointmentData)
    // Use PostgreSQL function to create appointment and update remaining appointments atomically
    const { data: rpcResult, error: rpcError } = await adminClient
      .rpc('create_appointment_with_slot_update', {
        p_citizen_id: appointmentData.citizen_id,
        p_officer_id: appointmentData.officer_id,
        p_service_id: appointmentData.service_id,
        p_timeslot_id: appointmentData.timeslot_id,
        p_status: appointmentData.status
      })

    if (rpcError) {
      return res.status(500).json({ error: `Database error: ${rpcError.message}` })
    }

    // Check if the RPC function returned an error
    if (!rpcResult.success) {
      return res.status(400).json({ error: rpcResult.error })
    }

    // Get the full appointment details using another RPC function
    const { data: appointmentDetails, error: detailsError } = await adminClient
      .rpc('get_appointment_with_details', {
        p_appointment_id: rpcResult.appointment_id
      })

    if (detailsError || !appointmentDetails.success) {
      // If we can't get details, still return success but with basic info
      return res.status(201).json({ 
        message: 'Appointment created successfully',
        data: { appointment_id: rpcResult.appointment_id }
      })
    }

    return res.status(201).json({ 
      message: 'Appointment created successfully',
      data: appointmentDetails.data
    })
  } catch (_error) {
    console.error('Create appointment error:', _error)
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// GET /appointments - Get appointments based on user role
export async function getAppointments(req: Request, res: Response) {
  try {
    const { status, service_id, date, limit = '50' } = req.query
    // Extract user token for authentication
    const token = extractUserToken(req)
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' })
    }

    // Verify user and get role
    const { user, error: userError } = await getUserFromToken(token)
    if (userError || !user) {
      return res.status(401).json({ error: 'Invalid token' })
    }

    const { role, error: roleError } = await getUserAppData(token, user.id)
    if (roleError) {
      return res.status(500).json({ error: 'Failed to get user role' })
    }

    let query = adminClient
      .from('appointment')
      .select(`
        *,
        service:service_id (
          title,
          department:department_id (
            title
          )
        ),
        timeslot:timeslot_id (
          start_time,
          end_time
        ),
        citizen:citizen_id (
          full_name,
          email
        ),
        officer:officer_id (
          full_name,
          email
        )
      `)
      .order('created_at', { ascending: false })
      .limit(parseInt(limit as string))

    // Filter by user role
    if (role === 'Citizen') {
      // Citizens can only see their own appointments
      query = query.eq('citizen_id', user.id)
    } else if (role === 'Officer') {
      // Officers can see appointments they're assigned to or in their department
      query = query.eq('officer_id', user.id)
    }
    // Admins can see all appointments (no additional filter)

    // Apply optional filters
    if (status) {
      query = query.eq('status', status)
    }

    if (service_id) {
      query = query.eq('service_id', service_id)
    }

    if (date) {
      // Filter by appointment date (using timeslot start_time)
      const startOfDay = new Date(date as string)
      startOfDay.setHours(0, 0, 0, 0)
      const endOfDay = new Date(date as string)
      endOfDay.setHours(23, 59, 59, 999)
      
      // This requires a join, which might be complex. For now, we'll get the data and filter in memory
      // In a production app, you'd want to optimize this query
    }

    const { data, error } = await query

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    // If date filter is applied, filter the results
    let filteredData = data
    if (date && data) {
      const startOfDay = new Date(date as string)
      startOfDay.setHours(0, 0, 0, 0)
      const endOfDay = new Date(date as string)
      endOfDay.setHours(23, 59, 59, 999)
      
      filteredData = data.filter((appointment: Appointment & { 
        timeslot?: { start_time: string } 
      }) => {
        if (appointment.timeslot?.start_time) {
          const appointmentDate = new Date(appointment.timeslot.start_time)
          return appointmentDate >= startOfDay && appointmentDate <= endOfDay
        }
        return false
      })
    }

    return res.status(200).json({ 
      data: filteredData,
      count: filteredData?.length || 0
    })
  } catch (_error) {
    console.error('Get appointments error:', _error)
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// GET /appointments/:id - Get specific appointment
export async function getAppointmentById(req: Request, res: Response) {
  try {
    const { id: appointmentId } = req.params
    
    // Extract user token for authentication
    const token = extractUserToken(req)
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' })
    }

    // Verify user and get role
    const { user, error: userError } = await getUserFromToken(token)
    if (userError || !user) {
      return res.status(401).json({ error: 'Invalid token' })
    }

    const { role, error: roleError } = await getUserAppData(token, user.id)
    if (roleError) {
      return res.status(500).json({ error: 'Failed to get user role' })
    }

    const { data, error } = await adminClient
      .from('appointment')
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
        timeslot:timeslot_id (
          start_time,
          end_time,
          remaining_appointments
        ),
        citizen:citizen_id (
          full_name,
          email,
          contact_number
        ),
        officer:officer_id (
          full_name,
          email,
          contact_number
        )
      `)
      .eq('appointment_id', appointmentId)
      .single()

    if (error) {
      return res.status(404).json({ error: 'Appointment not found' })
    }

    // Check access permissions
    if (role === 'Citizen' && data.citizen_id !== user.id) {
      return res.status(403).json({ error: 'Access denied' })
    } else if (role === 'Officer' && data.officer_id !== user.id) {
      return res.status(403).json({ error: 'Access denied' })
    }
    // Admins can access any appointment

    return res.status(200).json({ data })
  } catch (_error) {
    console.error('Get appointment by ID error:', _error)
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// PUT /appointments/:id - Update appointment status
export async function updateAppointmentStatus(req: Request, res: Response) {
  try {
    const { id: appointmentId } = req.params
    const { status } = req.body
    
    // Extract user token for authentication
    const token = extractUserToken(req)
    if (!token) {
      return res.status(401).json({ error: 'Authentication required' })
    }

    // Verify user and get role
    const { user, error: userError } = await getUserFromToken(token)
    if (userError || !user) {
      return res.status(401).json({ error: 'Invalid token' })
    }

    const { role, userId, error: roleError } = await getUserAppData(token, user.id)
    if (roleError) {
      return res.status(500).json({ error: 'Failed to get user role' })
    }

    // Validate status is provided
    if (!status) {
      return res.status(400).json({ error: 'Status is required' })
    }

    // Get the current appointment to check permissions
    const { data: currentAppointment, error: fetchError } = await adminClient
      .from('appointment')
      .select('*')
      .eq('appointment_id', appointmentId)
      .single()

    if (fetchError || !currentAppointment) {
      return res.status(404).json({ error: 'Appointment not found' })
    }

    // Check permissions based on role
    if (role === 'Citizen') {
      // Citizens can only update their own appointments
      if (currentAppointment.citizen_id !== userId) {
        return res.status(403).json({ error: 'Access denied. You can only update your own appointments.' })
      }
      
      // Citizens can only cancel or confirm
      if (!['Canceled', 'Confirmed'].includes(status)) {
        return res.status(403).json({ 
          error: 'Citizens can only cancel or confirm appointments' 
        })
      }
    } else if (role === 'Officer') {
      // Officers can only update appointments they're assigned to
      if (currentAppointment.officer_id !== userId) {
        return res.status(403).json({ 
          error: 'Access denied. You can only update appointments assigned to you.' 
        })
      }
      
      // Officers can only cancel or confirm
      if (!['Canceled', 'Confirmed'].includes(status)) {
        return res.status(403).json({ 
          error: 'Officers can only cancel or confirm appointments' 
        })
      }
    }
    // Admins can update any appointment to any status (no restrictions)

    // Validate the status value
    const validStatuses = ['Pending', 'Confirmed', 'Completed', 'Canceled', 'Absent']
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ 
        error: `Invalid status. Must be one of: ${validStatuses.join(', ')}` 
      })
    }

    // Check if the appointment can be updated (business logic)
    if (currentAppointment.status === 'Completed') {
      console.error("Cannot update status of completed appointments")
      return res.status(400).json({ 
        error: 'Cannot update status' 
      })
    }

    // If canceling an appointment, use the RPC function to restore remaining appointments
    if (status === 'Canceled' && currentAppointment.status !== 'Canceled') {
      const { data: cancelResult, error: cancelError } = await adminClient
        .rpc('cancel_appointment_with_slot_update', {
          p_appointment_id: parseInt(appointmentId)
        })

      if (cancelError) {
        return res.status(500).json({ error: `Database error: ${cancelError.message}` })
      }

      if (!cancelResult.success) {
        return res.status(400).json({ error: cancelResult.error })
      }

      // Get updated appointment details
      const { data: updatedAppointment, error: _detailsError } = await adminClient
        .rpc('get_appointment_with_details', {
          p_appointment_id: parseInt(appointmentId)
        })

      return res.status(200).json({
        message: 'Appointment status updated successfully',
        data: updatedAppointment.success ? updatedAppointment.data : { appointment_id: appointmentId, status: 'Canceled' }
      })
    }

    // For other status updates, use regular update
    const { data: updatedAppointment, error: updateError } = await adminClient
      .from('appointment')
      .update({ 
        status: status,
        updated_at: new Date().toISOString()
      })
      .eq('appointment_id', appointmentId)
      .select(`
        *,
        service:service_id (
          title,
          department:department_id (
            title
          )
        ),
        timeslot:timeslot_id (
          start_time,
          end_time
        ),
        citizen:citizen_id (
          full_name,
          email
        ),
        officer:officer_id (
          full_name,
          email
        )
      `)
      .single()

    if (updateError) {
      return res.status(400).json({ error: updateError.message })
    }

    return res.status(200).json({
      message: 'Appointment status updated successfully',
      data: updatedAppointment
    })
  } catch (_error) {
    console.error('Update appointment status error:', _error)
    return res.status(500).json({ error: 'Internal server error' })
  }
}