import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../utils/utils.dart';

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  String? _firebaseToken;
  String? get firebaseToken => _firebaseToken;

  String _nativeToken = '';
  String get nativeToken => _nativeToken;

  ReceivedAction? initialAction;

  /// *********************************************
  ///   INITIALIZATION METHODS
  /// *********************************************

  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    await AwesomeNotificationsFcm().initialize(
        onFcmTokenHandle: NotificationController.myFcmTokenHandle,
        onNativeTokenHandle: NotificationController.myNativeTokenHandle,
        onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
        licenseKeys: [
          dotenv.get('AWESOME_NOTIFICATION_LICENCE_v1'),
          dotenv.get('AWESOME_NOTIFICATION_LICENCE_v2'),
        ],
        debug: debug);
  }

  ///  *********************************************
  ///     REMOTE NOTIFICATION EVENTS
  ///  *********************************************

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    log('mySilentDataHandle received a FcmSilentData execution');
    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      log("bg");
    } else {
      log("FOREGROUND");
    }

    log('mySilentDataHandle received a FcmSilentData execution');
    // await executeLongTaskInBackground();
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    if (token.isNotEmpty) {
      // Fluttertoast.showToast(
      //     msg: 'Fcm token received',
      //     backgroundColor: Colors.blueAccent,
      //     textColor: Colors.white,
      //     fontSize: 16);

      debugPrint('Firebase Token:"$token"');
    } else {
      // Fluttertoast.showToast(
      //     msg: 'Fcm token deleted',
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16);

      debugPrint('Firebase Token deleted');
    }

    _instance._firebaseToken = token;
    _instance.notifyListeners();
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    // Fluttertoast.showToast(
    //     msg: 'Native token received',
    //     backgroundColor: Colors.blueAccent,
    //     textColor: Colors.white,
    //     fontSize: 16);
    // debugPrint('Native Token:"$token"');

    _instance._nativeToken = token;
    _instance.notifyListeners();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************

  static Future<void> executeLongTaskInBackground() async {
    log("starting long task");
    // await Future.delayed(const Duration(seconds: 4));
    // const url = "http://google.com";
    // final dio = Dio();
    // final re = await dio.get(url);
    // log(re.data);
    log("long task done");
  }

  static Future<void> deleteToken() async {
    await AwesomeNotificationsFcm().deleteToken();
    _instance._firebaseToken = null;
  }

  static Future<String?> requestFirebaseToken() async {
    try {
      _instance._firebaseToken =
          await AwesomeNotificationsFcm().requestFirebaseAppToken();

      await AwesomeNotifications().requestPermissionToSendNotifications();

      if (_instance._firebaseToken == null) {
        throw Exception('Token is null');
      } else {
        return _instance._firebaseToken!;
      }
    } catch (exception) {
      debugPrint('$exception');
    }
    return null;
  }
}
