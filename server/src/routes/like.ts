import express, { Request, Response } from 'express';
import auth from '../middlewares/auth';
import { Product } from '../models/product'; // Keep as is if Product is a named export
import User from '../models/user'; // Assuming you have default exports
import * as redis_controller from '../redis_controller/redis_controller'; // If exporting multiple items
import { logStart, logEnd, handleError } from '../functions/logFunction';

const likeRouter = express.Router();

likeRouter.post('/api/add-like', auth, async (req: Request, res: Response) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (!user || !product) {
      return res.status(404).send('User or Product not found');
    }

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
    handleError(res, e as Error);
  }
});

likeRouter.delete(
  '/api/remove-from-like/:id',
  auth,
  async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const product = await Product.findById(id);
      let user = await User.findById(req.user);

      if (!user || !product) {
        return res.status(404).send('User or Product not found');
      }

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
      handleError(res, e as Error);
    }
  }
);
export default likeRouter;
