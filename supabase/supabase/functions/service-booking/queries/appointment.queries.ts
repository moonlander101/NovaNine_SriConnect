import { supabase as adminClient } from "../../_shared/supabaseAdmin.ts"

export interface CreateAppointmentParams {
  citizen_id: number
  officer_id?: number | null
  service_id: string
  timeslot_id: string
  status?: string
}

export const createAppointmentQuery = (appointmentData: CreateAppointmentParams) => {
  return adminClient.rpc('create_appointment_with_slot_update', {
    p_citizen_id: appointmentData.citizen_id,
    p_officer_id: appointmentData.officer_id,
    p_service_id: appointmentData.service_id,
    p_timeslot_id: appointmentData.timeslot_id,
    p_status: appointmentData.status
  })
}

export const getAppointmentDetailsQuery = (appointmentId: string) => {
  return adminClient.rpc('get_appointment_with_details', {
    p_appointment_id: appointmentId
  })
}

export const getAppointmentsQuery = (filters: {
  status?: string
  service_id?: string
  date?: string
  limit?: string
  userRole: string
  userId: string
}) => {
  const { status, service_id, date: _date, limit = '50', userRole, userId } = filters

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
    .limit(parseInt(limit))

  // Filter by user role
  if (userRole === 'Citizen') {
    // Citizens can only see their own appointments
    query = query.eq('citizen_id', userId)
  } else if (userRole === 'Officer') {
    // Officers can see appointments they're assigned to
    query = query.eq('officer_id', userId)
  }
  // Admins can see all appointments (no additional filter)

  // Apply optional filters
  if (status) {
    query = query.eq('status', status)
  }

  if (service_id) {
    query = query.eq('service_id', service_id)
  }

  return query
}

export const getAppointmentByIdQuery = (appointmentId: string) => {
  return adminClient
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
        phone_no
      ),
      officer:officer_id (
        full_name,
        email,
        phone_no
      )
    `)
    .eq('appointment_id', appointmentId)
    .single()
}

export const updateAppointmentStatusQuery = (appointmentId: string, status: string) => {
  return adminClient
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
}

export const cancelAppointmentQuery = (appointmentId: string) => {
  return adminClient.rpc('cancel_appointment_with_slot_update', {
    p_appointment_id: parseInt(appointmentId)
  })
}

export const getCurrentAppointmentQuery = (appointmentId: string) => {
  return adminClient
    .from('appointment')
    .select('*')
    .eq('appointment_id', appointmentId)
    .single()
}

export const checkOfficerExistsQuery = (officerId: number) => {
  return adminClient
    .from('app_user')
    .select('user_id, role')
    .eq('user_id', officerId)
    .eq('role', 'Officer')
    .single()
}

export const updateAppointmentOfficerQuery = (appointmentId: string, officerId: number) => {
  return adminClient
    .from('appointment')
    .update({ 
      officer_id: officerId,
      updated_at: new Date().toISOString()
    })
    .eq('appointment_id', appointmentId)
    .select(`
      *,
      service:service_id (
        title
      ),
      officer:officer_id (
        full_name,
        email
      )
    `)
    .single()
}
