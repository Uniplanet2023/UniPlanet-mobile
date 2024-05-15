import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/network/notification/notification_handler/local_notification.dart';

// id = 10 Search Product
// id = 11 Like Product
// id = 12 Hot Product
void notificationScheduling(List<Product> products, int id) async {
  // Cancel any existing notification with the same ID
  AwesomeNotifications().listScheduledNotifications().then((value) {
    for (var notification in value) {
      if (notification.content?.id == id) {
        return;
      }
    }
  });

  // Get the current date and time
  DateTime now = DateTime.now();

  // Loop through the products and schedule notifications for the next day
  for (var index = 0; index < products.length; index++) {
    var title = id == 10
        ? '🧐Are you looking for this?'
        : id == 11
            ? '💕 ${products[index].name} 💕'
            : id == 12
                ? '🔥Hot Product Alert!🔥'
                : '${products[index].name} is trending now!';
    var body = id == 10
        ? '🔍 ${products[index].name} is prepared!'
        : id == 11
            ? '${products[index].name} is liked by many users.❤️ Check it out!'
            : id == 12
                ? '${products[index].name} is trending now! Check it out! 🌟'
                : '${products[index].name} is trending now!';

    // Calculate the scheduled time for the next day
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day + index, // Schedule for the next day
      now.hour + 1 + index * 6, // Hour adjustment based on index
      now.minute + 21 + index * 10, // Minute adjustment based on index
    );

    // Ensure the scheduled time is valid
    if (scheduledTime.hour >= 24) {
      scheduledTime = scheduledTime.add(const Duration(hours: -24, days: 1));
    }
    if (scheduledTime.minute >= 60) {
      scheduledTime = scheduledTime.add(const Duration(hours: 1, minutes: -60));
    }
    if (scheduledTime.day >
        DateTime(scheduledTime.year, scheduledTime.month + 1, 0).day) {
      scheduledTime = DateTime(
        scheduledTime.year,
        scheduledTime.month + 1,
        scheduledTime.day -
            DateTime(scheduledTime.year, scheduledTime.month + 1, 0).day,
        scheduledTime.hour,
        scheduledTime.minute,
      );
    }
    if (scheduledTime.month > 12) {
      scheduledTime = DateTime(
        scheduledTime.year + 1,
        scheduledTime.month - 12,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );
    }
    // Show the notification using the LocalNotificationController
    await LocalNotificationController.showNotification(
      id: id, // Use a unique ID for each notification
      channelKey: 'scheduled_channel',
      title: title,
      body: body,
      bigPicture: products[index].images.first,
      notificationLayout: NotificationLayout.BigPicture,
      scheduled: true,
      calendar: NotificationCalendar.fromDate(date: scheduledTime),
    );

    // Limit to a maximum of 3 notifications
    if (index >= 2) return;
  }
}
