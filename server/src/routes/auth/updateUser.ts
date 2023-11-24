import express from 'express';
// import bcryptjs from 'bcryptjs';
import { User } from '../../models/index';
import auth from '../../middlewares/auth';
import { sendResetPassword } from '../../middlewares/email_verify';
import { logStart, logEnd, handleError } from '../../functions/logFunction';

const updateUserRoute = express.Router();

updateUserRoute.post('api/password-update', auth, async (req, res) => {
	try {
		logStart('Password Update API');

		// const hashedPassword = await bcryptjs.hash(
		// 	req.body.password,
		// 	process.env.SECRET_PASS_KEY as string,
		// );
		const hashedPassword = '';

		const updateUser = await User.findByIdAndUpdate(
			req.body.id,
			{
				$password: hashedPassword,
			},
			{ new: true },
		);

		res.status(200).json(updateUser);
		logEnd('Password Update API');
	} catch (e) {
		handleError(res, e as Error);
	}
});

updateUserRoute.put('/api/forgottenPassword', async (req, res) => {
	try {
		const { email } = req.body;
		console.log(email);
		const existingUser = await User.findOne({ email });

		if (!existingUser) {
			console.log('User Exists!');
			res
				.status(200)
				.json({ message: "User with the given email address doesn't exists!" });
			return;
		}

		const ResetPassword = await sendResetPassword(email);
		const hashedPassword = '';

		console.log(ResetPassword);
		console.log(hashedPassword);

		existingUser.password = hashedPassword;

		await existingUser.save();

		res.status(200).json({ message: 'Password updated successfully' });
	} catch (error) {
		res.status(400).json({ message: 'Something went wrong' });
	}
});

export default updateUserRoute;
