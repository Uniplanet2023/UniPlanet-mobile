import express, { Request, Response } from 'express'
import { validationResult } from 'express-validator'
import { User } from '../../models/index'
import { SIGNUP_ROUTE } from '../route_defs'
import { verifyOtp } from '../../middlewares/email_verify'
import {
	emailValidation,
	nameValidation,
	passwordValidation,
	profileImageValidation,
	schoolValidation,
	verifiedValidation,
} from '../../validations/signup_validation'
import { DuplicatedEmail, InvalidInput } from '../../errors'
import { UserSignedUp } from '../../events'
import { EmailSender } from '../../utils'

const signUpRouter = express.Router()
signUpRouter.post(
	SIGNUP_ROUTE,
	[
		emailValidation,
		nameValidation,
		profileImageValidation,
		schoolValidation,
		verifiedValidation,
		...passwordValidation,
	],
	async (req: Request, res: Response) => {
		const errors = validationResult(req).array()

		if (errors.length > 0) throw new InvalidInput()

		const { name, email, password, profileImage, school, type } = req.body

		let user = await User.findOne({ email: email })
		if (user) {
			if (user.verified) {
				throw new DuplicatedEmail()
			}
		} else {
			user = await User.create({
				email,
				password,
				name,
				profileImage,
				school,
				type,
			})
		}

		const userSignedUp = await new UserSignedUp(user)
		const emailSender = EmailSender.getInstance()
		const { status, hash } = await emailSender.sendSignUpVerificationEmail({
			name: user.name,
			toEmail: user.email,
		})

		return res.status(userSignedUp.getStatusCode()).json({ status, hash, ...userSignedUp.serializeRest() })
	},
)

signUpRouter.post(`${SIGNUP_ROUTE}/verifyOtp`, async (req, res) => {
	try {
		const result = await verifyOtp(req.body)
		if (result === 'Success') {
			res.status(200).json({ message: result })
		} else if (result === 'OTP expired') {
			res.status(200).json({ message: result })
		} else if (result === 'Invalid Verfication number') {
			res.status(200).json({ message: result })
		}
	} catch (error) {
		res.status(400).json({ message: 'Error while sending OTP', data: error })
	}
})

export default signUpRouter
