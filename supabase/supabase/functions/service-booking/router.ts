import express from 'express'
import { 
  getSlots, 
  getSlotById, 
  updateSlot, 
  getAvailableSlots 
} from './handlers/slots.ts'

import {
  createAppointment,
  getAppointmentById,
  getAppointments,
  updateAppointmentStatus
} from './handlers/appointments.ts'

export const app = express()
  
// Middleware
app.use(express.json())

// Slot routes
app.get('/service-booking/', (_req,res)=>{
    res.json({
        message : "Hello"
    }).status(200)
})
app.get('/service-booking/slots', getSlots)
app.get('/service-booking/slots/available', getAvailableSlots)
app.get('/service-booking/slots/:id', getSlotById)
app.put('/service-booking/slots/:id', updateSlot)

app.post('/service-booking/appointments', createAppointment)
app.get('/service-booking/appointments/:id', getAppointmentById)
app.get('/service-booking/appointments', getAppointments)
app.put('/service-booking/appointments/:id', updateAppointmentStatus)