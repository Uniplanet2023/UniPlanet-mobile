import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart';
import 'package:uniplanet_mobile/features/search/widget/searched-product.dart';
import 'package:uniplanet_mobile/models/product_model.dart';

class SearchedProductList extends StatelessWidget {
  final List<Product> products;
  const SearchedProductList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailScreen.routeName,
                    arguments: products[index],
                  );
                },
                child: SearchedProduct(
                  product: products[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
