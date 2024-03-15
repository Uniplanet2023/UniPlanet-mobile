import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/features/chat/widgets/my_message_card.dart';
import 'package:uniplanet_mobile/features/chat/widgets/sender_message_card.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';

class ChatList extends StatefulWidget {
  final ScrollController scrollController;
  final ChatRoom chatRoom;
  final List<Message> messages;
  const ChatList(
      {super.key,
      required this.scrollController,
      required this.chatRoom,
      required this.messages});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    // Add a listener to the scrollController here

    widget.scrollController.addListener(_scrollListener);
  }

  // Define the scroll listener method
  void _scrollListener() {
    // If there's an existing timer, cancel it
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Check if the scroll position is at the end of the scroll extent
    // Set up a new timer that waits for 50ms (or your desired debounce duration) before firing
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent) {
        context
            .read<MessageBloc>()
            .add(GetMoreMessageEvent(widget.chatRoom.id));
      }
    });
  }

  @override
  void dispose() {
    // Don't forget to remove the listener when the widget is disposed
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('h:mm a');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        itemCount: widget.messages.length + 1,
        controller: widget.scrollController,
        cacheExtent: 100.0,
        reverse: true,
        itemBuilder: (context, index) {
          if (index == widget.messages.length) {
            // if (widget.messages.length > 19 && state is! EndMessageState) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else {
            //   return const SizedBox();
            // }
            return const SizedBox();
          }
          if (widget.messages.isEmpty) {
            return const SizedBox();
          }
          final Message currentMessage = widget.messages[index];
          String formattedDate =
              formatter.format(currentMessage.createdAt.toLocal());

          // Check for one-minute gap if not the first message and the same sender
          bool hidePreviousDate = false;
          if (index > 0) {
            final Message previousMessage = widget.messages[index - 1];

            final bool isSameSender =
                currentMessage.sender == previousMessage.sender;

            if (isSameSender &&
                previousMessage.createdAt.year ==
                    currentMessage.createdAt.year &&
                previousMessage.createdAt.day == currentMessage.createdAt.day &&
                previousMessage.createdAt.hour ==
                    currentMessage.createdAt.hour &&
                currentMessage.createdAt.minute ==
                    previousMessage.createdAt.minute) {
              // Flag to hide date for the previous message
              hidePreviousDate = true;
            }
          }

          // Card assignment with conditional date visibility
          if (currentMessage.sender == AccountRepository.user!.id) {
            return MyMessageCard(
              message: currentMessage,
              date: index == 0 || !hidePreviousDate ? formattedDate : '',
            );
          } else {
            if (currentMessage.readDate == null) {
              print('triggered');
              // SocketService.socket!.emit('seenMessageACK', {
              //   currentMessage.messageId,
              //   widget.chatRoom.chatRoomId,
              //   widget.chatRoom.chatRoom.chatRoomId
              // });
            }
            return SenderMessageCard(
              message: currentMessage,
              date: index == 0 || !hidePreviousDate ? formattedDate : '',
            );
          }
        },
      ),
    );
  }
}
