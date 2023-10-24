import "package:flutter/material.dart";
import "package:uniplanet_mobile/common/widgets/bottom_bar.dart";
import "package:uniplanet_mobile/features/address/screens/address_screen.dart";
import 'package:uniplanet_mobile/features/addProduct/screens/add_product_screen.dart';
import 'package:uniplanet_mobile/features/addProduct/screens/admin_screen.dart';
import "package:uniplanet_mobile/features/auth/screens/auth_screen.dart";
import "package:uniplanet_mobile/features/auth/screens/signin_screen.dart";
import "package:uniplanet_mobile/features/auth/screens/signup_screen.dart";
import "package:uniplanet_mobile/features/chat/screens/chat_layout_screen.dart";
import "package:uniplanet_mobile/features/chat/screens/chat_screen.dart";
import 'package:uniplanet_mobile/features/home/screens/category_screen.dart';
import "package:uniplanet_mobile/features/home/screens/home_screen.dart";
import "package:uniplanet_mobile/features/order_details/screens/order_details.dart";
import "package:uniplanet_mobile/features/product_details/screens/product_details_screen.dart";
import "package:uniplanet_mobile/features/search/screens/search_screen.dart";
import "package:uniplanet_mobile/models/order.dart";
import "package:uniplanet_mobile/models/product.dart";

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupScreen(),
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
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case ChatScreen.routeName:
      var recieverId = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(receiverId: recieverId),
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
