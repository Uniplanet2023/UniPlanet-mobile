import express, { Request, Response } from 'express';
import bcryptjs from 'bcryptjs';
import { validationResult } from 'express-validator';
import User from '../../models/user';
import { SIGNUP_ROUTE } from '../route-defs';
import { sendMail, verifyOtp } from '../../middlewares/email_verify';
import {signUpValidation} from '../validations/signUpValidation';
const signUpRouter = express.Router();
signUpRouter.post(
	SIGNUP_ROUTE,
	signUpValidation,
	async (req: Request, res: Response) => {
		const errors = validationResult(req);
		try {
			// logStart('Sign Up User API');
			if (!errors.isEmpty()) {
				console.log('here');
				return res.status(422).send({});
				
			}

			const { name, email, password, profileImage, school, verified } =
				req.body;

			const hashedPassword = await bcryptjs.hash(password, 8);
			
			let user = new User({
				email,
				password: hashedPassword,
				name,
				profileImage,
				school,
				verified,
			});
			
			user = await user.save();
			res.json(user);
		} catch (error) {
			res.status(422).send({});
		}
	},
);

signUpRouter.post(`${SIGNUP_ROUTE}/sendOtp`, async (req, res) => {
	try {
		const { userEmail, name } = req.body;
		const existingUser = await User.findOne({ userEmail });

		if (existingUser) {
			console.log('User Exists!');
			res.status(200).json({ message: 'User with same email already exists!' });
			return;
		}

		const mailResult = await sendMail({ userEmail, name });

		res.status(200).json({ message: 'Success', hash: mailResult });
	} catch (error) {
		res.status(400).json({ message: 'Error while sending OTP', error });
	}
});

signUpRouter.post(`${SIGNUP_ROUTE}/verifyOtp`, async (req, res) => {
	try {
		const result = await verifyOtp(req.body);
		if (result === 'Success') {
			res.status(200).json({ message: result });
		} else if (result === 'OTP expired') {
			res.status(200).json({ message: result });
		} else if (result === 'Invalid Verfication number') {
			res.status(200).json({ message: result });
		}
	} catch (error) {
		res.status(400).json({ message: 'Error while sending OTP', data: error });
	}
});

export default signUpRouter;
