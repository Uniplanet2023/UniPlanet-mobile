import 'dart:convert';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/common/routes/names.dart';
import 'package:uniplanet_mobile/features/account/screens/help_screen.dart';
import 'package:uniplanet_mobile/features/category/screens/categories.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_screen.dart';
import 'package:uniplanet_mobile/main.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class NotificationService {
  static Future<void> init() async {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: true,
            playSound: true,
          ),
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceived,
    );
  }

  // Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
    try {
      BuildContext? context = MyApp.navigatorKey.currentContext;
      if (receivedNotification.payload?['navigate'] == 'true') {
        if (receivedNotification.payload?['sender'] != null &&
            receivedNotification.payload?['message'] != null) {
          var messageJson =
              jsonDecode(receivedNotification.payload!['message']!);
          var userJson = jsonDecode(receivedNotification.payload!['sender']!);
          print(userJson);
          User sender = User.fromMap(userJson);
          if (context != null) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return ChatScreen(
                  client: sender,
                  chatRoomId: messageJson['chat'],
                );
              }),
            );
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification action: ${receivedAction.id}');
  }

  static Future<void> onDismissActionReceived(
      ReceivedAction receivedAction) async {
    debugPrint('Notification dismissed: ${receivedAction.id}');
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == 'true') {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const BottomAppBar(),
        ),
      );
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(
      scheduled == false || interval != null,
      'Interval must be provided when scheduling a notification',
    );
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: payload,
        summary: summary,
        notificationLayout: notificationLayout,
        category: category,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval!,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
