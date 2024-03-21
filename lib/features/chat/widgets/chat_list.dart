import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/typing/typing_bloc.dart';
import 'package:uniplanet_mobile/features/chat/widgets/message_card.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';
import 'package:uniplanet_mobile/repository/auth_repository/auth_repo.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        itemCount: widget.messages.length + 2,
        controller: widget.scrollController,
        cacheExtent: 100.0,
        reverse: true,
        itemBuilder: (context, index) {
          var itemNumber = index - 1;
          if (index == 0) {
            return BlocBuilder<TypingBloc, TypingState>(
              builder: (context, state) {
                if (state is TypingStarted &&
                    state.chatId == widget.chatRoom.id) {
                  return const MessageBox(
                    isMyMessage: true,
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
          if (itemNumber == widget.messages.length) {
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
          final Message oldMessage = widget.messages[itemNumber];
          Message? recentMessage;
          if (itemNumber > 0) {
            recentMessage = widget.messages[itemNumber - 1];
          }
          return MessageCard(
            oldMessage: oldMessage,
            recentMessage: recentMessage,
            isMyMessage: oldMessage.sender == AuthRepository.userId,
          );

          // // Card assignment with conditional date visibility
          // if (oldMessage.sender == AccountRepository.user!.id) {
          //   return MyMessageCard(
          //     message: oldMessage,
          //     date: index == 0 || !hidePreviousDate ? formattedDate : '',
          //   );
          // } else {
          //   return SenderMessageCard(
          //     message: oldMessage,
          //     date: index == 0 || !hidePreviousDate ? formattedDate : '',
          //   );
          // }
        },
      ),
    );
  }
}
