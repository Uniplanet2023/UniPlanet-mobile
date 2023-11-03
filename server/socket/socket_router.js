const socketIo = require("socket.io");
const Message = require("../models/message");
const { createAdapter } = require("@socket.io/redis-adapter");
const jwt = require("jsonwebtoken");
const ChatRoom = require("../models/chat_room");
const cors = require("cors");
let io;

// Store socket references for each user
const userSocketIds = {};
const auth = require("../middlewares/auth");
const User = require("../models/user");
module.exports = {
  init: (httpServer, pubClient, subClient) => {
    // io = socketIo(httpServer, { cors: { origin: "*" } });
    io = socketIo(httpServer);
    io.adapter(createAdapter(pubClient, subClient));

    //Middle ware
    io.use((socket, next) => {
      console.log(
        "\x1b[32m------------------- Socket Middleware is Triggered -------------------\x1b[0m"
      );
      //65440d86ecc17751f4bbdb31
      //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NDQwZDg2ZWNjMTc3NTFmNGJiZGIzMSIsImlhdCI6MTY5OTAyNTQyMn0.5bbjDmzk0jFlE28azjTcFqTQkIw7NeyRmDB-sUQxkYA

      const headers = socket.handshake.headers;
      console.log(headers);
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

        socket.user = verified.id;
        socket.token = token;
        socket.chatRoomList = [];
        console.log(socket.user);
        console.log(
          "\x1b[32m------------------- Socket Middleware is Successfully completed -------------------\x1b[0m"
        );
        next();
      } catch (err) {
        console.log("\x1b[31m Middle Ware Auth has issues!! \x1b[0m");
        console.log(err);
      }
    });

    io.on("connection", (socket) => {
      socket.on("joinChatRoom", async (chatRoomId) => {
        console.log(
          "\x1b[32m------------------- Joining ChatRoom is Triggered -------------------\x1b[0m"
        );
        console.log(`1. ${socket.user} joining chatRoom`);
        socket.join(chatRoomId);
        socket.chatRoomList.push(chatRoomId);
        console.log("2. Chat Room Id is " + chatRoomId);
        console.log("User : " + socket.user + " is notified");
        // Fetch the last 50 messages from this chat room and send to the user
        const chatRoom = await ChatRoom.findOne({ _id: chatRoomId }) // Ensure the field to match is correct, usually it's _id for MongoDB
          .populate({
            path: "messages",
            model: "Message",
            options: {
              sort: { timestamp: -1 },
              limit: 50,
            },
          })
          .populate({ path: "seller", model: "User" })
          .populate({ path: "buyer", model: "User" });

        io.to(chatRoomId).emit("chatRoomData", {
          chatRoom,
        });
        console.log(
          "\x1b[32m------------------- Joining ChatRoom is Successfully completed -------------------\x1b[0m"
        );
      });

      socket.on("signin", () => {
        console.log("signin Triggered");
        console.log(socket.user);
        socket.chatRoomList.forEach((chatRoomId) => {
          io.to(chatRoomId).emit("connectStatus", {
            userId: socket.user,
            chatRoomId: chatRoomId,
          });
        });
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
        console.log("send Message");
        console.log(msg);
        console.log("chat Room Id is " + chatRoomId);
        var msg = new Message({
          senderId: socket.user,
          chatRoomId: chatRoomId,
          message: msg,
          type: "text",
          isSeen: false,
        });
        try {
          await msg.save();
          console.log("send message");
          io.to(chatRoomId).emit("receiveMessage", msg);
          console.log("send message1");
        } catch (error) {
          console.error("Error saving message:", error);
        }
      });

      socket.on("broadcast_message", (data) => {
        socket.broadcast.emit("receive_message", data);
      });

      socket.on("disconnect", async () => {
        console.log("Client disconnected");
        socket.chatRoomList.forEach((chatRoomId) => {
          io.to(chatRoomId).emit("disconnectStatus", { userId: socket.user });
        });
        socket.user = "";
        socket.handshake.headers["x-auth-token"] = "";
        console.log(socket.handshake.headers);
        console.log(socket.user);
        // user = await User.findByIdAndUpdate(
        //   socket.user,
        //   { isOnline: false },
        //   { new: true }
        // );
        // Remove socket reference on disconnect
        const userId = Object.keys(userSocketIds).find(
          (id) => userSocketIds[id] === socket.id
        );
        if (userId) {
          delete userSocketIds[userId];
        }
      });
    });

    return io;
  },
};
