import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/main.dart';
import 'package:uniket/network/notification/firebase_api.dart';
import 'package:uniket/network/notification/firebase_options.dart';
import 'package:uniket/network/api_def/dio_client.dart';
import 'package:uniket/network/notification/notification_handler/notification_service.dart';
import 'package:uniket/network/socket/socket_channel.dart';

import 'constants/utils.dart';

class Global {
  static final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
  static late SocketService socketService;
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
    await NotificationService.init();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received a message in the foreground: $message");
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
