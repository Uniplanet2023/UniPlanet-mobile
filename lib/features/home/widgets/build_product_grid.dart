import 'package:flutter/material.dart';
import 'package:uniket/features/home/widgets/build_product.dart';
import 'package:uniket/features/search/widget/searched_product.dart';
import 'package:uniket/models/product.dart';

Widget buildProductGrid(
    {required BuildContext context,
    required List<Product> productList,
    required String category}) {
  return SafeArea(
    child: Column(
      children: [
        productList.isEmpty
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'Keep shopping for $category',
                  style: const TextStyle(fontSize: 20),
                ),
              )
            : Expanded(
                child: GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: category == "Hot Products" ? 1 : 2,
                    childAspectRatio: category == "Hot Products" ? 3 : 1,
                    mainAxisSpacing: category == "Hot Products" ? 0 : 5,
                  ),
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return category == "Hot Products"
                        ? SearchedProduct(
                            product: product,
                          )
                        : buildProductItem(product: product, context: context);
                  },
                ),
              ),
      ],
    ),
  );
}
