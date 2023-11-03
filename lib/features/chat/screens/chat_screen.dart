import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';

import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';

import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  get mobileChatBoxColor => null;

  @override
  void initState() {
    super.initState();
    ChatRoom roomState = context.read<ChatBloc>().state.currentChatRoom!;
    context
        .read<MessageBloc>()
        .add(GetMessageEvent(roomState.messages, roomState.chatRoomId));
  }

  @override
  Widget build(BuildContext context) {
    User client = context.watch<ChatBloc>().state.client!;
    var userOnline = context.watch<StatusBloc>().state.userOnList!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(client.name),
            userOnline.contains(client.id)
                ? const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 16),
                      Text(
                        'online',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Text(
                        'offline',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                      Icon(Icons.circle, color: Colors.red, size: 16),
                    ],
                  ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: ChatList()),
          BottomChatField(
              chatRoomId:
                  context.read<ChatBloc>().state.currentChatRoom!.chatRoomId),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
