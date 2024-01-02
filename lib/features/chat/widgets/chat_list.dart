import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/features/chat/widgets/my_message_card.dart';
import 'package:uniplanet_mobile/features/chat/widgets/sender_message_card.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatList extends StatefulWidget {
  final ScrollController scrollController;
  final MyChatRoom myChatRoom;
  const ChatList(
      {super.key, required this.scrollController, required this.myChatRoom});

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
            .add(GetMoreMessageEvent(widget.myChatRoom.myChatRoomId));
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
    var state = context.watch<MessageBloc>().state;

    final DateFormat formatter = DateFormat('h:mm a');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        itemCount: state.msgList!.length + 1,
        controller: widget.scrollController,
        cacheExtent: 100.0,
        reverse: true,
        itemBuilder: (context, index) {
          if (index == state.msgList!.length) {
            if (state.msgList!.length > 19 && state is! EndMessageState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const SizedBox();
            }
          }

          final Message currentMessage = state.msgList![index];
          String formattedDate = formatter.format(currentMessage.timestamp);

          // Check for one-minute gap if not the first message and the same sender
          bool hidePreviousDate = false;
          if (index > 0) {
            final Message previousMessage = state.msgList![index - 1];

            final bool isSameSender =
                currentMessage.senderId == previousMessage.senderId;

            if (isSameSender &&
                currentMessage.timestamp
                        .difference(previousMessage.timestamp)
                        .inMinutes
                        .abs() <
                    1) {
              // Flag to hide date for the previous message
              hidePreviousDate = true;
            }
          }

          // Card assignment with conditional date visibility
          if (currentMessage.senderId == UserRepository.user.id) {
            return MyMessageCard(
              message: currentMessage,
              date: index == 0 || !hidePreviousDate ? formattedDate : '',
            );
          } else {
            if (currentMessage.isSeen == false) {
              print('triggered');
              // SocketService.socket!.emit('seenMessageACK', {
              //   currentMessage.messageId,
              //   widget.myChatRoom.myChatRoomId,
              //   widget.myChatRoom.chatRoom.chatRoomId
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
