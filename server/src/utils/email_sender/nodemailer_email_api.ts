import Mail from 'nodemailer/lib/mailer';
import {
	EmailApiSendEmailArgs,
	EmailApiSendEmailResponse,
	EmailApi,
	EmailApiSendSignUpVerificationEmailArgs,
} from './types';
import nodemailer from 'nodemailer';
import NodemailerSmtpServer from './nodemailer_app_smtp_server';
export type BuildEmailVerificationLinkArgs = {
	emailVerificationToken:string;
}
export type BuildSignUpVerificationEmailTextArgs = {
	emailVerificationLink: string;
}
export default class NodemailerEmailApi implements EmailApi {
	private transporter: Mail;

	constructor() {
		this.transporter = nodemailer.createTransport(
			new NodemailerSmtpServer().getConfig(),
		);
	}

	async sendSignUpVerificationEmail(
		args: EmailApiSendSignUpVerificationEmailArgs,
	): Promise<EmailApiSendEmailResponse> {
		const { toEmail, emailVerificationToken, } = args;

		const emailVerificationLink = this.buildEmailVerificationLink({
			emailVerificationToken
		})

		const subject = 'Welcom to Uniplanet! Please verify your email address';
		const textBody = this.buildSignUpVerificationEmailTextBody({emailVerificationLink});
		const htmlBody = this.buildSignUpVerificationEmailHtmlBody({emailVerificationLink});

		await this.sendEmail({
			toEmail,
			subject,
			textBody,
			htmlBody,
		});

		return {
			toEmail,
			status: 'success',
		};
	}
	private buildEmailVerificationLink = (args:BuildEmailVerificationLinkArgs):string =>{
		const {emailVerificationToken}  = args;
		//TODO: this url will change once we integrate kubernetes in our application
		return `https://localhost:3000/api/auth/verify/${emailVerificationToken}`;
	}
	private buildSignUpVerificationEmailTextBody= (args:BuildSignUpVerificationEmailTextArgs):string =>{
		const {emailVerificationLink } = args;
		return `Welcome to UniPlanet the coolest resell market platform! Please click on the link below to verify your email address${emailVerificationLink}`;
	}
	private buildSignUpVerificationEmailHtmlBody= (args:BuildSignUpVerificationEmailTextArgs):string =>{
		const {emailVerificationLink } = args;
		return `<h1>Welcome to UniPlanet </h1>
		<br/>the coolest resell market platform!
		<br/><br/>
		Please click on the link below to verify your email address<a href="${emailVerificationLink}">${emailVerificationLink}</a>`;
	}
	private async sendEmail(args: EmailApiSendEmailArgs): Promise<void> {
		const { toEmail,subject,htmlBody,textBody } = args;
		await this.transporter.sendMail({
			from: 'UniPlanet <noreply@uniplanet.com>',
			to: toEmail,
			subject,
			text: textBody,
			html:htmlBody
		});
	}
}
