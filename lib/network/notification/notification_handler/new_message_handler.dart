import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uniplanet_mobile/network/notification/notification_service.dart';

void newMessageHandler(RemoteMessage sdfmessage) async {
  var message = jsonDecode(sdfmessage.data['message']);
  var sender = jsonDecode(sdfmessage.data['sender']);
  await NotificationService.showNotification(
    title: sender['name'],
    body: message['message'],
    payload: {
      "navigate": "true",
      "sender": sdfmessage.data['sender'],
      "message": sdfmessage.data['message'],
    },
  );
  return null;
}
