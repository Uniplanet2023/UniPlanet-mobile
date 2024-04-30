import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/chat/widgets/contacts_list.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

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
              title: Row(
                children: [
                  const Image(
                      image: AssetImage('assets/images/Logo_nbg.png'),
                      width: 30,
                      height: 30),
                  Text(
                    'UniPlanet',
                    style: TextStyle(
                      fontStyle: GoogleFonts.roboto().fontStyle,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
