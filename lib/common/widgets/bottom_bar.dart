import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/functions/streamer.dart';
import 'package:uniplanet/common/routes/names.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/account/screens/account_screen.dart';
import 'package:uniplanet/features/add-product/screens/add_product_screen.dart';
import 'package:uniplanet/features/category/screens/category_layout_screen.dart';
import 'package:uniplanet/features/chat/screens/chat_layout_screen.dart';
import 'package:uniplanet/features/home/screens/home_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:uniplanet/features/search/screens/search_screen.dart';
import 'package:uniplanet/api/notification/notification_handler/remote_notification_controller.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  final bool _isVisible = true;
  String? profileImage;
  final Streamer _streamer = Streamer();

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AppRoutes.addProductPage);
  }

  void navigateToSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    NotificationController().addListener(() => setState(() {}));
    _streamer.addChatListener(context);
    _streamer.addAccountListener(context);
    _streamer.addProductListener(context);
  }

  @override
  void dispose() {
    _streamer.disposeChatListener();
    _streamer.disposeAccountListener();
    _streamer.disposeProductListener();

    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomeScreen(),
      Container(
        margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 40),
        child: const CategoryPage(),
      ),
      const AddProductScreen(),
      const Padding(
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 40),
          child: ChatList()),
      const Padding(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 40),
        child: AccountScreen(),
      ),
    ];
    return Scaffold(
        body: Stack(
      children: [
        pages[_page],
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: _isVisible ? -15 : -120,
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
                        height: 40,
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
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search Items',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black26,
                                      fontSize: 18,
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
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      // child:
                      //     const Icon(Icons.mic, color: Colors.black, size: 25),
                    ),
                  ],
                ),
              ),
              BottomNavigationBar(
                currentIndex: _page,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: GlobalVariables.secondaryColor,
                unselectedItemColor: GlobalVariables.unselectedNavBarColor,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                backgroundColor: GlobalVariables.backgroundColor,
                enableFeedback: true,
                iconSize: 20,
                selectedIconTheme: const IconThemeData(size: 21),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                onTap: updatePage,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home_outlined,
                      ),
                      label: 'Home'),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.list,
                      ),
                      label: "Categories"),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_box_outlined,
                    ),
                    label: "sell",
                  ),
                  BottomNavigationBarItem(
                      icon: BlocBuilder<ChatBloc, ChatBlocState>(
                        builder: (context, state) {
                          if (state.totalUnseenMessageCount > 0) {
                            return badges.Badge(
                              badgeContent: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 5,
                                  minHeight: 5,
                                ),
                                child: Text(
                                  state.totalUnseenMessageCount.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              badgeStyle: const badges.BadgeStyle(
                                elevation: 0,
                                shape: badges.BadgeShape.circle,
                              ),
                              position: badges.BadgePosition.topEnd(
                                  top: -12, end: -6),
                              child: const Icon(
                                Icons.chat_bubble_outline_sharp,
                              ),
                            );
                          } else {
                            return const Icon(
                              Icons.chat_bubble_outline_sharp,
                            );
                          }
                        },
                      ),
                      label: "Chat"),
                  const BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_outline_sharp,
                      ),
                      label: 'Profile'),
                ],
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ],
    ));
  }
}
