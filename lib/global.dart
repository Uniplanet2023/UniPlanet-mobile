import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/main.dart';
import 'package:uniplanet/network/notification/firebase_api.dart';
import 'package:uniplanet/network/notification/firebase_options.dart';
import 'package:uniplanet/network/api_def/dio_client.dart';
import 'package:uniplanet/network/notification/notification_handler/notification_service.dart';
import 'package:uniplanet/network/socket/socket_channel.dart';

import 'constants/utils.dart';

class Global {
  static final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
  static late SocketService socketService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    //Firebase
    //Firebase initialization
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    //Firebase background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // await NotificationService.init();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Received a message in the foreground: $message");
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
