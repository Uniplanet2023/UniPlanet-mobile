import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/local_stoarage/local_stoarage.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/typing/typing_bloc.dart';
import 'package:uniplanet/features/chat/presentation/widgets/message_card.dart';
import 'package:uniplanet/features/chat/domain/entities/message.dart';

class ChatList extends StatefulWidget {
  final ScrollController scrollController;
  final String chatRoomId;
  final List<Message> messages;
  final User client;

  const ChatList({
    super.key,
    required this.scrollController,
    required this.chatRoomId,
    required this.messages,
    required this.client,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!widget.scrollController.hasClients) return;

      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent - 100) {
        if (widget.messages.isNotEmpty) {
          context
              .read<MessageBloc>()
              .add(GetMoreMessageEvent(widget.chatRoomId));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ListView.builder(
        key: ValueKey('ChatList_${widget.chatRoomId}}'),
        itemCount: widget.messages.length + 2,
        controller: widget.scrollController,
        cacheExtent: 100.0,
        reverse: true,
        itemBuilder: (context, index) {
          var itemNumber = index - 1;
          if (itemNumber == -1) {
            return BlocBuilder<TypingBloc, TypingState>(
              builder: (context, state) {
                if (state is TypingStarted &&
                    state.chatId == widget.chatRoomId) {
                  return const Align(
                    alignment: Alignment.centerRight,
                    child: MessageBox(isMyMessage: false),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }

          if (itemNumber == widget.messages.length) {
            return BlocBuilder<MessageBloc, MessageBlocState>(
              builder: (context, state) {
                if (state is EndMessageState || widget.messages.length < 19) {
                  return const SizedBox();
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }

          final Message oldMessage = widget.messages[itemNumber];
          Message? recentMessage;
          if (itemNumber > 0) {
            recentMessage = widget.messages[itemNumber - 1];
          }
          return MessageCard(
            key: ValueKey(recentMessage?.id),
            oldMessage: oldMessage,
            recentMessage: recentMessage,
            isMyMessage: oldMessage.sender == LocalStorage().getUserData().id,
            client: widget.client,
          );
        },
      ),
    );
  }
}
