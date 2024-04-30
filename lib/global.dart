import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/network/api_def/dio_client.dart';
import 'package:uniplanet/network/notification/notification_handler/notification_controller.dart';
import 'package:uniplanet/network/socket/socket_channel.dart';

class Global {
  static final cloudinary = CloudinaryPublic('dtgmmfv3d', 'l1zymzfi');
  static late SocketService socketService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Notification initialization
    await NotificationController.initializeLocalNotifications(debug: true);
    await NotificationController.initializeRemoteNotifications(debug: true);
    await NotificationController.initializeIsolateReceivePort();
    await NotificationController.getInitialNotificationAction();

    // Dio initialization (API client)
    await DioClient.instance.initCookie();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
