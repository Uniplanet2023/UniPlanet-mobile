import express from 'express'
import { Product } from '../../models/index'
import auth from '../../middlewares/auth'
import { PRODUCT_ROUTE } from '../route_defs'

const uploadProductRouter = express.Router()

// Add product
uploadProductRouter.post(`${PRODUCT_ROUTE}/upload_product`, auth, async (req, res) => {
	const { name, forSale, sellerId, description, images, price, category } = req.body

	let product = new Product({
		name,
		forSale,
		seller: sellerId,
		description,
		images,
		price,
		category,
	})

	product = await product.save()
	await product.populate({
		path: 'seller',
		select: '-myChatRoom -password -unseenNotifications -unseenMessages',
	})
	res.json(product)
})
export default uploadProductRouter
