import 'package:flutter/material.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Turn on notifications to stay up to date",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const NotificationCard(
                message:
                    'Mary sent you a message: Does the block party start at...',
                avatarUrl: 'notification_image_1.jpg'),
            NotificationCard(
              message: 'Patricia accepted your connection request.',
              avatarUrl: 'notification_image_2.jpg',
              extraWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Wave",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const NotificationCard(
              message:
                  'Linda replied to your post Northside trail runners meetup.',
              avatarUrl: 'notification_image_3.jpg',
            ),
            const NotificationCard(
              message: 'James mentioned you in Photographer needed.',
              avatarUrl: 'notification_image_4.jpg',
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    LocalNotificationController.notificationRationale(true);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    "Allow notifications",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String message;
  final String avatarUrl;
  final Widget? extraWidget;

  const NotificationCard({
    super.key,
    required this.message,
    required this.avatarUrl,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 8.0), // Adjust margin as needed
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color of the container
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        elevation: 5, // Adjust elevation as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/$avatarUrl'),
          ),
          title: Text(message),
          trailing: extraWidget,
        ),
      ),
    );
  }
}
