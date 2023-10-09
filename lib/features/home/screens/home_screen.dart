import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/home/widgets/address_box.dart';
import 'package:uniplanet_mobile/features/home/widgets/carousel_image.dart';
import 'package:uniplanet_mobile/features/home/widgets/deal_of_day.dart';
import 'package:uniplanet_mobile/features/home/widgets/top_categories.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

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
            expandedHeight: 0.0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/UniPlanet Caligraphy.png',
                    width: 100,
                    height: 70,
                    color: Colors.black,
                  ),
                ],
              ),
              background: const DecoratedBox(
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
            child: Column(
              children: [
                // AddressBox(),
                SizedBox(height: 10),
                TopCategories(),
                SizedBox(height: 10),
                CarouselImage(),
                DealOfDay(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
