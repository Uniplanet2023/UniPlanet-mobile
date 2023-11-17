import express from 'express';
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/user';
import auth from '../middlewares/auth';
import * as redis_controller from '../redis_controller/redis_controller';
import * as mail_verify from '../middlewares/email_verify';
import { logStart, logEnd, handleError } from '../functions/logFunction';
import { signInFunction } from '../functions/userdata';

const authRouter = express.Router();

// SIGN UP
authRouter.post('/api/signup', async (req, res) => {
  try {
    logStart('Sign Up User API');

    const { name, email, password, profileImage, school, verified } = req.body;
    console.log('1. Finding Existing User');
    const existingUser = await User.findOne({ email });

    if (existingUser) {
      console.log('2. User Exists!');
      return res
        .status(400)
        .json({ msg: 'User with same email already exists!' });
    }
    console.log('2. Generate Hash Password');
    const hashedPassword = await bcryptjs.hash(password, 8);
    console.log('3. Creating User Model');
    let user = new User({
      email,
      password: hashedPassword,
      name,
      profileImage,
      school,
      verified,
    });
    console.log('4. Save User into DB');
    user = await user.save();
    res.json(user);
    logEnd('Sign Up User API');
  } catch (e) {
    handleError(res, e as Error);
  }
});

authRouter.post('api/delete-user', auth, async (req, res) => {
  try {
    logStart('Delete User API');
    console.log('1. Find User and Delete is triggered');
    await User.findByIdAndDelete(req.user);
    console.log('2. Account Successfully Deleted');
    res.status(200).json('Account Successfully Deleted');
    logEnd('Delete User API');
  } catch (e) {
    handleError(res, e as Error);
  }
});

authRouter.post('api/password-update', async (req, res) => {
  try {
    logStart('Password Update API');

    const hashedPassword = await bcryptjs.hash(
      req.body.password,
      process.env.SECRET_PASS_KEY as string
    );

    const updateUser = await User.findByIdAndUpdate(
      req.body.id,
      {
        $password: req.body.password,
      },
      { new: true }
    );

    res.status(200).json(updateUser);
    logEnd('Password Update API');
  } catch (e) {
    handleError(res, e as Error);
  }
});
// Sign In Route
authRouter.post('/api/signin', async (req, res) => {
  try {
    logStart('Sign In API');

    const { email, password } = req.body;

    const user = await signInFunction(email);

    if (!user) {
      return res
        .status(400)
        .json({ msg: 'User with this email does not exist!' });
    }

    const isMatch = await bcryptjs.compare(password, user.password);

    if (!isMatch) {
      console.log('1. Incorrect Password');
      return res.status(400).json({ msg: 'Incorrect password.' });
    }

    console.log('1. Correct Password');
    console.log('2. Generate Token');
    const token = jwt.sign({ id: user._id }, 'passwordKey');

    console.log("3. Set the user's online status to true");
    console.log('4. Store User Data into Redis');
    redis_controller.set(user._id, user);
    const userObject = user.toObject();
    res.json({ token, ...userObject });
    logEnd('Sign In API');
  } catch (e) {
    handleError(res, e as Error);
  }
});

authRouter.post('/tokenIsValid', async (req, res) => {
  try {
    console.log(
      '\x1b[32m----------------- Auth API : Tocken valid API triggerd -----------------\x1b[0m'
    );
    const token = req.header('x-auth-token');
    if (!token) return res.json(false);
    console.log('1. Tocken is Existed');
    const verified = jwt.verify(token, 'passwordKey');
    if (!verified) return res.json(false);
    console.log('2. Tocken is Valid');

    console.log('3. Serach Tocket from database');
    const user = await User.findById(verified);

    if (!user) return res.json(false);
    console.log("4. Set the user's online status to true");
    await user.save();
    console.log('5. User is Existed');

    res.json(true);
    console.log(
      '\x1b[32m----------------- Auth API : Tocken valid API is Successfully completed -----------------\x1b[0m'
    );
    console.log('');
  } catch (e) {
    handleError(res, e as Error);
  }
});

authRouter.post('/api/sendOtp', async (req, res) => {
  try {
    const { user_email, name } = req.body;
    const existingUser = await User.findOne({ user_email });

    if (existingUser) {
      console.log('User Exists!');
      return res
        .status(200)
        .json({ message: 'User with same email already exists!' });
    }

    const mail_result = await mail_verify.send_mail({ user_email, name });

    res.status(200).json({ message: 'Success', hash: mail_result });
  } catch (error) {
    res.status(400).json({ message: 'Error while sending OTP', error: error });
  }
});

authRouter.post('/api/verifyOtp', async (req, res) => {
  try {
    let result = await mail_verify.verify_otp(req.body);
    if (result == 'Success') {
      res.status(200).json({ message: result });
    } else if (result == 'Verfication number expired, Try signing in again') {
      res.status(200).json({ message: result });
    } else if (result == 'Invalid Verfication number') {
      res.status(200).json({ message: result });
    }
  } catch (error) {
    res.status(400).json({ message: 'Error while sending OTP', data: error });
  }
});

authRouter.put('/api/forgottenPassword', async (req, res) => {
  try {
    const { email } = req.body;
    console.log(email);
    const existingUser = await User.findOne({ email });

    if (!existingUser) {
      console.log('User Exists!');
      return res
        .status(200)
        .json({ message: "User with the given email address doesn't exists!" });
    }

    const send_reset_password = await mail_verify.send_reset_password(email);
    const hashedPassword = await bcryptjs.hash(
      send_reset_password as string,
      8
    );

    console.log(send_reset_password);
    console.log(hashedPassword);

    existingUser.password = hashedPassword;

    const updatedUser = await existingUser.save();

    return res.status(200).json({ message: 'Password updated successfully' });
  } catch (error) {
    return res.status(400).json({ message: 'Something went wrong' });
  }
});

export default authRouter;
