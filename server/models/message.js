const mongoose = require("mongoose");
const ChatRoom = require("./chat_room");
const User = require("./user");
const UserChatRoom = require("./user_chat_room");
const message = mongoose.Schema(
  {
    chatRoomId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "ChatRoom",
      required: true,
    },
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
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
      required: false,
    },
    seenAt: {
      type: Date,
    },
  },
  { timestamps: true }
);
const Message = mongoose.model("Message", message);
module.exports = Message;
