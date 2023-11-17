import mongoose, { Schema } from 'mongoose';
import User from './user';
import { IProduct } from './database_model';

const productSchema: Schema = new mongoose.Schema(
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
      ref: 'User',
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
    likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
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

const Product = mongoose.model<IProduct>('Product', productSchema);
export { Product, productSchema, IProduct };

const changeStream = Product.watch();

changeStream.on('change', async (change) => {
  if (change.operationType === 'insert') {
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
changeStream.on('error', (error) => {
  console.error('Error watching Product collection:', error);
  changeStream.close();
});
