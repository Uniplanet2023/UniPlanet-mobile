import request from 'supertest';
import app from '../../app';
import { MongoMemoryServer } from 'mongodb-memory-server';
import mongoose from 'mongoose';
import {SIGNUP_ROUTE} from '../route-defs'
let mongoMemoryServer: MongoMemoryServer;
/**
 * Valid email conditions:
 *  - Standard email formats form 'express-validator' package
 */
beforeAll(async () => {
	mongoMemoryServer = new MongoMemoryServer();
	const mongoUri = process.env.MONGO_DB_HOST;
	await mongoose.connect(mongoUri as string);
});
beforeEach(async () => {
	const allCollections = await mongoose.connection.db.collections();

	allCollections.forEach(async (collection) => {
		await collection.deleteMany({});
	});
	jest.clearAllMocks();
});

afterAll(async () => {
	// await mongoMemoryServer.stop();
	await mongoose.connection.close();
});
/**
 * Available HTTP method in /api/auth/signup:
 * - Post
 */
describe('tests signup route method availability', () => {
	let password = '';
	let profileImage = '';
	let school = '';
	let verified = false;
	let name = '';
	let email = '';
	beforeAll(() => {
		email = 'testUser@stonybrook.edu';
		password = 'Validpassword1!';
		profileImage =
			'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg';
		school = 'Stony Brook University';
		verified = true;
		name = 'sije';
	});
	it('should return 405 for non-post requests', async () => {
		await request(app).get(SIGNUP_ROUTE).expect(405);
		await request(app).put(SIGNUP_ROUTE).expect(405);
		await request(app).patch(SIGNUP_ROUTE).expect(405);
		await request(app).delete(SIGNUP_ROUTE).expect(405);
	});
	it('should return 200 for post request', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				email,
				name,
				password,
				profileImage,
				school,
				verified,
			})
			.expect(200);
	});
});

describe('test Validify of email input', () => {
	let password = '';
	let profileImage = '';
	let school = '';
	let verified = false;
	let name = '';
	beforeAll(() => {
		password = 'Validpassword1!';
		profileImage =
			'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg';
		school = 'Stony Brook University';
		verified = true;
		name = 'sije';
	});

	it('should return 422 if the email is not valid', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email: 'invalidEmail',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(422);
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email: 'qkrtlwp1111@gmailcom',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(422);
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email: 'qkrtlwp1111gmail.com',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(422);
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email: '@gmail.com',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(422);
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email: 'qkrtlwp1111@.com',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(422);
	});
	it('should return 200 if the email is valid', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email: 'qkrtlwp1111@gmail.com',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(200);
	});
});

/**
 * Valid password conditions:
 * 	- At least 8 characters
 *  - One lower-case letter
 *  - On uppper-case letter
 *  - One number
 *
 */
describe('test validity of password input', () => {
	let email = '';
	let profileImage = '';
	let school = '';
	let verified = false;
	let name = '';
	beforeAll(() => {
		email = 'sije.park@stonybrook.edu';
		profileImage =
			'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg';
		school = 'Stony Brook University';
		verified = true;
		name = 'sije';
	});
	it('should return 422 if the password contains less than 8 characters', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email,
				password: 'Test1!',
				profileImage,
				school,
				verified,
			})
			.expect(422);
	});
	it('should return 422 if the password does not contain one lower-case letter', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email,
				password: 'TESTPASSWORD1!',
				profileImage,
				school,
				verified,
			})
			.expect(422);
	});
	it('should return 422 if the password does not contain one upper-case letter', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email,
				password: 'testpassword!!',
				profileImage,
				school,
				verified,
			})
			.expect(422);
	});
	it('should return 422 if the password does not contain one special charator', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email,
				password: 'testpassword11',
				profileImage,
				school,
				verified,
			})
			.expect(422);
	});

	it('should return 422 if the password does not contain a number', async () => {
		await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email,
				password: 'test',
				profileImage,
				school,
				verified,
			})
			.expect(422);
	});
	it('should return 200 if the password is valid', async () => {
		const response = await request(app)
			.post(SIGNUP_ROUTE)
			.send({
				name,
				email,
				password: 'TestPasswrod1!',
				profileImage,
				school,
				verified,
			})
			.expect(200);
	});
});
// beforeAll(() =>{
//     //Start the database connection
// })

// beforeEach(() =>{
//     // clean up the database.

// })

// afterAll(() =>{
//     //Close the database connection.
// })
