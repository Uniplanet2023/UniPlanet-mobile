import 'package:cached_network_image/cached_network_image.dart';
import 'package:uniplanet_mobile/constants/number_formatter.dart';
import 'package:uniplanet_mobile/constants/time_formatter.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            children: [
              Hero(
                tag: "product-picture-${product.id}",
                child: CachedNetworkImage(
                  cacheManager: GlobalVariables.customCacheManager,
                  imageUrl: product.images[0],
                  key: UniqueKey(),
                  fit: BoxFit.contain,
                  height: 135,
                  width: 135,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.price == 0 ? 'Free' : '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      const Text(
                        'Location goes here',
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: GlobalVariables.secondaryColor),
                        maxLines: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TimeAgoFormatter(product.createdAt).format(),
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
                      const Divider(
                        thickness: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
