import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_screen.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

class ContactsList extends StatefulWidget {
  final List<MyChatRoom> list;
  const ContactsList({super.key, required this.list});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  _loadList() {
    context.read<ChatBloc>().add(const LoadChatRoomEvent());
  }

  @override
  Widget build(BuildContext context) {
    var userOnline = context.watch<StatusBloc>().state.userOnList!;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          User client = widget.list[index].receiver;

          return Column(
            children: [
              InkWell(
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ChatScreen(
                        client: client,
                        myChatRoom: widget.list[index],
                      );
                    }),
                  );
                  _loadList();
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
                        widget.list[index].chatRoom.lastMessage == null
                            ? " "
                            : widget.list[index].chatRoom.lastMessage!.message,
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
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: Text(
                            widget.list[index].chatRoom.lastMessage
                                        ?.timestamp !=
                                    null
                                ? formatTimestamp(widget.list[index].chatRoom
                                    .lastMessage!.timestamp)
                                : "",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        widget.list[index].unseenMessage.isEmpty
                            ? const SizedBox()
                            : Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors
                                      .red, // Background color for the circle
                                  borderRadius: BorderRadius.circular(
                                      10), // Makes it round
                                ),
                                constraints: const BoxConstraints(
                                  minWidth:
                                      45, // Minimum width for the red circle
                                  minHeight:
                                      25, // Minimum height for the red circle
                                ),
                                child: Center(
                                  child: Text(
                                    widget.list[index].unseenMessage.length
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize:
                                          12, // You can adjust the font size as needed
                                    ),
                                  ),
                                ),
                              ),
                      ],
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
