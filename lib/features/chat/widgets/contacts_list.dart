import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
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
  selectChatRoom(ChatRoom chatroom, String userId) {
    context.read<ChatBloc>().add(SelectChatRoomEvent(chatroom, userId));
  }

  _loadList(User user) {
    context.read<ChatBloc>().add(LoadChatRoomEvent(user.chatRooms));
  }

  @override
  Widget build(BuildContext context) {
    User user = context.read<UserBloc>().state.user!;

    var userOnline = context.watch<StatusBloc>().state.userOnList!;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          User client = widget.list[index].buyer.id == user.id
              ? widget.list[index].seller
              : widget.list[index].buyer;

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  selectChatRoom(widget.list[index], user.id);
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return const ChatScreen();
                    }),
                  );
                  _loadList(user);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      client.name,
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
                            child: userOnline.contains(client.id)
                                ? const Icon(Icons.circle,
                                    color: Colors.green, size: 16)
                                : const Icon(Icons.circle,
                                    color: Colors.red, size: 16)),
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
