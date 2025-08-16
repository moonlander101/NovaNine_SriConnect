import { supabase as adminClient } from  "../../_shared/supabaseAdmin.ts"
import { TimeSlot } from "../../_shared/types.ts";

export const getSlotsQuery = (filters: {
  service_id?: string | string[]
  status?: string | string[]
  date?: string | string[]
  limit?: string
}) => {
  const { service_id, status, date, limit = '50' } = filters

  let query = adminClient
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

  return query
}

export const getSlotByIdQuery = (timeslot_id : string) => {
  return adminClient
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
    .eq('timeslot_id', timeslot_id)
    .single()
}

export const updateSlotQuery = (updateData : Partial<TimeSlot>, timeslot_id : string) => {
  return adminClient
    .from('time_slot')
    .update(updateData)
    .eq('timeslot_id', timeslot_id)
    .select()
    .single()
}

export function availableSlotQuery(filters: {
  service_id?: string | string[]
  from_date?: string
  to_date?: string
  role?: string
}) {
  const { service_id, from_date, to_date, role } = filters

  let query = adminClient
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

  if (role !== 'Citizen') {
    query = query
      .eq('status', 'Available')
  }

  if (service_id) query = query.eq('service_id', service_id)
  if (from_date) query = query.gte('start_time', from_date)
  if (to_date) query = query.lte('start_time', to_date)

  return query
}
