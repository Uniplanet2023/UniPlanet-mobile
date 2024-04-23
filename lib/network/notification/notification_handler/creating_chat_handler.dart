import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uniplanet/network/notification/notification_handler/notification_service.dart';

void creatingChatHandler(RemoteMessage sdfmessage) async {
  var message = jsonDecode(sdfmessage.data['message']);
  var chat = jsonDecode(sdfmessage.data['chat']);
  int badgeCount = await NotificationService.getCurrentBadgeCount();
  await NotificationService.showNotification(
      title: jsonDecode(chat['sender'])['name'],
      body: message['message'] ?? "",
      payload: {
        "navigate": "true",
        "sender": chat['sender'],
        "message": sdfmessage.data['message'],
      },
      badgeCount: badgeCount);
}
