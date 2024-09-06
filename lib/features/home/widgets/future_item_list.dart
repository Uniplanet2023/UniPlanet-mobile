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
  State<ItemList> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // Determine the actual item index (excluding ads)
          final productIndex = index - (index ~/ 6);

          // Insert an ad every 5 items
          if (index % 6 == 5) {
            return _buildAdContainer();
          }

          // Get the product and build the item
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
        // Total count should include ads as well
        childCount:
            widget.productList.length + (widget.productList.length ~/ 5),
      ),
    );
  }

  Widget _buildAdContainer() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetailsPage,
          arguments: widget.productList[0],
        );
      },
      child: Item(product: widget.productList[0]),
    );
  }
}
