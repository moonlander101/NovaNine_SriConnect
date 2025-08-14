import express from 'express'
import { 
  getSlots, 
  getSlotById, 
  updateSlot, 
  getAvailableSlots 
} from './handlers/slots.ts'

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