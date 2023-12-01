import express from 'express'
import { Product } from '../../models/index'
import auth from '../../middlewares/auth'
import { PRODUCT_ROUTE } from '../route_defs'

const searchProductRouter = express.Router()

searchProductRouter.get(`${PRODUCT_ROUTE}/search/:name`, auth, async (req, res) => {
	const products = await Product.find({
		name: { $regex: req.params.name, $options: 'i' },
	}).populate('seller', '-myChatRoom -password -unseenNotifications -unseenMessages')
	res.json(products)
})

export default searchProductRouter
