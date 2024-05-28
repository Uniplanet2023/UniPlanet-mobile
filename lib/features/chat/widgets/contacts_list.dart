import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/bloc/status/status_bloc.dart';
import 'package:uniplanet/bloc/typing/typing_bloc.dart';
import 'package:uniplanet/common/enums/chat_enum.dart';
import 'package:uniplanet/common/enums/message_enum.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/features/account/screens/user_profile.dart';
import 'package:uniplanet/features/chat/screens/chat_screen.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/user_model.dart';
import 'package:uniplanet/api/repository/auth_repository/auth_repo.dart';

class ContactsList extends StatefulWidget {
  final List<ChatRoom> list;
  final String sort;
  const ContactsList({super.key, required this.list, required this.sort});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
  }

  void _fetchData() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      context.read<ChatBloc>().add(const LoadMoreChatRoomEvent());
      // Simulate a network request delay
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return; // Check if the widget is still mounted

      // Fetch data logic here, possibly increasing _currentPage
      // Update widget.list here with new items

      setState(() => _isLoading = false);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        notification.metrics.pixels == notification.metrics.maxScrollExtent) {
      if (context.read<ChatBloc>().state is! EndChatRoomState &&
          widget.list.length > 9) {
        _fetchData();
      }
    }
    return false;
  }

  _onDismissed(int index, ChatActions action, User client) {
    switch (action) {
      case ChatActions.archive:
        // Archive chat room
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ChatActions.delete:
        // Delete chat room
        context.read<ChatBloc>().add(DeleteChatRoomEvent(
            chatId: widget.list[index].id, clientId: client.id));
        setState(() {
          widget.list.removeAt(index);
        });
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.list.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == widget.list.length && widget.list.length > 9) {
              return const Center(child: CircularProgressIndicator());
            }
            return Builder(builder: (BuildContext innerContext) {
              User client =
                  widget.list[index].seller.id == AuthRepository.userId
                      ? widget.list[index].buyer
                      : widget.list[index].seller;

              // Determine if the user is typing f    or this chat room.
              Message last;
              if (widget.list[index].lastMessage != null) {
                last = widget.list[index].lastMessage!;
              } else {
                last = Message.initMessage();
              }

              return Slidable(
                key: Key(widget.list[index].id),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _onDismissed(index, ChatActions.delete, client);
                      },
                      icon: Icons.delete,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          final slidable = Slidable.of(innerContext);
                          if (slidable == null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return ChatScreen(
                                  client: client,
                                  chatRoom: widget.list[index],
                                );
                              }),
                            );
                          } else {
                            final isClosed = slidable.actionPaneType.value ==
                                ActionPaneType.none;
                            if (isClosed) {
                              slidable.openStartActionPane();
                            } else {
                              slidable.close();
                            }
                          }
                        },
                        title: Text(
                          widget.sort == 'product'
                              ? widget.list[index].productName
                              : client.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: BlocBuilder<TypingBloc, TypingState>(
                            builder: (context, state) {
                              bool isTyping = state is TypingStarted &&
                                  state.chatId == widget.list[index].id;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (isTyping)
                                    const SpinKitThreeBounce(
                                      color: Colors
                                          .grey, // Adjust the color to fit your app theme
                                      size:
                                          16.0, // Adjust the size based on your UI
                                    ),
                                  if (!isTyping)
                                    Expanded(
                                      child: Text(
                                        last.messageType ==
                                                MessageEnum.image.value
                                            ? "Image"
                                            : last.message,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: last.sender !=
                                                      AuthRepository.userId &&
                                                  last.readDate == null
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines:
                                            1, // Ensure only one line is shown
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                        leading: Stack(
                          children: [
                            client.profileImage == null
                                ? const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 25,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                          return UserProfileScreen(
                                              user: widget.list[index].seller);
                                        }),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        client.profileImage!,
                                        cacheManager:
                                            GlobalVariables.customCacheManager,
                                      ),
                                      radius: 25,
                                    ),
                                  ),
                            BlocBuilder<StatusBloc, StatusState>(
                              builder: (context, state) {
                                return Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: state.online.contains(client.id)
                                        ? const Icon(Icons.circle,
                                            color: Colors.green, size: 12)
                                        : const Icon(Icons.circle,
                                            color: Colors.red, size: 12));
                              },
                            ),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              child: Text(
                                widget.list[index].lastMessage?.createdAt !=
                                        null
                                    ? formatTimestamp(widget
                                        .list[index].lastMessage!.createdAt)
                                    : "",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            widget.list[index].unseenMessageCount == 0
                                ? const SizedBox()
                                : Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .red, // Background color for the circle
                                      borderRadius: BorderRadius.circular(
                                          10), // Makes it round
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth:
                                          25, // Minimum width for the red circle
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
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
