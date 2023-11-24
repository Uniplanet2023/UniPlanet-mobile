import { model, Model, Schema, Document } from 'mongoose';
import { ProductDocument, UserChatRoomDocument, EventDocument } from './index';
import { DuplicatedEmail } from '../errors';
import { PasswordHash } from '../utils';

export type UserDocument = Document & {
	name: string;
	email: string;
	school: string;
	verified: boolean;
	password: string;
	profileImage: string;
	type: string;
	recentSearchHistory: string[];
	recentViewHistory: ProductDocument[];
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
		password: {
			required: true,
			type: String,
		},
		school: {
			required: true,
			type: String,
		},
		verified: {
			type: Boolean,
			default: false,
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
		recentViewHistory: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		like: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		myEvent: [{ type: Schema.Types.ObjectId, ref: 'Event' }], // when you like save button
		selling: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		sold: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		bought: [{ type: Schema.Types.ObjectId, ref: 'Product' }],
		myChatRoom: [{ type: Schema.Types.ObjectId, ref: 'UserChatRoom' }],
	},
	{ timestamps: true },
);

userSchema.pre(
	'save',
	async function validateUniqueness(this: UserDocument, next) {
		// eslint-disable-next-line @typescript-eslint/no-use-before-define
		const existingUser = await User.findOne({ email: this.email });

		if (existingUser) {
			throw new DuplicatedEmail();
		}
		next();
	},
);

userSchema.pre('save', async function hashPassword(this: UserDocument, next) {
	if (this.isModified('password')) {
		const hashedPassword = PasswordHash.toHashSync({
			password: this.get('password'),
		});
		this.set('password', hashedPassword);
	}
	next();
});
const User = model<UserDocument, UserModel>('User', userSchema);
export default User;
