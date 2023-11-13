const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const redis_controller = require("../redis_controller/redis_controller");
const { logStart, logEnd, handleError } = require("../functions/logFunction");

productRouter.get("/api/all-products", async (req, res) => {
  logStart("Getting All product API");
  try {
    let page = 0;
    if (req.query.page) {
      page = req.query.page;
    }
    const limit = 20;
    const skip = page * limit;

    var products = await redis_controller.getJson("products");

    if (products != null && products && products.length != 0) {
      console.log("1. Search Data from Redis , product file");
      res.json(products);
    } else {
      console.log("2. Search from database , product file");
      products = await Product.find()
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .populate({
          path: "seller",
          select: "-myChatRoom -password -unseenNotifications -unseenMessages",
        });

      res.json(products);

      console.log("3. Fetching Datata to Redis");
      const categories = [
        "Mobiles",
        "Essentials",
        "Appliances",
        "Books",
        "Fashion",
      ];
      const dbQueries = categories.map((category) =>
        Product.find({ category })
          .sort({ timestamp: -1 })
          .limit(20)
          .populate(
            "seller",
            "-myChatRoom -password -unseenNotifications -unseenMessages"
          )
      );
      const results = await Promise.all(dbQueries);

      console.log("4. Updating Data to Redis");
      const redisQueries = categories.map((category, index) =>
        redis_controller.setJson(category, "$", results[index])
      );
      await Promise.all(redisQueries);
    }

    logEnd("Getting All product API");
  } catch (e) {
    handleError(res, e);
  }
});

// create a get request to search products and get them
// /api/products/search/i
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    logStart("Searching product API");
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    }).populate(
      "seller",
      "-myChatRoom -password -unseenNotifications -unseenMessages"
    );
    res.json(products);
    logEnd("Searching product API");
  } catch (e) {
    handleError(res, e);
  }
});
productRouter.get("/api/products", async (req, res) => {
  logStart("Searching Category Product API");
  let data;
  try {
    console.log("1. Checking if there is category in query");
    if (req.query.category) {
      console.log("2. Search product from Redis");
      data = await redis_controller.getJson(req.query.category);
      res.json(data);
    }
    logEnd("Searching product API");
  } catch (e) {
    handleError(res, e);
  }
});

// Add product
productRouter.post("/api/add-product", auth, async (req, res) => {
  logStart("Adding Product");
  try {
    const { name, forSale, sellerId, description, images, price, category } =
      req.body;
    console.log("1. Creating Product Model");
    let product = new Product({
      name,
      forSale,
      seller: sellerId,
      description,
      images,
      price,
      category,
    });

    console.log("2. Adding Product to Database and Redis");
    product = await product.save();
    await product.populate({
      path: "seller",
      select: "-myChatRoom -password -unseenNotifications -unseenMessages",
    });
    res.json(product);
    Promise.all([
      await redis_controller.addJson("products", product),
      await redis_controller.addJson(product.category, product),
    ]);

    logEnd("Adding Product");
  } catch (e) {
    handleError(res, e);
  }
});

module.exports = productRouter;
