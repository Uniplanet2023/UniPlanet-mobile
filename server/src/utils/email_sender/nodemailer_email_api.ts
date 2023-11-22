import Mail from 'nodemailer/lib/mailer';
import {
	EmailApiSendEmailArgs,
	EmailApiSendEmailResponse,
	IEmailSender,
	EmailSenderEmailApi,
} from './types';
import nodemailer from 'nodemailer';

export default class NodemailerEmailApi extends EmailSenderEmailApi {
	private transporter: Mail;

	constructor() {
		super();
		this.transporter = nodemailer.createTransport({
			host: 'localhost',
			port: 1025,
			auth: {
				user: 'project.1',
				pass: 'secret.1',
			},
		});
	}
	async sendSignUpVerificationEmail(
		args: EmailApiSendEmailArgs,
	): Promise<EmailApiSendEmailResponse> {
		await this.sendEmail({
			toEmail: 'test@test.com',
		});

		return {
			toEmail: 'test@test.com',
			status: 'success',
		};
	}
	protected async sendEmail(args: EmailApiSendEmailArgs): Promise<void> {
		const { toEmail } = args;
		const res = this.transporter.sendMail({
			from: 'noreply@uniplanet.com',
			to: 'test@test.com',
			subject: `Hello, Your UniPlanet Marketplace verification code`,
			text: `This is our first test email`,
		});
		console.log(res);
	}
}
