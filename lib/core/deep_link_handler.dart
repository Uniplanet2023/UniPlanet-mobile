import 'package:flutter/material.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/main.dart'; // Update with your actual path

class DeepLinkHandler {
  // Private constructor
  DeepLinkHandler._privateConstructor();

  // Singleton instance
  static final DeepLinkHandler _instance =
      DeepLinkHandler._privateConstructor();

  // Factory constructor to return the singleton instance
  factory DeepLinkHandler() {
    return _instance;
  }

  // Function to handle the initial deep link when the app is opened
  Future<void> handleInitialDeepLink(String link) async {
    if (link == "mobile://uniplanet.shop/redirect/payment-success") {
      Navigator.pushNamed(
        MyApp.navigatorKey.currentContext!,
        AppRoutes.paymentSuccessPage,
      );
    } else if (link == "mobile://uniplanet.shop/redirect") {}
  }
}
