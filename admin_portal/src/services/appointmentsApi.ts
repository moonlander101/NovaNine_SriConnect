import { supabaseAdmin } from '@/lib/supabase';
import type { Appointment, AppointmentWithDetails, AppointmentStatus } from '@/types/database';

// Create a new appointment
export const createAppointment = async (appointment: Omit<Appointment, 'appointment_id' | 'created_at' | 'updated_at'>): Promise<Appointment> => {
  console.log('🔍 Creating appointment:', appointment);
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .insert([appointment])
    .select()
    .single();

  if (error) {
    console.error('❌ Error creating appointment:', error);
    throw new Error(`Failed to create appointment: ${error.message}`);
  }

  console.log('✅ Appointment created successfully:', data);
  return data;
};

// Get all appointments with related details
export const getAllAppointments = async (): Promise<AppointmentWithDetails[]> => {
  console.log('🔍 Fetching all appointments with details...');
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .select(`
      *,
      citizen:citizen_id(
        user_id,
        full_name,
        email,
        phone_no,
        nic_no,
        role
      ),
      officer:officer_id(
        user_id,
        full_name,
        email,
        phone_no,
        role
      ),
      service:service_id(
        service_id,
        title,
        description,
        department_id
      ),
      timeslot:timeslot_id(
        timeslot_id,
        start_time,
        end_time,
        remaining_appointments,
        status
      )
    `)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('❌ Error fetching appointments:', error);
    throw new Error(`Failed to fetch appointments: ${error.message}`);
  }

  console.log('✅ Appointments fetched successfully:', data?.length || 0, 'appointments');
  return data || [];
};

// Get appointments by date range
export const getAppointmentsByDateRange = async (startDate: string, endDate: string): Promise<AppointmentWithDetails[]> => {
  console.log('🔍 Fetching appointments for date range:', startDate, 'to', endDate);
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .select(`
      *,
      citizen:citizen_id(
        user_id,
        full_name,
        email,
        phone_no,
        nic_no,
        role
      ),
      officer:officer_id(
        user_id,
        full_name,
        email,
        phone_no,
        role
      ),
      service:service_id(
        service_id,
        title,
        description,
        department_id
      ),
      timeslot:timeslot_id(
        timeslot_id,
        start_time,
        end_time,
        remaining_appointments,
        status
      )
    `)
    .gte('created_at', startDate)
    .lte('created_at', endDate)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('❌ Error fetching appointments by date:', error);
    throw new Error(`Failed to fetch appointments: ${error.message}`);
  }

  console.log('✅ Appointments fetched by date range:', data?.length || 0, 'appointments');
  return data || [];
};

// Get appointments by status
export const getAppointmentsByStatus = async (status: AppointmentStatus): Promise<AppointmentWithDetails[]> => {
  console.log('🔍 Fetching appointments by status:', status);
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .select(`
      *,
      citizen:citizen_id(
        user_id,
        full_name,
        email,
        phone_no,
        nic_no,
        role
      ),
      officer:officer_id(
        user_id,
        full_name,
        email,
        phone_no,
        role
      ),
      service:service_id(
        service_id,
        title,
        description,
        department_id
      ),
      timeslot:timeslot_id(
        timeslot_id,
        start_time,
        end_time,
        remaining_appointments,
        status
      )
    `)
    .eq('status', status)
    .order('created_at', { ascending: false });

  if (error) {
    console.error('❌ Error fetching appointments by status:', error);
    throw new Error(`Failed to fetch appointments: ${error.message}`);
  }

  console.log('✅ Appointments fetched by status:', data?.length || 0, 'appointments');
  return data || [];
};

// Update appointment status
export const updateAppointmentStatus = async (appointmentId: number, status: AppointmentStatus): Promise<Appointment> => {
  console.log('🔍 Updating appointment status:', appointmentId, 'to', status);
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .update({ 
      status,
      updated_at: new Date().toISOString()
    })
    .eq('appointment_id', appointmentId)
    .select()
    .single();

  if (error) {
    console.error('❌ Error updating appointment status:', error);
    throw new Error(`Failed to update appointment: ${error.message}`);
  }

  console.log('✅ Appointment status updated successfully:', data);
  return data;
};

// Assign officer to appointment
export const assignOfficerToAppointment = async (appointmentId: number, officerId: number): Promise<Appointment> => {
  console.log('🔍 Assigning officer to appointment:', appointmentId, 'officer:', officerId);
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .update({ 
      officer_id: officerId,
      updated_at: new Date().toISOString()
    })
    .eq('appointment_id', appointmentId)
    .select()
    .single();

  if (error) {
    console.error('❌ Error assigning officer:', error);
    throw new Error(`Failed to assign officer: ${error.message}`);
  }

  console.log('✅ Officer assigned successfully:', data);
  return data;
};

// Get appointment by ID with details
export const getAppointmentById = async (appointmentId: number): Promise<AppointmentWithDetails | null> => {
  console.log('🔍 Fetching appointment by ID:', appointmentId);
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .select(`
      *,
      citizen:citizen_id(
        user_id,
        full_name,
        email,
        phone_no,
        nic_no,
        role
      ),
      officer:officer_id(
        user_id,
        full_name,
        email,
        phone_no,
        role
      ),
      service:service_id(
        service_id,
        title,
        description,
        department_id
      ),
      timeslot:timeslot_id(
        timeslot_id,
        start_time,
        end_time,
        remaining_appointments,
        status
      )
    `)
    .eq('appointment_id', appointmentId)
    .single();

  if (error) {
    if (error.code === 'PGRST116') {
      console.log('ℹ️ Appointment not found:', appointmentId);
      return null;
    }
    console.error('❌ Error fetching appointment:', error);
    throw new Error(`Failed to fetch appointment: ${error.message}`);
  }

  console.log('✅ Appointment fetched successfully:', data);
  return data;
};

// Delete appointment
export const deleteAppointment = async (appointmentId: number): Promise<void> => {
  console.log('🔍 Deleting appointment:', appointmentId);
  
  const { error } = await supabaseAdmin
    .from('appointment')
    .delete()
    .eq('appointment_id', appointmentId);

  if (error) {
    console.error('❌ Error deleting appointment:', error);
    throw new Error(`Failed to delete appointment: ${error.message}`);
  }

  console.log('✅ Appointment deleted successfully');
};

// Get appointment statistics
export const getAppointmentStats = async () => {
  console.log('🔍 Fetching appointment statistics...');
  
  const { data, error } = await supabaseAdmin
    .from('appointment')
    .select('status');

  if (error) {
    console.error('❌ Error fetching appointment stats:', error);
    throw new Error(`Failed to fetch appointment statistics: ${error.message}`);
  }

  const stats = {
    total: data?.length || 0,
    pending: data?.filter(a => a.status === 'Pending').length || 0,
    confirmed: data?.filter(a => a.status === 'Confirmed').length || 0,
    completed: data?.filter(a => a.status === 'Completed').length || 0,
    cancelled: data?.filter(a => a.status === 'Cancelled').length || 0,
  };

  console.log('✅ Appointment statistics:', stats);
  return stats;
};

export const appointmentsApi = {
  create: createAppointment,
  getAll: getAllAppointments,
  getByDateRange: getAppointmentsByDateRange,
  getByStatus: getAppointmentsByStatus,
  getById: getAppointmentById,
  updateStatus: updateAppointmentStatus,
  assignOfficer: assignOfficerToAppointment,
  delete: deleteAppointment,
  getStats: getAppointmentStats,
};
