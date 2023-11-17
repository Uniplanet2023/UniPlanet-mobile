import request from "supertest";
import app from "../../app";

// it('should return 405 for non-post requests to the signup route',()=>{
    
// })

it('should return 422 if the email is not valid',async ()=>{
    await request(app).post('/api/signup').expect(422);
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