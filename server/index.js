// IMPORTS FROM PACKAGES
const express = require("express");
const mongoose = require("mongoose");
/// Real Time Connection
const http = require("http");
const redis_socket_controller = require("./redis_controller/redis_controller");

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
redis_socket_controller.init(server);

// middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

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
