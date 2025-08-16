import { Appointment, AppointmentCreateData } from "../../_shared/types.ts"

export function checkAppointmentAccess(
  appointment: Appointment, 
  userRole: string, 
  userId: string
): boolean {
  if (userRole === 'Admin') {
    return true
  }
  
  const userIdNum = parseInt(userId)
  
  if (userRole === 'Citizen') {
    return appointment.citizen_id === userIdNum
  }
  
  if (userRole === 'Officer') {
    return appointment.officer_id === userIdNum
  }
  
  return false
}

export function validateStatusUpdate(
  currentStatus: string, 
  newStatus: string, 
  userRole: string
): { isValid: boolean; error?: string } {
  if (currentStatus === 'Completed') {
    return {
      isValid: false,
      error: 'Cannot update status of completed appointments'
    }
  }

  const validStatuses = ['Pending', 'Confirmed', 'Completed', 'Canceled', 'Absent']
  if (!validStatuses.includes(newStatus)) {
    return {
      isValid: false,
      error: `Invalid status. Must be one of: ${validStatuses.join(', ')}`
    }
  }

  if (userRole === 'Citizen' || userRole === 'Officer') {
    if (!['Canceled', 'Confirmed'].includes(newStatus)) {
      return {
        isValid: false,
        error: `${userRole}s can only cancel or confirm appointments`
      }
    }
  }

  return { isValid: true }
}

export function canUserCreateAppointment(userRole: string): boolean {
  return ['Citizen', 'Admin'].includes(userRole)
}

export function buildAppointmentData(
  body: AppointmentCreateData, 
  userRole: string, 
  userId: string
): { data?: Partial<Appointment>; error?: string } {
  if (!body.service_id || !body.timeslot_id) {
    return {
      error: 'service_id and timeslot_id are required'
    }
  }

  const appointmentData: Partial<Appointment> = {
    service_id: body.service_id,
    timeslot_id: body.timeslot_id,
  }

  if (userRole === 'Citizen') {
    appointmentData.citizen_id = parseInt(userId)
    appointmentData.officer_id = null
  } else if (userRole === 'Admin') {
    if (!body.citizen_id) {
      return {
        error: 'citizen_id is required when booking for others'
      }
    }
    appointmentData.citizen_id = body.citizen_id
    appointmentData.officer_id = body.officer_id ? body.officer_id : null
  } else {
    return {
      error: 'Access denied'
    }
  }

  return { data: appointmentData }
}

export function canUserUpdateAppointment(
  appointment: Appointment,
  userRole: string,
  userId: string
): { canUpdate: boolean; error?: string } {
  if (userRole === 'Admin') {
    return { canUpdate: true }
  }

  if (userRole === 'Citizen') {
    if (appointment.citizen_id !== parseInt(userId)) {
      return {
        canUpdate: false,
        error: 'Access denied. You can only update your own appointments.'
      }
    }
    return { canUpdate: true }
  }

  if (userRole === 'Officer') {
    if (appointment.officer_id !== parseInt(userId)) {
      return {
        canUpdate: false,
        error: 'Access denied. You can only update appointments assigned to you.'
      }
    }
    return { canUpdate: true }
  }

  return {
    canUpdate: false,
    error: 'Access denied'
  }
}
