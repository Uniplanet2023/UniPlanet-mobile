import mongoose, { Model, Schema, model } from 'mongoose';
import User from './user';
import { INotification } from './database_model';

const notificationSchema: Schema<INotification> = new Schema({
  noticeMessages: {
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    timestamp: {
      type: Date,
      default: Date.now,
    },
  },
});

const Notification: Model<INotification> = model<INotification>(
  'Notification',
  notificationSchema
);

// Watch the Notification collection
Notification.watch().on('change', async (change) => {
  if (
    change.operationType === 'insert' &&
    change.fullDocument &&
    change.fullDocument._id
  ) {
    const notificationId = change.fullDocument._id;

    try {
      await User.updateMany(
        {},
        {
          $push: {
            unseenNotifications: notificationId,
          },
        }
      );
    } catch (err) {
      console.error("Error updating all users' unseenNotifications:", err);
    }
  }
});

export default Notification;
