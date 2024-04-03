import "package:flutter/material.dart";
import "package:uniplanet_mobile/common/routes/names.dart";
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/features/add-product/screens/add_product_screen.dart';
import "package:uniplanet_mobile/features/auth/screens/auth_screen.dart";
import "package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart";
import 'package:uniplanet_mobile/features/auth/screens/signin-screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/signup-screen.dart';
import 'package:uniplanet_mobile/features/auth/screens/splash-screen.dart';
import "package:uniplanet_mobile/features/category/screens/categories.dart";
import "package:uniplanet_mobile/features/chat/screens/chat_layout_screen.dart";
import "package:uniplanet_mobile/features/chat/screens/chat_screen.dart";
import "package:uniplanet_mobile/features/home/screens/category_screen.dart";
import "package:uniplanet_mobile/features/home/screens/home_screen.dart";
import "package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart";
import "package:uniplanet_mobile/features/search/screens/search_screen.dart";
import "package:uniplanet_mobile/models/chat_room.dart";
import "package:uniplanet_mobile/models/product.dart";
import "package:uniplanet_mobile/models/user_model.dart";

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppRoutes.authPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case AppRoutes.splashScreenPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SplashScreen(),
      );
    case AppRoutes.signupPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupScreen(),
      );

    case AppRoutes.otpVerifyPage:
      var email = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OtpVerifyScreen(email: email),
      );
    case AppRoutes.signinPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SigninScreen(),
      );
    case AppRoutes.homePage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(controller: ScrollController()),
      );
    case AppRoutes.bottomBarPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    case AppRoutes.addProductPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case AppRoutes.categoryPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CategoriesPage(),
      );
    case AppRoutes.category:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryScreen(
          category: category,
        ),
      );
    case AppRoutes.searchScreenPage:
      var searchQuery = routeSettings.arguments as String?;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchScreen(),
      );
    case AppRoutes.productDetailsPage:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );

    case AppRoutes.chatPage:
      final arguments = routeSettings.arguments as Map<String, dynamic>;

      User client = arguments['seller'] as User;
      ChatRoom chatRoom = arguments['chatRoom'] as ChatRoom;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(
          client: client,
          chatRoomId: chatRoom.id,
        ),
      );
    case AppRoutes.chatLayoutPage:
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
