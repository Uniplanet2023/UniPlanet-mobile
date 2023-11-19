import express, { Request, Response } from 'express';
import bcryptjs from 'bcryptjs';
import { body, validationResult } from 'express-validator';
import User from '../../models/user';
import { SIGNUP_ROUTE } from '../route-defs';
import { sendMail, verifyOtp } from '../../middlewares/email_verify';

const signUpRouter = express.Router();
signUpRouter.post(
	SIGNUP_ROUTE,
	[
		body('email')
			.isEmail()
			.custom(async (value) => {
				const existingUser = await User.findOne({ email: value });
				if (existingUser) {
					throw new Error('User Already exist');
				}
			})
			.withMessage('Email must be in a valid format'),
		body('name').isString().withMessage('Name should be String'),
		body('password')
			.trim()
			.isLength({ min: 8 })
			.isStrongPassword()
			.withMessage('Password should be Strong Enough'),
		body('profileImage').isURL().withMessage('Profile Image should be URL'),
		body('school').isString().withMessage('School should be String'),
		body('verified')
			.isBoolean()
			.withMessage('verified should be boolean value'),
	],
	async (req: Request, res: Response) => {
		const errors = validationResult(req);
		try {
			// logStart('Sign Up User API');
			if (!errors.isEmpty()) {
				res.status(422).send({});
				return;
			}

			const { name, email, password, profileImage, school, verified } =
				req.body;

			// console.log('1. Finding Existing User');
			// const existingUser = await User.findOne({ email });

			// // console.log('2. Generate Hash Password');
			const hashedPassword = await bcryptjs.hash(password, 8);
			// // console.log('3. Creating User Model');
			let user = new User({
				email,
				password: hashedPassword,
				name,
				profileImage,
				school,
				verified,
			});
			// // console.log('4. Save User into DB');
			user = await user.save();
			res.json(user);
			// logEnd('Sign Up User API');
			// res.send({'pass':'pass'});
		} catch (e) {
			res.status(422).send({});
			// handleError(res, e as Error);
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

signUpRouter.all(`${SIGNUP_ROUTE}*`, (req, res) => {
	res.status(405).send({});
});

export default signUpRouter;
