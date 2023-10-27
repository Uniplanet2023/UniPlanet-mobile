const mongoose = require("mongoose");
const { userSchema } = require("./user");

const chatRoomSchema = new mongoose.Schema({
  buyer: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  chatRoomType: { type: String },
  seller: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  messages: [{ type: mongoose.Schema.Types.ObjectId, ref: "Message" }],
  lastMessage: { type: mongoose.Schema.Types.ObjectId, ref: "Message" },
  updated_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model("ChatRoom", chatRoomSchema);
