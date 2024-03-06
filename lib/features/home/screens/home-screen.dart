import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/bloc/product/product_bloc.dart';
import 'package:uniplanet_mobile/bloc/product/product_state/basic_state.dart';
import 'package:uniplanet_mobile/features/home/widgets/buildProductBox.dart';
import 'package:uniplanet_mobile/features/home/widgets/top_categories.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController controller;
  const HomeScreen({super.key, required this.controller});

  final bool _pinned = false;

  final bool _snap = true;

  final bool _floating = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 30.0,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(left: 20),
              title: TopCategories(),
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 114, 226, 221),
                      Color.fromARGB(255, 162, 236, 233),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return ItemBox(
                productList: state.productList,
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
