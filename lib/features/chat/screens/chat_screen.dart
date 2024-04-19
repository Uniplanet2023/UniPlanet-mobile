// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniket/bloc/chat/chat_bloc.dart';
import 'package:uniket/bloc/status/status_bloc.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniket/features/chat/widgets/chat_list.dart';
import 'package:uniket/global.dart';
import 'package:uniket/models/message.dart';
import 'package:uniket/models/user_model.dart';
import 'package:uniket/bloc/message/message_bloc.dart';
import 'package:uniket/network/socket/socket_channel.dart';

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
    Global.socketService.readAllMessages(widget.chatRoomId);
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this chat room?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Dismiss the dialog but not the screen
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Proceed with deletion after confirmation
                          context.read<ChatBloc>().add(
                              DeleteChatRoomEvent(chatId: widget.chatRoomId));
                          Navigator.of(context).pop(); // Dismiss the dialog
                          Navigator.of(context)
                              .pop(); // Navigate back from current screen
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: BlocListener<MessageBloc, MessageBlocState>(
        listener: (context, state) {
          var chatMessages = state.chatMessages[widget.chatRoomId] ?? [];
          // TODO: implement listener
          if (state is LoadingMessageState ||
              state is LoadedMessageState ||
              state is ReceivedMessageState ||
              state is ReadMessageState ||
              state is SentMessageState ||
              state is SendingMessageState ||
              state is ErrorMessageState) {
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
              messages: messages.reversed.toList(),
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
