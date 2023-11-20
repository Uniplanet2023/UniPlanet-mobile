const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const redis_controller = require("../redis_controller/redis_controller");
productRouter.get("/api/all-products", async (req, res) => {
  logStart("Getting All product API");
  try {
    let page = 0;
    if (req.query.page) {
      page = parseInt(req.query.page);
    }
    const limit = 20;
    const skip = page * limit;

    var products = await getJson("products");

    if (products != null && products.length != 0) {
      console.log("1. Search Data from Redis, product file");
      res.json(products);
    } else {
      console.log("2. Search from database, product file");
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
        setJson(category, "$", results[index])
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
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
productRouter.get("/api/products", async (req, res) => {
  console.log("category api is triggerd");
  let data;
  try {
    if (req.query.category) {
      console.log("search from redis");
      data = await redis_controller.getJson(req.query.category);
      res.json(data);
    }
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Add product
productRouter.post("/api/add-product", auth, async (req, res) => {
  try {
    console.log("add product is triggered");
    console.log(req.body);
    const {
      name,
      seller,
      seller_id,
      description,
      images,
      quantity,
      price,
      category,
    } = req.body;
    console.log(req.user);
    let product = new Product({
      name,
      sellerName: seller,
      sellerId: seller_id,
      description,
      images,
      quantity,
      price,
      category,
    });
    console.log(product);
    Promise.all([
      (product = await product.save()),
      await redis_controller.addJson("products", product),
      await redis_controller.addJson(product.category, product),
    ]);
    res.json(product);
  } catch (e) {
    console.log(e);
    res.status(500).json({ error: e.message });
  }
});

// create a post request route to rate the product.
productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    let product = await Product.findById(id);

    for (let i = 0; i < product.ratings.length; i++) {
      if (product.ratings[i].userId == req.user) {
        product.ratings.splice(i, 1);
        break;
      }
    }

    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.ratings.push(ratingSchema);
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

productRouter.get("/api/deal-of-day", async (req, res) => {
  try {
    let products = await Product.find({});

    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      for (let i = 0; i < a.ratings.length; i++) {
        aSum += a.ratings[i].rating;
      }

      for (let i = 0; i < b.ratings.length; i++) {
        bSum += b.ratings[i].rating;
      }
      return aSum < bSum ? 1 : -1;
    });

    res.json(products[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = productRouter;
