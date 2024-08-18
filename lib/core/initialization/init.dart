import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/core/dependency_injection/auth.dart';
import 'package:uniplanet/core/dependency_injection/get_housing.dart';
import 'package:uniplanet/core/dependency_injection/housing.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/config/firebase_options.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';
import 'package:uniplanet/core/network/socket/socket_channel.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/common/presentation/widgets/error_screen.dart';

class Initialization {
  static late SocketService socketService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase initialization
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // Mobile Ads initialization
    MobileAds.instance.initialize();

    // Notification initialization
    await LocalNotificationController.init(debug: true);
    await LocalNotificationController.getInitialNotificationAction();
    await NotificationController.requestFirebaseToken();

    // Dio initialization (API client)
    await DioHelper.instance.init();
    // Shared Preference initialization
    await SharedPreferencesHelper().init();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    //setup block
    setup();
    setupAuth();
    setupHousing();
    initGetHouse();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      bool inDebug = false;
      assert(() {
        inDebug = true;
        return true;
      }());
      if (inDebug) {
        return ErrorWidget(details.exception);
      }
      return const ErrorScreen();
    };
  }
}
