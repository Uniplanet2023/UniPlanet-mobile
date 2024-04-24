import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
void newMessageHandler(RemoteMessage sdfmessage) async {
  var message = jsonDecode(sdfmessage.data['message']);
  var sender = jsonDecode(sdfmessage.data['sender']);
  String modifiedBody =
      message['message'].startsWith("https://res.cloudinary.com/dtgmmfv3d/")
          ? "image"
          : message['message'];
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: -1,
      channelKey: 'basic_channel',
      title: sender['name'],
      body: modifiedBody,
      payload: {
        "navigate": "true",
        "sender": sdfmessage.data['sender'],
        "message": sdfmessage.data['message'],
      },
      notificationLayout: NotificationLayout.Messaging,
      // bigPicture: sender['profileImage'],
    ),
  );
}
