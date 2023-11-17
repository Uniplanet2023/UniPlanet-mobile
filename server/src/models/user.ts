import mongoose, { Schema } from 'mongoose';
import { IUser } from './database_model';

const userSchema: Schema = new mongoose.Schema(
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
    like: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
    myEvent: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Event' }], // when you like save button
    selling: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
    sold: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
    bought: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
    myChatRoom: [{ type: mongoose.Schema.Types.ObjectId, ref: 'UserChatRoom' }],
  },
  { timestamps: true }
);

// Email validation middleware
userSchema.pre<IUser>('save', function validateEmail(next) {
  const re =
    /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@(([^<>()[\]\\.,;:\s@"]+\.)+[^<>()[\]\\.,;:\s@"]{2,})$/i;
  if (!re.test(this.email)) {
    next(new Error('Please enter a valid email address'));
    return;
  }
  next();
});

const User = mongoose.model<IUser>('User', userSchema);
export default User;
