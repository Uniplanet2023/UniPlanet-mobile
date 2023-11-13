const mongoose = require("mongoose");
const User = require("./user");

const chatroom = new mongoose.Schema(
  {
    product: { type: mongoose.Schema.Types.ObjectId, ref: "Product" },
    chatRoomType: { type: String },
    messages: [{ type: mongoose.Schema.Types.ObjectId, ref: "Message" }],
    lastMessage: { type: mongoose.Schema.Types.ObjectId, ref: "Message" },
  },
  { timestamps: true }
);

const ChatRoom = mongoose.model("ChatRoom", chatroom);
module.exports = ChatRoom;
