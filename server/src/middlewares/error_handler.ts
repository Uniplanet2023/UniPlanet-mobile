import { Response, Request, NextFunction } from 'express';
import { BaseCustomError } from '../errors/base_custom_error';
const errorHandler = (
	err: Error,
	req: Request,
	res: Response,
	next: NextFunction,
): Response => {
	if (err instanceof BaseCustomError) {
		return res.sendStatus(err.getStatusCode());
	}
	return res.sendStatus(500);
};
export default errorHandler;
