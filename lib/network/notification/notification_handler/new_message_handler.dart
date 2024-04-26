import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uniplanet/network/notification/notification_handler/notification_service.dart';

void newMessageHandler(RemoteMessage sdfmessage) async {
  var message = jsonDecode(sdfmessage.data['message']);
  var sender = jsonDecode(sdfmessage.data['sender']);
  NotificationService.showNotification(
    title: sender['name'],
    body: message['message'],
    notificationLayout: NotificationLayout.Messaging,
  );
}
