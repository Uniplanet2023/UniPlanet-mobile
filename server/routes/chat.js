const express = require("express");
const chatRouter = express.Router();
const auth = require("../middlewares/auth");
const redis_controller = require("../redis_controller/redis_controller");
const Message = require("../models/message");
const User = require("../models/user");
const ChatRoom = require("../models/chat_room");
chatRouter.post("/api/joinChatingRoom", auth, async (req, res) => {
  try {
    console.log("creating chat room api triggered");
    const { userId, receiverId } = req.body;
    if (!userId || !receiverId) {
      throw new Error("Both userId and receiverId are required");
    }
    Promise.all([
      (user = await User.findById(userId)),
      (receiver = await User.findById(receiverId)),
    ]);

    if (!user || !receiver) {
      throw new Error("User or Receiver not found");
    }

    const chatRoom = new ChatRoom({
      participants: [user._id, receiver._id],
    });
    const chatRoomId = chatRoom._id.toString();
    console.log(chatRoomId);
    Promise.all([await chatRoom.save(), await user.chatRooms.push(chatRoomId)]);
    await user.save();
    reciverData = { receiverName: receiver.name };
    const chatRoomData = { receiver: reciverData, chatRoom };
    res.status(200).json(chatRoomData);
  } catch (error) {
    console.log(error);
    res.status(400).json({ error: error.message });
  }
});
chatRouter.post("/api/chatRooms", auth, async (req, res) => {
  try {
    console.log("chat rooms ");
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
chatRouter.post("/api/message", auth, async (req, res) => {
  try {
    console.log("message triggered");
    const { user_id, receiver_id, message } = req.body;
    let msg = new Message({
      senderId: user_id,
      receiverId: receiver_id,
      message,
      type: "text",
      isSeen: false,
    });
    console.log(msg);

    Promise.all([
      (product = await product.save()),
      await redis_controller.addJson("products", product),
      await redis_controller.addJson(product.category, product),
    ]);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
module.exports = chatRouter;
