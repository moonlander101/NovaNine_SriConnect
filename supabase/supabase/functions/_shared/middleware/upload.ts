import type { Request, Response, NextFunction } from "npm:express"
import {
  parseMultipartRequest,
  MultipartParseError
} from "npm:@mjackson/multipart-parser/node"

interface MultipartRequest extends Request {
  body: Record<string, string | File>
  files: File[]
}

export function multipartParser() {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {    
        const contentType = req.headers["content-type"] || ""
        if (!contentType.startsWith("multipart/form-data")) {
            console.log("No multipart data, skipping")
            return next()
        }

        console.log("Processing multipart request")
        const mReq = req as MultipartRequest
        mReq.body = mReq.body || {}
        mReq.files = []

        for await (const part of parseMultipartRequest(req)) {
            if (part.isFile && part.filename) {
                const bytes = part.bytes
                const file = new File([bytes], part.filename, {
                    type: part.mediaType || "application/octet-stream"
                })
                
                mReq.files.push(file)
                if (part.name) {
                    mReq.body[part.name] = file
                }
            } else {
                if (part.name) {
                    mReq.body[part.name] = part.text
                }
            }
        }
        console.log(`Parsed ${mReq.files.length} files and ${Object.keys(mReq.body).length} fields`)
        next()
    } catch (err) {
        console.error("Multipart parsing error:", err)
        if (err instanceof MultipartParseError) {
            res.status(400).send(`Error: ${err.message}`)
        } else {
            next(err)
        }
    }
  }
}