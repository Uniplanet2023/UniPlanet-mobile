const socketIo = require("socket.io");
const Message = require("../models/message");
const { createAdapter } = require("@socket.io/redis-adapter");
const jwt = require("jsonwebtoken");
const ChatRoom = require("../models/chat_room");
const UserChatRoom = require("../models/user_chat_room");
const mongoose = require("mongoose");
const cors = require("cors");
let io;

// Store socket references for each user
const userSocketIds = {};
const auth = require("../middlewares/auth");
const User = require("../models/user");
const { logStart, logEnd, handleError } = require("../functions/logFunction");

module.exports = {
  init: (httpServer, pubClient, subClient) => {
    // io = socketIo(httpServer, { cors: { origin: "*" } });
    io = socketIo(httpServer);
    io.adapter(createAdapter(pubClient, subClient));

    //Middle ware (Socket middle ware)
    io.use((socket, next) => {
      logStart("Socket Middleware");

      const headers = socket.handshake.headers;

      try {
        console.log("1. Getting Token from header");
        const token = headers["x-auth-token"];
        if (!token) {
          console.log("No token");
          return next(new Error("No token provided"));
        }
        console.log("2. Token Verification");
        const verified = jwt.verify(token, "passwordKey");
        if (!verified) {
          console.log("Token verification failed, authorization denied.");
          return next(new Error("Token verification failed"));
        }
        console.log("3. Setting User Id into the Socket");

        socket.user = verified.id; //user ID
        socket.token = token;
        socket.chatRoomList = [];
        console.log(socket.user);
        logEnd("Socket Middleware");
        next();
      } catch (err) {
        console.log("\x1b[31m Middle Ware Auth has issues!! \x1b[0m");
        console.log(err);
      }
    });
    // socket API
    io.on("connection", (socket) => {
      socket.on("joinChatRoom", async (chatRoomId) => {
        logStart("Joining ChatRoom");

        let userList = await isUserInChatRoom(chatRoomId);
        console.log(userList);
        console.log(userList.includes(socket.user));
        if (!userList.includes(chatRoomId)) {
          socket.chatRoomList.push(chatRoomId);
        }

        if (userList.length == 0 || !userList.includes(socket.user)) {
          socket.join(chatRoomId);
          console.log(`1. ${socket.user} joining chatRoom`);
          console.log(`ChatRoom Id: ${chatRoomId}`);
          userList.push(socket.user);
        }
        console.log("Final userList is " + userList);
        io.to(chatRoomId).emit("connectStatus", {
          userId: userList,
          chatRoomId: chatRoomId,
        });
        logEnd("Joining ChatRoom");
      });

      socket.on("fetch_messages", async () => {
        try {
          const messages = await Message.find()
            .sort({ timestamp: -1 })
            .limit(50);
          socket.emit("message_history", messages);
        } catch (error) {
          console.error("Error fetching messages:", error);
        }
      });

      socket.on("sendMessage", async (msg, chatRoomId) => {
        logStart("Socket API : Send Message");
        console.log("chat Room Id is " + chatRoomId);

        var newMessage = new Message({
          senderId: socket.user,
          chatRoomId: chatRoomId,
          message: msg,
          type: "text",
          isSeen: false,
          createdAt: Date.now(),
        });
        try {
          var test = await isUserInChatRoom(chatRoomId);
          console.log(test);
          io.to(chatRoomId).emit("receiveMessage", newMessage); //Front End

          const session = await mongoose.startSession(); // start a new session for the transaction
          session.startTransaction(); // Start the transaction

          await newMessage.save({ session }); // saving msg to the mongo db
          await UserChatRoom.findOneAndUpdate(
            { receiver: socket.user, chatRoom: chatRoomId },
            { $push: { unseenMessage: newMessage["_id"] } },
            { session }
          );
          await ChatRoom.findByIdAndUpdate(
            chatRoomId,
            {
              $push: { messages: newMessage["_id"] },
              $set: { lastMessage: newMessage["_id"] },
            },
            { session }
          );
          await session.commitTransaction(); // Committing the transaction
          session.endSession();
          logEnd("Socket API : Send Message");
        } catch (error) {
          handleError(res, error);
        }
      });

      socket.on("broadcast_message", (data) => {
        socket.broadcast.emit("receive_message", data);
      });

      socket.on("disconnect", async () => {
        console.log("Client disconnected");
        console.log(socket.chatRoomList);
        socket.chatRoomList.forEach((chatRoomId) => {
          console.log("disconnected");
          io.to(chatRoomId).emit("disconnectStatus", { userId: socket.user });
        });
        socket.user = "";
        socket.handshake.headers["x-auth-token"] = "";

        const userId = Object.keys(userSocketIds).find(
          (id) => userSocketIds[id] === socket.id
        );
        if (userId) {
          delete userSocketIds[userId];
        }
      });
      // This function checks if a user is already in a chat room
      const isUserInChatRoom = async (chatRoomId) => {
        // Get the room's data
        const sockets = await io.in(chatRoomId).fetchSockets(); // let you know who is joining the certain chat room
        let userList = [];
        sockets.map((e) => {
          userList.push(e.user);
          console.log(e.user);
        });

        console.log("isUserInChatRoom " + userList);
        return userList; // User is not in the chat room
      };
    });

    return io;
  },
};
