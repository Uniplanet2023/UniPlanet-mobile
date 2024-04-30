import 'dart:io';
import 'package:uniplanet/constants/utils.dart';

class FirebaseApi {
  // static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // ignore: prefer_typing_uninitialized_variables
  static String? firebaseToken;
  // Future<void> initNotification() async {
  //   NotificationSettings settings = await firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: true,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: true,
  //     provisional: true,
  //     sound: true,
  //   );
  //   if (Platform.isIOS) {
  //     final apnsToken = await firebaseMessaging.getAPNSToken();
  //     if (apnsToken == null) {
  //       log('APNS Token is null');
  //     }
  //     log('APNS Token: $apnsToken');
  //   }
  //   await firebaseMessaging.setAutoInitEnabled(false);
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized ||
  //       settings.authorizationStatus == AuthorizationStatus.provisional) {
  //     firebaseToken = await firebaseMessaging.getToken();

  //     log('FCM Token: $firebaseToken');
  //   } else {
  //     log('User declined permission');
  //   }
  // }

  // Future<void> subscribeToTopic(String topic) async {
  //   await firebaseMessaging.subscribeToTopic(topic);
  //   log('Subscribed to $topic');
  // }

  // Future<void> unsubscribeFromTopic(String topic) async {
  //   await firebaseMessaging.unsubscribeFromTopic(topic);
  //   log('Unsubscribed from $topic');
  // }
}
