import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/common/routes/names.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/constants/number_formatter.dart';
import 'package:uniket/constants/price_formatter.dart';
import 'package:uniket/constants/time_formatter.dart';
import 'package:uniket/models/product.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.productDetailsPage,
        arguments: product,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: "product-picture-${product.id}",
                      child: product.images.isEmpty
                          ? const Icon(
                              Icons.image_not_supported,
                              size: 135,
                            )
                          : Container(
                              foregroundDecoration: BoxDecoration(
                                color: (product.status == 'On Sale')
                                    ? Colors.transparent
                                    : Colors.grey,
                                backgroundBlendMode: BlendMode.saturation,
                              ),
                              child: CachedNetworkImage(
                                cacheManager:
                                    GlobalVariables.customCacheManager,
                                imageUrl: product.images[0],
                                key: UniqueKey(),
                                fit: BoxFit.cover,
                                height: 135,
                                width: 135,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.black12,
                                  child: const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${product.name[0].toUpperCase()}${product.name.substring(1).toLowerCase()}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          product.price == 0
                              ? Text(
                                  product.price == 0
                                      ? 'Free'
                                      : '\$${product.price}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              : Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: '\$',
                                            style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                '${PriceFormatter(product.price).getDigit()}.',
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: PriceFormatter(product.price)
                                                .getDecimal(),
                                            style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.bold))
                                      ]),
                                    )
                                  ],
                                ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: product.status == 'On Sale'
                                    ? GlobalVariables.secondaryColor
                                    : Colors.grey,
                              ),
                              Expanded(
                                child: Text(
                                  product.location,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: product.status == 'On Sale'
                                          ? GlobalVariables.secondaryColor
                                          : Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                TimeAgoFormatter(product.createdAt).format(),
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  BlocBuilder<LikeBloc, LikeState>(
                                    builder: (context, state) {
                                      bool isLikeProduct = false;

                                      if (state is LikeRemoved &&
                                          state.removedProduct != null &&
                                          state.removedProduct!.id ==
                                              product.id) {
                                        product.likes = product.likes - 1;
                                        state.removedProduct = null;
                                      } else if (state is LikeAdded &&
                                          state.addedProduct != null &&
                                          state.addedProduct!.id ==
                                              product.id) {
                                        product.likes = product.likes + 1;
                                        isLikeProduct = true;
                                        state.addedProduct = null;
                                      } else {
                                        for (var element in state.likeProduct) {
                                          if (element.id == product.id) {
                                            isLikeProduct = true;
                                            break;
                                          }
                                        }
                                      }

                                      return Row(
                                        children: [
                                          isLikeProduct
                                              ? const Icon(Icons.favorite,
                                                  color: Colors.red)
                                              : const Icon(
                                                  Icons.favorite_border),
                                          Text(NumberFormatter(product.likes)
                                              .format()),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        size: 18,
                                      ),
                                      Text(NumberFormatter(product.numberOfChat)
                                          .format())
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 0.2,
                indent: 8,
                endIndent: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
