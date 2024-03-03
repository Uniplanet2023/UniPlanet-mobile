import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/features/home/widgets/buildProduct.dart';
import 'package:uniplanet_mobile/models/product_model.dart';

Widget buildProductGrid(
    {required BuildContext context,
    required List<Product> productList,
    required String category}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        alignment: Alignment.topLeft,
        child: Text(
          'Keep shopping for $category',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      Expanded(
        child: GridView.builder(
          itemCount: productList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            final product = productList[index];
            return buildProductItem(product: product, context: context);
          },
        ),
      ),
    ],
  );
}
