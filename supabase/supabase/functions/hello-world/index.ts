import express, { Express, Request, Response } from 'express'

const app : Express= express()
app.use(express.json())

app.get('/hello-world', (_req: Request, res: Response) => {
  res.send('Hello World!')
})

app.post('/hello-world', (req: Request, res: Response) => {
  const { name } = req.body
  res.send(`Hello ${name}!`)
})

// Serve the Express app using Deno.serve
app.listen(3000, ()=>{
  console.log("CRUDS listening in at 3000")
})