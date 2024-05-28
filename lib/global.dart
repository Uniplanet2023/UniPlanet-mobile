import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/api/api_def/dio_client.dart';
import 'package:uniplanet/api/notification/firebase_options.dart';
import 'package:uniplanet/api/notification/notification_handler/local_notification.dart';
import 'package:uniplanet/api/socket/socket_channel.dart';

class Global {
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

    // Dio initialization (API client)
    await DioClient.instance.initCookie();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
