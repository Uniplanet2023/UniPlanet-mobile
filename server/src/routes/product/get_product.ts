import express, { Request, Response } from 'express'
import { Product } from '../../models/index'
import { PRODUCT_ROUTE } from '../route_defs'

const getRecentProductRouter = express.Router()

getRecentProductRouter.get(`${PRODUCT_ROUTE}`, async (req: Request, res: Response) => {
	const { page, category } = req.query
	const pageNumber = parseInt(page as string, 10)

	const limit = 20
	const skip = pageNumber * limit
	const products = await Product.find({ category }).sort({ createdAt: -1 }).skip(skip).limit(limit).populate({
		path: 'seller',
		select: '-myChatRoom -password -unseenNotifications -unseenMessages',
	})
	res.json(products)
})
// let products = await getJson('products')

// if (products !== null && products.length !== 0) {
// 	console.log('1. Search Data from Redis, product file')
// 	res.json(products)
// } else {
// 	console.log('2. Search from database, product file')
// 	products = await Product.find().sort({ createdAt: -1 }).skip(skip).limit(limit).populate({
// 		path: 'seller',
// 		select: '-myChatRoom -password -unseenNotifications -unseenMessages',
// 	})

// 	res.json(products)

// 	console.log('3. Fetching Datata to Redis')
// 	const categories = ['Mobiles', 'Essentials', 'Appliances', 'Books', 'Fashion']
// 	const dbQueries = categories.map(category =>
// 		Product.find({ category })
// 			.sort({ timestamp: -1 })
// 			.limit(20)
// 			.populate('seller', '-myChatRoom -password -unseenNotifications -unseenMessages'),
// 	)
// 	const results = await Promise.all(dbQueries)

// 	console.log('4. Updating Data to Redis')
// 	const redisQueries = categories.map((category, index) => setJson(category, '$', results[index]))
// 	await Promise.all(redisQueries)
// }
// })
export default getRecentProductRouter
