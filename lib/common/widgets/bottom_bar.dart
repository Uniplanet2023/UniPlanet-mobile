import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/bloc/serach_product/search_product_bloc.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/account/screens/account-screen.dart';
import 'package:uniplanet_mobile/features/add-product/screens/add_product_screen.dart';
import 'package:uniplanet_mobile/features/category/screens/categories.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_layout_screen.dart';
import 'package:uniplanet_mobile/features/home/screens/home_screen.dart';
import 'package:uniplanet_mobile/features/search/screens/search_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42.w;
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
    var chatState = context.read<ChatBloc>().state;
    List<String> chatRooms = [];
    for (var chatRoom in chatState.buyingChatRooms) {
      chatRooms.add(chatRoom.toJson());
    }
    for (var chatRoom in chatState.sellingChatRooms) {
      chatRooms.add(chatRoom.toJson());
    }
    String chatRoomJson = jsonEncode(chatRooms);
    SocketService.instance.connect(context, chatRoomJson);
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
    Navigator.pushNamed(context, AppRoutes.searchScreenPage).then(
      (value) => context.read<SearchProductBloc>().add(
            InitalSearchProductEvent(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(controller: _controller!),
      const CategoriesPage(),
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
                selectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 0.035.sw),
                backgroundColor: GlobalVariables.backgroundColor,
                enableFeedback: true,
                iconSize: 28,
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
                      icon: BlocBuilder<AccountBloc, AccountState>(
                        builder: (context, state) {
                          if (state.account.unreadMessage != 0) {
                            return badges.Badge(
                              badgeContent: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 10,
                                  minHeight: 10,
                                ),
                                child: Text(
                                  state.account.unreadMessage.toString(),
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
