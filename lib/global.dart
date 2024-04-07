import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/main.dart';
import 'package:uniplanet_mobile/network/notification/firebase_api.dart';
import 'package:uniplanet_mobile/network/notification/firebase_options.dart';
import 'package:uniplanet_mobile/network/api_def/dio_client.dart';
import 'package:uniplanet_mobile/network/notification/notification_service.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';

class Global {
  static final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await DioClient.instance.initCookie();

    //Firebase
    //Firebase initialization
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    //Firebase notification initialization
    await FirebaseApi().initNotification();
    //Firebase background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //Firebase foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (SocketService.currentChatLocation == null) {
        AwesomeNotifications().incrementGlobalBadgeCounter();
      }

      print("Received a message in the foreground: $message");
      print(message.toString());
      // You can still handle data messages here, if needed.
    });
    // Awesome Notifications initialization
    NotificationService.init();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
