import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/router/names.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/get_product/get_product_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/screens/user_profile.dart';
import 'package:uniplanet/features/chat/presentation/widgets/bottom_chat_bar.dart';
import 'package:uniplanet/features/chat/presentation/widgets/chat_expansion_housing.dart';
import 'package:uniplanet/features/chat/presentation/widgets/chat_expansion_product.dart';
import 'package:uniplanet/features/chat/presentation/widgets/chat_list.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/report/presentation/screen/report_screen.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';
import 'package:uniplanet/core/network/socket/socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;
  final User client;
  const ChatScreen({super.key, required this.client, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool isExpanded = false;
  bool? isNotificationAllowed;
  bool isChatRoomDeleted = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTimeVisit();
    });

    isChatRoomDeleted = widget.chatRoom.deletedFrom != null ? true : false;
    _initChat();
  }

  void _checkFirstTimeVisit() {
    bool? firstTimeVisit =
        SharedPreferencesHelper.instance.getBool('firstTimeChatScreenVisited');
    bool? isNotificationAllowed =
        SharedPreferencesHelper.instance.getBool('isNotificationAllowed');

    if ((firstTimeVisit == null && isNotificationAllowed == null) ||
        (firstTimeVisit == null && isNotificationAllowed == false)) {
      SharedPreferencesHelper.instance
          .saveBool('firstTimeChatScreenVisited', true);
      Navigator.pushNamed(
        context,
        AppRoutes.notificationPage,
      );
    }
  }

  void _initChat() async {
    getIt<MessageBloc>().add(GetMessageEvent(widget.chatRoom.id));
    if (widget.chatRoom.type == 'product') {
      getIt<GetProductBloc>()
          .add(GetProductLoadEvent(productId: widget.chatRoom.productId));
    } else if (widget.chatRoom.type == 'housing') {
      getIt<GetHousingBloc>()
          .add(FetchHousingPostEvent(housingId: widget.chatRoom.productId));
    }
    SocketService.currentChatLocation = widget.chatRoom.id;
    Initialization.socketService.readAllMessages(widget.chatRoom.id);

    var currentBadgeCount =
        await AwesomeNotifications().getGlobalBadgeCounter() -
            widget.chatRoom.unseenMessageCount;
    if (currentBadgeCount > 0) {
      AwesomeNotifications().setGlobalBadgeCounter(currentBadgeCount);
    } else {
      AwesomeNotifications().setGlobalBadgeCounter(0);
    }
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();

    bool isAllowed = prefsHelper.getBool('isNotificationAllowed') ?? false;
    isNotificationAllowed = isAllowed;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  void messageAddFunction(Message message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    SocketService.currentChatLocation = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        getIt<MessageBloc>().add(GetMessageEvent(widget.chatRoom.id));
        Initialization.socketService.readAllMessages(widget.chatRoom.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatBlocState>(
      listener: (context, state) {
        if (state is DeletedChatRoomState) {
          if (state.deletedChatRoomId == widget.chatRoom.id) {
            setState(() {
              isChatRoomDeleted = true;
            });
            widget.chatRoom.deletedFrom = widget.client.id;
            SnackbarGlobal.key.currentState!.showSnackBar(
              const SnackBar(
                content: Text('User has deleted this chat room'),
              ),
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: BlocBuilder<StatusBloc, StatusState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserProfileScreen(user: widget.client),
                          ),
                        );
                      },
                      child: Text(widget.client.name)),
                  state.online.contains(widget.client.id)
                      ? const Row(
                          children: [
                            Text(
                              'online',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                            Icon(Icons.circle, color: Colors.green, size: 16),
                          ],
                        )
                      : const Row(
                          children: [
                            Text(
                              'offline',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.normal),
                            ),
                            Icon(Icons.circle, color: Colors.red, size: 16),
                          ],
                        ),
                ],
              );
            },
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportUserPage(
                        client: widget.client,
                        productId: widget.chatRoom.productId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.report_gmailerrorred)),
            isNotificationAllowed == null || isNotificationAllowed == false
                ? IconButton(
                    onPressed: () async {
                      await LocalNotificationController.notificationRationale(
                          true);
                      if (mounted) {
                        setState(() {
                          isNotificationAllowed = true;
                        });
                      }
                    },
                    icon: const Icon(Icons.notifications_off_outlined))
                : IconButton(
                    onPressed: () async {
                      await LocalNotificationController.notificationRationale(
                          false);
                      if (mounted) {
                        setState(() {
                          isNotificationAllowed = false;
                        });
                      }
                    },
                    icon: const Icon(Icons.notifications_active_outlined)),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this chat room?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Dismiss the dialog but not the screen
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Proceed with deletion after confirmation
                            Initialization.socketService
                                .readAllMessages(widget.chatRoom.id);
                            getIt<ChatBloc>().add(DeleteChatRoomEvent(
                                chatId: widget.chatRoom.id,
                                clientId: widget.client.id));
                            Navigator.of(context).pop(); // Dismiss the dialog
                            Navigator.of(context)
                                .pop(); // Navigate back from current screen
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: BlocListener<MessageBloc, MessageBlocState>(
          listener: (context, state) {
            var chatMessages = state.chatMessages[widget.chatRoom.id] ?? [];
            if (state is LoadingMessageState ||
                state is LoadedMessageState ||
                state is ReceivedMessageState ||
                state is ReadMessageState ||
                state is SentMessageState ||
                state is SendingMessageState ||
                state is ErrorMessageState) {
              setState(() {
                messages = chatMessages;
              });
            }
          },
          child: Column(
            children: [
              widget.chatRoom.type == 'product'
                  ? BlocBuilder<GetProductBloc, GetProductState>(
                      builder: (context, state) {
                        if (state is GetProductLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is GetProductLoaded) {
                          return chatExpansionPanel(state, context, isExpanded,
                              (bool isExpanded) {
                            setState(() {
                              this.isExpanded = !isExpanded;
                            });
                          });
                        } else {
                          return const SizedBox();
                        }
                      },
                    )
                  : BlocBuilder<GetHousingBloc, GetHousingState>(
                      builder: (context, state) {
                        if (state is FetchingHousingPost) {
                          return const CircularProgressIndicator();
                        } else if (state is FetchedHousingPost) {
                          return chatExpansionPanelHousing(
                              state, context, isExpanded, (bool isExpanded) {
                            setState(() {
                              this.isExpanded = !isExpanded;
                            });
                          });
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
              Expanded(
                  child: ChatList(
                scrollController: _scrollController,
                chatRoomId: widget.chatRoom.id,
                messages: messages.reversed.toList(),
                client: widget.client,
              )),
              widget.chatRoom.deletedFrom == null
                  ? BottomChatField(
                      chatRoomId: widget.chatRoom.id,
                      scrollDownfuction: _scrollToBottom,
                      sellerId: widget.client.id,
                    )
                  : Column(
                      children: [
                        Center(
                          child: Text(
                              '${widget.client.name} leaves the chat room',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 30)
                      ],
                    ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
