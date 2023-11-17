import mongoose, { Schema } from 'mongoose';
import { IUserChatRoom } from './database_model';

const userRoomSchema: Schema = new mongoose.Schema({
	receiver: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'User',
	},
	type: {
		type: String,
	},
	chatRoom: {
		type: mongoose.Schema.Types.ObjectId,
		ref: 'ChatRoom',
	},
	unseenMessage: [
		{
			type: mongoose.Schema.Types.ObjectId,
			ref: 'Message',
		},
	],
});

const UserChatRoom = mongoose.model<IUserChatRoom>(
	'UserChatRoom',
	userRoomSchema,
);
export default UserChatRoom;
