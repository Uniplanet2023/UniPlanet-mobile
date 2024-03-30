import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/status/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/typing/typing_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/chat/screens/chat_screen.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/repository/auth_repository/auth_repo.dart';

class ContactsList extends StatefulWidget {
  final List<ChatRoom> list;
  const ContactsList({super.key, required this.list});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return Builder(builder: (BuildContext innerContext) {
            User client = widget.list[index].seller.id == AuthRepository.userId
                ? widget.list[index].buyer
                : widget.list[index].seller;

            // Determine if the user is typing f    or this chat room.
            Message last;
            if (widget.list[index].lastMessage != null) {
              last = widget.list[index].lastMessage!;
            }
            last = innerContext.select<MessageBloc, Message>((bloc) {
              if (bloc.state is ReadMessageState ||
                  bloc.state is ReceivedMessageState ||
                  bloc.state is LoadedMessageState) {
                if ((bloc.state).chatMessages[widget.list[index].id] != null) {
                  return bloc.state.chatMessages[widget.list[index].id]!.first;
                }
              }
              if (widget.list[index].lastMessage != null) {
                return widget.list[index].lastMessage!;
              } else {
                return Message.initMessage();
              }
            });

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
                        child: BlocBuilder<TypingBloc, TypingState>(
                          builder: (context, state) {
                            bool isTyping = state is TypingStarted &&
                                state.chatId == widget.list[index].id;
                            return Text(
                              isTyping ? "Typing..." : last.message,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    last.sender != AuthRepository.userId &&
                                            last.readDate == null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            );
                          },
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
                          BlocBuilder<StatusBloc, StatusState>(
                            builder: (context, state) {
                              return Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: state.online.contains(client.id)
                                      ? const Icon(Icons.circle,
                                          color: Colors.green, size: 16)
                                      : const Icon(Icons.circle,
                                          color: Colors.red, size: 16));
                            },
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Text(
                              widget.list[index].lastMessage?.createdAt != null
                                  ? formatTimestamp(
                                      widget.list[index].lastMessage!.createdAt)
                                  : "",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          widget.list[index].unseenMessageCount == 0
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
                                      widget.list[index].unseenMessageCount
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
                          const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                    color: GlobalVariables.backgroundColor, indent: 85),
              ],
            );
          });
        },
      ),
    );
  }
}
