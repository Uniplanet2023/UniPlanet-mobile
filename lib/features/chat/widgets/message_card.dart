import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet/common/enums/message_enum.dart';
import 'package:uniplanet/common/enums/message_status_enum.dart';
import 'package:uniplanet/common/widgets/full_image.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/models/message.dart';

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
    bool isTyping = oldMessage == null;
    bool isOverflowing = false;
    int newlineCount = 0;
    if (oldMessage != null) {
      newlineCount = '\n'.allMatches(oldMessage!.message).length;

      oldMessage!.message.length > 100
          ? isOverflowing = true
          : isOverflowing = newlineCount > 9;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isTyping ? 100.w : 250.w, // Smaller width when typing
        maxHeight: isTyping ? 40.h : 250.h,
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: getColorForCard(),
        margin: EdgeInsets.fromLTRB(
            isMyMessage ? 5 : 15, 5, isMyMessage ? 15 : 5, 5),
        child: Padding(
          padding: getPaddingForContent(),
          child: getContentWidget(context, isTyping, isOverflowing),
        ),
      ),
    );
  }

  Color getColorForCard() {
    if (oldMessage?.messageType == MessageEnum.image.value) {
      return Colors.transparent;
    } else {
      return isMyMessage ? GlobalVariables.primaryColor : Colors.white;
    }
  }

  EdgeInsets getPaddingForContent() {
    return oldMessage?.messageType == MessageEnum.image.value
        ? const EdgeInsets.all(0)
        : const EdgeInsets.all(8.0);
  }

  Widget getContentWidget(
      BuildContext context, bool isTyping, bool isOverflowing) {
    if (isTyping) {
      return const SpinKitThreeBounce(
        color: Colors.grey,
        size: 20,
      );
    } else if (oldMessage!.messageType == MessageEnum.text.value) {
      return isOverflowing
          ? getOverflowTextMessage(context)
          : getTextMessage(context);
    } else if (oldMessage!.messageType == MessageEnum.image.value) {
      return handleImageMessage(context);
    } else {
      return Text(oldMessage!.message, style: const TextStyle(fontSize: 16));
    }
  }

  Widget getTextMessage(BuildContext context) {
    var textMessage = oldMessage!.message;

    return Text(textMessage,
        style: const TextStyle(fontSize: 16),
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        softWrap: true);
  }

  Widget getOverflowTextMessage(BuildContext context) {
    var textMessage = oldMessage!.message;

    return GestureDetector(
      onTap: () {
        _handleTap(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(textMessage,
                style: const TextStyle(fontSize: 16),
                maxLines: 9,
                overflow: TextOverflow.ellipsis,
                softWrap: true),
          ),
          const Text('View All', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (oldMessage != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MessageDetailScreen(message: oldMessage!),
      ));
    }
  }

  Widget handleImageMessage(BuildContext context) {
    return oldMessage!.status == MessageStatusEnum.received.value
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      FullScreenImageView(imagePath: oldMessage!.message),
                ));
              },
              child: CachedNetworkImage(
                imageUrl: oldMessage!.message,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          )
        : ImageWithLoadingIndicator(
            imagePath: oldMessage!.message,
            status: oldMessage!.status,
          );
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
        ClipRRect(
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for the image
          child: Image.file(File(imagePath), fit: BoxFit.cover), // Your image
        ),
        if (status == MessageStatusEnum.sending.value)
          const SpinKitFadingCircle(color: Colors.blue, size: 50.0),
        if (status == MessageStatusEnum.error.value)
          const Icon(
            Icons.error_sharp,
            size: 100,
            color: Colors.black54,
          ),
      ],
    );
  }
}

class MessageDetailScreen extends StatelessWidget {
  final Message message;

  const MessageDetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: double.infinity,
            child: Text(
              message.message,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
