import { randomBytes } from 'crypto';
import { User } from '../index';
import { BaseCustomError, DuplicatedEmail } from '../../errors';
import { PasswordHash } from '../../utils';

describe('tests the User mongoose model', () => {
	const validUserInfo = {
		email: 'test1@stonybrook.edu',
		profileImage:
			'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
		school: 'Stony Brook University',
		verified: true,
		name: 'sije',
		password: 'TestPassword1!',
	};

	it('should not save a user if the email is already in the database', async () => {
		const newUser1 = await User.create(validUserInfo);
		expect(newUser1).toBeDefined();
		expect(newUser1.email).toEqual(validUserInfo.email);
		let err;
		try {
			await User.create(validUserInfo); // Error
		} catch (e) {
			err = e as DuplicatedEmail;
		}
		const serializedErrorOutput = err ? err.serializeErrorOutput() : undefined;

		expect(err).toBeDefined();
		expect(err).toBeInstanceOf(BaseCustomError);
		expect(serializedErrorOutput).toBeDefined();
		expect(serializedErrorOutput?.errors[0].message).toEqual(
			'The email is already in the database',
		);
	});
	it('should encrypt the password when creating the user', async () => {
		const newUser = await User.create(validUserInfo);
		expect(newUser.password).not.toEqual(validUserInfo.password);
		expect(newUser.password.split('.')).toHaveLength(2);
		expect(newUser.password.split('.')[1].length).toEqual(
			randomBytes(16).toString('hex').length,
		);
	});

	it('should return true when comparing the hashedPassword with its original providedPassword', async () => {
		const newUser = await User.create(validUserInfo);

		expect(
			PasswordHash.compareSync({
				providedPassword: '1234',
				storedPassword: newUser.password,
			}),
		).toEqual(false);
		expect(
			PasswordHash.compareSync({
				providedPassword: validUserInfo.password,
				storedPassword: newUser.password,
			}),
		).toEqual(true);
	});
});
