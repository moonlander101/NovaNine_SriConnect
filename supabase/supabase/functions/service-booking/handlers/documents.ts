import type { Request, Response } from 'npm:@types/express@4.17.17'
import { MiddlewareRequest } from '../../_shared/middleware/auth.ts'
import { 
  canUploadToAppointment, 
  canViewAppointmentDocuments
} from '../helpers/document.permissions.ts'
import { 
  validateDocumentUploadRequest,
  generateFilePath,
  validateFile
} from '../helpers/document.validation.ts'
import {
  uploadFileToStorage,
  deleteFileFromStorage,
  generateSignedUrl
} from '../helpers/document.storage.ts'
import {
  getAppointmentDocuments,
  getExistingDocument,
  insertAppointmentDocument,
  updateAppointmentDocument,
  deleteAppointmentDocument as deleteDocRecord,
  getDocumentTypes
} from '../queries/document.queries.ts'

// POST /appointments/:id/documents - Upload document
export async function uploadAppointmentDocument(req: Request, res: Response) {
  try {
    const { id } = req.params
    const appointmentId = parseInt(id)
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user
    
    // For now, assume multipart form data is parsed by middleware
    const file = req.body.file as File
    const docTypeId = parseInt(req.body.doc_type_id)
    
    // Validate request
    const validation = validateDocumentUploadRequest({ 
      appointment_id: appointmentId, 
      doc_type_id: docTypeId, 
      file 
    })
    if (!validation.isValid) {
      return res.status(400).json({ errors: validation.errors })
    }
    
    // Check permissions
    const permission = await canUploadToAppointment(appointmentId, role, userId)
    if (!permission.allowed) {
      return res.status(403).json({ error: permission.reason })
    }
    
    // Validate file
    const fileValidation = validateFile(file)
    if (!fileValidation.isValid) {
      return res.status(400).json({ errors: fileValidation.errors })
    }
    
    // Generate file path
    const filePath = generateFilePath(appointmentId, docTypeId, file.name)
    
    // Check for existing document
    const { data: existingDoc } = await getExistingDocument(appointmentId, docTypeId)
    
    // Upload to storage
    await uploadFileToStorage(file, filePath)
    
    let result
    if (existingDoc) {
      // Replace existing document
      result = await updateAppointmentDocument(existingDoc.appointment_doc_id, filePath)
      // Delete old file
      await deleteFileFromStorage(existingDoc.file_path)
    } else {
      // Insert new document
      result = await insertAppointmentDocument({
        appointment_id: appointmentId,
        file_path: filePath,
        doc_type: docTypeId
      })
    }
    
    return res.status(200).json(result)
    
  } catch (error) {
    console.error('Upload error:', error)
    return res.status(500).json({ error: 'Failed to upload document' })
  }
}

// GET /appointments/:id/documents - Get appointment documents  
export async function getAppointmentDocumentsList(req: Request, res: Response) {
  try {
    const { id } = req.params
    const appointmentId = parseInt(id)
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user
    
    // Check permissions
    const permission = await canViewAppointmentDocuments(appointmentId, role, userId)
    if (!permission.allowed) {
      return res.status(403).json({ error: permission.reason })
    }
    
    const documents = await getAppointmentDocuments(appointmentId)
    return res.status(200).json(documents)
    
  } catch (error) {
    console.error('Get documents error:', error)
    return res.status(500).json({ error: 'Failed to retrieve documents' })
  }
}

// DELETE /appointments/:id/documents/:docId - Delete document
export async function deleteAppointmentDocument(req: Request, res: Response) {
  try {
    const { id, docId } = req.params
    const appointmentId = parseInt(id)
    const documentId = parseInt(docId)
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user
    
    // Check permissions (only Citizens can delete their own docs)
    const permission = await canUploadToAppointment(appointmentId, role, userId)
    if (!permission.allowed) {
      return res.status(403).json({ error: permission.reason })
    }
    
    // Get document details
    const documents = await getAppointmentDocuments(appointmentId)
    const document = documents.find(doc => doc.appointment_doc_id === documentId)
    
    if (!document) {
      return res.status(404).json({ error: 'Document not found' })
    }
    
    // Delete from storage and database
    await deleteFileFromStorage(document.file_path)
    await deleteDocRecord(documentId)
    
    return res.status(200).json({ success: true })
    
  } catch (error) {
    console.error('Delete document error:', error)
    return res.status(500).json({ error: 'Failed to delete document' })
  }
}

// GET /document-types - Get available document types
export async function getDocumentTypesList(_req: Request, res: Response) {
  try {
    const documentTypes = await getDocumentTypes()
    return res.status(200).json(documentTypes)
    
  } catch (error) {
    console.error('Get document types error:', error)
    return res.status(500).json({ error: 'Failed to retrieve document types' })
  }
}

// GET /appointments/:id/documents/:docId/download - Download document
export async function downloadDocument(req: Request, res: Response) {
  try {
    const { id, docId } = req.params
    const appointmentId = parseInt(id)
    const documentId = parseInt(docId)
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user
    
    // Check permissions
    const permission = await canViewAppointmentDocuments(appointmentId, role, userId)
    if (!permission.allowed) {
      return res.status(403).json({ error: permission.reason })
    }
    
    // Get document details
    const documents = await getAppointmentDocuments(appointmentId)
    const document = documents.find(doc => doc.appointment_doc_id === documentId)
    
    if (!document) {
      return res.status(404).json({ error: 'Document not found' })
    }
    
    // Generate signed URL
    const signedUrl = await generateSignedUrl(document.file_path, 60) // 1 minute
    
    return res.json({
      url : signedUrl
    }).status(200)
    
  } catch (error) {
    console.error('Download document error:', error)
    return res.status(500).json({ error: 'Failed to download document' })
  }
}
