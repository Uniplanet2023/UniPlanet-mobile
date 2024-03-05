import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/productBloc/product_bloc.dart';
import 'package:uniplanet_mobile/features/home/widgets/item_box.dart';
import 'package:uniplanet_mobile/features/home/widgets/top_categories.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  final ScrollController controller;
  const HomeScreen({super.key, required this.controller});

  final bool _pinned = false;

  final bool _snap = true;

  final bool _floating = true;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<ProductBloc>().state;
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
            titlePadding: EdgeInsets.fromLTRB(20, 5, 20, 0),
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
        ItemBox(
          productList: state.productList!,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
          ),
        ),
      ],
    ));
  }
}
