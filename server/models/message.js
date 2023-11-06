const mongoose = require("mongoose");
const ChatRoom = require("./chat_room");
const User = require("./user");
const message = mongoose.Schema({
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
    required: true,
  },
  seenAt: {
    type: Date,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
});
const Message = mongoose.model("Message", message);
module.exports = Message;

Message.watch().on("change", async (change) => {
  if (
    change.operationType === "insert" &&
    change.fullDocument &&
    change.fullDocument._id
  ) {
    const messageId = change.fullDocument._id;
    const chatRoomId = change.fullDocument.chatRoomId;
    const senderId = change.fullDocument.senderId;

    // Fetch the associated ChatRoom
    const chatRoom = await ChatRoom.findById(chatRoomId);

    // Determine the receiver's ID based on who sent the message
    let receiverId;
    if (String(senderId) === String(chatRoom.buyer)) {
      receiverId = chatRoom.seller;
    } else if (String(senderId) === String(chatRoom.seller)) {
      receiverId = chatRoom.buyer;
    } else {
      // The sender is neither the buyer nor the seller
      console.error("Invalid sender for chat room:", chatRoomId);
      return;
    }

    // Update the receiver's unseenMessages array
    try {
      await User.findByIdAndUpdate(receiverId, {
        $push: {
          unseenMessages: messageId,
        },
      });
    } catch (err) {
      console.error("Error updating user's unseenMessages:", err);
    }
  }
});
