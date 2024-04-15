import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uniplanet_mobile/common/enums/message_enum.dart';
import 'package:uniplanet_mobile/common/enums/message_status_enum.dart';
import 'package:uniplanet_mobile/common/widgets/full_image.dart';
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

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required this.isMyMessage,
    this.oldMessage,
  });

  final bool isMyMessage;
  final Message? oldMessage;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final GlobalKey _key = GlobalKey();
  bool _isOverflowing = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
    super.initState();
  }

  void _checkOverflow() {
    if (_key.currentContext != null) {
      final RenderBox? box =
          _key.currentContext!.findRenderObject() as RenderBox?;
      if (box != null && box.size.height > 220.h) {
        setState(() {
          _isOverflowing = true; // Now you know it's overflowing
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTyping = widget.oldMessage == null;

    return ConstrainedBox(
      key: _key,
      constraints: BoxConstraints(
        maxWidth: isTyping ? 100.w : 250.w, // Smaller width when typing
        maxHeight: isTyping ? 40.h : 250.h,
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: getColorForCard(),
        margin: EdgeInsets.fromLTRB(
            widget.isMyMessage ? 5 : 15, 5, widget.isMyMessage ? 15 : 5, 5),
        child: Padding(
          padding: getPaddingForContent(),
          child: getContentWidget(context, isTyping),
        ),
      ),
    );
  }

  Color getColorForCard() {
    if (widget.oldMessage?.messageType == MessageEnum.image.value) {
      return Colors.transparent;
    } else {
      return widget.isMyMessage ? GlobalVariables.primaryColor : Colors.white;
    }
  }

  EdgeInsets getPaddingForContent() {
    return widget.oldMessage?.messageType == MessageEnum.image.value
        ? const EdgeInsets.all(0)
        : const EdgeInsets.all(8.0);
  }

  Widget getContentWidget(BuildContext context, bool isTyping) {
    if (isTyping) {
      return const SpinKitThreeBounce(
        color: Colors.grey,
        size: 20,
      );
    } else if (widget.oldMessage!.messageType == MessageEnum.text.value) {
      return getTextMessage(context);
    } else if (widget.oldMessage!.messageType == MessageEnum.image.value) {
      return handleImageMessage(context);
    } else {
      return Text(widget.oldMessage!.message,
          style: const TextStyle(fontSize: 16));
    }
  }

  Widget getTextMessage(BuildContext context) {
    var textMessage = widget.oldMessage!.message;

    return GestureDetector(
      onTap: () {
        _isOverflowing ? _handleTap(context) : null;
      },
      child: Text(textMessage, style: const TextStyle(fontSize: 16)),
    );
  }

  void _handleTap(BuildContext context) {
    if (widget.oldMessage != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MessageDetailScreen(message: widget.oldMessage!),
      ));
    }
  }

  Widget handleImageMessage(BuildContext context) {
    return widget.oldMessage!.status == MessageStatusEnum.received.value
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => FullScreenImageView(
                      imagePath: widget.oldMessage!.message),
                ));
              },
              child: CachedNetworkImage(
                imageUrl: widget.oldMessage!.message,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          )
        : ImageWithLoadingIndicator(
            imagePath: widget.oldMessage!.message,
            status: widget.oldMessage!.status,
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
