import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/services/socket_client.dart';

import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';
import 'package:uniplanet_mobile/features/chat/widgets/info.dart';

class MobileChatScreen extends StatefulWidget {
  static const String routeName = '/mobile-chat-screen';
  const MobileChatScreen({Key? key}) : super(key: key);

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  get mobileChatBoxColor => null;
  SocketClient? client;

  @override
  void initState() {
    super.initState();
    client = SocketClient.instance;
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
      body: const Column(
        children: [
          Expanded(
            child: ChatList(),
          ),
          BottomChatField(),
        ],
      ),
    );
  }
}
