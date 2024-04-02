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
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // This is where you receive messages when the app is in the foreground.
      // If you want to prevent showing notifications in the foreground, simply do not display them here.

      print("Received a message in the foreground: ${message.messageId}");
      // You can still handle data messages here, if needed.
    });

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
