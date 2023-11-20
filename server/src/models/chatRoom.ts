import { Document, Model, Schema, model } from 'mongoose';
import { ProductDocument, MessageDocument } from './index';
export type ChatRoomDocument = Document & {
	product: ProductDocument;
	chatRoomType: string;
	messages: MessageDocument[];
	lastMessage: MessageDocument;
};
export interface ChatRoomModel extends Model<ChatRoomDocument> {}

// Define the schema
const chatRoomSchema: Schema = new Schema(
	{
		product: { type: Schema.Types.ObjectId, ref: 'Product' },
		chatRoomType: { type: String },
		messages: [{ type: Schema.Types.ObjectId, ref: 'Message' }],
		lastMessage: { type: Schema.Types.ObjectId, ref: 'Message' },
	},
	{ timestamps: true },
);
// Create the model
const ChatRoom = model<ChatRoomDocument, ChatRoomModel>(
	'ChatRoom',
	chatRoomSchema,
);
export default ChatRoom;
