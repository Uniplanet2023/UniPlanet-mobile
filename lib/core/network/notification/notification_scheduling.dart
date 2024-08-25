import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';

// Notification IDs
const int searchProductId = 10;
const int likeProductId = 11;
const int hotProductId = 12;

void notificationScheduling(
  List<Product> products, {
  int dailyLimit = 2,
  int weeklyLimit = 15,
  int monthlyLimit = 64,
  required int notificationId,
}) async {
  List<NotificationModel> list =
      await AwesomeNotifications().listScheduledNotifications();

  DateTime now = DateTime.now();
  int dailyCount = 0;
  int weeklyCount = 0;
  int monthlyCount = 0;

  // Define notification titles and bodies based on the notification ID
  String getTitle(int notificationId, String productName) {
    switch (notificationId) {
      case searchProductId:
        return '🧐 Are you looking for this?';
      case likeProductId:
        return '💕 $productName 💕';
      case hotProductId:
        return '🔥 Hot Product Alert! 🔥';
      default:
        return '$productName is trending now!';
    }
  }

  String getBody(int notificationId, String productName) {
    switch (notificationId) {
      case searchProductId:
        return '🔍 $productName is prepared!';
      case likeProductId:
        return '$productName is liked by many users. ❤️ Check it out!';
      case hotProductId:
        return '$productName is trending now! 🌟';
      default:
        return '$productName is trending now!';
    }
  }

  // Loop through the products and schedule notifications
  for (var index = 0; index < products.length; index++) {
    if (list.length + index >= 63) {
      return;
    }
    if (dailyCount >= dailyLimit &&
        weeklyCount >= weeklyLimit &&
        monthlyCount >= monthlyLimit) {
      break;
    }

    var product = products[index];

    // Calculate the scheduled time
    DateTime scheduledTime = now.add(Duration(
      days: (monthlyCount / dailyLimit).floor(), // Spread across days
      hours: (dailyCount * 2) + 11, // Spread between 11 AM and 10 PM
      minutes: (index % 60), // Spread across the hour
    ));

    // Ensure the scheduled time is within 11:00 AM - 11:00 PM
    if (scheduledTime.hour < 11) {
      scheduledTime = DateTime(
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        11 + index, // Adjust to just after 11:00 AM
        scheduledTime.minute,
      );
    } else if (scheduledTime.hour > 21) {
      scheduledTime = DateTime(
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        21 - index,
        59, // Adjust to just before 10:00 PM
      );
    }

    // Schedule the notification using the LocalNotificationController
    await LocalNotificationController.showNotification(
      id: Random().nextInt(1000), // Use a unique ID for each notification
      channelKey: 'scheduled_channel',
      title: getTitle(notificationId, product.name),
      body: getBody(notificationId, product.name),
      bigPicture: product.images.isNotEmpty ? product.images.first : null,
      notificationLayout: NotificationLayout.BigPicture,
      scheduled: true,
      calendar: NotificationCalendar.fromDate(date: scheduledTime),
    );

    dailyCount++;
    weeklyCount++;
    monthlyCount++;
  }
}
