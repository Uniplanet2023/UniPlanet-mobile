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
  int dailyLimit =
      2, // If you want to limit daily notifications, you can use this
  required int notificationId,
}) async {
  final random = Random();
  final now = DateTime.now();

  List<NotificationModel> scheduledNotifications =
      await AwesomeNotifications().listScheduledNotifications();

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

  // Ensure you don't exceed the number of products available
  int maxNotifications =
      min(products.length, 10); // Limit to 10 or the number of products

  for (int i = 0; i < maxNotifications; i++) {
    // Calculate the date for each day in the next 10 days
    DateTime scheduledDate = now.add(Duration(days: i));

    // Generate a random hour between 11 AM (11) and 10 PM (22)
    int randomHour = 11 + random.nextInt(12);
    int randomMinute = random.nextInt(60);

    // Set the notification time to the generated hour and minute
    scheduledDate = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      randomHour,
      randomMinute,
    );

    // Check if there's already a scheduled notification for that day
    bool alreadyScheduled = scheduledNotifications.any((notification) {
      if (notification.schedule is NotificationCalendar) {
        NotificationCalendar calendar =
            notification.schedule as NotificationCalendar;
        DateTime notificationDate = DateTime(
          calendar.year ?? scheduledDate.year,
          calendar.month ?? scheduledDate.month,
          calendar.day ?? scheduledDate.day,
          calendar.hour ?? 0,
          calendar.minute ?? 0,
        );

        // Check if the notification is on the same day
        return notificationDate.year == scheduledDate.year &&
            notificationDate.month == scheduledDate.month &&
            notificationDate.day == scheduledDate.day;
      }
      return false;
    });

    // If no notification is scheduled for that day, schedule a new one
    if (!alreadyScheduled) {
      await LocalNotificationController.showNotification(
        id: random
            .nextInt(1000), // Use the reusable Random object for consistency
        channelKey: 'scheduled_channel',
        title: getTitle(notificationId, products[i].name),
        body: getBody(notificationId, products[i].name),
        bigPicture:
            products[i].images.isNotEmpty ? products[i].images.first : null,
        notificationLayout: NotificationLayout.BigPicture,
        scheduled: true,
        calendar: NotificationCalendar.fromDate(date: scheduledDate),
      );
    }
  }
}
