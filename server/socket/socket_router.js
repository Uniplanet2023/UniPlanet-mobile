const socketIo = require("socket.io");
const Message = require("../models/message");
const { createAdapter } = require("@socket.io/redis-adapter");
let io;

// Store socket references for each user
const userSocketIds = {};

module.exports = {
  init: (httpServer, pubClient, subClient) => {
    io = socketIo(httpServer);
    io.adapter(createAdapter(pubClient, subClient));
    io.on("connection", (socket) => {
      console.log("New client connected", socket.id);

      socket.on("/test", (msg) => {
        console.log(msg);
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

      socket.on("message", async (msg) => {
        console.log(msg);
        const message = new Message({
          senderId: msg.userId,
          receiverId: msg.targetId,
          message: msg.content,
        });
        try {
          await message.save();
          const targetSocketId = userSocketIds[msg.targetId];
          if (targetSocketId) {
            io.to(targetSocketId).emit("message", msg);
          }
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
