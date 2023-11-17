import mongoose, { Document, Model, Schema, model } from 'mongoose';
import { IEvent } from './database_model';
const eventSchema: Schema<IEvent> = new Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  location: { type: String, required: true },
  images: [String],
  organizer: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  createdAt: { type: Date, default: Date.now },
});

const Event: Model<IEvent> = model<IEvent>('Event', eventSchema);
export default Event;
