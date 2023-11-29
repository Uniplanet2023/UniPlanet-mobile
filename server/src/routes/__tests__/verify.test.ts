import request from 'supertest'
import app from '../../app'
import { SIGNUP_ROUTE, VERIFY_ROUTE } from '../route_defs'
import { EmailSender } from '../../utils'
import { MockEmailApi } from '../../test_util/mock_email_api'
import { AccountVerification, User } from '../../models'
import { generateEmailVerificationToken } from '../../utils/account_verification'
let validUserInfo = {
	email: '',
	profileImage: '',
	school: '',
	verified: false,
	name: '',
	password: '',
}
beforeEach(() => {
	const emailSender = EmailSender.getInstance()

	emailSender.activate()
	emailSender.setEmailApi(new MockEmailApi())
	jest.clearAllMocks()
})
describe('tests the email verification route', () => {
	beforeAll(() => {
		validUserInfo = {
			email: 'test1@stonybrook.edu',
			profileImage:
				'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
			school: 'Stony Brook University',
			verified: true,
			name: 'sije',
			password: 'TestPassword1!',
		}
	})
	it('should return a 422 if the provided email verification token is invalid', async () => {
		const response = await request(app).post(VERIFY_ROUTE).send({ emailVerificationToken: 'something' }).expect(500)

		expect(response.body).toStrictEqual({})
	})
	it('should return a 500 if the provided email verification token is not found', async () => {
		const response = await request(app)
			.post(VERIFY_ROUTE)
			.send({ emailVerificationToken: generateEmailVerificationToken() })
			.expect(500)
		expect(response.body).toStrictEqual({})
	})
	it('should mark the user as verified upon matching verification token', async () => {
		const signUpResponse = await request(app).post(SIGNUP_ROUTE).send(validUserInfo).expect(201)

		let user = await User.findOne({ email: signUpResponse.body.email })

		const verificationToken = await AccountVerification.findOne({
			userId: user!._id,
		})
		expect(verificationToken).not.toBe(null)

		await request(app).post(VERIFY_ROUTE).send({ emailVerificationToken: verificationToken!.emailVerificationToken })

		user = await User.findOne({ email: signUpResponse.body.email })

		expect(user!.verified).toEqual(true)
	})

	it('should send a 200 and successful verification status upon successful verification', async () => {
		const signUpResponse = await request(app).post(SIGNUP_ROUTE).send(validUserInfo).expect(201)

		const user = await User.findOne({ email: signUpResponse.body.email })

		const verificationToken = await AccountVerification.findOne({
			userId: user!._id,
		})
		expect(verificationToken).not.toBe(null)

		const response = await request(app)
			.post(VERIFY_ROUTE)
			.send({ emailVerificationToken: verificationToken!.emailVerificationToken })
			.expect(200)
		expect(response.body).toStrictEqual({})
	})
})
