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
  // Cancel any existing scheduled notifications to prevent duplicates
  await AwesomeNotifications().cancelAllSchedules();

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
    if (dailyCount >= dailyLimit ||
        weeklyCount >= weeklyLimit ||
        monthlyCount >= monthlyLimit) {
      break;
    }

    var product = products[index];

    // Calculate the scheduled time based on the current counts
    DateTime scheduledTime = now.add(Duration(
      days: (monthlyCount / dailyLimit).floor(), // Spread across days
      hours: (dailyCount * 2) + 11, // Spread between 11 AM and 9 PM
      minutes: (index % 60), // Spread across the hour
    ));

    // Ensure the scheduled time is within 11:00 AM - 9:00 PM
    if (scheduledTime.hour > 21) {
      scheduledTime = DateTime(
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        21,
        59, // Adjust to just before 10:00 PM
      );
    }

    // Schedule the notification using the LocalNotificationController
    await LocalNotificationController.showNotification(
      id: index + 100, // Use a unique ID for each notification
      channelKey: 'scheduled_channel',
      title: getTitle(notificationId, product.name), // Rotate through IDs
      body: getBody(notificationId, product.name), // Rotate through bodies
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
