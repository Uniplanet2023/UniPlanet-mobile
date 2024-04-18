import 'package:flutter/material.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/bloc/product/product_bloc.dart';
import 'package:uniket/common/routes/names.dart';
import 'package:uniket/features/search/widget/searched-product.dart';
import 'package:uniket/models/product.dart';

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
        return SearchedProduct(
          product: widget.products[index],
        );
      },
    );
  }
}
