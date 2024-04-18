import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniket/bloc/chat/chat_bloc.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:uniket/features/chat/widgets/contacts_list.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    context.read<ChatBloc>().add(const LoadChatRoomEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<ChatBloc, ChatBlocState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: GlobalVariables.backgroundColor,
              centerTitle: false,
              title: Text(
                'UniKet',
                style: TextStyle(
                  fontStyle: GoogleFonts.roboto().fontStyle,
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: const TabBar(
                indicatorColor: GlobalVariables.secondaryColor,
                indicatorWeight: 4,
                labelColor: GlobalVariables.secondaryColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(
                    text: 'By User',
                  ),
                  Tab(
                    text: 'By Product',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // User Tab
                ContactsList(
                  list: state.chatRooms,
                  sort: 'user',
                ),
                // Product Tab
                ContactsList(
                  list: state.chatRooms,
                  sort: 'product',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
