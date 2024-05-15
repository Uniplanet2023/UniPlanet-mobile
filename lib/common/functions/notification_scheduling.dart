import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/network/notification/notification_handler/local_notification.dart';

void notificationScheduling(List<Product> products, int id) async {
  // Cancel any existing notification with the same ID
  await AwesomeNotifications().cancel(id);

  // Get the current date and time
  DateTime now = DateTime.now();

  // Loop through the products and schedule notifications for the next day
  for (var index = 0; index < products.length; index++) {
    // Calculate the scheduled time for the next day
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day + 1 + index, // Schedule for the next day
      10 + index * 6, // Hour adjustment based on index
      21 + index * 10, // Minute adjustment based on index
    );

    // Ensure the scheduled time is valid
    if (scheduledTime.hour >= 24) {
      scheduledTime = scheduledTime.add(const Duration(hours: -24, days: 1));
    }

    // Show the notification using the LocalNotificationController
    await LocalNotificationController.showNotification(
      id: id + index, // Use a unique ID for each notification
      channelKey: 'scheduled_channel',
      title: products[index].name,
      body: products[index].description,
      bigPicture: products[index].images.first,
      notificationLayout: NotificationLayout.BigPicture,
      scheduled: true,
      calendar: NotificationCalendar.fromDate(date: scheduledTime),
    );

    // Limit to a maximum of 3 notifications
    if (index >= 2) return;
  }
}
