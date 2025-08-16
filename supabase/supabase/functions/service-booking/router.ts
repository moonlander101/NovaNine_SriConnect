import express from 'express'

import {router as appointmentRouter} from "./routers/appointments.router.ts"
import {router as slotRouter} from "./routers/slots.router.ts"
import { requireAuth } from "../_shared/middleware/auth.ts";

export const app = express()
  
// Middleware
app.use(express.json())
app.use(requireAuth)

// Slot routes
app.get('/service-booking/', (_req,res)=>{
    res.json({
        message : "Hello"
    }).status(200)
})

app.use(slotRouter)
app.use(appointmentRouter)