import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/messageBloc/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/statusBloc/status_bloc.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';
import 'package:uniplanet_mobile/repository/auth_repository/auth_repo.dart';

class SocketService {
  static IO.Socket? socket;

  StreamController<bool> messageAddStatus = StreamController<bool>.broadcast();
  late Stream<bool> stream;

  SocketService() {
    stream = messageAddStatus.stream;
  }
  void connect() {
    socket = IO.io(
        messageURI,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionAttempts(3)
            .setReconnectionDelay(300)
            .build());
    socket!.onConnect((data) => print('Connected $data'));
    socket!.onDisconnect((data) => print('Disconnected $data'));
    socket!.onConnectError((data) => print('ConnectError $data'));
    socket!.onConnectTimeout((data) => print('ConnectTimeout $data'));
    socket!.onReconnect((data) => print('Reconnect $data'));
    socket!.onReconnectAttempt((data) => print('ReconnectAttempt $data'));
    socket!.onReconnecting((data) => print('Reconnecting $data'));
    //TODO: add the token to the header
    socket!.emit("setup", AccountRepository.user.id);
    socket!.connect();
  }

  void setSocket(BuildContext context) {
    // var state = context.read<UserBloc>().state;

    // receiveMessageOn();
    // createChatRoom(context, state.user!);
    // emptyUnSeenMessageOn();
    // userStatusChange();
    // disconnectStatus();
    // joiningAllChatRoom(state.user!.myChatRoom);
  }

  void emptyUnSeenMessageOn() {
    try {
      socket?.off("seenMessageFIN");
      socket!.on("seenMessageFIN", (data) {
        // context.read<MessageBloc>().add(const ReadMessageEvent());
        // context.read<ChatBloc>().add(EmptyUnseenMessageEvent(data));
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
        // context.read<MessageBloc>().add(ReceiveMessageEvent(msg));
      });
    } catch (e) {
      print(e);
    }
  }

  void userStatusChange() {
    // StatusBloc stateBloc = context.read<StatusBloc>();
    socket?.off("connectStatus");
    // print("this is my User id${UserRepository.user.id}");
    socket!.on("connectStatus", (data) {
      // print(data['userId']);
      data['userId'].forEach((userId) {
        // print(
        //     "${"User : $userId"} join the chatRoom ${data['chatRoomId'].toString()}");
        // stateBloc.add(StatusChangeEvent(userId));
      });
    });
  }

  void disconnectStatus() {
    // StatusBloc stateBloc = context.read<StatusBloc>();
    socket?.off("disconnectStatus");
    socket!.on('disconnectStatus', (data) {
      print('disconnnectStatus');

      // stateBloc.add(StatusDisconnectEvent(data['userId']));
    });
  }

  // void createChatRoom(BuildContext context, User user) {
  //   socket?.off("created_chatRoom");
  //   socket!.on("created_chatRoom", (data) {
  //     print("chatRoom data is received(socket.io)");
  //     ChatRoom chatRoom = ChatRoom.fromMap(data);
  //   });
  // }

  // void joiningAllChatRoom(List<MyChatRoom> myChatRooms) {
  //   for (var myChatRoom in myChatRooms) {
  //     socket!.emit("joinChatRoom", myChatRoom.chatRoom.chatRoomId);
  //   }
  // }
}
