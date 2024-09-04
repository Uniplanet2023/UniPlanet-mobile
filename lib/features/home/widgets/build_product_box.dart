import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/home/widgets/item.dart';
import 'package:uniplanet/models/product.dart';

class ItemList extends StatefulWidget {
  final List<Product> productList;
  const ItemList({super.key, required this.productList});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final productIndex = index;
          final product = widget.productList[productIndex];
          return InkWell(
              onTap: () {
                context
                    .read<ProductBloc>()
                    .add(IncreaseClickProductEvent(product.id));
                Navigator.pushNamed(
                  context,
                  AppRoutes.productDetailsPage,
                  arguments: product,
                );
              },
              child: Item(product: product));
        },
        // 40 list items
        childCount: widget.productList.length,
      ),
    );
  }
}
