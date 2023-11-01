import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';

import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';

import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  final List<String> msgList;
  final String chatRoomId;
  const ChatScreen({Key? key, required this.msgList, required this.chatRoomId})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  get mobileChatBoxColor => null;

  @override
  void initState() {
    super.initState();
    context
        .read<MessageBloc>()
        .add(GetMessageEvent(widget.msgList, widget.chatRoomId));
  }

  @override
  Widget build(BuildContext context) {
    ChatRoom roomState = context.read<ChatBloc>().state.currentChatRoom!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Column(
          children: [
            Text(roomState.name),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: StreamBuilder<bool>(
            //     stream: context
            //         .read<ChatBloc>()
            //         .onlineStatusStream, // Replace with your stream source
            //     builder: (context, snapshot) {
            //       if (snapshot.data == true) {
            //         return const Text(
            //           'online',
            //           style: TextStyle(
            //               fontSize: 13, fontWeight: FontWeight.normal),
            //         );
            //       } else {
            //         return const Text(
            //           'offline',
            //           style: TextStyle(
            //               fontSize: 13, fontWeight: FontWeight.normal),
            //         );
            //       }
            //     },
            //   ),
            // ),
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
          BottomChatField(chatRoomId: widget.chatRoomId),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
