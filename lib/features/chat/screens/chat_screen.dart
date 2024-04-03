// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/status/status_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet_mobile/features/chat/widgets/chat_list.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/network/notification/firebase_api.dart';
import 'package:uniplanet_mobile/network/socket/socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final User client;
  const ChatScreen({super.key, required this.client, required this.chatRoomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];

  @override
  void initState() {
    context.read<MessageBloc>().add(GetMessageEvent(widget.chatRoomId));
    SocketService.currentChatLocation = widget.chatRoomId;
    SocketService.instance.readAllMessages(widget.chatRoomId);
    super.initState();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  void messageAddFunction(Message message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    SocketService.currentChatLocation = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalVariables.backgroundColor,
        title: BlocBuilder<StatusBloc, StatusState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.client.name),
                state.online.contains(widget.client.id)
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
            );
          },
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
      body: BlocListener<MessageBloc, MessageBlocState>(
        listener: (context, state) {
          var chatMessages = state.chatMessages[widget.chatRoomId] ?? [];
          // TODO: implement listener
          if (state is LoadedMessageState || state is ReceivedMessageState) {
            setState(() {
              messages = chatMessages;
            });
          } else if (state is ReadMessageState) {
            setState(() {
              messages = chatMessages;
            });
          }
        },
        child: Column(
          children: [
            Expanded(
                child: ChatList(
              scrollController: _scrollController,
              chatRoomId: widget.chatRoomId,
              messages: messages,
            )),
            BottomChatField(
              chatRoomId: widget.chatRoomId,
              scrollDownfuction: _scrollToBottom,
              sellerId: widget.client.id,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
