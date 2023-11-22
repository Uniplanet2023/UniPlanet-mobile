import mongoose from 'mongoose';
import dotenv from 'dotenv-safe';
import app from './app';
import { EmailSender, NodemailerEmailApi } from './utils';

dotenv.config({});

const emailSender = EmailSender.getInstance();
emailSender.activate();
emailSender.setEmailApi(new NodemailerEmailApi());
const PORT = process.env.PORT || 3000;

mongoose.connect(process.env.MONGO_DB_HOST as string).then(() => {});

app.listen(PORT, () => {
	console.log(`BackEnd Connection : BackEnd Server connected at port ${PORT}`);
});
