import request from 'supertest';
import app from '../../app';
import { SIGNUP_ROUTE } from '../route-defs';
<<<<<<< Updated upstream
import User from '../../models/user';
=======
>>>>>>> Stashed changes

/**
 * Valid email conditions:
 *  - Standard email formats form 'express-validator' package
 */
let userInfo ={
	email : 'test1@stonybrook.edu',
	profileImage :
		'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
	school : 'Stony Brook University',
	verified : true,
	name : 'sije',
	password:'TestPassword1!'
}

describe('test Validify of email input', () => {
	it('should return 422 if there is no super domain',async()=>{
		userInfo.email = 'emailTest@gmail.';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if there is no dot',async()=>{
		userInfo.email = 'emailTest@gmail';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if there is no subdomain',async()=>{
		userInfo.email = 'emailTest@.com';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if there is no at',async()=>{
		userInfo.email = 'emailTestgmail.com';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if there is no user name',async()=>{
		userInfo.email = '@gmail.com';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if sub-domain is capital',async()=>{
		userInfo.email = 'emailTest@GMAIL.com';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
		
	it('should return 200 if the email is valid', async () => {
		userInfo.email = 'emailTest@gmail.com';
		console.log(userInfo);
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(200);
	});
});

/**
 * Valid password conditions:
 * 	- At least 8 characters
 *  - One lower-case letter
 *  - On uppper-case letter
 *  - One special letter
 *  - One number
 *
 */
describe('test validity of password input', () => {
	
	beforeAll(async() =>{
		userInfo.email='passTest@gmail.com'
	})
	it('should return 422 if the password contains less than 8 characters', async () => {
		userInfo.password = 'Test1!';
		await request(app).post(SIGNUP_ROUTE).send(userInfo).expect(422);
	});
	it('should return 422 if the password does not contain one lower-case letter', async () => {
		userInfo.password = 'TESTPASSWORD1!';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if the password does not contain one upper-case letter', async () => {
		userInfo.password = 'testpassword1!';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 422 if the password does not contain one special charator', async () => {
		userInfo.password = 'testpassword11';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});

	it('should return 422 if the password does not contain a number', async () => {
		userInfo.password = 'testpassword!!';
		await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(422);
	});
	it('should return 200 if the password is valid', async () => {
		userInfo.password ='TestPassword1!';
		const response = await request(app)
			.post(SIGNUP_ROUTE)
			.send(userInfo)
			.expect(200);
	});
});

describe('tests saving the signed up user to the database', () =>{
	
	it('saves the user successfully as long as the information is valid',async ()=>{
		// Send valid user information
		// Receive the user information back from the route
		// Check whether I can find the user in the databse by using the _id or email property
		const response = await request(app).post(SIGNUP_ROUTE).send(userInfo).expect(200);
		expect(response.body.email).toEqual(userInfo.email.toLowerCase());
<<<<<<< Updated upstream
		const user = User.findOne({email:response.body.email })
=======
>>>>>>> Stashed changes

	});
	it('does not allow saving a user with a duplicate email',()=>{
		// Send valid user information
		// Send valid user information again( the sam info)
		// Should return the respective HTTP error code
	});
})