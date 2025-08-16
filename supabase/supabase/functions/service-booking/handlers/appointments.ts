import type { Request, Response } from 'npm:@types/express@4.17.17'
import { MiddlewareRequest } from "../../_shared/middleware/auth.ts"
import { AppointmentCreateData } from "../../_shared/types.ts"
import { 
  createAppointmentQuery, 
  getAppointmentDetailsQuery,
  getAppointmentsQuery,
  getAppointmentByIdQuery,
  updateAppointmentStatusQuery,
  cancelAppointmentQuery,
  getCurrentAppointmentQuery,
  CreateAppointmentParams
} from "../queries/appointment.queries.ts"
import {
  checkAppointmentAccess,
  validateStatusUpdate,
  canUserCreateAppointment,
  buildAppointmentData,
  canUserUpdateAppointment
} from "../helpers/appointment.permissions.ts"
import {
  validateCreateAppointmentRequest,
  validateStatusValue,
  validateAppointmentUpdatePermissions,
  validateDateFilter,
  filterAppointmentsByDate
} from "../helpers/appointment.validation.ts"

export async function createAppointment(req: Request, res: Response) {
  try {
    const body: AppointmentCreateData = req.body
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user

    const validation = validateCreateAppointmentRequest(body, role)
    if (!validation.isValid) {
      return res.status(400).json({ error: validation.error })
    }

    if (!canUserCreateAppointment(role)) {
      return res.status(403).json({ error: 'Access denied' })
    }

    const appointmentResult = buildAppointmentData(body, role, userId)
    if (appointmentResult.error) {
      return res.status(400).json({ error: appointmentResult.error })
    }

    const { data: rpcResult, error: rpcError } = await createAppointmentQuery(appointmentResult.data! as unknown as CreateAppointmentParams)
    if (rpcError) {
      return res.status(500).json({ error: `Database error: ${rpcError.message}` })
    }

    if (!rpcResult.success) {
      return res.status(400).json({ error: rpcResult.error })
    }

    const { data: appointmentDetails, error: detailsError } = await getAppointmentDetailsQuery(rpcResult.appointment_id)
    if (detailsError || !appointmentDetails.success) {
      return res.status(201).json({ 
        message: 'Appointment created successfully',
        data: { appointment_id: rpcResult.appointment_id }
      })
    }

    return res.status(201).json({ 
      message: 'Appointment created successfully',
      data: appointmentDetails.data
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

export async function getAppointments(req: Request, res: Response) {
  try {
    const { status, service_id, date, limit = '50' } = req.query
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user

    const { data, error } = await getAppointmentsQuery({
      status: status as string,
      service_id: service_id as string,
      date: date as string,
      limit: limit as string,
      userRole: role,
      userId: userId
    })

    if (error) {
      return res.status(400).json({ error: error.message })
    }

    const dateRange = validateDateFilter(date as string)
    
    const filteredData = filterAppointmentsByDate(data || [], dateRange || [])
    return res.status(200).json({ 
      data: filteredData,
      count: filteredData?.length || 0
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

export async function getAppointmentById(req: Request, res: Response) {
  try {
    const { id: appointmentId } = req.params
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user

    const { data, error } = await getAppointmentByIdQuery(appointmentId)
    if (error) {
      return res.status(404).json({ error: 'Appointment not found' })
    }

    if (!checkAppointmentAccess(data, role, userId)) {
      return res.status(403).json({ error: 'Access denied' })
    }

    return res.status(200).json({ data })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}

export async function updateAppointmentStatus(req: Request, res: Response) {
  try {
    const { id: appointmentId } = req.params
    const { status } = req.body
    const mReq = req as MiddlewareRequest
    const { role, id: userId } = mReq.app_user

    const statusValidation = validateStatusValue(status)
    if (!statusValidation.isValid) {
      return res.status(400).json({ error: statusValidation.error })
    }

    const { data: currentAppointment, error: fetchError } = await getCurrentAppointmentQuery(appointmentId)
    if (fetchError || !currentAppointment) {
      return res.status(404).json({ error: 'Appointment not found' })
    }

    const updatePermission = canUserUpdateAppointment(currentAppointment, role, userId)
    if (!updatePermission.canUpdate) {
      return res.status(403).json({ error: updatePermission.error })
    }

    const updateValidation = validateAppointmentUpdatePermissions(currentAppointment, status, role, userId)
    if (!updateValidation.isValid) {
      return res.status(400).json({ error: updateValidation.error })
    }

    if (status === 'Canceled' && currentAppointment.status !== 'Canceled') {
      const { data: cancelResult, error: cancelError } = await cancelAppointmentQuery(appointmentId)
      if (cancelError) {
        return res.status(500).json({ error: `Database error: ${cancelError.message}` })
      }

      if (!cancelResult.success) {
        return res.status(400).json({ error: cancelResult.error })
      }

      const { data: updatedAppointment, error: _detailsError } = await getAppointmentDetailsQuery(appointmentId)
      return res.status(200).json({
        message: 'Appointment status updated successfully',
        data: updatedAppointment.success ? updatedAppointment.data : { appointment_id: appointmentId, status: 'Canceled' }
      })
    }

    const { data: updatedAppointment, error: updateError } = await updateAppointmentStatusQuery(appointmentId, status)
    if (updateError) {
      return res.status(400).json({ error: updateError.message })
    }

    return res.status(200).json({
      message: 'Appointment status updated successfully',
      data: updatedAppointment
    })
  } catch (_error) {
    return res.status(500).json({ error: 'Internal server error' })
  }
}