import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/widgets/loader.dart';
import 'package:uniplanet_mobile/features/home/services/home_services.dart';
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
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        widget.productList[index].images[0],
                        fit: BoxFit.contain,
                        height: 135,
                        width: 135,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 235,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              widget.productList[index].name,
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
                              '\$${widget.productList[index].price}',
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
                            child: const Text('Eligible for FREE Shipping'),
                          ),
                          Container(
                            width: 235,
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            child: const Text(
                              'In Stock',
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
                );
              },
              // 40 list items
              childCount: widget.productList.length,
            ),
          );
  }
}
