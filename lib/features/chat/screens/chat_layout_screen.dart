import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_state.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/features/chat/widgets/contacts_list.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';

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
    return DefaultTabController(
      length: 2,
      child: BlocListener<ChatBloc, ChatBlocState>(
        listener: (context, state) {
          if (state is LoadedChatRoomState) {}
        },
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
                BlocBuilder<ChatBloc, ChatBlocState>(
                  builder: (context, state) {
                    return Tab(
                      text: 'Buying (${state.buyingChatRoom.length})',
                    );
                  },
                ),
                BlocBuilder<ChatBloc, ChatBlocState>(
                  builder: (context, state) {
                    return Tab(
                      text: 'Selling (${state.sellingChatRooms.length})',
                    );
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Buy Items Tab
              BlocBuilder<ChatBloc, ChatBlocState>(
                builder: (context, state) {
                  return ContactsList(
                    list: state.buyingChatRoom,
                  );
                },
              ),
              // Sell Items Tab
              BlocBuilder<ChatBloc, ChatBlocState>(
                builder: (context, state) {
                  return ContactsList(
                    list: state.sellingChatRooms,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
