import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/features/chat/widgets/my_message_card.dart';
import 'package:uniplanet_mobile/features/chat/widgets/sender_message_card.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    User user = context.read<UserBloc>().state.user!;
    var state = context.watch<MessageBloc>().state;

    if (state.msgList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final DateFormat formatter = DateFormat('h:mm a');

    return ListView.builder(
      itemCount: state.msgList!.length,
      itemBuilder: (context, index) {
        final Message currentMessage = state.msgList![index];
        String formattedDate = formatter.format(currentMessage.timestamp);

        // Check for one-minute gap if not the first message and the same sender
        bool hidePreviousDate = false;
        if (index > 0) {
          final Message previousMessage = state.msgList![index - 1];
          print("$index current message : ${currentMessage.message}");
          print('$index previous message : ${previousMessage.message}');
          final bool isSameSender =
              currentMessage.senderId == previousMessage.senderId;

          if (isSameSender &&
              currentMessage.timestamp
                      .difference(previousMessage.timestamp)
                      .inMinutes <
                  1) {
            // Flag to hide date for the previous message
            hidePreviousDate = true;
          }
        }

        // Card assignment with conditional date visibility
        if (currentMessage.senderId == user.id) {
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
    );
  }
}
