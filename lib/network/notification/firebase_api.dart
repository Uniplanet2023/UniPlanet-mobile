import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uniplanet/constants/utils.dart';

class FirebaseApi {
  late String userId;
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // ignore: prefer_typing_uninitialized_variables
  static late final firebaseToken;
  Future<void> initNotification() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (Platform.isIOS) {
      final apnsToken = await firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        throw Exception('APNS Token is null');
      }
      log('APNS Token: $apnsToken');
    }
    await FirebaseMessaging.instance.setAutoInitEnabled(false);
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      firebaseToken = await firebaseMessaging.getToken();
      // var fcmToken = prefs.get('fcm_token');
      // if (fcmToken == null) {

      //   prefs.setString('fcm_token', firebaseToken);
      // } else {
      //   firebaseToken = fcmToken;
      // }

      log('FCM Token: $firebaseToken');
    } else {
      log('User declined permission');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await firebaseMessaging.subscribeToTopic(topic);
    log('Subscribed to $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await firebaseMessaging.unsubscribeFromTopic(topic);
    log('Unsubscribed from $topic');
  }
}
