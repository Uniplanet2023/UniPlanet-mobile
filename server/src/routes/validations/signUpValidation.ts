import { body} from 'express-validator';
import {User} from '../../models/index';
export const signUpValidation = [
    body('email')
        .isEmail()
        .custom(async (value) => {
            if(/.+@[A-Z]/g.test(value)){
                throw new Error('Capital letter Domain')
            }
            const existingUser = await User.findOne({ email: value });
            if (existingUser) {
                throw new Error('User Already exist');
            }
        })
        .withMessage('Email must be in a valid format')
        .normalizeEmail(),
    body('name').isString().withMessage('Name should be String'),
    body('password')
    .trim()
    .isLength({ min: 8, max: 32 })
    .withMessage('Password must be between 8 and 32 characters'),
    body('password')
    .matches(/^(.*[a-z].*)$/)
    .withMessage('Password must contain at least one lowercase letter'),
    body('password')
    .matches(/^(.*[A-Z].*)$/)
    .withMessage('Password must contain at least one uppercase letter'),
    body('password')
  .matches(/^(.*\d.*)$/)
  .withMessage('Password must contain at least one digit'),
    body('password')
        .isStrongPassword()
        .withMessage('Password should be Strong Enough'),
    body('password').trim(),
    body('profileImage').isURL().withMessage('Profile Image should be URL'),
    body('school').isString().withMessage('School should be String'),
    body('verified')
        .isBoolean()
        .withMessage('verified should be boolean value'),
]