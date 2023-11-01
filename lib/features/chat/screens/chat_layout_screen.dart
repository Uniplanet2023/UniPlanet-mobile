import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_state.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/widgets/contacts_list.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatList extends StatefulWidget {
  static const String routeName = '/chat_list';
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    super.initState();
    _loadList();
  }

  _loadList() {
    User user = context.read<UserBloc>().state.user!;
    context.read<ChatBloc>().add(LoadChatRoomEvent(user.chatRooms));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatBloc>().state;

    List<ChatRoom> buyerChatRoom = [];
    List<ChatRoom> sellerChatRooms = [];

    if (state is LoadedChatRoomState) {
      buyerChatRoom = state.chatRoomList!
          .where((chatRoom) => chatRoom.type == 'buyer')
          .toList();
      sellerChatRooms = state.chatRoomList!
          .where((chatRoom) => chatRoom.type == 'seller')
          .toList();
    }
    return DefaultTabController(
      length: 3,
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
                text: 'Buy Items (${buyerChatRoom.length})',
              ),
              Tab(
                text: 'Buy Items (${sellerChatRooms.length})',
              ),
              const Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Buy Items Tab
            ContactsList(
              list: buyerChatRoom,
            ),
            // Sell Items Tab
            ContactsList(
              list: sellerChatRooms,
            ),
            // Calls Tab
            // For this example, I'm leaving it empty. Update it as per your requirements.
            Container(),
          ],
        ),
      ),
    );
  }
}
