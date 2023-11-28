import { Response, Request, NextFunction } from 'express'
import { BaseCustomError } from '../errors'
const errorHandler = (err: Error, req: Request, res: Response, _next: NextFunction): Response => {
	if (err instanceof BaseCustomError) {
		res.sendStatus(err.getStatusCode()).send(err.serializeErrorOutput())
	}
	return res.sendStatus(500)
}
export default errorHandler
