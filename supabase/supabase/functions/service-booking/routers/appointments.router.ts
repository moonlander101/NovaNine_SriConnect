import express from "express";
import {
  createAppointment,
  getAppointmentById,
  getAppointments,
  updateAppointmentStatus
} from '../handlers/appointments.ts'

import {
  uploadAppointmentDocument,
  getAppointmentDocumentsList,
  deleteAppointmentDocument,
  getDocumentTypesList,
  downloadDocument
} from '../handlers/documents.ts'


export const router = express.Router();

router.post('/service-booking/appointments', createAppointment)
router.get('/service-booking/appointments/:id', getAppointmentById)
router.get('/service-booking/appointments', getAppointments)
router.put('/service-booking/appointments/:id', updateAppointmentStatus)

// Document routes
router.post('/service-booking/appointments/:id/documents', uploadAppointmentDocument)
router.get('/service-booking/appointments/:id/documents', getAppointmentDocumentsList)
router.delete('/service-booking/appointments/:id/documents/:docId', deleteAppointmentDocument)
router.get('/service-booking/appointments/:id/documents/:docId/download', downloadDocument)
router.get('/service-booking/document-types', getDocumentTypesList)