import { AppointmentCreateData, Appointment } from "../../_shared/types.ts"

export function validateCreateAppointmentRequest(
  body: AppointmentCreateData, 
  userRole: string
): { isValid: boolean; error?: string } {
  if (!body.service_id || !body.timeslot_id) {
    return {
      isValid: false,
      error: 'service_id and timeslot_id are required'
    }
  }

  if (userRole === 'Admin' && !body.citizen_id) {
    return {
      isValid: false,
      error: 'citizen_id is required when booking for others'
    }
  }

  if (!['Citizen', 'Admin'].includes(userRole)) {
    return {
      isValid: false,
      error: 'Access denied'
    }
  }

  return { isValid: true }
}

export function validateStatusValue(status: string): { isValid: boolean; error?: string } {
  if (!status) {
    return {
      isValid: false,
      error: 'Status is required'
    }
  }

  const validStatuses = ['Pending', 'Confirmed', 'Completed', 'Canceled', 'Absent']
  if (!validStatuses.includes(status)) {
    return {
      isValid: false,
      error: `Invalid status. Must be one of: ${validStatuses.join(', ')}`
    }
  }

  return { isValid: true }
}

export function validateAppointmentUpdatePermissions(
  currentAppointment: Appointment,
  newStatus: string,
  userRole: string,
  userId: string
): { isValid: boolean; error?: string } {
  if (currentAppointment.status === 'Completed') {
    return {
      isValid: false,
      error: 'Cannot update status of completed appointments'
    }
  }

  const userIdNum = parseInt(userId)

  if (userRole === 'Citizen') {
    if (currentAppointment.citizen_id !== userIdNum) {
      return {
        isValid: false,
        error: 'Access denied. You can only update your own appointments.'
      }
    }
    
    if (!['Canceled', 'Confirmed'].includes(newStatus)) {
      return {
        isValid: false,
        error: 'Citizens can only cancel or confirm appointments'
      }
    }
  } else if (userRole === 'Officer') {
    if (currentAppointment.officer_id !== userIdNum) {
      return {
        isValid: false,
        error: 'Access denied. You can only update appointments assigned to you.'
      }
    }
    
    if (!['Canceled', 'Confirmed'].includes(newStatus)) {
      return {
        isValid: false,
        error: 'Officers can only cancel or confirm appointments'
      }
    }
  }

  return { isValid: true }
}

export function validateDateFilter(date: string): Date[] | null {
  if (!date) return null
  
  try {
    const startOfDay = new Date(date)
    startOfDay.setHours(0, 0, 0, 0)
    const endOfDay = new Date(date)
    endOfDay.setHours(23, 59, 59, 999)
    
    return [startOfDay, endOfDay]
  } catch {
    return null
  }
}

export function filterAppointmentsByDate(
  appointments: (Appointment & { 
    timeslot?: { start_time: string } 
  })[], 
  dateRange: Date[]
): (Appointment & { 
  timeslot?: { start_time: string } 
})[] {
  if (!dateRange) return appointments
  
  const [startOfDay, endOfDay] = dateRange
  
  return appointments.filter((appointment) => {
    if (appointment.timeslot?.start_time) {
      const appointmentDate = new Date(appointment.timeslot.start_time)
      return appointmentDate >= startOfDay && appointmentDate <= endOfDay
    }
    return false
  })
}
