// import 'dart:convert';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:uniplanet/network/notification/notification_handler/notification_service.dart';

// void creatingChatHandler(RemoteMessage sdfmessage) async {
//   var chat = jsonDecode(sdfmessage.data['chat']);
//   int badgeCount = await NotificationService.getCurrentBadgeCount();
//   await NotificationService.showNotification(
//       title: chat['buyer']['name'],
//       body: '${chat['buyer']['name']} has started a conversation',
//       payload: {
//         "navigate": "true",
//       },
//       bigPicture: chat['buyer']['profileImage'],
//       notificationLayout: NotificationLayout.Messaging,
//       badgeCount: badgeCount);
// }
