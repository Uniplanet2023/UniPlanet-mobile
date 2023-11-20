import express from 'express';
import {User} from '../../models/index';
import auth from '../../middlewares/auth';
import { logStart, logEnd, handleError } from '../../functions/logFunction';

const deleteUserRoute = express.Router();

deleteUserRoute.post('api/delete-user', auth, async (req, res) => {
	try {
		logStart('Delete User API');
		console.log('1. Find User and Delete is triggered');
		await User.findByIdAndDelete(req.user);
		console.log('2. Account Successfully Deleted');
		res.status(200).json('Account Successfully Deleted');
		logEnd('Delete User API');
	} catch (e) {
		handleError(res, e as Error);
	}
});
export default deleteUserRoute;
