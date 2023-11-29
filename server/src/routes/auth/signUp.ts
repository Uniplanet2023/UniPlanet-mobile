import express, { Request, Response } from 'express'
import { validationResult } from 'express-validator'
import { AccountVerification, User } from '../../models/index'
import { SIGNUP_ROUTE } from '../route_defs'
import { sendMail, verifyOtp } from '../../middlewares/email_verify'
import {
	emailValidation,
	nameValidation,
	passwordValidation,
	profileImageValidation,
	schoolValidation,
	verifiedValidation,
} from '../../validations/signup_validation'
import { InvalidInput } from '../../errors'
import { UserSignedUp } from '../../events'
import { EmailSender } from '../../utils'
import { generateEmailVerificationToken } from '../../utils/account_verification'

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

		const { name, email, password, profileImage, school, verified } = req.body

		const newUser = await User.create({
			email,
			password,
			name,
			profileImage,
			school,
			verified,
		})
		const emailVerificationToken = generateEmailVerificationToken()
		const accountVerification = await AccountVerification.create({
			userId: newUser._id,
			emailVerificationToken,
		})

		const userSignedUp = await new UserSignedUp(newUser)
		const emailSender = EmailSender.getInstance()
		emailSender.sendSignUpVerificationEmail({
			toEmail: newUser.email,
			emailVerificationToken: accountVerification.emailVerificationToken,
		})

		return res.status(userSignedUp.getStatusCode()).json(userSignedUp.serializeRest())
	},
)

signUpRouter.post(`${SIGNUP_ROUTE}/sendOtp`, async (req, res) => {
	try {
		const { userEmail, name } = req.body
		const existingUser = await User.findOne({ userEmail })

		if (existingUser) {
			console.log('User Exists!')
			res.status(200).json({ message: 'User with same email already exists!' })
			return
		}

		const mailResult = await sendMail({ userEmail, name })

		res.status(200).json({ message: 'Success', hash: mailResult })
	} catch (error) {
		res.status(400).json({ message: 'Error while sending OTP', error })
	}
})

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
