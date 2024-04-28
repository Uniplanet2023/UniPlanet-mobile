// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/bloc/get_product/get_product_bloc.dart';
import 'package:uniplanet/bloc/status/status_bloc.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/account/screens/user_profile.dart';
import 'package:uniplanet/features/chat/widgets/bottom_chat_bar.dart';
import 'package:uniplanet/features/chat/widgets/chat_list.dart';
import 'package:uniplanet/features/product_details/screens/product_details_screen.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user_model.dart';
import 'package:uniplanet/bloc/message/message_bloc.dart';
import 'package:uniplanet/network/socket/socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  final User client;
  const ChatScreen({super.key, required this.client, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool isExpanded = false;

  @override
  void initState() {
    context.read<MessageBloc>().add(GetMessageEvent(widget.chatRoom.id));
    context
        .read<GetProductBloc>()
        .add(GetProductLoadEvent(productId: widget.chatRoom.productId));
    SocketService.currentChatLocation = widget.chatRoom.id;
    Global.socketService.readAllMessages(widget.chatRoom.id);
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
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserProfileScreen(user: widget.client),
                        ),
                      );
                    },
                    child: Text(widget.client.name)),
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
                          context.read<ChatBloc>().add(DeleteChatRoomEvent(
                              chatId: widget.chatRoom.id,
                              clientId: widget.client.id));
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
          var chatMessages = state.chatMessages[widget.chatRoom.id] ?? [];
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
            BlocBuilder<GetProductBloc, GetProductState>(
              builder: (context, state) {
                if (state is GetProductLoading) {
                  return const CircularProgressIndicator();
                } else if (state is GetProductLoaded) {
                  return ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        this.isExpanded = isExpanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(state.product!.name),
                          );
                        },
                        body: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                product: state.product!)));
                              },
                              child: CachedNetworkImage(
                                imageUrl: state.product!.images[0],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150, // Adjust the size as needed
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                '\$${state.product!.price}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.star),
                              label: const Text('Review Product'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: GlobalVariables.secondaryColor,
                                side: const BorderSide(color: Colors.black),
                              ),
                              onPressed: () {
                                // Review Product
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                product: state.product!)));
                              },
                            ),
                          ],
                        ),
                        isExpanded: isExpanded,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            Expanded(
                child: ChatList(
              scrollController: _scrollController,
              chatRoomId: widget.chatRoom.id,
              messages: messages.reversed.toList(),
            )),
            BottomChatField(
              chatRoomId: widget.chatRoom.id,
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
