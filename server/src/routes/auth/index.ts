import express from 'express';
import signUpRoute from './sign_up';
import signInRoute from './sign_in';
import deleteUserRoute from './delete_user';
import updateUserRoute from './update_user';

const authRouter = express.Router();

authRouter.use(deleteUserRoute);
authRouter.use(signUpRoute);
authRouter.use(signInRoute);
authRouter.use(updateUserRoute);

export default authRouter;
