const express = require("express");
const likeRouter = express.Router();
const auth = require("../middlewares/auth");
const Order = require("../models/order");
const { Product } = require("../models/product");
const User = require("../models/user");
const redis_controller = require("../redis_controller/redis_controller");

likeRouter.post("/api/add-like", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.like.length == 0) {
      user.like.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.like.length; i++) {
        if (user.like[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.like.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.like.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

likeRouter.delete("/api/remove-from-like/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.like.length; i++) {
      if (user.like[i].product._id.equals(product._id)) {
        if (user.like[i].quantity == 1) {
          user.like.splice(i, 1);
        } else {
          user.like[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = likeRouter;
