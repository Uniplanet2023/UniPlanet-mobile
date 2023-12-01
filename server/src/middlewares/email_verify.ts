/*
verifies incoming request to check validity of email address
receive OTP number emailed to user, Hashed value of (user email + OTP code + expiry time)
Hashed email, otp Code and expiry date and compares with recieved Hash value to determine
validity of the user's email account
*/
const verifyOtp = async (params: VerifyOtpParams) => {
	const [otpHash, expires] = params.otpHash.split('.')
	const now = Date.now()

	// checking if OTP received is expired before continuing
	if (now > parseInt(expires, 10)) {
		const notice = 'OTP expired'
		return notice
	}

	const data = `${params.email}.${params.otpCode}.${expires}`

	const newCalculatedHash = crypto.createHmac('sha256', key).update(data).digest('hex')

	if (otpHash === newCalculatedHash) {
		return 'Success'
	}
	return 'Invalid Verfication number'
}

/*
Generates a 7 character password to be used for forgotten passwords
*/
const generatePassword = () => {
	const password = otpGenerator.generate(7, {
		digits: true,
		upperCaseAlphabets: true,
		lowerCaseAlphabets: true,
		specialChars: true,
	})
	return password
}

/*
Sends a generated 7 character password to the email address of the user using Nodemailer
*/
const sendResetPassword = async (userEmail: string): Promise<string | Error> => {
	try {
		const accessToken = await oAuth2Client.getAccessToken()

		const transporter = nodemailer.createTransport({
			host: 'smtp.gmail.com',
			port: 465,
			secure: true,
			auth: {
				type: 'OAuth2',
				clientId: CLIENT_ID,
				clientSecret: CLIENT_SECRET,
			},
		})

		const tempPassword = generatePassword()

		transporter.sendMail({
			from: 'UniPlanet ✉️ <uniplanet.info@gmail.com>',
			to: userEmail,
			subject: `Your New Password`,
			text: `
      We've received a request to reset your password for your Uniplanet Marketplace account.
      To make it easier for you, we've generated a temporary password that you can use to log in immediately.

      Temporary Password: ${tempPassword}

      Please use this temporary password to log in to your Uniplanet Marketplace account. We highly recommend changing this temporary password to your preferred one after you log in for security reasons.
      `,
			auth: {
				user: 'uniplanet.info@gmail.com',
				refreshToken: REFRESH_TOKEN,
				accessToken,
			},
		} as nodemailer.SendMailOptions)

		return tempPassword
	} catch (error) {
		return error as string
	}
}

export { otpGenerate, verifyOtp, generatePassword, sendResetPassword }
