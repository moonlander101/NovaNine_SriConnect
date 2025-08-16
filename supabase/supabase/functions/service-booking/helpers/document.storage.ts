import { supabase } from '../../_shared/supabaseAdmin.ts'

// Upload file to Supabase Storage
export async function uploadFileToStorage(file: File, filePath: string): Promise<string> {
  const { data, error } = await supabase.storage
    .from('appointment-documents')
    .upload(filePath, file)
  
  if (error) throw error
  return data.path
}

// Delete file from Supabase Storage  
export async function deleteFileFromStorage(filePath: string): Promise<boolean> {
  const { error } = await supabase.storage
    .from('appointment-documents')
    .remove([filePath])
  
  if (error) throw error
  return true
}

// Generate signed URL for file download
export async function generateSignedUrl(filePath: string, expiresIn: number = 300): Promise<string> {
  const { data, error } = await supabase.storage
    .from('appointment-documents')
    .createSignedUrl(filePath, expiresIn)
  
  if (error) throw error
  return data.signedUrl
}

// Get file metadata
export async function getFileMetadata(filePath: string) {
  const pathParts = filePath.split('/')
  const folder = pathParts[0]
  const fileName = pathParts[1]
  
  const { data, error } = await supabase.storage
    .from('appointment-documents')
    .list(folder, {
      search: fileName
    })
  
  return { data, error }
}

// Generate secure file path with UUID components
export function generateSecureFilePath(
  appointmentId: number, 
  docTypeId: number, 
  originalFileName: string
): string {
  const timestamp = Date.now()
  const uuid = crypto.randomUUID().substring(0, 8)
  const extension = originalFileName.split('.').pop()?.toLowerCase() || ''
  
  // Create unpredictable path with UUID components
  return `appointment-${appointmentId}/doc-type-${docTypeId}-${timestamp}-${uuid}.${extension}`
}
