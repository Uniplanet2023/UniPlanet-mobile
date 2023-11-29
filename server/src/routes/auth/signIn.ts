import express from 'express'
// import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken'
import { User } from '../../models/index'
import { set } from '../../redis_controller/redis_controller'
import { logStart, logEnd, handleError } from '../../functions/log_function'
import { signInFunction } from '../../functions/user_data'
const signInRoute = express.Router()

// Sign In Route
signInRoute.post('/api/signin', async (req, res) => {
	try {
		logStart('Sign In API')

		// const { email, password } = req.body;
		const { email } = req.body
		const user = await signInFunction(email)

		if (!user) {
			res.status(400).json({ msg: 'User with this email does not exist!' })
			return
		}

		// const isMatch = await bcryptjs.compare(password, user.password);

		// if (!isMatch) {
		// 	console.log('1. Incorrect Password');
		// 	res.status(400).json({ msg: 'Incorrect password.' });
		// 	return;
		// }

		console.log('1. Correct Password')
		console.log('2. Generate Token')
		const token = jwt.sign({ id: user._id }, 'passwordKey')

		console.log("3. Set the user's online status to true")
		console.log('4. Store User Data into Redis')
		set(user._id.toString(), user)
		const userObject = user.toObject()
		res.json({ token, ...userObject })
		logEnd('Sign In API')
	} catch (e) {
		handleError(res, e as Error)
	}
})

signInRoute.post('/tokenIsValid', async (req, res) => {
	try {
		console.log('\x1b[32m----------------- Auth API : Tocken valid API triggerd -----------------\x1b[0m')
		const token = req.header('x-auth-token')
		if (!token) {
			res.json(false)
			return
		}
		console.log('1. Tocken is Existed')
		const verified = jwt.verify(token, 'passwordKey')
		if (!verified) {
			res.json(false)
			return
		}
		console.log('2. Tocken is Valid')

		console.log('3. Serach Tocket from database')
		const user = await User.findById(verified)

		if (!user) {
			res.json(false)
			return
		}
		console.log("4. Set the user's online status to true")
		await user.save()
		console.log('5. User is Existed')

		res.json(true)
		console.log(
			'\x1b[32m----------------- Auth API : Tocken valid API is Successfully completed -----------------\x1b[0m',
		)
		console.log('')
	} catch (e) {
		handleError(res, e as Error)
	}
})

export default signInRoute
