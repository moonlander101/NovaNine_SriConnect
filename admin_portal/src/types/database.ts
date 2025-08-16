// Database Types
export type UserRole = 'Citizen' | 'Officer' | 'Admin'
export type AppointmentStatus = 'Pending' | 'Confirmed' | 'Completed' | 'Cancelled'
export type VerificationStatus = 'Pending' | 'Approved' | 'Rejected'
export type TimeslotStatus = 'Active' | 'Inactive' | 'Full'
export type NotificationType = 'Reminder' | 'Status_Update' | 'General'
export type SendVia = 'Email' | 'SMS' | 'In_App'

export interface AppUser {
  user_id: number
  full_name: string
  nic_no: string
  email: string
  phone_no: string
  role: UserRole
  created_at: string
  updated_at: string
}

export interface Department {
  department_id: number
  title: string
  description: string | null
  email: string | null
  phone_no: string | null
  created_at: string
  updated_at: string
}

export interface Service {
  service_id: number
  title: string
  description: string | null
  department_id: number | null
  created_at: string
  updated_at: string
}

export interface TimeSlot {
  timeslot_id: number
  service_id: number | null
  start_time: string
  end_time: string
  remaining_appointments: number
  status: TimeslotStatus
  created_at: string
  updated_at: string
}

export interface Appointment {
  appointment_id: number
  officer_id: number | null
  citizen_id: number | null
  service_id: number | null
  timeslot_id: number | null
  status: AppointmentStatus
  created_at: string
  updated_at: string
}

export interface ServiceWithDepartment extends Service {
  department?: Department
}

export interface AppointmentWithDetails extends Appointment {
  citizen?: AppUser
  officer?: AppUser
  service?: Service
  timeslot?: TimeSlot
}

export interface UserAuth {
  user_id: number
  auth_user_id: string
  created_at: string
  updated_at: string
}

export interface OfficerDepartment {
  officer_id: number
  department_id: number
  created_at: string
  updated_at: string
}