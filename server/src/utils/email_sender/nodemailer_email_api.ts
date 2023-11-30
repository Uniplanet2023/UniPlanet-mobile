import Mail from 'nodemailer/lib/mailer'
import {
	EmailApiSendEmailArgs,
	EmailApiSendEmailResponse,
	EmailApi,
	EmailApiSendSignUpVerificationEmailArgs,
} from './types'
import nodemailer from 'nodemailer'
import NodemailerSmtpServer from './nodemailer_app_smtp_server'
import { otpGenerate } from '../account_verification/otp_generater'

export type BuildEmailVerificationLinkArgs = {
	emailVerificationToken: string
}
export type BuildSignUpVerificationEmailTextArgs = {
	name: string
	otpCode: string
}
export default class NodemailerEmailApi implements EmailApi {
	private transporter: Mail

	private smtpServer: NodemailerSmtpServer

	constructor() {
		this.smtpServer = new NodemailerSmtpServer()
		this.transporter = nodemailer.createTransport(this.smtpServer.getConfig() as nodemailer.SendMailOptions)
	}

	async sendSignUpVerificationEmail(args: EmailApiSendSignUpVerificationEmailArgs): Promise<EmailApiSendEmailResponse> {
		const { name, toEmail } = args

		const [otpCode, fullHash] = otpGenerate(toEmail)
		console.log(`otpCode is ${otpCode}`)
		console.log(`fullHash is ${fullHash}`)
		const subject = `Welcome to Uniplanet, ${name}! Please verify your email address`
		const textBody = this.buildSignUpVerificationEmailTextBody({
			name,
			otpCode,
		})
		const htmlBody = this.buildSignUpVerificationEmailHtmlBody({
			name,
			otpCode,
		})

		await this.sendEmail({
			toEmail,
			subject,
			textBody,
			htmlBody,
		})

		return {
			toEmail,
			status: 'success',
			hash: fullHash,
		}
	}

	private buildSignUpVerificationEmailTextBody = (args: BuildSignUpVerificationEmailTextArgs): string => {
		const { name, otpCode } = args
		return `Welcome to UniPlanet the coolest resell market platform!
		Hi ${name}, Please verify your email address using the following verification code: ${otpCode}.
		\nThe verification code is valid for 5 minutes. Please complete the verification as soon as possible.`
	}

	private buildSignUpVerificationEmailHtmlBody = (args: BuildSignUpVerificationEmailTextArgs): string => {
		const { name, otpCode } = args
		return `<h2>Welcome to UniPlanet the coolest resell market platform!</h2>
		<br> Hi ${name}, Please verify your email address using the following verification code: ${otpCode}.
		<br/><br/>
		The verification code is valid for 5 minutes. Please complete the verification as soon as possible.`
	}

	private async sendEmail(args: EmailApiSendEmailArgs): Promise<void> {
		const { toEmail, subject, htmlBody, textBody } = args
		const accessToken = await this.smtpServer.getAccessToken()
		await this.transporter.sendMail({
			from: 'UniPlanet ✉️ <noreply@uniplanet.com>',
			to: toEmail,
			subject,
			text: textBody,
			html: htmlBody,
			auth: {
				accessToken: accessToken,
			},
		} as nodemailer.SendMailOptions)
	}
}
