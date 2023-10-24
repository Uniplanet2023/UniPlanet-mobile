const express = require("express");
const chatRouter = express.Router();
const auth = require("../middlewares/auth");
const redis_controller = require("../redis_controller/redis_controller");
const Message = require("../models/message");
chatRouter.post("/api/message", auth, async (req, res) => {
  try {
    console.log("message triggered");
    const { user_id, receiver_id, message } = req.body;
    let msg = new Message({
      senderId: user_id,
      receiverId: receiver_id,
      message,
      type: "text",
      isSeen: false,
    });
    console.log(msg);

    Promise.all([
      (product = await product.save()),
      await redis_controller.addJson("products", product),
      await redis_controller.addJson(product.category, product),
    ]);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
module.exports = chatRouter;
