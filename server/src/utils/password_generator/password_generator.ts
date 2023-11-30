import otpGenerator from 'otp-generator'

export const generatePassword = () => {
	const password = otpGenerator.generate(7, {
		digits: true,
		upperCaseAlphabets: true,
		lowerCaseAlphabets: true,
		specialChars: true,
	})
	return password
}
