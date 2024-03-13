import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom myChatRoom;
  final User client;
  const ChatScreen({super.key, required this.client, required this.myChatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late SocketService socketService;
  List<Message>? messages;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    getMessages();
    // socketService = SocketService(context);, (message) {
    //   setState(() {
    //     messages!.insert(0, message);
    //   });
    // });
    // socketService.connect(context);
    socketService.onConnectChat(context, widget.myChatRoom.id, (message) {
      setState(() {
        messages!.insert(0, message);
      });
    });
    socketService.joinChat(widget.myChatRoom.id);
    super.initState();
  }

  @override
  void dispose() {
    socketService.socket.disconnect();
    _scrollController.dispose();
    super.dispose();
  }

  // context.read<MessageBloc>().add(GetMessageEvent(widget.myChatRoom.id));
  void getMessages() {
    context.read<MessageBloc>().add(GetMessageEvent(widget.myChatRoom.id));
  }

  @override
  Widget build(BuildContext context) {
    // var userOnline = context.watch<StatusBloc>().state.userOnList!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.client.name),
            // userOnline.contains(widget.client.id)
            //     ? const Row(
            //         children: [
            //           Text(
            //             'online',
            //             style: TextStyle(
            //                 fontSize: 13, fontWeight: FontWeight.normal),
            //           ),
            //           Icon(Icons.circle, color: Colors.green, size: 16),
            //         ],
            //       )
            //     :
            const Row(
              children: [
                Text(
                  'offline',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
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
            chatRoom: widget.myChatRoom,
          )),
          BottomChatField(
            chatRoomId: widget.myChatRoom.id,
            scrollDownfuction: _scrollToBottom,
            socketService: socketService,
            sellerId: widget.client.id,
            messages: messages,
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
