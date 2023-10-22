import 'package:uniplanet_mobile/features/home/widgets/item_box.dart';
import 'package:uniplanet_mobile/features/home/widgets/top_categories.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/product_repo.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  final ScrollController controller;
  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _pinned = false;
  final bool _snap = true;
  final bool _floating = true;
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProductsAll();
  }

  void fetchProductsAll() async {
    print('fetch Product is triggered');
    productList = await ProductRepository().fetchAllProducts(context);
    setState(() {});
  }

  void updateProducts() async {}
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      controller: widget.controller,
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
        ItemBox(
          productList: productList,
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
