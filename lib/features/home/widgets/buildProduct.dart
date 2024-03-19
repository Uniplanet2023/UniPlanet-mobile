import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/enums/number_formatter.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/models/product.dart';

Widget buildProductItem(
    {required BuildContext context, required Product product}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        AppRoutes.productDetailsPage,
        arguments: product,
      );
    },
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 0),
      child: Card(
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: 2 / 1.3,
                child: Hero(
                  tag: "product-picture-${product.id}",
                  child: CachedNetworkImage(
                    imageUrl: product.images[0],
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red, size: 80),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          product.price == 0 ? 'Free' : '\$${product.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_outlined,
                        size: 18,
                      ),
                      Text(NumberFormatter(product.likes).format()),
                      const SizedBox(
                        width: 4,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 18,
                          ),
                          Text(NumberFormatter(product.likes).format())
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
