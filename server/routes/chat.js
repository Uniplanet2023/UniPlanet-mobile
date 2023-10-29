const express = require("express");
const chatRouter = express.Router();
const auth = require("../middlewares/auth");
const redis_controller = require("../redis_controller/redis_controller");
const Message = require("../models/message");
const User = require("../models/user");
const ChatRoom = require("../models/chat_room");
const { ObjectId } = require("mongoose").Types;

chatRouter.post("/api/joinChatingRoom", auth, async (req, res) => {
  try {
    console.log("creating chat room api triggered");
    const { receiverId } = req.body;
    if (!receiverId) {
      throw new Error("receiverId are required");
    }
    if (req.user == receiverId) {
      return res.status(400).json("It`s your self");
    }
    // Check if a chat room already exists between the user and the receiver
    let existingChatRoom = await ChatRoom.findOne({
      buyer: req.user,
      seller: receiverId,
    });

    if (existingChatRoom) {
      // Determine if req.user is the buyer or seller
      if (existingChatRoom.buyer.toString() === req.user.toString()) {
        existingChatRoom.buyer = null;
        Promise.all([
          await existingChatRoom.populate({
            path: "seller",
            select: "name email isOnline school verified profileImage type",
            model: "User",
          }),
          await existingChatRoom.populate({
            path: "lastMessage",
            model: "Message",
          }),
        ]);
      } else {
        existingChatRoom.seller = null;
        Promise.all([
          await existingChatRoom.populate({
            path: "buyer",
            select: "name email isOnline school verified profileImage type",
            model: "User",
          }),
          await existingChatRoom.populate({
            path: "lastMessage",
            model: "Message",
          }),
        ]);
      }

      return res.status(200).json(existingChatRoom);
    }
    console.log("create chatRoom");
    let chatRoom = new ChatRoom({
      buyer: req.user,
      seller: receiverId,
      chatRoomType: "resell",
    });

    await chatRoom.save();
    // Populate the seller details
    chatRoom.buyer = null;
    await chatRoom.populate({
      path: "seller",
      select: "name email isOnline school verified profileImage type",
      model: "User",
    });
    console.log(chatRoom);
    res.status(200).json(chatRoom);
  } catch (error) {
    console.log(error);
    res.status(400).json({ error: error.message });
  }
});
chatRouter.get("/api/getChatRooms", auth, async (req, res) => {
  try {
    console.log("chat rooms");
    const { chatRoomIds } = req.body;
    console.log(chatRoomIds);
    // Find chatRooms directly using chatRoomIds
    let chatRooms = await ChatRoom.find({
      _id: { $in: chatRoomIds },
    }).populate([
      {
        path: "buyer",
        match: { _id: { $ne: req.user } },
        select: "name email isOnline school verified profileImage type",
        model: "User",
      },
      {
        path: "seller",
        match: { _id: { $ne: req.user } },
        model: "User",
        select: "name email isOnline school verified profileImage type",
      },
      {
        path: "lastMessage",
        model: "Message",
      },
    ]);

    console.log(chatRooms);
    res.status(200).json(chatRooms);
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});

chatRouter.post("/api/message", auth, async (req, res) => {
  try {
    console.log("message triggered");
    const { chatroom_id, message } = req.body;
    console.log(message);
    var msg = new Message({
      senderId: req.user,
      chatRoomId: chatroom_id,
      message: message,
      type: "text",
      isSeen: false,
    });
    console.log(msg);
    await msg.save();
    res.status(200).json(msg);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

chatRouter.post("/api/getMessages", auth, async (req, res) => {
  try {
    console.log("message gets is triggered");
    const { msgList } = req.body;

    // Directly find messages using the list of message IDs
    const messages = await Message.find({
      _id: { $in: msgList },
    })
      .sort({ createdAt: -1 })
      .limit(20);

    res.status(200).json({ messages });
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});
module.exports = chatRouter;
