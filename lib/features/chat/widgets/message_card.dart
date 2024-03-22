import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/message.dart';

class MessageCard extends StatelessWidget {
  final Message oldMessage;
  final Message? recentMessage;
  final bool isMyMessage; // Determines if the message is sent by the user

  const MessageCard({
    super.key,
    required this.oldMessage,
    this.recentMessage,
    required this.isMyMessage, // Add this to determine the message sender
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('h:mm a');
    String formattedDate = formatter.format(oldMessage.createdAt.toLocal());

    // Check for one-minute gap if not the first message and the same sender
    bool hidePreviousDate = false;
    final difference =
        recentMessage?.createdAt.difference(oldMessage.createdAt);

    if (recentMessage != null) {
      final bool isSameSender = oldMessage.sender == recentMessage!.sender;
      if (isSameSender && difference!.inMinutes < 1) {
        // Flag to hide date for the previous message
        hidePreviousDate = true;
      }
    }

    List<Widget> messageComponents = [
      // Date and Icon Row
      Row(
        children: [
          Text(
            !hidePreviousDate ? formattedDate : '',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 5),
          oldMessage.readDate == null
              ? const Icon(
                  Icons.local_fire_department_outlined,
                  size: 20,
                  color: Colors.black54,
                )
              : const SizedBox(),
        ],
      ),
      // Message Card
      MessageBox(isMyMessage: isMyMessage, oldMessage: oldMessage),
    ];

    return Column(
      children: [
        // Show date and icon if not the first message
        Align(
          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: isMyMessage
                ? messageComponents
                : messageComponents.reversed.toList(),
          ),
        ),
        (recentMessage != null &&
                oldMessage.createdAt.day < recentMessage!.createdAt.day)
            ? Align(
                alignment: Alignment.center,
                child: Text(
                  oldMessage.createdAt.day + 1 == DateTime.now().toLocal().day
                      ? 'Yesterday'
                      : DateFormat('d MMM').format(oldMessage.createdAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class MessageBox extends StatelessWidget {
  const MessageBox({
    super.key,
    required this.isMyMessage,
    this.oldMessage,
  });

  final bool isMyMessage;
  final Message? oldMessage;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 45,
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: GlobalVariables.primaryColor,
        margin: EdgeInsets.fromLTRB(
            isMyMessage ? 5 : 15, 5, isMyMessage ? 15 : 5, 5),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 30,
            top: 5,
            bottom: 10, // Adjust padding as needed
          ),
          child: Text(
            oldMessage != null ? oldMessage!.message : 'Typing ...',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
