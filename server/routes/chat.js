const express = require("express");
const chatRouter = express.Router();
const auth = require("../middlewares/auth");
const redis_controller = require("../redis_controller/redis_controller");
const Message = require("../models/message");
const User = require("../models/user");
const ChatRoom = require("../models/chat_room");
const { ObjectId } = require("mongoose").Types;
chatRouter.post("/api/createChatRoom", auth, async (req, res) => {
  try {
    logStart("Creating ChatRoom API");

    const { receiverId } = req.body;
    if (!receiverId) {
      return res.status(400).json({ error: "receiverId is required" });
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
    }).populate("seller buyer lastMessage");
    if (existingChatRoom) {
      console.log(
        "3. Existing Room : Determine if req.user is the buyer or seller"
      );
      res.status(200).json(existingChatRoom);
    } else {
      console.log("3. Creating Room Model");
      let chatRoom = new ChatRoom({
        buyer: req.user,
        seller: receiverId,
        chatRoomType: "resell",
      });
      console.log("4. Save ChatRoom into DB");
      await chatRoom.save();
      console.log("5. Setting User as Buyer");
      console.log("done");
      // Populate the seller details
      await chatRoom.populate("seller buyer");
      res.status(200).json(chatRoom);
    }
    logEnd("Creating ChatRoom API");
  } catch (error) {
    handleError(res, error);
  }
});
chatRouter.get("/api/getChatRooms", auth, async (req, res) => {
  try {
    logStart("Getting ChatRoom API");

    console.log("1. Finding ChatRoom from DB");
    // Execute the user lookup to get chatRooms.
    const user = await User.findById(req.user, "chatRooms");

    if (!user || user.chatRooms.length == 0) {
      // No chat rooms for the user
      return res.status(200).json([]);
    }
    console.log(user);
    // Execute the chat room lookup.
    const chatRoomstest = await ChatRoom.find({
      _id: { $in: user.chatRooms },
    });
    console.log(chatRoomstest);
    const chatRooms = await ChatRoom.find({
      _id: { $in: user.chatRooms },
    })
      .populate(
        "buyer",
        "name email isOnline school verified profileImage type"
      )
      .populate(
        "seller",
        "name email isOnline school verified profileImage type"
      )
      .populate("lastMessage");
    console.log(chatRooms);
    res.status(200).json(chatRooms);
    logEnd("Getting ChatRoom API");
  } catch (e) {
    handleError(res, e);
  }
});

chatRouter.post("/api/getMessages", auth, async (req, res) => {
  try {
    logStart("Getting Message API");
    const { chatRoomId, page } = req.body;
    console.log("1. getting messages from database");
    // Directly find messages using the list of message IDs
    const chatRoom = await ChatRoom.findById(chatRoomId).lean();
    const limit = 20;
    const skip = page * limit;
    if (!chatRoom) {
      throw Error("No ChatRoom");
    }
    const messages = await Message.find({
      _id: { $in: chatRoom.messages },
    })
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit);
    console.log(messages);

    res.status(200).json({ messages });
    logEnd("Getting Message API");
  } catch (e) {
    handleError(res, e);
  }
});
// Middleware for logging
function logStart(apiName) {
  console.log(
    `\x1b[32m----------------- Chat API : ${apiName} is triggered -----------------\x1b[0m`
  );
  console.log("");
}
// Middleware for logging
function logEnd(apiName) {
  console.log(
    `\x1b[32m----------------- Chat API : ${apiName} is Successfully completed -----------------\x1b[0m`
  );
  console.log("");
}
// Middleware for error handling
function handleError(res, e) {
  console.log(
    "\x1b[31m -----------------There is an issue at Chat API -----------------\x1b[0m"
  );
  console.log(e);
  res.status(500).json({ error: e.message });
}

module.exports = chatRouter;
