import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet/config/enums/message_enum.dart';
import 'package:uniplanet/config/enums/message_status_enum.dart';
import 'package:uniplanet/features/common/presentation/widgets/full_image.dart';
import 'package:uniplanet/features/common/presentation/widgets/selectable_text.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:uniplanet/features/account/screens/user_profile.dart';
import 'package:uniplanet/features/chat/widgets/image_with_loading.dart';
import 'package:uniplanet/features/chat/widgets/message_detail.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user.dart';

class MessageCard extends StatelessWidget {
  final Message oldMessage;
  final Message? recentMessage;
  final bool isMyMessage;
  final User client;

  const MessageCard({
    super.key,
    required this.oldMessage,
    this.recentMessage,
    required this.isMyMessage,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('h:mm a');
    String formattedDate = formatter.format(oldMessage.createdAt.toLocal());

    bool hidePreviousDate = false;
    if (recentMessage != null) {
      final bool isSameSender = oldMessage.sender == recentMessage!.sender;
      final difference =
          recentMessage!.createdAt.difference(oldMessage.createdAt);
      if (isSameSender && difference.inMinutes < 1) {
        hidePreviousDate = true;
      }
    }

    return Column(
      children: [
        Align(
          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: isMyMessage
                ? _buildMessageComponents(
                    context, formattedDate, hidePreviousDate)
                : _buildMessageComponents(
                        context, formattedDate, hidePreviousDate)
                    .reversed
                    .toList(),
          ),
        ),
        if (recentMessage != null &&
            oldMessage.createdAt.day < recentMessage!.createdAt.day)
          Align(
            alignment: Alignment.center,
            child: Text(
              oldMessage.createdAt.day + 1 == DateTime.now().toLocal().day
                  ? 'Yesterday'
                  : DateFormat('d MMM').format(oldMessage.createdAt),
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.tertiaryContainer),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildMessageComponents(
      BuildContext context, String formattedDate, bool hidePreviousDate) {
    return [
      Row(
        children: [
          if (!hidePreviousDate)
            Text(
              formattedDate,
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.tertiaryContainer),
            ),
          const SizedBox(width: 5),
          _buildMessageStatusIcon(context),
        ],
      ),
      MessageBox(isMyMessage: isMyMessage, oldMessage: oldMessage),
      if (!hidePreviousDate && !isMyMessage)
        _buildProfileAvatar(context)
      else if (!isMyMessage)
        const SizedBox(width: 48),
    ];
  }

  Widget _buildMessageStatusIcon(BuildContext context) {
    if (oldMessage.status == MessageStatusEnum.sending.value) {
      return const SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(strokeWidth: 4),
      );
    } else if (oldMessage.status == MessageStatusEnum.received.value) {
      return oldMessage.readDate == null
          ? Text(
              'unseen',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            )
          : const SizedBox();
    } else {
      return Icon(Icons.error,
          size: 20, color: Theme.of(context).colorScheme.tertiaryContainer);
    }
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      width: 30,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserProfileScreen(user: client),
          ));
        },
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            client.profileImage!,
            cacheManager: GlobalVariables.customCacheManager,
          ),
          radius: 18,
        ),
      ),
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
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isTyping ? 100 : 250, // Smaller width when typing
          maxHeight: isTyping ? 40 : 250,
        ),
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: getColorForCard(context),
          margin: EdgeInsets.fromLTRB(
              isMyMessage ? 5 : 10, 5, isMyMessage ? 15 : 5, 5),
          child: Padding(
            padding: getPaddingForContent(),
            child: getContentWidget(context, isTyping, isOverflowing),
          ),
        ),
      ),
    );
  }

  Color getColorForCard(BuildContext context) {
    if (oldMessage?.messageType == MessageEnum.image.value) {
      return Colors.transparent;
    } else {
      return isMyMessage
          ? Theme.of(context).colorScheme.primaryFixedDim
          : Theme.of(context).colorScheme.secondaryFixedDim;
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

    return SelectableLinkText(
      text: textMessage,
      maxLines: 10,
      minLines: 1,
    );
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
    return oldMessage!.status == MessageStatusEnum.received.value ||
            oldMessage!.status == MessageStatusEnum.error.value
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
