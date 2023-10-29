import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/features/chat/widgets/info.dart';
import 'package:uniplanet_mobile/features/chat/widgets/my_message_card.dart';
import 'package:uniplanet_mobile/features/chat/widgets/sender_message_card.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user.dart';

class ChatList extends StatefulWidget {
  final List<Message> msgList;
  const ChatList({Key? key, required this.msgList}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    User user = context.read<UserBloc>().state.user!;
    return ListView.builder(
      itemCount: widget.msgList.length,
      itemBuilder: (context, index) {
        if (widget.msgList[index].senderId == user.id) {
          return MyMessageCard(
            message: widget.msgList[index].message,
            date: widget.msgList[index].timestamp.toString(),
          );
        }
        return SenderMessageCard(
          message: widget.msgList[index].message,
          date: widget.msgList[index].timestamp.toString(),
        );
      },
    );
  }
}
