import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniket/bloc/message/message_bloc.dart';
import 'package:uniket/bloc/typing/typing_bloc.dart';
import 'package:uniket/features/chat/widgets/message_card.dart';
import 'package:uniket/models/message.dart';
import 'package:uniket/network/repository/auth_repository/auth_repo.dart';

class ChatList extends StatefulWidget {
  final ScrollController scrollController;
  final String chatRoomId;
  final List<Message> messages;
  const ChatList(
      {super.key,
      required this.scrollController,
      required this.chatRoomId,
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
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!widget.scrollController.hasClients) return;

      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent) {
        // Ensure this is called only when there are items in the list
        if (widget.messages.isNotEmpty) {
          context
              .read<MessageBloc>()
              .add(GetMoreMessageEvent(widget.chatRoomId));
        }
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
        itemCount: widget.messages.length +
            2, // first item is typing indicator and last item is loading indicator
        controller: widget.scrollController,
        cacheExtent: 100.0,
        reverse: true,
        itemBuilder: (context, index) {
          var itemNumber = index - 1;
          // if it is the first item, return a typing indicator
          if (itemNumber == -1) {
            return BlocBuilder<TypingBloc, TypingState>(
              builder: (context, state) {
                if (state is TypingStarted &&
                    state.chatId == widget.chatRoomId) {
                  return const Align(
                    alignment: Alignment.centerRight,
                    child: MessageBox(
                      isMyMessage: true,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
          // if it is the last item, return a loading indicator or nothing

          if (itemNumber == widget.messages.length) {
            return BlocBuilder<MessageBloc, MessageBlocState>(
              builder: (context, state) {
                return state is EndMessageState ||
                        state.chatMessages.length < 19
                    ? const SizedBox()
                    : const Center(
                        child: CircularProgressIndicator(),
                      );
              },
            );
          }
          // if there are messages, return a message card
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
        },
      ),
    );
  }
}
