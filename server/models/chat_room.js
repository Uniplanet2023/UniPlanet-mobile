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

ChatRoom.watch().on("change", async (change) => {
  // Check if the operation is an insert of a new ChatRoom
  console.log("chatRoom wacth is triggered");

  if (
    change.operationType === "insert" &&
    change.fullDocument &&
    change.documentKey._id
  ) {
    const chatRoomId = change.fullDocument._id;
    const { buyer, seller } = change.fullDocument;
    console.log("chatRoom wacth is triggered1");
    // Update the buyer's chatRooms field
    await User.findByIdAndUpdate(
      buyer,
      { $push: { chatRooms: chatRoomId } },
      { new: true, useFindAndModify: false }
    );

    // Update the seller's chatRooms field
    await User.findByIdAndUpdate(
      seller,
      { $push: { chatRooms: chatRoomId } },
      { new: true, useFindAndModify: false }
    );
  }
});
module.exports = ChatRoom;
