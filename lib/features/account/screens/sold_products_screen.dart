import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
// import 'package:uniplanet_mobile/bloc/product/product_state/basic_state.dart';
import 'package:uniplanet_mobile/features/account/widgets/inventory_screen_product_box.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class SoldProductsScreen extends StatelessWidget {
  final ScrollController controller;
  final User user;
  const SoldProductsScreen(
      {super.key, required this.controller, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold Products'),
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return InventoryProductBox(
                productList: state.productList
                    .where((product) =>
                        (product.seller.id == user.id) &&
                        (product.status == 'Sold'))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
