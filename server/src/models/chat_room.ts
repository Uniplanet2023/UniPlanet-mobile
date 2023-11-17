import mongoose, { Model, Schema, model } from 'mongoose';
import { IChatRoom } from './database_model';

// Define the schema
const chatroomSchema: Schema = new Schema<IChatRoom>(
	{
		product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
		chatRoomType: { type: String },
		messages: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Message' }],
		lastMessage: { type: mongoose.Schema.Types.ObjectId, ref: 'Message' },
	},
	{ timestamps: true },
);

// Create the model
const ChatRoom: Model<IChatRoom> = model<IChatRoom>('ChatRoom', chatroomSchema);

export default ChatRoom;
