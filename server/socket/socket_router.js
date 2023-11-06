const socketIo = require("socket.io");
const Message = require("../models/message");
const { createAdapter } = require("@socket.io/redis-adapter");
const jwt = require("jsonwebtoken");
const ChatRoom = require("../models/chat_room");
const creatingChatRoom = require("../routes/chatFunction");
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

    //Middle ware (Socket middle ware)
    io.use((socket, next) => {
      console.log(
        "\x1b[32m------------------- Socket Middleware is Triggered -------------------\x1b[0m"
      );

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

        socket.user = verified.id; //user ID
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
    // socket API
    io.on("connection", (socket) => {
      socket.on("joinChatRoom", async (chatRoomId) => {
        console.log(
          "\x1b[32m------------------- Joining ChatRoom is Triggered -------------------\x1b[0m"
        );

        let userList = await isUserInChatRoom(chatRoomId);
        socket.chatRoomList.push(chatRoomId);
        if (userList.length == 0 || !userList.includes(socket.user)) {
          socket.join(chatRoomId);
          console.log(`1. ${socket.user} joining chatRoom`);
          userList.push(socket.user);
        }
        console.log("Final userList is " + userList);
        io.to(chatRoomId).emit("connectStatus", {
          userId: userList,
          chatRoomId: chatRoomId,
        });

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
        console.log(
          "\x1b[32m----------------- Socket API : Send Message  is Triggered -----------------\x1b[0m"
        );
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
          io.to(chatRoomId).emit("receiveMessage", msg); //Front End
          await msg.save(); // saving msg to the mongo db

          console.log(
            "\x1b[32m----------------- Socket API : Send Message  is Successfully Completed -----------------\x1b[0m"
          );
        } catch (error) {
          console.error("Error saving message:", error);
        }
      });
      socket.on("creating_chatRoom", async (receiverId) => {
        // Socket (Temp), DB (Persistant)
        var chatRoom = await creatingChatRoom(socket.user, receiverId); // Creating ChatRoom to the Mongo DB
        // Every socket is different
        socket.join(chatRoom._id); // Creating Chatroom and Join the chatRoom (Chat Room in Socket Level)

        io.to(chatRoom._id).emit("connectStatus", {
          userId: [socket.user],
          chatRoomId: chatRoom._id,
        }); // client have to let seller know I'm in the online.
        io.to(chatRoom._id).emit("chatRoomInvitation"); // Clinet make a chatroom. seller have to join.
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
