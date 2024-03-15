import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/status/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/typing/typing_bloc.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';

class SocketService {
  late String userId;
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;
  late final IO.Socket socket;
  SocketService._internal() {
    userId = AccountRepository.user!.id;
    socket = IO.io(
        messageURI,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(1000)
            .setQuery({"userId": userId})
            .build());
  }

  void connect(BuildContext context) {
    socket.onConnect((_) {
      print('Connected');
      socket.on('online user', (userId) {
        context.read<StatusBloc>().add(StatusChangeEvent(userId: userId));
      });
      socket.on('offline user', (userId) {
        context.read<StatusBloc>().add(StatusDisconnectEvent(userId: userId));
      });
    });
    socket.onDisconnect((data) => print('Disconnected $data'));
    socket.onConnectError((data) => print('ConnectError $data'));
    socket.onConnectTimeout((data) => print('ConnectTimeout $data'));
    socket.onReconnect((data) => print('Reconnect $data'));
    socket.onReconnectAttempt((data) => print('ReconnectAttempt $data'));
    socket.onReconnecting((data) => print('Reconnecting $data'));
    //TODO: add the token to the header

    socket.emit("setup");
    socket.connect();
  }

  void onConnectChat(BuildContext context, String chatId) {
    socket.on('typing', (status) {
      context.read<TypingBloc>().add(const TypingStartEvent());
    });
    socket.on('stop typing', (status) {
      print('stop typing');
      context.read<TypingBloc>().add(const TypingStopEvent());
    });
    socket.on('message received', (newMessageReceived) {
      print(newMessageReceived);
      sendStopTypingEvent(chatId);
      Message receivedMessage = Message.fromMap(newMessageReceived);
      context.read<MessageBloc>().add(ReceiveMessageEvent(receivedMessage));
    });
  }

  void sendTypingEvent(String status) {
    socket.emit('typing', status);
  }

  void sendStopTypingEvent(String status) {
    socket.emit('stop typing', status);
  }

  void joinChat(chatId) {
    socket.emit('join chat', chatId);
  }

  Message sendMessage(
      String content, String chatId, String messageType, String receiver) {
    Message message = Message(
      sender: userId,
      message: content,
      messageType: messageType,
      chat: chatId,
      receiver: receiver,
      createdAt: DateTime.now().toUtc(),
    );
    socket.emit('new message', message);
    // sendStopTypingEvent(chatId);
    // messageStoreCallback(message);
    return message;
  }

  // void setSocket(BuildContext context) {
  //   // var state = context.read<UserBloc>().state;

  //   // receiveMessageOn();
  //   // createChatRoom(context, state.user!);
  //   // emptyUnSeenMessageOn();
  //   // userStatusChange();
  //   // disconnectStatus();
  //   // joiningAllChatRoom(state.user!.myChatRoom);
  // }

  // void emptyUnSeenMessageOn() {
  //   try {
  //     socket?.off("seenMessageFIN");
  //     socket!.on("seenMessageFIN", (data) {
  //       // context.read<MessageBloc>().add(const ReadMessageEvent());
  //       // context.read<ChatBloc>().add(EmptyUnseenMessageEvent(data));
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void receiveMessageOn() {
  //   try {
  //     socket?.off("receiveMessage");
  //     socket!.on("receiveMessage", (data) {
  //       //TCP chanell
  //       Message msg = Message.fromJson(data);
  //       messageAddStatus.sink.add(true);
  //       // context.read<MessageBloc>().add(ReceiveMessageEvent(msg));
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // void userStatusChange() {
  //   // StatusBloc stateBloc = context.read<StatusBloc>();
  //   socket?.off("connectStatus");
  //   // print("this is my User id${UserRepository.user.id}");
  //   socket!.on("connectStatus", (data) {
  //     // print(data['userId']);
  //     data['userId'].forEach((userId) {
  //       // print(
  //       //     "${"User : $userId"} join the chatRoom ${data['chatRoomId'].toString()}");
  //       // stateBloc.add(StatusChangeEvent(userId));
  //     });
  //   });
  // }

  // void disconnectStatus() {
  //   // StatusBloc stateBloc = context.read<StatusBloc>();
  //   socket?.off("disconnectStatus");
  //   socket!.on('disconnectStatus', (data) {
  //     print('disconnnectStatus');

  //     // stateBloc.add(StatusDisconnectEvent(data['userId']));
  //   });
  // }

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
