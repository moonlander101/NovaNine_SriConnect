import { supabase } from '../../_shared/supabaseAdmin.ts'
import { AppointmentDocument, DocumentType } from '../../_shared/types.ts'

// Get required documents for a service
export async function getRequiredDocumentsForService(serviceId: number) {
  const { data, error } = await supabase
    .from('required_doc_for_service')
    .select(`
      doc_type_id,
      is_mandatory,
      document_type (
        doc_type_id,
        doc_type,
        description
      )
    `)
    .eq('service_id', serviceId)
  
  if (error) throw error
  return data
}

// Get existing documents for an appointment
export async function getAppointmentDocuments(appointmentId: number) {
  const { data, error } = await supabase
    .from('appointment_document')
    .select(`
      appointment_doc_id,
      appointment_id,
      file_path,
      doc_type,
      uploaded_date,
      verification_status,
      review,
      document_type (
        doc_type,
        description
      )
    `)
    .eq('appointment_id', appointmentId)
  
  if (error) throw error
  return data
}

// Check if document type exists for appointment
export async function getExistingDocument(appointmentId: number, docTypeId: number) {
  const { data, error } = await supabase
    .from('appointment_document')
    .select('*')
    .eq('appointment_id', appointmentId)
    .eq('doc_type', docTypeId)
    .single()
  
  return { data, error }
}

// Insert new document record
export async function insertAppointmentDocument(documentData: Partial<AppointmentDocument>) {
  const { data, error } = await supabase
    .from('appointment_document')
    .insert(documentData)
    .select()
    .single()
  
  if (error) throw error
  return data
}

// Update existing document record (for replacement)
export async function updateAppointmentDocument(appointmentDocId: number, filePath: string) {
  const { data, error } = await supabase
    .from('appointment_document')
    .update({ 
      file_path: filePath,
      uploaded_date: new Date().toISOString()
    })
    .eq('appointment_doc_id', appointmentDocId)
    .select()
    .single()
  
  if (error) throw error
  return data
}

// Delete document record
export async function deleteAppointmentDocument(appointmentDocId: number) {
  const { error } = await supabase
    .from('appointment_document')
    .delete()
    .eq('appointment_doc_id', appointmentDocId)
  
  if (error) throw error
  return true
}

// Get document types
export async function getDocumentTypes(): Promise<DocumentType[]> {
  const { data, error } = await supabase
    .from('document_type')
    .select('*')
    .order('doc_type')
  
  if (error) throw error
  return data
}
