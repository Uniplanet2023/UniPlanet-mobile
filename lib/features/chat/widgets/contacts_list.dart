import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_screen.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';

class ContactsList extends StatefulWidget {
  final List<ChatRoom> list;
  const ContactsList({Key? key, required this.list}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  selectChatRoom(ChatRoom chatroom) {
    context.read<ChatBloc>().add(SelectChatRoomEvent(chatroom));
  }

  _loadList() {
    User user = context.read<UserBloc>().state.user!;
    context.read<ChatBloc>().add(LoadChatRoomEvent(user.chatRooms));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () async {
                  selectChatRoom(widget.list[index]);
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ChatScreen(
                        chatRoomId: widget.list[index].chatRoomId,
                        msgList: widget.list[index].msgList,
                      );
                    }),
                  );
                  _loadList();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      widget.list[index].name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        widget.list[index].lastMessage == null
                            ? " "
                            : widget.list[index].lastMessage!.message,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                            cacheManager: GlobalVariables.customCacheManager,
                          ),
                          radius: 30,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: StreamBuilder<bool>(
                            stream: context
                                .read<ChatBloc>()
                                .onlineStatusStream, // Replace with your stream source
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return const Icon(Icons.circle,
                                    color: Colors.green, size: 16);
                              } else {
                                return const Icon(Icons.circle,
                                    color: Colors.red, size: 16);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      widget.list[index].lastMessage?.timestamp != null
                          ? formatTimestamp(
                              widget.list[index].lastMessage!.timestamp)
                          : "",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: GlobalVariables.backgroundColor, indent: 85),
            ],
          );
        },
      ),
    );
  }
}
