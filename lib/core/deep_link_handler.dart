import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
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

  bool _isDeepLinkHandled = true;

  // Function to handle incoming deep links
  void handleDeepLink(Uri deepLink) {
    if (!_isDeepLinkHandled) {
      _isDeepLinkHandled = true; // Mark the deep link as handled

      // Example of handling a specific deep link path
      if (deepLink.path == AppRoutes.paymentSuccessPage) {
        Navigator.pushNamed(
          MyApp.navigatorKey.currentContext!,
          AppRoutes.paymentSuccessPage,
        );
      }

      // Add more deep link handling logic as needed
    }
  }

  // Function to handle the initial deep link when the app is opened
  Future<void> handleInitialDeepLink() async {
    final initialLink = await getInitialLink();

    if (initialLink != null && !_isDeepLinkHandled) {
      final Uri deepLink = Uri.parse(initialLink);
      handleDeepLink(deepLink);
    }
  }

  // Function to reset deep link handling, allowing the same deep link to be processed again
  void resetDeepLinkHandling() {
    _isDeepLinkHandled = false;
  }
}
