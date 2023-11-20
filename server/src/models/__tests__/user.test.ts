import User from '../user';

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
		err = e as Error;
	}
	expect(err).toBeDefined();
});
