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

ChatRoom.watch().on("change", async (change) => {
  // Check if the operation is an insert of a new ChatRoom
  if (change.operationType === "insert") {
    const chatRoomId = change.documentKey._id;
    const { buyer, seller } = change.fullDocument;

    // Update both the buyer and seller's chatRooms field in parallel
    await Promise.all([
      User.updateOne({ _id: buyer }, { $push: { chatRooms: chatRoomId } }),
      User.updateOne({ _id: seller }, { $push: { chatRooms: chatRoomId } }),
    ]);
  }
});
