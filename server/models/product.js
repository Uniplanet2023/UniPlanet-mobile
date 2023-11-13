const mongoose = require("mongoose");
const User = require("./user");
const productSchema = mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    forSale: {
      type: Boolean,
      required: true,
    },
    seller: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    images: [
      {
        type: String,
        required: true,
      },
    ],
    likes: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    price: {
      type: Number,
      required: true,
    },
    category: {
      type: String,
      required: true,
      index: true,
    },
  },
  { timestamps: true }
);

const Product = mongoose.model("Product", productSchema);
module.exports = { Product, productSchema };
// Function to handle the change event

const changeStream = Product.watch();

changeStream.on("change", async (change) => {
  if (change.operationType === "insert") {
    const productId = change.documentKey._id;
    const sellerId = change.fullDocument.seller;

    try {
      await User.updateOne(
        { _id: sellerId },
        { $push: { selling: productId } }
      );
      console.log(`Updated seller ${sellerId} with new product ${productId}`);
    } catch (error) {
      console.error(`Error updating seller ${sellerId}: ${error}`);
    }
  }
});

// Make sure to handle errors and close the change stream when the application is terminating
changeStream.on("error", (error) => {
  console.error("Error watching Product collection:", error);
  changeStream.close();
});

process.on("SIGINT", () => {
  changeStream.close(() => {
    console.log("Change stream closed due to application termination");
    process.exit(0);
  });
});
