const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const Order = require("../models/order");
const { Product } = require("../models/product");
const User = require("../models/user");
const redis_controller = require("../redis_controller/redis_controller");
const { getUserDataFunction } = require("../functions/userdata");
const { logStart, logEnd, handleError } = require("../functions/logFunction");

// get user data
userRouter.get("/", auth, async (req, res) => {
  logStart("User Data Get API");
  try {
    console.log("1. Getting data from redis");
    const data = await redis_controller.get(req.tocken);

    if (data != null && data) {
      console.log("2. Sending data from Redis");
      res.json({ ...data._doc, tocken: req.token });
    } else {
      console.log("2. No Data From Redis");
      console.log("3. Search User From DB");
      const user = await getUserDataFunction(req.user);

      console.log("4. Sending User Data from DB");

      res.json({ ...user._doc, token: req.token });
      logEnd("User Data Get API");
    }
  } catch (e) {
    handleError(res, e);
  }
});

// Delete the product
userRouter.post("/api/delete-product", auth, async (req, res) => {
  logStart("Delete Product API");
  try {
    const { id } = req.body;
    console.log("1. Finding and Delete Product");
    let product = await Product.findByIdAndDelete(id);
    if (product) {
      consolse.log("2. Successfully Deleted");
    } else {
      consolse.log("2. Can't find Product or Couldn't Delete the Product");
    }
    res.json(product);
    logEnd("Delete Product API");
  } catch (e) {
    handleError(res, e);
  }
});
module.exports = userRouter;
