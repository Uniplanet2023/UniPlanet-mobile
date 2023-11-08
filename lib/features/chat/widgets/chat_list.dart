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
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class ChatList extends StatefulWidget {
  final ScrollController scrollController;
  final ChatRoom chatRoom;
  const ChatList(
      {Key? key, required this.scrollController, required this.chatRoom})
      : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollController.hasClients &&
          widget.scrollController.position.maxScrollExtent - 200 <=
              widget.scrollController.offset) {
        context
            .read<MessageBloc>()
            .add(GetMessageEvent(widget.chatRoom.chatRoomId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MessageBloc>().state;

    if (state.msgList == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
            if (state.msgList!.length > 19) {
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
              message: currentMessage.message,
              date: index == 0 || !hidePreviousDate ? formattedDate : '',
            );
          } else {
            return SenderMessageCard(
              message: currentMessage.message,
              date: index == 0 || !hidePreviousDate ? formattedDate : '',
            );
          }
        },
      ),
    );
  }
}
