import mongoose, { Document, Types } from 'mongoose';

// Define an interface that represents a document in MongoDB.
interface IChatRoom extends Document {
  product: mongoose.Types.ObjectId;
  chatRoomType: string;
  messages: IMessage[];
  lastMessage: mongoose.Types.ObjectId;
}

interface IEvent extends Document {
  title: string;
  description: string;
  startDate: Date;
  endDate: Date;
  location: string;
  images: string[];
  organizer: mongoose.Types.ObjectId;
  likes: mongoose.Types.ObjectId[];
  createdAt: Date;
}
interface IMessage extends Document {
  chatRoomId: mongoose.Types.ObjectId;
  senderId: mongoose.Types.ObjectId;
  message: string;
  type: string;
  isSeen: boolean;
  seenAt?: Date;
}
interface INoticeMessage {
  senderId: mongoose.Types.ObjectId;
  message: string;
  timestamp: Date;
}

interface INotification extends Document {
  noticeMessages: INoticeMessage;
}

interface IProduct extends Document {
  name: string;
  forSale: boolean;
  seller: Types.ObjectId;
  description: string;
  images: string[];
  likes: Types.ObjectId[];
  price: number;
  category: string;
}

interface IUserChatRoom extends Document {
  receiver: Types.ObjectId[];
  type: string;
  chatRoom: IChatRoom;
  unseenMessage: mongoose.Types.ObjectId[]; // Assuming 'Message' schema exists
}

interface IUser extends Document {
  name: string;
  email: string;
  school: string;
  verified: boolean;
  password: string;
  profileImage: string;
  type: string;
  recentSearchHistory: string[];
  like: IProduct['_id'][];
  myEvent: mongoose.Types.ObjectId[]; // Assuming 'Event' schema exists
  selling: IProduct['_id'][];
  sold: IProduct['_id'][];
  bought: IProduct['_id'][];
  myChatRoom: IUserChatRoom['_id'][];
}

export {
  IChatRoom,
  IEvent,
  IMessage,
  INoticeMessage,
  INotification,
  IProduct,
  IUserChatRoom,
  IUser,
};
