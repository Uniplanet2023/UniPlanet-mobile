import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';

import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';
import 'package:uniplanet_mobile/features/chat/widgets/info.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  final String receiverId;
  const ChatScreen({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  get mobileChatBoxColor => null;
  ChatRepository? client;

  @override
  void initState() {
    super.initState();

    // client = ChatRepository.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Text(
          info[0]['name'].toString(),
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
          const Expanded(
            child: ChatList(),
          ),
          BottomChatField(recieverId: widget.receiverId),
        ],
      ),
    );
  }
}
