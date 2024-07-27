import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/chat/presentation/screens/chat_screen.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/main.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/core/utils/show_dialog.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';

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
          'resource://drawable/res_notification_logo',
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
              ledColor: GlobalVariables.secondaryColor,
              soundSource: 'resource://raw/res_custom_notification',
            ),
            NotificationChannel(
              channelKey: 'chats',
              channelName: 'Messages',
              channelDescription: 'Notification for messages',
              playSound: true,
              enableVibration: true,
              enableLights: true,
              defaultRingtoneType: DefaultRingtoneType.Notification,
              importance: NotificationImportance.Max,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: GlobalVariables.secondaryColor,
              ledColor: GlobalVariables.secondaryColor,
              soundSource: 'resource://raw/res_custom_notification',
            ),
            NotificationChannel(
              channelKey: 'inapp_notification',
              channelName: 'Messages',
              channelDescription: 'Notification for messages',
              playSound: false,
              enableVibration: true,
              enableLights: true,
              defaultRingtoneType: DefaultRingtoneType.Notification,
              importance: NotificationImportance.Max,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: GlobalVariables.secondaryColor,
              ledColor: GlobalVariables.secondaryColor,
            )
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

  Future<void> createMessageChannel() async {
    await AwesomeNotifications().setChannel(NotificationChannel(
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
      ledColor: GlobalVariables.secondaryColor,
      soundSource: 'resource://raw/res_custom_notification',
    ));
  }

  Future<void> createScheduledChannel() async {
    await AwesomeNotifications().setChannel(NotificationChannel(
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
      ledColor: GlobalVariables.secondaryColor,
      soundSource: 'resource://raw/res_custom_notification',
    ));
  }

  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
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
    final bool silent = false,
  }) async {
    assert(
      scheduled == false || calendar != null,
      'Calendar must be provided when scheduling a notification',
    );
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      return;
    }
    // Check if body starts with the specific URL and replace it
    String modifiedBody = body.startsWith("https://") ? "image" : body;
    var resizedBigPicture = bigPicture;
    // if (bigPicture != null) {
    //   resizedBigPicture =
    //       cloudinaryTransformImage(bigPicture, width: 150, height: 150);
    // }

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
    try {
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        displayNotificationRationale();
        return;
      }
      ChatRoom? chatRoom;
      if (Platform.isAndroid && receivedAction.payload != null) {
        chatRoom = ChatRoom.fromMap(receivedAction.payload!);
      } else if (receivedAction.payload != null &&
          receivedAction.payload!["iOS.content.payload.ios"] != null) {
        chatRoom = ChatRoom.fromJson(
            receivedAction.payload!["iOS.content.payload.ios"]!);
      }
      if (chatRoom != null) {
        var badgeCount = await AwesomeNotifications().getGlobalBadgeCounter();
        var currentBadgeCount = badgeCount - chatRoom.unseenMessageCount;
        if (currentBadgeCount > 0) {
          AwesomeNotifications().setGlobalBadgeCounter(currentBadgeCount);
        } else {
          AwesomeNotifications().setGlobalBadgeCounter(0);
        }
        if (MyApp.navigatorKey.currentState == null) {
          Fluttertoast.showToast(
              msg: 'currentstate is null',
              backgroundColor: Colors.blueAccent,
              textColor: Colors.white,
              fontSize: 10);
        }
        MyApp.navigatorKey.currentState?.popUntil((route) => route.isFirst);
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoom: chatRoom!,
              client: AuthRepository.userId == chatRoom.seller.id
                  ? chatRoom.buyer
                  : chatRoom.seller,
            ),
          ),
        );
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
    bool isAllowed = await showOptionDialog(context, 'Get Notified',
        'Allow notifications to receive messages from clients!');

    await notificationRationale(isAllowed);
    return userAuthorized;
  }

  static Future<bool> notificationRationale(bool isAllowed) async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    if (isAllowed) {
      // Enable all notification
      await LocalNotificationController.init();
      await NotificationController.requestFirebaseToken();
      Initialization.socketService.notificationEnableEvent();

      if (!await AwesomeNotifications().isNotificationAllowed()) {
        bool isNotiAllowed =
            await AwesomeNotifications().requestPermissionToSendNotifications();
        prefsHelper.saveBool('isNotificationAllowed', isNotiAllowed);
        if (isNotiAllowed) {
          await LocalNotificationController._instance.createMessageChannel();
          await LocalNotificationController._instance.createScheduledChannel();
        }
        return isNotiAllowed;
      } else {
        await LocalNotificationController._instance.createMessageChannel();
        await LocalNotificationController._instance.createScheduledChannel();
        prefsHelper.saveBool('isNotificationAllowed', true);
      }
    } else {
      prefsHelper.saveBool('isNotificationAllowed', false);
      // Disable all notification
      await AwesomeNotifications().cancelAll();
      NotificationController.deleteToken();
    }
    return isAllowed;
  }
}
