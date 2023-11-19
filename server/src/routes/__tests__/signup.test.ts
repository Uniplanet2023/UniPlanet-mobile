import request from 'supertest';
import app from '../../app';
/**
 * Valid email conditions:
 *  - Standard email formats form 'express-validator' package
 */
describe('test Validify of email input', () =>{
	let password = '';
	let profileImage = '';
	let school= '';
	let verified = false;
	let name ='';
	beforeAll(() =>{
		password = 'Validpassword1!';
		profileImage = 'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg';
		school = 'Stony Brook University';
		verified = true;
		name ='sije';
	})

	it('should return 422 if the email is not valid', async () => {
		await request(app).post('/api/signup').send({
			name,
			email: 'invalidEmail',
				password,
				profileImage,
				school,
				verified,
		}).expect(422);
		await request(app).post('/api/signup').send({
			name,
			email: 'qkrtlwp1111@gmailcom',
				password,
				profileImage,
				school,
				verified,
		}).expect(422);
		await request(app).post('/api/signup').send({
			name,
			email: 'qkrtlwp1111gmail.com',
				password,
				profileImage,
				school,
				verified,
		}).expect(422);
		await request(app).post('/api/signup').send({
			name,
			email: '@gmail.com',
				password,
				profileImage,
				school,
				verified,
		}).expect(422);
		await request(app).post('/api/signup').send({
			name,
			email: 'qkrtlwp1111@.com',
				password,
				profileImage,
				school,
				verified,
		}).expect(422);
	});
	it('should return 200 if the email is valid',async ()=>{
		await request(app)
			.post('/api/signup')
			.send({
				name,
				email: 'qkrtlwp1111@gmail.com',
				password,
				profileImage,
				school,
				verified,
			})
			.expect(200);
	})
})



/**
 * Valid password conditions:
 * 	- At least 8 characters
 *  - One lower-case letter
 *  - On uppper-case letter
 *  - One number
 * 
 */
describe('test validity of password input',()=>{
	let email = '';
	let password = '';
	let profileImage = '';
	let school= '';
	let verified = false;
	let name ='';
	beforeAll(() =>{
		email = 'sije.park@stonybrook.edu';
		profileImage = 'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg';
		school = 'Stony Brook University';
		verified = true;
		name ='sije';
	})
	it('should return 422 if the password contains less than 8 characters', async()=>{
		await request(app).post('/api/signup').send({
			name,
			email,
			password:'Test1!',
			profileImage,
			school,
			verified,
		}).expect(422);
 	})
	 it('should return 422 if the password does not contain one lower-case letter', async()=>{
		await request(app).post('/api/signup').send({
			name,
			email,
			password:'TESTPASSWORD1!',
			profileImage,
			school,
			verified,
		}).expect(422);
 	})
	 it('should return 422 if the password does not contain one upper-case letter', async()=>{
		await request(app).post('/api/signup').send({
			name,
			email,
			password:'testpassword!!',
			profileImage,
			school,
			verified,
		}).expect(422);
 	})
	 it('should return 422 if the password does not contain one special charator', async()=>{
		await request(app).post('/api/signup').send({
			name,
			email,
			password:'testpassword11',
			profileImage,
			school,
			verified,
		}).expect(422);
 	})
	
	 it('should return 422 if the password does not contain a number', async()=>{
		await request(app).post('/api/signup').send({
			name,
			email,
			password:'test',
			profileImage,
			school,
			verified,
		}).expect(422);
 	})
	it('should return 200 if the password is valid', async()=>{
		const response = await request(app).post('/api/signup').send({
			name,
			email,
			password:'TestPasswrod1!',
			profileImage,
			school,
			verified,
		}).expect(200);
		console.log(response.body);
	})
})
// beforeAll(() =>{
//     //Start the database connection

// })

// beforeEach(() =>{
//     // clean up the database.

// })

// afterAll(() =>{
//     //Close the database connection.
// })
