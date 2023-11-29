import express from 'express'
import signUpRouter from './signup'
import verifyRouter from './verify'
import signInRoute from './signin'
import deleteUserRoute from './delete_user'
import updateUserRoute from './update_user'

const authRouter = express.Router()
authRouter.use(verifyRouter)
authRouter.use(deleteUserRoute)
authRouter.use(signUpRouter)
authRouter.use(signInRoute)
authRouter.use(updateUserRoute)

export default authRouter
