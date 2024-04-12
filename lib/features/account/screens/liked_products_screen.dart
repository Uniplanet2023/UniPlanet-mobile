import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/features/account/widgets/inventory_screen_product_box.dart';

class LikedProductsScreen extends StatelessWidget {
  final ScrollController controller;
  const LikedProductsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Products'),
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          BlocBuilder<LikeBloc, LikeState>(
            builder: (context, state) {
              return InventoryProductBox(
                productList: state.likeProduct,
              );
            },
          ),
        ],
      ),
    );
  }
}
