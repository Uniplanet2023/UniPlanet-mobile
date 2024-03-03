import "package:flutter/material.dart";
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/features/add-product/screens/add_product_screen.dart';
import "package:uniplanet_mobile/features/auth/screens/auth_screen.dart";
import "package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart";
import 'package:uniplanet_mobile/features/auth/screens/signin-screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/splash-screen.dart';
import "package:uniplanet_mobile/features/chat/screens/chat_layout_screen.dart";
import "package:uniplanet_mobile/features/chat/screens/chat_screen.dart";
import "package:uniplanet_mobile/features/home/screens/category_screen.dart";
import 'package:uniplanet_mobile/features/home/screens/home-screen.dart';
import "package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart";
import "package:uniplanet_mobile/features/search/screens/search_screen.dart";
import "package:uniplanet_mobile/models/myChatRoom.dart";
import 'package:uniplanet_mobile/models/product_model.dart';
import "package:uniplanet_mobile/models/user_model.dart";

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case SplashScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SplashScreen(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupScreen(),
      );

    case OtpVerifyScreen.routeName:
      var email = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OtpVerifyScreen(email: email),
      );
    case SigninScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SigninScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(controller: ScrollController()),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case CategoryScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String?;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchScreen(),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );

    case ChatScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;

      User client = arguments['seller'] as User;
      MyChatRoom myChatRoom = arguments['myChatRoom'] as MyChatRoom;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(
          client: client,
          myChatRoom: myChatRoom,
        ),
      );
    case ChatList.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChatList(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
