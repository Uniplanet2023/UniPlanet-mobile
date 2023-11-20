import express from 'express';
import signUpRoute from './signUp';
import signInRoute from './signIn';
import deleteUserRoute from './deleteUser';
import updateUserRoute from './updateUser';

const authRouter = express.Router();

authRouter.use(deleteUserRoute);
authRouter.use(signUpRoute);
authRouter.use(signInRoute);
authRouter.use(updateUserRoute);

export default authRouter;
