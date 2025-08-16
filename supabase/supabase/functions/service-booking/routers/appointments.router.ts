import express from "express";
import {
  createAppointment,
  getAppointmentById,
  getAppointments,
  updateAppointmentStatus,
  updateAppointmentOfficer
} from '../handlers/appointments.ts'

import {
  uploadAppointmentDocument,
  getAppointmentDocumentsList,
  deleteAppointmentDocument,
  getDocumentTypesList,
  downloadDocument
} from '../handlers/documents.ts'
import { multipartParser } from "../../_shared/middleware/upload.ts";


export const router = express.Router();

router.post('/service-booking/appointments', createAppointment)
router.get('/service-booking/appointments/:id', getAppointmentById)
router.get('/service-booking/appointments', getAppointments)
router.put('/service-booking/appointments/:id', updateAppointmentStatus)
router.patch('/service-booking/appointments/:id/officer', updateAppointmentOfficer)

router.post('/service-booking/appointments/:id/documents', multipartParser(), uploadAppointmentDocument)
router.get('/service-booking/appointments/:id/documents', getAppointmentDocumentsList)
router.delete('/service-booking/appointments/:id/documents/:docId', deleteAppointmentDocument)
router.get('/service-booking/appointments/:id/documents/:docId/download', downloadDocument)
router.get('/service-booking/document-types', getDocumentTypesList)