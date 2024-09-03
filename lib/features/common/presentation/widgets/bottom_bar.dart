import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/utils/streamer.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/account/presentation/screens/account_screen.dart';
import 'package:uniplanet/features/upload/presentation/screens/add_product_screen.dart';
import 'package:uniplanet/features/category/presentation/screens/category_layout_screen.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/screens/chat_layout_screen.dart';
import 'package:uniplanet/features/home/screens/home_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:uniplanet/features/search/presentation/screens/search_screen.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  bool _isVisible = true; // State variable to control visibility
  String? profileImage;
  final Streamer _streamer = Streamer();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  @override
  void initState() {
    super.initState();
    NotificationController().addListener(() => setState(() {}));
    _streamer.addChatListener();
    _streamer.addAccountListener();
    _streamer.addProductListener();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _streamer.disposeChatListener();
    _streamer.disposeAccountListener();
    _streamer.disposeProductListener();
    _scrollController.dispose();
    super.dispose();
  }

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
      HomeScreen(controller: _scrollController),
      Container(
        margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 40),
        child: CategoryPage(controller: _scrollController),
      ),
      const AddProductScreen(),
      ChatListPage(
        controller: _scrollController,
      ),
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
                color: Theme.of(context).colorScheme.surface,
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
                            onTap: () => navigateToSearchScreen(),
                            child: Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryFixedDim,
                                    width: 1),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Search Items',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
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
                      color: Theme.of(context).colorScheme.surface,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ],
                ),
              ),
              BottomNavigationBar(
                currentIndex: _page,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.tertiary,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                backgroundColor: Theme.of(context).colorScheme.surface,
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
