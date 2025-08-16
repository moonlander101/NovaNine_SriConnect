import {type Request, type Response, type NextFunction} from "express"
import { extractUserToken, getUserAppData, getUserFromToken } from "../../_shared/supabaseClient.ts";
import { User } from 'npm:@supabase/supabase-js'

export interface AppUser {
  id: string
  role: string
  fullName: string
}

export interface MiddlewareRequest extends Request {
  auth_user: User
  app_user: AppUser
}

export async function requireAuth(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const mReq = req as MiddlewareRequest

  const token = extractUserToken(req)
  if (!token) {
    return res.status(401).json({ error: 'Authentication required' })
  }

  const { user: authUser, error: userError } = await getUserFromToken(token)
  if (userError || !authUser) {
    return res.status(401).json({ error: 'Invalid token' })
  }

  const { role, userId, fullName, error: roleError } = await getUserAppData(token, authUser.id)
  if (roleError || !role || !userId) {
    return res.status(500).json({ error: 'Failed to get user role' })
  }

  mReq.auth_user = authUser
  mReq.app_user = {
    id: userId,
    role,
    fullName: fullName || ''
  }

  next()
}