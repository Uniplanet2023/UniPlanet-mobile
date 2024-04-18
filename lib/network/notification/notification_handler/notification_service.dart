import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniket/features/chat/screens/chat_screen.dart';
import 'package:uniket/main.dart';
import 'package:uniket/models/user_model.dart';

class NotificationService {
  static bool isNotificationAllowed = false;
  static Future<void> init() async {
    try {
      AwesomeNotifications().initialize(
          // set the icon to null if you want to use the default app icon
          null,
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
      await AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceived,
      );

      var pref = await SharedPreferences.getInstance();

      bool? isNotificationAllow = pref.getBool('isNotificationAllowed');

      // User already set
      if (isNotificationAllow != null) {
        NotificationService.isNotificationAllowed = isNotificationAllow;
        return;
      } else {
        notificationAllowRequest(pref);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> notificationAllowRequest(SharedPreferences pref) async {
    // Check if the user has already allowed notifications
    bool isAllow = await AwesomeNotifications().isNotificationAllowed();
    // If not, request permission
    if (!isAllow) {
      bool isNotificationAllow =
          await AwesomeNotifications().requestPermissionToSendNotifications();

      NotificationService.isNotificationAllowed = isNotificationAllow;
      pref.setBool(
          'isNotificationAllowed', NotificationService.isNotificationAllowed);
      return isNotificationAllow;
    } else {
      // If the user has already allowed notifications
      NotificationService.isNotificationAllowed = isAllow;
      pref.setBool(
          'isNotificationAllowed', NotificationService.isNotificationAllowed);
      return isAllow;
    }
  }

  // Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification created: ${receivedNotification.id}');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification displayed: ${receivedNotification.id}');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification action: ${receivedAction.id}');
    try {
      BuildContext? context = MyApp.navigatorKey.currentContext;
      if (receivedAction.payload?['navigate'] == 'true') {
        if (receivedAction.payload?['sender'] != null &&
            receivedAction.payload?['message'] != null) {
          var messageJson = jsonDecode(receivedAction.payload!['message']!);
          var userJson = jsonDecode(receivedAction.payload!['sender']!);
          User sender = User.fromMap(userJson);
          var pref = await SharedPreferences.getInstance();
          var userData = pref.getString('userRecord');
          var userRecord = jsonDecode(userData.toString());
          if (userRecord != null && context != null && context.mounted) {
            // SocketService.instance.readAllMessages(messageJson['chat']);
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
    if (NotificationService.isNotificationAllowed == false) return;
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
        largeIcon: 'assets/images/Logo.png',
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
