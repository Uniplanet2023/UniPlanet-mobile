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
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user.dart';

class SocketService {
  final BuildContext context;
  static socketio.Socket? socket;
  SocketService(this.context) {
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
              .setExtraHeaders({
                'x-auth-token': token,
              })
              .disableAutoConnect()
              .build());
      socket!.onConnect((_) {
        print('connect');
        var state = context.read<UserBloc>().state;
        context.read<ChatBloc>().add(LoadChatRoomEvent(state.user!.chatRooms));

        receiveMessageOn();
        receivingChatRoomData();
        userStatusChange();
        disconnectStatus();
        joiningAllChatRoom(state.user!.chatRooms);
      });
      socket!.onDisconnect((_) {
        print('disconnected');
        socket = null;
      });
      socket!.onConnectError((data) => throw Exception(data));
      socket!.connect();
    }
  }

  void setSocket(BuildContext context) {
    var state = context.read<UserBloc>().state;
    context.read<ChatBloc>().add(LoadChatRoomEvent(state.user!.chatRooms));

    receiveMessageOn();
    receivingChatRoomData();
    userStatusChange();
    disconnectStatus();
    joiningAllChatRoom(state.user!.chatRooms);
  }

  void receiveMessageOn() {
    try {
      socket!.on("receiveMessage", (data) {
        Message msg = Message.fromMap(data);

        context.read<MessageBloc>().add(ReceiveMessageEvent(msg));
      });
    } catch (e) {
      print(e);
    }
  }

  void userStatusChange() {
    StatusBloc stateBloc = context.read<StatusBloc>();
    print("this is my User id${context.read<UserBloc>().state.user!.id}");
    socket!.on("connectStatus", (data) {
      print(
          "${"User : " + data['userId']} join the chatRoom ${data['chatRoomId']}");
      print(stateBloc.state.userOnList!);
      stateBloc.add(StatusChangeEvent(data['userId']));
    });
  }

  void disconnectStatus() {
    StatusBloc stateBloc = context.read<StatusBloc>();
    socket!.on('disconnectStatus', (data) {
      stateBloc.add(StatusDisconnectEvent(data['userId']));
    });
  }

  static void receivingChatRoomData() {
    socket!.on("chatRoomData", (data) {
      print(data);
    });
  }

  void joiningAllChatRoom(List<String> chatRoomIds) {
    for (var chatRoomId in chatRoomIds) {
      socket!.emit("joinChatRoom", chatRoomId);
    }
    socket!.emit('signin');
  }
}
