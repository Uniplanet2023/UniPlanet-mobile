import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/widgets/contacts_list.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const LoadChatRoomEvent());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatBloc>().state;

    List<ChatRoom> buyingChatRoom = [];
    List<ChatRoom> sellingChatRooms = [];

    if (state is LoadedChatRoomState) {
      // sellingChatRooms = state.chatRoomList!
      //     .where((myChatRoom) => myChatRoom.type == "seller")
      //     .toList();
      // buyingChatRoom = state.chatRoomList!
      //     .where((myChatRoom) => myChatRoom.type == "buyer")
      //     .toList();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: GlobalVariables.backgroundColor,
          centerTitle: false,
          title: const Text(
            'UniPlanet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: GlobalVariables.secondaryColor,
            indicatorWeight: 4,
            labelColor: GlobalVariables.secondaryColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'Buying (${buyingChatRoom.length})',
              ),
              Tab(
                text: 'Selling (${sellingChatRooms.length})',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Buy Items Tab
            ContactsList(
              list: buyingChatRoom,
            ),
            // Sell Items Tab
            ContactsList(
              list: sellingChatRooms,
            ),
          ],
        ),
      ),
    );
  }
}
