const mongoose = require("mongoose");
const User = require("./user");

const chatroom = new mongoose.Schema({
  buyer: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  chatRoomType: { type: String },
  seller: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  messages: [{ type: mongoose.Schema.Types.ObjectId, ref: "Message" }],
  lastMessage: { type: mongoose.Schema.Types.ObjectId, ref: "Message" },
  created_at: { type: Date, default: Date.now },
});

const ChatRoom = mongoose.model("ChatRoom", chatroom);
module.exports = ChatRoom;
