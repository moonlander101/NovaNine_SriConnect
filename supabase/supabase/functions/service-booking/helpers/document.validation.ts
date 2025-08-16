import { ValidationResult } from '../../_shared/types.ts'

// Validate upload request
export function validateDocumentUploadRequest(body: {
  appointment_id: number
  doc_type_id: number
  file: File
}): ValidationResult {
  const errors: string[] = []
  
  if (!body.appointment_id || isNaN(body.appointment_id)) {
    errors.push('Valid appointment_id is required')
  }
  
  if (!body.doc_type_id || isNaN(body.doc_type_id)) {
    errors.push('Valid doc_type_id is required')
  }
  
  if (!body.file) {
    errors.push('File is required')
  }
  
  return {
    isValid: errors.length === 0,
    errors
  }
}

// Validate file format (PDF, JPG, PNG, etc.)
export function validateFileFormat(file: File): boolean {
  const allowedTypes = [
    'application/pdf',
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/webp'
  ]
  
  return allowedTypes.includes(file.type)
}

// Validate file size (max 10MB)
export function validateFileSize(file: File): boolean {
  return file.size <= 10 * 1024 * 1024
}

// Generate unique file path
export function generateFilePath(
  appointmentId: number, 
  docTypeId: number, 
  fileName: string
): string {
  const timestamp = Date.now()
  const uuid = crypto.randomUUID().substring(0, 8)
  const extension = fileName.split('.').pop()?.toLowerCase() || ''
  
  return `appointment-${appointmentId}/doc-type-${docTypeId}-${timestamp}-${uuid}.${extension}`
}

// Sanitize file name for storage
export function sanitizeFileName(fileName: string): string {
  return fileName
    .replace(/[^a-zA-Z0-9.-]/g, '_')
    .substring(0, 100)
    .toLowerCase()
}

// Comprehensive file validation
export function validateFile(file: File): ValidationResult {
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
  
  // File extension validation (prevent spoofing)
  const extension = file.name.split('.').pop()?.toLowerCase()
  const typeExtensionMap: Record<string, string[]> = {
    'application/pdf': ['pdf'],
    'image/jpeg': ['jpg', 'jpeg'],
    'image/jpg': ['jpg', 'jpeg'],
    'image/png': ['png'],
    'image/webp': ['webp']
  }
  
  const validExtensions = typeExtensionMap[file.type]
  if (!validExtensions?.includes(extension || '')) {
    errors.push('File extension does not match file type')
  }
  
  return {
    isValid: errors.length === 0,
    errors
  }
}
