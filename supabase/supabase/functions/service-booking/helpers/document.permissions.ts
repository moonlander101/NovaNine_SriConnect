import { PermissionResult } from '../../_shared/types.ts'
import { getAppointmentByIdQuery } from '../queries/appointment.queries.ts'
import { getRequiredDocumentsForService } from '../queries/document.queries.ts'

interface RequiredDocument {
  doc_type_id: number
  is_mandatory: boolean
  document_type: {
    doc_type_id: number
    doc_type: string
    description: string
  }
}

interface DocWithType {
  doc_type_id: number
}

// Helper function to get appointment data from query response
async function getAppointmentData(appointmentId: string) {
  const { data, error } = await getAppointmentByIdQuery(appointmentId)
  if (error) throw error
  return data
}

// Check if user can upload documents to appointment
export async function canUploadToAppointment(
  appointmentId: number, 
  userRole: string, 
  userId: string
): Promise<PermissionResult> {
  // Only Citizens can upload
  if (userRole !== 'Citizen') {
    return { allowed: false, reason: 'Only citizens can upload documents' }
  }

  // Get appointment details
  const appointment = await getAppointmentData(appointmentId.toString())
  if (!appointment) {
    return { allowed: false, reason: 'Appointment not found' }
  }

  // Check ownership
  if (appointment.citizen_id !== parseInt(userId)) {
    return { allowed: false, reason: 'Can only upload to own appointments' }
  }

  // Check appointment status
  if (['Completed', 'Canceled'].includes(appointment.status)) {
    return { allowed: false, reason: 'Cannot upload to completed or cancelled appointments' }
  }

  return { allowed: true }
}

// Validate document type is required for service
export async function validateDocumentTypeForService(
  serviceId: number, 
  docTypeId: number
): Promise<boolean> {
  const requiredDocs = await getRequiredDocumentsForService(serviceId)
  return requiredDocs.some((doc: DocWithType) => doc.doc_type_id === docTypeId)
}

// Check file type and size limitations
export function validateFileUpload(file: File): { valid: boolean; errors: string[] } {
  const errors: string[] = []
  
  // File size validation (10MB limit)
  if (file.size > 10 * 1024 * 1024) {
    errors.push('File size exceeds 10MB limit')
  }
  
  // MIME type validation
  const allowedTypes = [
    'application/pdf',
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/webp'
  ]
  
  if (!allowedTypes.includes(file.type)) {
    errors.push('File type not supported')
  }
  
  return {
    valid: errors.length === 0,
    errors
  }
}

// Permission check for viewing documents
export async function canViewAppointmentDocuments(
  appointmentId: number,
  userRole: string,
  userId: string
): Promise<PermissionResult> {
  const appointment = await getAppointmentData(appointmentId.toString())
  if (!appointment) {
    return { allowed: false, reason: 'Appointment not found' }
  }

  const userIdNum = parseInt(userId)
  
  switch (userRole) {
    case 'Citizen':
      return { 
        allowed: appointment.citizen_id === userIdNum,
        reason: appointment.citizen_id === userIdNum ? undefined : 'Access denied'
      }
      
    case 'Officer':
      return { 
        allowed: appointment.officer_id === userIdNum,
        reason: appointment.officer_id === userIdNum ? undefined : 'Not assigned to this appointment'
      }
      
    case 'Admin':
      return { allowed: true }
      
    default:
      return { allowed: false, reason: 'Invalid role' }
  }
}
