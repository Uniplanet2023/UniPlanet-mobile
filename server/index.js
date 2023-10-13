// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
/// Real Time Connection
const http = require("http");
const socketController = require("./socket/socket_router");
const redis = require("redis");
// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
const adminRouter = require("./routes/admin");
// INIT
require("dotenv").config();
const PORT = process.env.PORT || 3000;
const app = express();
const server = http.createServer(app);
const pubClient = redis.createClient({
  password: process.env.REDIS_PASSWORD, // Use environment variable
  socket: {
    host: process.env.REDIS_HOST,
    port: process.env.REDIS_PORT,
  },
});
const subClient = pubClient.duplicate();

//Redis DB Setting
pubClient.on("error", (err) => console.log("Redis Client Error", err));
pubClient.on("connect", () => console.log("Pub Connected to Redis"));
subClient.on("connect", () => console.log("Sub Connected to Redis"));
// middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// DB,redis Connections
Promise.all([pubClient.connect(), subClient.connect()]).then(() => {
  socketController.init(server, pubClient, subClient);
});

mongoose
  .connect(process.env.MONGO_DB_HOST)
  .then(() => {
    console.log("Mongo DB Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

server.listen(PORT, () => {
  console.log(`BackEnd Server connected at port ${PORT}`);
});
