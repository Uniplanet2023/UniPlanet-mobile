import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet_mobile/main.dart';
import 'package:uniplanet_mobile/network/notification/firebase_api.dart';
import 'package:uniplanet_mobile/network/notification/firebase_options.dart';
import 'package:uniplanet_mobile/network/api_def/dio_client.dart';

class Global {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DioClient.instance.initCookie();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseApi().initNotification();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // AwesomeNotifications().initialize(
    //     null,
    //     [
    //       NotificationChannel(
    //           channelKey: 'basic_channel',
    //           channelName: 'Basic notifications',
    //           channelDescription: 'Notification channel for basic tests',
    //           defaultColor: const Color(0xFF9D50DD),
    //           ledColor: Colors.white)
    //     ],
    //     debug: true);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
