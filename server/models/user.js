const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
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
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
  isOnline: {
    required: true,
    type: Boolean,
    default: true,
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
    default: "user",
  },
  unseenNotifications: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Notification",
    },
  ],
  unseenMessages: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Message",
    },
  ],
  like: [{ type: mongoose.Schema.Types.ObjectId, ref: "Product" }],
  selling: [{ type: mongoose.Schema.Types.ObjectId, ref: "Product" }],
  sold: [{ type: mongoose.Schema.Types.ObjectId, ref: "Product" }],
  bought: [{ type: mongoose.Schema.Types.ObjectId, ref: "Product" }],
  chatRooms: [{ type: mongoose.Schema.Types.ObjectId, ref: "ChatRoom" }],
});

const User = mongoose.model("User", userSchema);

module.exports = User;
