import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/features/search/widget/searched-product.dart';
import 'package:uniplanet_mobile/models/product.dart';

class SearchedProductList extends StatefulWidget {
  final List<Product> products;
  const SearchedProductList({
    super.key,
    required this.products,
  });

  @override
  State<SearchedProductList> createState() => _SearchedProductListState();
}

class _SearchedProductListState extends State<SearchedProductList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.productDetailsPage,
              arguments: widget.products[index],
            );
          },
          child: SearchedProduct(
            product: widget.products[index],
          ),
        );
      },
    );
  }
}
