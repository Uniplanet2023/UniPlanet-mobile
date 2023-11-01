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
    console.log(
      "\x1b[32m----------------- ChatRoom API : Creating ChatRoom API is Triggered -----------------\x1b[0m"
    );

    const { receiverId } = req.body;
    if (!receiverId) {
      throw new Error("receiverId are required");
    }
    console.log("1. Cheking UserID and ReceiverID");
    if (req.user == receiverId) {
      console.log("2. Cheking UserID and ReceiverID are Same!");
      return res.status(400).json("It`s your self");
    }
    // Check if a chat room already exists between the user and the receiver
    console.log("2. Checking the chatroom is already existed");
    let existingChatRoom = await ChatRoom.findOne({
      buyer: req.user,
      seller: receiverId,
    });

    if (existingChatRoom) {
      console.log(
        "3. Existing Room : Determine if req.user is the buyer or seller"
      );

      if (existingChatRoom.buyer.toString() === req.user.toString()) {
        console.log("4. Req.user is Seller");
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
        console.log("4. Req.user is Buyer");
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
    console.log("3. Creating Room Model");

    let chatRoom = new ChatRoom({
      buyer: req.user,
      seller: receiverId,
      chatRoomType: "resell",
    });
    console.log("4. Save ChatRoom into DB");
    await chatRoom.save();
    console.log("5. Setting User as Buyer");
    // Populate the seller details
    chatRoom.buyer = null;
    await chatRoom.populate({
      path: "seller",
      select: "name email isOnline school verified profileImage type",
      model: "User",
    });

    res.status(200).json(chatRoom);
    console.log(
      "\x1b[32m----------------- ChatRoom API : Creating ChatRoom API is scuessfully completed -----------------\x1b[0m"
    );
  } catch (error) {
    console.log(
      "\x1b[31m----------------- There is an error in Creating ChatRoom API -----------------\x1b[0m"
    );
    console.error(error);
    res.status(400).json({ error: error.message });
  }
});
chatRouter.get("/api/getChatRooms", auth, async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- ChatRoom API : Getting ChatRoom API is Triggered -----------------\x1b[0m"
    );

    const { chatRoomIds } = req.body;
    console.log("1. Finding ChatRoom from DB");
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

    res.status(200).json(chatRooms);
    console.log(
      "\x1b[32m----------------- ChatRoom API : Getting ChatRoom API is scuessfully completed -----------------\x1b[0m"
    );
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});

chatRouter.post("/api/message", auth, async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- ChatRoom API : Sending Message API is Triggered -----------------\x1b[0m"
    );

    const { chatroom_id, message } = req.body;
    console.log("1. Creating Message Model");
    var msg = new Message({
      senderId: req.user,
      chatRoomId: chatroom_id,
      message: message,
      type: "text",
      isSeen: false,
    });
    console.log("2. Save message into database");
    await msg.save();
    res.status(200).json(msg);
    console.log(
      "\x1b[32m----------------- ChatRoom API : Sending Message API is successfully completed -----------------\x1b[0m"
    );
  } catch (e) {
    console.log("\x1b[31m There is Issues at Sending Message API \x1b[0m");
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

chatRouter.post("/api/getMessages", auth, async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- ChatRoom API : Getting Message API is Triggered -----------------\x1b[0m"
    );
    const { msgList } = req.body;
    console.log("1. getting messages from database");
    // Directly find messages using the list of message IDs
    const messages = await Message.find({
      _id: { $in: msgList },
    })
      .sort({ timestamp: -1 })
      .limit(20);

    res.status(200).json({ messages });
    console.log(
      "\x1b[32m----------------- ChatRoom API : Getting Message API is successfully completed -----------------\x1b[0m"
    );
  } catch (e) {
    console.log("\x1b[31m There is Issues at Getting Message API \x1b[0m");
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});
module.exports = chatRouter;
