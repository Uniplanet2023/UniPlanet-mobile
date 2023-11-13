const mongoose = require("mongoose");
const ChatRoom = require("./chat_room");
const User = require("./user");
const userRoomSchema = new mongoose.Schema({
  receiver: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  type: {
    type: String,
  },
  chatRoom: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "ChatRoom",
  },
  unseenMessage: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Message",
    },
  ],
});

const UserChatRoom = mongoose.model("UserChatRoom", userRoomSchema);
module.exports = UserChatRoom;
