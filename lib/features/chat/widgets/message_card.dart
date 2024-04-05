import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/common/enums/message_status_enum.dart';
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
          oldMessage.status == MessageStatusEnum.sending.value
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                  ),
                )
              : oldMessage.status == MessageStatusEnum.received.value
                  ? oldMessage.readDate == null
                      ? const Icon(
                          Icons.local_fire_department_outlined,
                          size: 20,
                          color: Colors.black54,
                        )
                      : const SizedBox()
                  : const Icon(
                      Icons.error,
                      size: 20,
                      color: Colors.black54,
                    )
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
        maxWidth: MediaQuery.of(context).size.width - 110,
        maxHeight: 300, // Keep if you want to limit height of image messages
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: isMyMessage ? GlobalVariables.primaryColor : Colors.white,
        margin: EdgeInsets.fromLTRB(
            isMyMessage ? 5 : 15, 5, isMyMessage ? 15 : 5, 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getContentWidget(context),
        ),
      ),
    );
  }

  Widget getContentWidget(BuildContext context) {
    if (oldMessage == null) {
      return const Text('Typing ...', style: TextStyle(fontSize: 16));
    } else if (oldMessage!.messageType == MessageEnum.text.value) {
      return Text(oldMessage!.message, style: const TextStyle(fontSize: 16));
    } else if (oldMessage!.messageType == MessageEnum.image.value) {
      return oldMessage!.status == MessageStatusEnum.received.value
          ? CachedNetworkImage(
              imageUrl: oldMessage!.message,
              placeholder: (context, url) =>
                  const SpinKitFadingCircle(color: Colors.grey),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            )
          : ImageWithLoadingIndicator(
              imagePath: oldMessage!.message,
              status: oldMessage!.status,
            );
    } else {
      return Text(oldMessage!.message, style: const TextStyle(fontSize: 16));
    }
  }
}

class ImageWithLoadingIndicator extends StatelessWidget {
  final String imagePath;
  final String status;
  const ImageWithLoadingIndicator({
    super.key,
    required this.imagePath,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.file(File(imagePath), fit: BoxFit.cover), // Your image
        if (status == MessageStatusEnum.sending.value)
          const SpinKitFadingCircle(color: Colors.blue, size: 50.0),
        if (status == MessageStatusEnum.error.value)
          const Icon(
            Icons.error_sharp,
            size: 100,
            color: Colors.black54,
          ), // Error icon (optional
      ],
    );
  }
}
