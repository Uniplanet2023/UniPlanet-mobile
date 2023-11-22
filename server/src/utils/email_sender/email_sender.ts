import {
	EmailApiSendEmailArgs,
	EmailApiSendEmailResponse,
	IEmailSender,
	EmailSenderEmailApi,
} from './types';

export default class EmailSender implements IEmailSender {
	private isActive = false;

	private emailApi: EmailSenderEmailApi | undefined;

	private static emailSenderInstance: EmailSender;

	private constructor() {
		//op-no
	}

	static getInstance(): EmailSender {
		if (!this.emailSenderInstance) {
			this.emailSenderInstance = new EmailSender();
		}

		return this.emailSenderInstance;
	}

	static resetEmailSenderInstance(): void {
		this.emailSenderInstance = new EmailSender();
	}

	deactivate(): void {
		this.isActive = false;
	}

	activate(): void {
		this.isActive = true;
	}

	setEmailApi(emailApi: EmailSenderEmailApi): void {
		this.emailApi = emailApi;
	}

	async sendSignUpVerificationEmail(
		args: EmailApiSendEmailArgs,
	): Promise<EmailApiSendEmailResponse> {
		this.validateEmailSender();

		return this.emailApi!.sendSignUpVerificationEmail(args);
	}

	private validateEmailSender() {
		if (!this.isActive) {
			throw new Error('EmailSender is not active');
		}
		if (!this.emailApi) {
			throw new Error('EmailApi is not set');
		}
	}
}
