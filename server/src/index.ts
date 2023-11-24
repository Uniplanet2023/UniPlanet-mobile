import mongoose from 'mongoose';
import dotenv from 'dotenv-safe';
import server from './app';
import { EmailSender, NodemailerEmailApi } from './utils';

dotenv.config({
	path: '.env.dev',
});
const PORT = process.env.PORT || 3000;

const emailSender = EmailSender.getInstance();

emailSender.activate();
emailSender.setEmailApi(new NodemailerEmailApi());

server.listen(PORT, async () => {
	console.log(`BackEnd Connection : BackEnd Server connected at port ${PORT}`);
	
	const res = await emailSender.sendSignUpVerificationEmail({
		toEmail:'test@test.com'
	})
	console.log(res);
	await mongoose.connect(process.env.MONGO_DB_HOST as string).then(() => {
		console.log('DB connection');
	});
});
