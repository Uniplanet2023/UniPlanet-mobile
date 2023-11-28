import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as socketio;
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/userBloc/user_bloc.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/user.dart';

class SocketService {
  final BuildContext context;
  static socketio.Socket? socket;

  StreamController<bool> messageAddStatus = StreamController<bool>.broadcast();
  late Stream<bool> stream;

  SocketService(this.context) {
    stream = messageAddStatus.stream;
    _initSocket(context);
  }

  _initSocket(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('x-auth-token')!;

    if (token.isEmpty) {
      print('There is No token');
    } else {
      socket = socketio.io(
          uri,
          socketio.OptionBuilder()
              .enableForceNew()
              .setTransports(['websocket'])
              .setExtraHeaders({'x-auth-token': token})
              .enableAutoConnect()
              .setReconnectionAttempts(3)
              .setReconnectionDelay(300)
              .build());
      socket!.onReconnect((data) {
        print("reconnecting");
        print(data);
      });
      socket!.onReconnect((_) {
        print('onReconecting');
      });
      socket!.onConnect((_) {
        print('connect');
        setSocket(context);
      });
      socket!.onDisconnect((_) async {
        print('disconnected');
      });
      socket!.onConnectError((data) async {
        throw Exception(data);
      });
      socket!.connect();
    }
  }

  void setSocket(BuildContext context) {
    var state = context.read<UserBloc>().state;

    receiveMessageOn();
    createChatRoom(context, state.user!);
    emptyUnSeenMessageOn();
    userStatusChange();
    disconnectStatus();
    joiningAllChatRoom(state.user!.myChatRoom);
  }

  void emptyUnSeenMessageOn() {
    try {
      socket?.off("seenMessageFIN");
      socket!.on("seenMessageFIN", (data) {
        print('empty emptyUnseenMessage');
        print(data);
        context.read<MessageBloc>().add(const ReadMessageEvent());
        context.read<ChatBloc>().add(EmptyUnseenMessageEvent(data));
      });
    } catch (e) {
      print(e);
    }
  }

  void receiveMessageOn() {
    try {
      socket?.off("receiveMessage");
      socket!.on("receiveMessage", (data) {
        //TCP chanell
        Message msg = Message.fromMap(data);
        messageAddStatus.sink.add(true);
        context.read<MessageBloc>().add(ReceiveMessageEvent(msg));
      });
    } catch (e) {
      print(e);
    }
  }

  void userStatusChange() {
    StatusBloc stateBloc = context.read<StatusBloc>();
    socket?.off("connectStatus");
    // print("this is my User id${UserRepository.user.id}");
    socket!.on("connectStatus", (data) {
      // print(data['userId']);
      data['userId'].forEach((userId) {
        // print(
        //     "${"User : $userId"} join the chatRoom ${data['chatRoomId'].toString()}");
        stateBloc.add(StatusChangeEvent(userId));
      });
    });
  }

  void disconnectStatus() {
    StatusBloc stateBloc = context.read<StatusBloc>();
    socket?.off("disconnectStatus");
    socket!.on('disconnectStatus', (data) {
      print('disconnnectStatus');

      stateBloc.add(StatusDisconnectEvent(data['userId']));
    });
  }

  void createChatRoom(BuildContext context, User user) {
    socket?.off("created_chatRoom");
    socket!.on("created_chatRoom", (data) {
      print("chatRoom data is received(socket.io)");
      ChatRoom chatRoom = ChatRoom.fromMap(data);
    });
  }

  void joiningAllChatRoom(List<MyChatRoom> myChatRooms) {
    for (var myChatRoom in myChatRooms) {
      socket!.emit("joinChatRoom", myChatRoom.chatRoom.chatRoomId);
    }
  }
}
