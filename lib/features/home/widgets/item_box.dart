import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemBox extends StatefulWidget {
  final List<Product> productList;
  const ItemBox({Key? key, required this.productList}) : super(key: key);

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
                    ProductDetailScreen.routeName,
                    arguments: product,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            cacheManager: GlobalVariables.customCacheManager,
                            imageUrl: product.images[0],
                            key: UniqueKey(),
                            fit: BoxFit.contain,
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
                        Column(
                          children: [
                            Container(
                              width: 235,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "${product.name[0].toUpperCase()}${product.name.substring(1).toLowerCase()}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: 235,
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                '\$${product.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: 235,
                              padding: const EdgeInsets.only(left: 10),
                              child: const Row(
                                children: [
                                  Icon(Icons.location_on),
                                  Text('Yang Hall'),
                                ],
                              ),
                            ),
                            Container(
                              width: 235,
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: const Text(
                                'On Sell',
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                      ],
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
