import type { Request, Response } from 'npm:@types/express@4.17.17'
import {SlotUpdateData, TimeslotStatus, TimeSlot} from "../../_shared/types.ts"
import { MiddlewareRequest } from "../../_shared/middleware/auth.ts";
import { getSlotsQuery, getSlotByIdQuery, updateSlotQuery, availableSlotQuery } from "../queries/slot.queries.ts";

// GET /slots - Get all slots with optional filters (Officer/Admin only)
export async function getSlots(req: Request, res: Response) {
  try {
    const { service_id, status, date, limit = '50' } = req.query
    
    const mReq = req as MiddlewareRequest    
    const app_user = mReq.app_user

    const role = app_user.role

    if (role !== 'Admin' && role !== 'Officer') {
      return res.status(403).json({ error: 'Access denied.' })
    }

    const { data, error } = await getSlotsQuery({
      service_id : service_id as string || undefined,
      status : status as string || undefined,
      date : date as string,
      limit : limit as string
    })

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    return res.status(200).json({ 
      data,
      count: data?.length || 0
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// GET /slots/:id - Get specific slot (Officer/Admin only)
export async function getSlotById(req: Request, res: Response) {
  try {
    const { id: timeslotId } = req.params
    
    // Extract user token for authentication
    const mReq = req as MiddlewareRequest
    const app_user = mReq.app_user
    const role = app_user.role

    if (role !== 'Admin' && role !== 'Officer') {
      return res.status(403).json({ error: 'Access denied' })
    }

    const { data, error } = await getSlotByIdQuery(timeslotId)
    if (error) {
      return res.status(404).json({ error: error.message })
    }

    return res.status(200).json({ data })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// PUT /slots/:id - Update slot status or remaining appointments (Admin only)
export async function updateSlot(req: Request, res: Response) {
  try {
    const { id: timeslotId } = req.params
    const body: SlotUpdateData = req.body
    
    const mReq = req as MiddlewareRequest
    const app_user = mReq.app_user
    const role = app_user.role

    if (role !== 'Admin') {
      return res.status(403).json({ error: 'Access denied. Only Admins can update slots.' })
    }

    // Build update object with only provided fields
    const updateData: Partial<TimeSlot> = {}
    
    if (body.status !== undefined) {
      const validStatuses: TimeslotStatus[] = ['Pending', 'Available']
      if (!validStatuses.includes(body.status)) {
        return res.status(400).json({ error: 'Invalid status. Must be Pending or Available' })
      }
      updateData.status = body.status
    }

    if (body.remaining_appointments !== undefined) {
      if (body.remaining_appointments < 0) {
        return res.status(400).json({ error: 'Remaining appointments cannot be negative' })
      }
      updateData.remaining_appointments = body.remaining_appointments
    }

    if (body.start_time !== undefined) {
      updateData.start_time = body.start_time
    }

    if (body.end_time !== undefined) {
      updateData.end_time = body.end_time
    }

    // Validate time logic if both times are being updated
    if (updateData.start_time && updateData.end_time) {
      const startTime = new Date(updateData.start_time)
      const endTime = new Date(updateData.end_time)
      
      if (startTime >= endTime) {
        return res.status(400).json({ error: 'End time must be after start time' })
      }
    }

    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({ error: 'No valid fields to update' })
    }

    const { data, error } = await updateSlotQuery(updateData, timeslotId);

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    if (!data) {
      return res.status(404).json({ error: 'Time slot not found' })
    }

    return res.status(200).json({ 
      message: 'Time slot updated successfully',
      data 
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

// GET /slots/available - Get available slots for booking
export async function getAvailableSlots(req: Request, res: Response) {
  try {
    const { service_id, from_date, to_date } = req.query
    const role = (req as MiddlewareRequest).app_user.role

    const { data, error } = await availableSlotQuery({
      service_id: service_id as string,
      from_date: from_date as string || undefined,
      to_date: to_date as string || undefined,
      role : role
    })

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    return res.status(200).json({ 
      data,
      count: data?.length || 0
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}