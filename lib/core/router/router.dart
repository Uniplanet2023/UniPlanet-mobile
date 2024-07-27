import "package:flutter/material.dart";
import "package:uniplanet/core/router/names.dart";
import "package:uniplanet/core/entities/user.dart";
import 'package:uniplanet/features/common/presentation/widgets/bottom_bar.dart';
import "package:uniplanet/features/housing/presentation/screens/housing_page.dart";
import 'package:uniplanet/features/upload/presentation/screens/add_product_screen.dart';
import "package:uniplanet/features/auth/presention/screens/auth_screen.dart";
import "package:uniplanet/features/auth/presention/screens/opt_verify_screen.dart";
import 'package:uniplanet/features/auth/presention/screens/signin_screen.dart';
import 'package:uniplanet/features/auth/presention/screens/signup_screen.dart';
import "package:uniplanet/features/category/presentation/screens/categories.dart";
import "package:uniplanet/features/chat/presentation/screens/chat_layout_screen.dart";
import "package:uniplanet/features/chat/presentation/screens/chat_screen.dart";
import "package:uniplanet/features/home/screens/home_screen.dart";
import "package:uniplanet/features/product_details/presentation/pages/product_details_screen.dart";
import "package:uniplanet/features/search/presentation/screens/search_screen.dart";
import "package:uniplanet/models/chat_room.dart";
import "package:uniplanet/models/product.dart";

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AppRoutes.authPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case AppRoutes.housingPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HousingListPage(),
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
      final scroller = routeSettings.arguments as ScrollController;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(
          controller: scroller,
        ),
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
    case AppRoutes.category:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            CategoriesPage(controller: ScrollController(), category: category),
      );
    case AppRoutes.searchScreenPage:
      // var searchQuery = routeSettings.arguments as String?;
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
          chatRoom: chatRoom,
        ),
      );
    case AppRoutes.chatLayoutPage:
      final scroller = routeSettings.arguments as ScrollController;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatListPage(controller: scroller),
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
