import request from 'supertest';
import app from '../../app';

it('should return 422 if the email is not valid', async () => {
	await request(app).post('/api/signup').send({}).expect(422);

	await request(app)
		.post('/api/signup')
		.send({
			email: 'qkrtlwp1111@gmail.com',
			password: 'test',
			profileImage: '',
			school: '',
			verified: false,
		})
		.expect(422);

	await request(app)
		.post('/api/signup')
		.send({
			name: 'test',
			email: 'qkrtlwp1111@gmail.com',
			password: 'test',
			profileImage: '',
			school: '',
			verified: false,
		})
		.expect(422);
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
