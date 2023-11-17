import mongoose from 'mongoose';
import { Document, Model, Schema, model } from 'mongoose';

// Define an interface that represents a document in MongoDB.
interface IChatRoom extends Document {
  product: mongoose.Types.ObjectId;
  chatRoomType: string;
  messages: mongoose.Types.ObjectId[];
  lastMessage: mongoose.Types.ObjectId;
}

// Define the schema
const chatroomSchema: Schema = new Schema<IChatRoom>(
  {
    product: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
    chatRoomType: { type: String },
    messages: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Message' }],
    lastMessage: { type: mongoose.Schema.Types.ObjectId, ref: 'Message' },
  },
  { timestamps: true }
);

// Create the model
const ChatRoom: Model<IChatRoom> = model<IChatRoom>('ChatRoom', chatroomSchema);

export default ChatRoom;
