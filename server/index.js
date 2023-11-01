// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
/// Real Time Connection
const http = require("http");
const redis_socket_controller = require("./redis_controller/redis_controller");

// IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
const likeRouter = require("./routes/like");
const chatRouter = require("./routes/chat");
// INIT
require("dotenv").config();
const PORT = process.env.PORT || 3000;
const app = express();
const server = http.createServer(app);
redis_socket_controller.init(server);

// middleware
app.use(express.json());
app.use(authRouter);
app.use(chatRouter);
app.use(productRouter);
app.use(userRouter);
app.use(likeRouter);
app.use(cors());
mongoose
  .connect(process.env.MONGO_DB_HOST)
  .then(() => {
    console.log("3. DB Connection : Mongo DB Connection Successful");
    console.log(
      "\x1b[32m------------------- All the Connect is successfully connected -------------------\x1b[0m "
    );
    console.log("");
  })

  .catch((e) => {
    console.log(e);
  });

server.listen(PORT, () => {
  console.log("");
  console.info(
    "\x1b[32m------------------- Back End Connection is Staring -------------------\x1b[0m"
  );
  console.log(
    `1. BackEnd Connection : BackEnd Server connected at port ${PORT}`
  );
});
