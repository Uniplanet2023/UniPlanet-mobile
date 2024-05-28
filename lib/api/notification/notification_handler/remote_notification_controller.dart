import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';
import '../../../constants/utils.dart';

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
          '2024-05-03==CW4ZpzeUmcW4iuNK8dcdIgP+g5y4XyaeMYdANdnFZmXSDLtLBwUJTtoKwJMlTDqBWCcAeTKlH2GOgORoNDxou/OMoeV4WVweOBab4Sb/LYYKthVGkWrRsTdRqoCbPCkh2eJxB+1OhO+AJr2jDnw0H73EqJFTFdGc06a0c6B7mq9iXegul+/yM8b6hhPZxswgkM39YI11IYV79XGgmcgUaL5Cnh9Rz4kUq4jCee7BoD5PQkNMMyUCmbQP0sUIbu2Gmcxsq5qYYngCQuJRY2mpzASc9c+Tj/s5UhY/WWQBr6n9uf+YK/1ZDk2fnzegxgPzghZr7necmXLARArexJo/xA==',
          '2024-05-03==QTqoNm32wuO6YiBsvpMCnUM1J+jYKoB9MVDe0eDQyFumvF2JDSRlzmMQP35o5QechgnCVo/jq7SNAVWVpPFkUgyybdYRgdNTP2cnwNd/IHoh53/9ew0LGR5l6m127nK49oRDszgs9XsJm658Gpj2Q6vI1+h+HzDRGZ7D9YQ0fMLjoSiUKMZho1AIJw0VwPZ8wT0ZOjLcPcHcTcdNasMXYUX7rpXqr7RiR/T17p05fLhPyXwsN/jMXghCYhqPCk9oYemz9pT5jvWsPfBApiMpRqo/RPQ+IpychiGKGuUSPGpk2F4NWgFoutAm9XD0T5L0a/vAZ1ci6cOPRuA34wq9iQ=='
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
    await executeLongTaskInBackground();
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
      log(_instance._firebaseToken);
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
