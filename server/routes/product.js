const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const redis_controller = require("../redis_controller/redis_controller");
productRouter.get("/api/all-products", async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Product API : Getting All product API is triggered -----------------\x1b[0m"
    );

    var products = await redis_controller.getJson("products");

    if (products != null && products && products.length != 0) {
      console.log("1. Search Data from Redis , product file");
    } else {
      console.log("2. Search from database , product file");
      Promise.all([
        (products = await Product.find().sort({ created_at: -1 }).limit(20)),
        (mobileProducts = await Product.find({ category: "Mobiles" })
          .sort({ timestamp: -1 })
          .limit(20)),
        (essentialProducts = await Product.find({ category: "Essentials" })
          .sort({ timestamp: -1 })
          .limit(20)), //Fashion
        (applianceProducts = await Product.find({ category: "Appliances" })
          .sort({ timestamp: -1 })
          .limit(20)),
        (booksProducts = await Product.find({ category: "Books" })
          .sort({ timestamp: -1 })
          .limit(20)),
        (fashionProducts = await Product.find({ category: "Fashion" })
          .sort({ timestamp: -1 })
          .limit(20)),
      ]);
      console.log("3. Fetching Datata to Redis");
      Promise.all([
        await redis_controller.setJson("products", "$", products),
        await redis_controller.setJson("Mobiles", "$", mobileProducts),
        await redis_controller.setJson("Essentials", "$", essentialProducts),
        await redis_controller.setJson("Appliances", "$", applianceProducts),
        await redis_controller.setJson("Books", "$", booksProducts),
        await redis_controller.setJson("Fashion", "$", fashionProducts),
      ]);

      console.log("4. Updating Data to Redis");
    }

    res.json(products);
    console.log(
      "\x1b[32m----------------- Product API : Getting All product API is scuessfully completed -----------------\x1b[0m"
    );
    console.log("");
  } catch (e) {
    console.log(
      "\x1b[31m There is Issues at Product API: Getting All Product\x1b[0m"
    );
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

// create a get request to search products and get them
// /api/products/search/i
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Product API : Searching product API is triggered -----------------\x1b[0m"
    );
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });

    res.json(products);
    console.log(
      "\x1b[32m----------------- Product API : Searching product API is Sucessfully completed -----------------\x1b[0m"
    );
    console.log("");
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
productRouter.get("/api/products", async (req, res) => {
  console.log(
    "\x1b[32m----------------- Product API : Searching Category Product API is Triggered -----------------\x1b[0m"
  );
  let data;
  try {
    console.log("1. Checking if there is category in query");
    if (req.query.category) {
      console.log("2. Search product from Redis");
      data = await redis_controller.getJson(req.query.category);
      res.json(data);
    }
    console.log(
      "\x1b[32m----------------- Product API : Searching product API is Sucessfully completed -----------------\x1b[0m"
    );
    console.log("");
  } catch (e) {
    console.log(
      "\x1b[31m----------------- There is Issues at Searching Category Product API -----------------\x1b[0m"
    );
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

// Add product
productRouter.post("/api/add-product", auth, async (req, res) => {
  try {
    console.log(
      "\x1b[32m----------------- Product API : Adding Product is Triggered -----------------\x1b[0m"
    );
    const { name, forSale, seller, description, images, price, category } =
      req.body;
    console.log("1. Creating Product Model");
    let product = new Product({
      name,
      forSale,
      seller,
      description,
      images,
      price,
      category,
    });

    console.log("2. Adding Product to Database and Redis");
    console.log(product);
    Promise.all([
      (product = await product.save()),
      await redis_controller.addJson("products", product),
      await redis_controller.addJson(product.category, product),
    ]);
    res.json(product);
    console.log(
      "\x1b[32m----------------- Product API : Adding Product is Successfully completed -----------------\x1b[0m"
    );
    console.log("");
  } catch (e) {
    console.error("\x1b[31m There is Issues at Adding Product API \x1b[0m");
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
