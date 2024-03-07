import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/screens/account-screen.dart';
import 'package:uniplanet_mobile/features/add-product/screens/add_product_screen.dart';
import 'package:uniplanet_mobile/features/event/screens/cart.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_layout_screen.dart';
import 'package:uniplanet_mobile/features/home/screens/home_screen.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  ScrollController? _controller;
  bool _isVisible = true;
  String? profileImage;

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AppRoutes.addProductPage);
  }

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
    if (page == 2) {
      navigateToAddProduct();
      return;
    }
    setState(() {
      _page = page;
    });
  }

  void navigateToSearchScreen() {
    Navigator.pushNamed(context, AppRoutes.searchScreenPage);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(controller: _controller!),
      const CartPage(),
      const AddProductScreen(),
      const ChatList(),
      const AccountScreen(),
    ];
    return Scaffold(
        body: Stack(
      children: [
        pages[_page],
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: _isVisible ? -20 : -120,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: InkWell(
                            // Use InkWell to capture the tap event
                            onTap: () =>
                                navigateToSearchScreen(), // Navigate to search screen on tap
                            child: Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black38, width: 1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.black54,
                                    size: 23,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search College Market',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
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
                type: BottomNavigationBarType.fixed,
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
                          bottom: BorderSide(
                            color: _page == 0
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          _page == 0
                              ? const Icon(
                                  Icons.home,
                                )
                              : const Icon(
                                  Icons.home_outlined,
                                ),
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: _page == 0
                                  ? FontWeight.w800
                                  : FontWeight.normal,
                              color: _page == 0
                                  ? GlobalVariables.selectedNavBarColor
                                  : Colors.black,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ],
                      ),
                    ),
                    label: '',
                  ),

                    // My Cart
                    BottomNavigationBarItem(
                      icon: Container(
                        width: bottomBarWidth,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _page == 1
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor,
                              width: bottomBarBorderWidth,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            _page == 1
                                ? const Icon(
                                    Icons.shopping_cart,
                                  )
                                : const Icon(
                                    Icons.shopping_cart_outlined,
                                  ),
                            Text(
                              'Cart',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: _page == 1
                                    ? FontWeight.w800
                                    : FontWeight.normal,
                                color: _page == 1
                                    ? GlobalVariables.selectedNavBarColor
                                    : Colors.black,
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        ),
                      ),
                      label: '',
                    ),

                    //add
                    BottomNavigationBarItem(
                      icon: InkWell(
                        onTap: navigateToAddProduct,
                        child: Container(
                          width: bottomBarWidth,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: GlobalVariables.backgroundColor,
                                width: bottomBarBorderWidth,
                              ),
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                              ),
                              Text(
                                'Sell',
                                style: TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.visible,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      label: '',
                    ),

                    // Chat
                    BottomNavigationBarItem(
                      icon: Container(
                        width: bottomBarWidth,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _page == 3
                                  ? GlobalVariables.selectedNavBarColor
                                  : GlobalVariables.backgroundColor,
                              width: bottomBarBorderWidth,
                            ),
                          ),
                        ),
                        child: badges.Badge(
                          badgeContent: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.red, // Background color for the circle
                              borderRadius:
                                  BorderRadius.circular(10), // Makes it round
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 10, // Minimum width for the red circle
                              minHeight:
                                  10, // Minimum height for the red circle
                            ),
                            child: const Text(
                              '0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize:
                                    12, // You can adjust the font size as needed
                              ),
                            ),
                          ),
                          badgeStyle: const badges.BadgeStyle(
                            elevation: 0,
                            shape: badges.BadgeShape.circle,
                          ),
                          position:
                              badges.BadgePosition.topEnd(top: -12, end: 5),
                          child: Column(
                            children: [
                              _page == 3
                                  ? const Icon(
                                      Icons.chat,
                                    )
                                  : const Icon(
                                      Icons.chat_bubble_outline,
                                    ),
                              Text(
                                'Chat',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: _page == 3
                                      ? FontWeight.w800
                                      : FontWeight.normal,
                                  color: _page == 3
                                      ? GlobalVariables.selectedNavBarColor
                                      : Colors.black,
                                  overflow: TextOverflow.visible,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      label: '',
                    ),
                  // Chat
                  BottomNavigationBarItem(
                    icon: Container(
                      width: bottomBarWidth,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _page == 3
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth,
                          ),
                        ),
                      ),
                      child: badges.Badge(
                        badgeContent: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.red, // Background color for the circle
                            borderRadius:
                                BorderRadius.circular(10), // Makes it round
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 10, // Minimum width for the red circle
                            minHeight: 10, // Minimum height for the red circle
                          ),
                          child: BlocBuilder<AccountBloc, AccountState>(
                            builder: (context, state) {
                              return Text(
                                state.account.unreadMessage.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      12, // You can adjust the font size as needed
                                ),
                              );
                            },
                          ),
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          elevation: 0,
                          shape: badges.BadgeShape.circle,
                        ),
                        position: badges.BadgePosition.topEnd(top: -12, end: 5),
                        child: Column(
                          children: [
                            _page == 3
                                ? const Icon(
                                    Icons.chat,
                                  )
                                : const Icon(
                                    Icons.chat_bubble_outline,
                                  ),
                            Text(
                              'Chat',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: _page == 3
                                    ? FontWeight.w800
                                    : FontWeight.normal,
                                color: _page == 3
                                    ? GlobalVariables.selectedNavBarColor
                                    : Colors.black,
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        ),
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
                          bottom: BorderSide(
                            color: _page == 4
                                ? GlobalVariables.selectedNavBarColor
                                : GlobalVariables.backgroundColor,
                            width: bottomBarBorderWidth,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          _page == 4
                              ? const Icon(
                                  Icons.person,
                                )
                              : const Icon(
                                  Icons.person_outline_outlined,
                                ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: _page == 4
                                  ? FontWeight.w800
                                  : FontWeight.normal,
                              color: _page == 4
                                  ? GlobalVariables.selectedNavBarColor
                                  : Colors.black,
                              overflow: TextOverflow.visible,
                            ),
                          )
                        ],
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
