// Type definitions for auth mapping
export interface AppUserData {
  role: string
  user_id: number
  full_name: string
}

export interface UserAuthResponse {
  app_user: AppUserData
}


export type TimeslotStatus = 'Pending' | 'Available'

// Database table interfaces matching the schema
export interface TimeSlot {
  timeslot_id?: number
  service_id: number
  start_time: string
  end_time: string
  remaining_appointments: number
  status?: TimeslotStatus // timeslot_status DEFAULT 'Pending'
  created_at?: string // TIMESTAMP WITH TIME ZONE DEFAULT NOW()
}

export interface SlotUpdateData {
  service_id?: number
  start_time?: string
  end_time?: string
  remaining_appointments?: number
  status?: TimeslotStatus
}