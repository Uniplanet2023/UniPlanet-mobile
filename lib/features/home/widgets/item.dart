import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/number_formatter.dart';
import 'package:uniplanet/core/utils/price_formatter.dart';
import 'package:uniplanet/core/utils/time_formatter.dart';
import 'package:uniplanet/features/auth/presention/blocs/like/like_bloc.dart';
import 'package:uniplanet/models/product.dart';

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag:
                        "product-picture-${product.id}-${UniqueKey().hashCode}",
                    child: product.images.isEmpty
                        ? const Icon(
                            Icons.image_not_supported,
                            size: 100,
                          )
                        : CachedNetworkImage(
                            cacheManager: GlobalVariables.customCacheManager,
                            imageUrl: product.images[0],
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                            height: 110,
                            width: 110,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black12,
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
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
                          "${product.name[0].toUpperCase()}${product.name.substring(1)}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        product.isAdvertisement
                            ? const Text(
                                'Ads',
                                style: TextStyle(
                                  color: GlobalVariables.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : product.price == 0
                                ? Text(
                                    product.price == 0
                                        ? 'Free'
                                        : '\$${product.price}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '\$',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiaryContainer,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${PriceFormatter(product.price).getDigit()}.',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: PriceFormatter(
                                                        product.price)
                                                    .getDecimal(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      product.isNegotiable
                                          ? const Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .handshake, // Placeholder for an appropriate icon
                                                  color: GlobalVariables
                                                      .secondaryColor,
                                                  size: 14,
                                                ),
                                                Text(
                                                  'Negotiable',
                                                  style: TextStyle(
                                                    color: GlobalVariables
                                                        .secondaryColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: GlobalVariables.secondaryColor,
                            ),
                            Expanded(
                              child: Text(
                                product.city != null
                                    ? product.city!
                                    : product.location,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: GlobalVariables.secondaryColor,
                                ),
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
                              TimeAgoFormatter(product.updatedAt).format(),
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
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
                                      isLikeProduct = false;
                                      state.removedProduct = null;
                                    } else if (state is LikeAdded &&
                                        state.addedProduct != null &&
                                        state.addedProduct!.id == product.id) {
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
                                            ? const Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 18,
                                              )
                                            : Icon(Icons.favorite_border,
                                                size: 18,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiaryContainer),
                                        product.likes == 0
                                            ? const SizedBox()
                                            : Text(
                                                NumberFormatter(product.likes)
                                                    .format(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiaryContainer)),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.chat_bubble_outline_rounded,
                                        size: 17,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer),
                                    product.numberOfChat == 0
                                        ? const SizedBox()
                                        : Text(
                                            NumberFormatter(
                                                    product.numberOfChat)
                                                .format(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiaryContainer))
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
    );
  }
}
