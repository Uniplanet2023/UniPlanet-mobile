import express, { Request, Response } from 'express'
import jwt from 'jsonwebtoken'
import { User } from '../../models/index'
import { PasswordHash } from '../../utils'
import { SIGNIN_ROUTE } from '../route_defs'
import { validationResult } from 'express-validator'
import { InvalidInput } from '../../errors'
const signInRoute = express.Router()

// Sign In Route
signInRoute.post(SIGNIN_ROUTE, async (req, res) => {
	const { email, password } = req.body
	const user = await User.findOne({ email })

	if (!user) {
		return res.status(400).json({ msg: 'User with this email does not exist!' })
	}
	if (!user.verified) {
		return res.status(400).json({ msg: 'User Should be verified!' })
	}

	const isMatch = PasswordHash.compareSync({ providedPassword: password, storedPassword: user.password })

	if (!isMatch) {
		res.status(400).json({ msg: 'Incorrect password.' })
		return
	}
	const userInfo = { id: user._id, name: user.name }
	const secretKey = process.env.JWT_TOKEN_SECRET as string
	const options = { expiresIn: '10d', issuer: 'UniPlanet', subject: 'userInfo' }
	const token = jwt.sign(userInfo, secretKey, options)

	const userData = user.toObject()
	res.json({ token, ...userData })
})

signInRoute.post(`${SIGNIN_ROUTE}/tokenIsValid`, async (req: Request, res: Response) => {
	const errors = validationResult(req).array()

	if (errors.length > 0) throw new InvalidInput()

	const token = req.header('x-auth-token')

	const verified = jwt.verify(token!, process.env.JWT_TOKEN_SECRET as string) as { id: string }

	if (!verified) {
		return res.json(false)
	}

	const user = await User.findById(verified.id)

	if (!user) {
		return res.json(false)
	}

	return res.json(true)
})

export default signInRoute
