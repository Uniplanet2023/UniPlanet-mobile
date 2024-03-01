import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/User.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  final MyChatRoom myChatRoom;
  final User client;
  const ChatScreen({super.key, required this.client, required this.myChatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    super.initState();
    context
        .read<MessageBloc>()
        .add(GetMessageEvent(widget.myChatRoom.myChatRoomId));
  }

  @override
  Widget build(BuildContext context) {
    var userOnline = context.watch<StatusBloc>().state.userOnList!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.client.name),
            userOnline.contains(widget.client.id)
                ? const Row(
                    children: [
                      Text(
                        'online',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.normal),
                      ),
                      Icon(Icons.circle, color: Colors.green, size: 16),
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
          Expanded(
              child: ChatList(
            scrollController: _scrollController,
            myChatRoom: widget.myChatRoom,
          )),
          BottomChatField(
            chatRoomId: widget.myChatRoom.chatRoom.chatRoomId,
            scrollDownfuction: _scrollToBottom,
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
