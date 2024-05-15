import 'dart:convert';
import 'dart:ffi';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uniplanet/common/functions/cloudinary_image.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/features/chat/screens/chat_screen.dart';
import 'package:uniplanet/main.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/network/repository/auth_repository/auth_repo.dart';

class LocalNotificationController {
  static final LocalNotificationController _instance =
      LocalNotificationController._internal();

  factory LocalNotificationController() {
    return _instance;
  }

  LocalNotificationController._internal();

  ReceivedAction? initialAction;
  static Future<void> init({bool debug = false}) async {
    try {
      AwesomeNotifications().initialize(
          // set the icon to null if you want to use the default app icon
          null,
          [
            NotificationChannel(
                channelKey: 'scheduled_channel',
                channelName: 'Scheduled Notifications',
                channelDescription: 'Notification tests as newProductAlerts',
                playSound: true,
                importance: NotificationImportance.Max,
                defaultPrivacy: NotificationPrivacy.Private,
                defaultRingtoneType: DefaultRingtoneType.Notification,
                enableVibration: true,
                enableLights: true,
                defaultColor: GlobalVariables.secondaryColor,
                ledColor: GlobalVariables.secondaryColor),
            NotificationChannel(
                channelKey: 'chats',
                channelName: 'Messages',
                channelDescription: 'Notification tests as chats',
                playSound: true,
                enableVibration: true,
                enableLights: true,
                defaultRingtoneType: DefaultRingtoneType.Notification,
                importance: NotificationImportance.Max,
                defaultPrivacy: NotificationPrivacy.Private,
                defaultColor: GlobalVariables.secondaryColor,
                ledColor: GlobalVariables.secondaryColor)
          ],
          debug: true);
      // Get initial notification action is optional
      _instance.initialAction = await AwesomeNotifications()
          .getInitialNotificationAction(removeFromActionEvents: false);
      await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceived,
      );
    } catch (e) {
      log(e);
    }
  }

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction == null) return;
    log('App launched by a notification action: $receivedAction');
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    final int? id,
    final String? channelKey,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final NotificationCalendar? calendar,
    final String? largeIcon,
    final String? icon,
    final int? badgeCount,
  }) async {
    assert(
      scheduled == false || calendar != null,
      'Calendar must be provided when scheduling a notification',
    );

    // Check if body starts with the specific URL and replace it
    String modifiedBody =
        body.startsWith("https://res.cloudinary.com/dtgmmfv3d/")
            ? "image"
            : body;
    var resizedBigPicture = bigPicture;
    if (bigPicture != null) {
      resizedBigPicture =
          cloudinaryTransformImage(bigPicture, width: 150, height: 150);
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id ?? -1,
        channelKey: channelKey ?? 'scheduled_channel',
        title: title,
        body: modifiedBody,
        payload: payload,
        summary: summary,
        notificationLayout: notificationLayout,
        category: category,
        bigPicture: resizedBigPicture,
        largeIcon: largeIcon,
        badge: badgeCount,
      ),
      actionButtons: actionButtons,
      schedule: scheduled ? calendar : null,
    );
  }

  // Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    Fluttertoast.showToast(
        msg: receivedAction.payload.toString(),
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 10);
    try {
      BuildContext? context = SnackbarGlobal.key.currentContext;
      if (context == null) return;
      // if (receivedAction.payload?['navigate'] == 'true') {
      if (receivedAction.payload != null &&
          receivedAction.payload!['payload'] != null) {
        var chatRoom = ChatRoom.fromJson(receivedAction.payload!['payload']!);
        var badgeCount = await AwesomeNotifications().getGlobalBadgeCounter();
        var currentBadgeCount = badgeCount - chatRoom.unseenMessageCount;
        if (currentBadgeCount > 0) {
          AwesomeNotifications().setGlobalBadgeCounter(currentBadgeCount);
        } else {
          AwesomeNotifications().setGlobalBadgeCounter(0);
        }
        MyApp.navigatorKey.currentState?.popUntil((route) => route.isFirst);
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoom: chatRoom,
              client: AuthRepository.userId == chatRoom.seller.id
                  ? chatRoom.buyer
                  : chatRoom.seller,
            ),
          ),
        );
        // }
      }
    } catch (e) {
      log(e);
    }
  }

  static Future<void> onDismissActionReceived(
      ReceivedAction receivedAction) async {
    log('Notification dismissed: ${receivedAction.id}');
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == 'true') {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const BottomAppBar(),
        ),
      );
    }
  }

  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext!;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified',
                style: Theme.of(context).textTheme.titleLarge),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.notifications_active,
                        size: 50,
                        color: GlobalVariables.secondaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Allow notifications to receive messages from clients!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: GlobalVariables.secondaryColor),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
