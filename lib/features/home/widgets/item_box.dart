import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart';
import 'package:uniplanet_mobile/models/product.dart';

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
                        Image.network(
                          product.images[0],
                          fit: BoxFit.contain,
                          height: 135,
                          width: 135,
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
