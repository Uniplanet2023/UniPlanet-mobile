import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/network/api_def/dio_client.dart';
import 'package:uniplanet/network/notification/notification_handler/local_notification.dart';
import 'package:uniplanet/network/socket/socket_channel.dart';

class Global {
  static final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
  static late SocketService socketService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // MobileAds.instance.initialize();
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
