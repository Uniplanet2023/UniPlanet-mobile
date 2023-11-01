const socketIo = require("socket.io");
const Message = require("../models/message");
const { createAdapter } = require("@socket.io/redis-adapter");
const jwt = require("jsonwebtoken");
const cors = require("cors");
let io;

// Store socket references for each user
const userSocketIds = {};
const auth = require("../middlewares/auth");
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
      var clients = {};
      const headers = socket.handshake.headers;
      try {
        console.log("1. Getting Token from header");
        const token = headers["x-auth-token"];
        if (!token) {
          console.log("No token");
          return;
        }
        console.log("2. Token Verification");
        const verified = jwt.verify(token, "passwordKey");
        if (!verified) {
          console.log("Token verification failed, authorization denied.");
          return;
        }
        console.log("3. Setting User Id into the Socket");
        socket.user = verified.id;
        socket.token = token;
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
      console.log(
        "\x1b[32m------------------- Socket Connect is Triggered -------------------\x1b[0m"
      );
      console.log("1. Socket Server is connected");
      console.log("2. Socket Client is connected", socket.id);
      console.log(
        "\x1b[32m------------------- All the Connect is successfully connected -------------------\x1b[0m"
      );
      console.log("");
      socket.on("joinChatRoom", async (chatRoomId) => {
        console.log(`${socket.user}joining chatRoom`);
        socket.join(chatRoomId);
        console.log("Chat Room Id is " + chatRoomId);
        // Fetch the last 50 messages from this chat room and send to the user
        const messages = await Message.find({ chatRoomId: chatRoomId })
          .sort({ timestamp: -1 })
          .limit(50);
        socket.emit("previousMessages", messages);
      });

      socket.on("signin", (id) => {
        // Authenticate the user here before proceeding
        userSocketIds[id] = socket.id;
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

      socket.on("disconnect", () => {
        console.log("Client disconnected");
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
