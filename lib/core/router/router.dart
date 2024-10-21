import "package:flutter/material.dart";
import "package:uniplanet/config/statemanager_provider.dart";
import "package:uniplanet/core/router/names.dart";
import "package:uniplanet/core/entities/user.dart";
import "package:uniplanet/features/advertiser/domain/entities/advertisement.dart";
import "package:uniplanet/features/advertiser/presentation/screens/ad_detail_statistic.dart";
import "package:uniplanet/features/advertiser/presentation/screens/inventory_ads_screen.dart";
import "package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart";
import "package:uniplanet/features/auth/presention/screens/notification_page.dart";
import "package:uniplanet/features/chat/domain/entities/chat_room.dart";
import 'package:uniplanet/features/common/presentation/widgets/bottom_bar.dart';
import "package:uniplanet/features/edit-product/edit_product.dart";
import "package:uniplanet/features/housing/presentation/screens/housing_page.dart";
import "package:uniplanet/features/job/presentation/screens/job_list_screen.dart";
import "package:uniplanet/features/offer/presentation/screens/offer_layout.dart";
import "package:uniplanet/features/product_details/presentation/pages/ad_detail_screen.dart";
import "package:uniplanet/features/upload/presentation/screens/add_advertisement.dart";
import 'package:uniplanet/features/upload/presentation/screens/add_product_screen.dart';
import "package:uniplanet/features/auth/presention/screens/auth_screen.dart";
import "package:uniplanet/features/auth/presention/screens/opt_verify_screen.dart";
import 'package:uniplanet/features/auth/presention/screens/signin_screen.dart';
import 'package:uniplanet/features/auth/presention/screens/signup_screen.dart';
import "package:uniplanet/features/category/presentation/screens/categories.dart";
import "package:uniplanet/features/chat/presentation/screens/chat_layout_screen.dart";
import "package:uniplanet/features/chat/presentation/screens/chat_screen.dart";
import "package:uniplanet/features/home/presentation/screens/home_screen.dart";
import "package:uniplanet/features/product_details/presentation/pages/product_details_screen.dart";
import "package:uniplanet/features/search/presentation/screens/search_screen.dart";
import "package:uniplanet/features/upload/presentation/screens/payment_success.dart";
import "package:uniplanet/features/upload/presentation/screens/review_payment.dart";
import "package:uniplanet/features/upload/presentation/screens/set_buget_screen.dart";
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
      final user = getIt<AuthBloc>().state.user;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => user?.type == 'advertiser'
            ? const AddAdScreen()
            : const AddProductScreen(),
      );
    case AppRoutes.editProductPage:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EditProductScreen(product: product),
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
    case AppRoutes.adDetailPage:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdDetailScreen(advertisement: arguments['ad']),
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
    case AppRoutes.notificationPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const NotificationScreen(),
      );
    case AppRoutes.reviewPaymentPage:
      // Cast routeSettings.arguments to a Map<String, Object>
      var arguments = routeSettings.arguments as Map<String, dynamic>;

      // Access the values from the map
      var tier = arguments['tier'] as String;
      var totalPayment = arguments['totalPayment'] as double;
      var uploadAd = arguments['uploadAd'] as Function({required String tier});
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ReviewPaymentScreen(
            totalPayment: totalPayment, tier: tier, uploadAd: uploadAd),
      );
    case AppRoutes.setBudgetPage:
      var uploadAd =
          routeSettings.arguments as Function({required String tier});
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SetBudgetScreen(uploadAd: uploadAd),
      );
    case AppRoutes.paymentSuccessPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PaymentSuccessPage(),
      );
    case AppRoutes.adsInventoryPage:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => InventoryAdsScreen(user: getIt<AuthBloc>().state.user!),
      );
    case AppRoutes.adStatisticPage:
      Advertisement ad = routeSettings.arguments is Map<String, dynamic>
          ? (routeSettings.arguments as Map<String, dynamic>)['advertisement']
              as Advertisement
          : throw ArgumentError('Invalid arguments for InsightsPage');

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => InsightsPage(ad: ad),
      );
    case AppRoutes.jobList:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const JobListScreen(),
      );
    case AppRoutes.offerList:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OfferListScreen(),
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
