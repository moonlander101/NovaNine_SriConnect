import {type Request} from "express"

export const extractUserToken = (req: Request): string | null => {
  const authHeader = req.get('Authorization') || req.headers.authorization
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return null
  }
  return authHeader.substring(7)
}