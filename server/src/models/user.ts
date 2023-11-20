import { model, Model, Schema, Document } from 'mongoose';
import { ProductDocument, UserChatRoomDocument, EventDocument } from './index';

export type UserDocument = Document & {
	name: string;
	email: string;
	school: string;
	verified: boolean;
	password: string;
	profileImage: string;
	type: string;
	recentSearchHistory: string[];
	like: ProductDocument[];
	myEvent: EventDocument[]; // Assuming 'Event' schema exists
	selling: ProductDocument[];
	sold: ProductDocument[];
	bought: ProductDocument[];
	myChatRoom: UserChatRoomDocument[];
};
export interface UserModel extends Model<UserDocument> {}

const userSchema: Schema = new Schema(
	{
		name: {
			required: true,
			type: String,
			trim: true,
		},
		email: {
			required: true,
			type: String,
			trim: true,
			unique: true,
			index: true,
		},
		school: {
			required: true,
			type: String,
		},
		verified: {
			type: Boolean,
			default: false,
		},
		password: {
			required: true,
			type: String,
		},
		profileImage: {
			required: true,
			type: String,
		},
		type: {
			type: String,
			default: 'user',
		},
		recentSearchHistory: [{ type: String }],
		like: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		myEvent: [{ type: Schema.Types.ObjectId, ref: 'Event' }], // when you like save button
		selling: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		sold: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		bought: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		myChatRoom: [{ type: Schema.Types.ObjectId, ref: 'UserChatRoom' }],
	},
	{ timestamps: true },
);
const User = model<UserDocument, UserModel>('User', userSchema);
export default User;
