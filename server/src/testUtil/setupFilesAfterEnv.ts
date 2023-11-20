import { MongoMemoryServer } from 'mongodb-memory-server';
import mongoose from 'mongoose';
let mongoMemoryServer: MongoMemoryServer;
beforeAll(async () => {
	mongoMemoryServer = await MongoMemoryServer.create();
	const mongoUri = mongoMemoryServer.getUri();
	await mongoose.connect(mongoUri);
});
beforeEach(async () => {
	const allCollections = await mongoose.connection.db.collections();

	allCollections.forEach(async (collection) => {
		await collection.deleteMany({});
	});
});
afterAll(async () => {
	await mongoMemoryServer.stop();
	await mongoose.connection.close();
});
// Before everything:
//1. Create an instance of my MongoDB server
//2. Connect to my MongoDB server via mongoose

// Before each test
// 3. Clean up the databse

// After all tests
// 4. Close the connection with the database
