import 'package:flutter/scheduler.dart';
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
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

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

    userStatusChange();
    disconnectStatus();
    joiningAllChatRoom(state.user!.chatRooms);
  }

  void receiveMessageOn() {
    try {
      socket!.on("receiveMessage", (data) {
        //TCP chanell
        Message msg = Message.fromMap(data);
        context.read<MessageBloc>().add(ReceiveMessageEvent(msg));
      });
    } catch (e) {
      print(e);
    }
  }

  void userStatusChange() {
    StatusBloc stateBloc = context.read<StatusBloc>();
    print("this is my User id${UserRepository.user.id}");
    socket!.on("connectStatus", (data) {
      print(data['userId']);
      data['userId'].forEach((userId) {
        print(
            "${"User : $userId"} join the chatRoom ${data['chatRoomId'].toString()}");
        stateBloc.add(StatusChangeEvent(userId));
      });
    });
  }

  void disconnectStatus() {
    StatusBloc stateBloc = context.read<StatusBloc>();
    socket!.on('disconnectStatus', (data) {
      print('disconnnectStatus');

      stateBloc.add(StatusDisconnectEvent(data['userId']));
    });
  }

  void createChatRoom(BuildContext context, User user) {
    socket!.on("created_chatRoom", (data) {
      print("chatRoom data is received(socket.io)");
      ChatRoom chatRoom = ChatRoom.fromMap(data);
    });
  }

  void joiningAllChatRoom(List<String> chatRoomIds) {
    for (var chatRoomId in chatRoomIds) {
      socket!.emit("joinChatRoom", chatRoomId);
    }
  }
}
