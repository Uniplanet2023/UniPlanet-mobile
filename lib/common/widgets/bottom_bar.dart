import 'package:flutter/rendering.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/screens/account_screen.dart';
import 'package:uniplanet_mobile/features/cart/screens/cart_screen.dart';
import 'package:uniplanet_mobile/features/home/screens/home_screen.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:uniplanet_mobile/providers/user_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  ScrollController? _controller;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller!.addListener(() {
      if (_controller!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      }
      if (_controller!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isVisible == false) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    List<Widget> pages = [
      HomeScreen(controller: _controller!),
      const AccountScreen(),
      const CartScreen(),
    ];
    return Scaffold(
        body: Stack(
      children: [
        pages[_page],
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: _isVisible ? -20 : -100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: _isVisible
                    ? const EdgeInsets.fromLTRB(0, 8, 0, 10)
                    : const EdgeInsets.fromLTRB(0, 8, 0, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        margin: const EdgeInsets.only(left: 15),
                        child: Material(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 1,
                          child: TextFormField(
                            onFieldSubmitted: navigateToSearchScreen,
                            decoration: InputDecoration(
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 6,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 23,
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(top: 10),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(7),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                              ),
                              hintText: 'Search College Market',
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 42,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child:
                          const Icon(Icons.mic, color: Colors.black, size: 25),
                    ),
                  ],
                ),
              ),
              BottomNavigationBar(
                currentIndex: _page,
                selectedItemColor: GlobalVariables.selectedNavBarColor,
                unselectedItemColor: GlobalVariables.unselectedNavBarColor,
                backgroundColor: GlobalVariables.backgroundColor,
                iconSize: 28,
                onTap: updatePage,
                items: <BottomNavigationBarItem>[
                  // HOME
                  BottomNavigationBarItem(
                    icon: Container(
                      width: bottomBarWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: _page == 0
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.home_outlined,
                      ),
                    ),
                    label: '',
                  ),
                  // ACCOUNT
                  BottomNavigationBarItem(
                    icon: Container(
                      width: bottomBarWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: _page == 1
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline_outlined,
                      ),
                    ),
                    label: '',
                  ),
                  // CART
                  BottomNavigationBarItem(
                    icon: Container(
                      width: bottomBarWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: _page == 2
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth,
                          ),
                        ),
                      ),
                      child: badges.Badge(
                        badgeContent: Text(userCartLen.toString()),
                        badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.white, elevation: 0),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
