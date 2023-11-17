import mongoose, { Document, Model, Schema, model } from 'mongoose';
import { IMessage } from './database_model';

const messageSchema: Schema<IMessage> = new Schema(
  {
    chatRoomId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'ChatRoom',
      required: true,
    },
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
    isSeen: {
      type: Boolean,
      default: false,
    },
    seenAt: {
      type: Date,
    },
  },
  { timestamps: true }
);

const Message: Model<IMessage> = model<IMessage>('Message', messageSchema);
export default Message;
