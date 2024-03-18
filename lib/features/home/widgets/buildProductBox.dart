import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/enums/number_formatter.dart';
import 'package:uniplanet_mobile/common/enums/time_formatter.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemBox extends StatefulWidget {
  final List<Product> productList;
  const ItemBox({super.key, required this.productList});

  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  @override
  Widget build(BuildContext context) {
    return widget.productList == []
        ? const Loader()
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final product =
                    widget.productList[widget.productList.length - 1 - index];
                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.productDetailsPage,
                    arguments: product,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      // margin: const EdgeInsets.symmetric(
                      //   horizontal: 10,
                      // ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
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
                                  errorWidget: (context, url, error) =>
                                      Container(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      Text(
                                        product.price == 0
                                            ? 'Free'
                                            : '\$${product.price}',
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 18,
                                            color: Colors.grey.shade800,
                                          ),
                                          Text(
                                            'Yang Hall',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            TimeAgoFormatter(product.createdAt)
                                                .format(),
                                            style: TextStyle(
                                              color: Colors.grey.shade900,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.favorite_border_outlined,
                                                size: 18,
                                              ),
                                              Text(
                                                  NumberFormatter(product.likes)
                                                      .format()),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .chat_bubble_outline_rounded,
                                                    size: 18,
                                                  ),
                                                  Text(NumberFormatter(
                                                          product.likes)
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
              },
              // 40 list items
              childCount: widget.productList.length,
            ),
          );
  }
}
