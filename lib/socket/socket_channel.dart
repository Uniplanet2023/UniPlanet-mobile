import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uniplanet_mobile/bloc/status/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/typing/typing_bloc.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;
  late final IO.Socket socket;
  SocketService._internal() {
    socket = IO.io(
        messageURI,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionAttempts(3)
            .setReconnectionDelay(300)
            .setQuery({"session_token": DioClient.instance.session})
            .build());
  }

  void connect(BuildContext context) {
    socket.onConnect((_) {
      print('Connected');
      socket.on('online-user', (userId) {
        context.read<StatusBloc>().add(StatusChangeEvent(userId: userId));
      });
      socket.on('offline-user', (userId) {
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
    if (AccountRepository.user == null) {
      throw Exception("User is not logged in");
    }
    socket.emit("setup", AccountRepository.user!.id);
    socket.connect();
  }

  void onConnectChat(BuildContext context, String chatId,
      Function(Message) messageStoreCallback) {
    socket.on('typing', (status) {
      context.read<TypingBloc>().add(const TypingStartEvent());
    });
    socket.on('stop typing', (status) {
      context.read<TypingBloc>().add(const TypingStopEvent());
    });
    socket.on('message received', (newMessageReceived) {
      sendStopTypingEvent(chatId);
      Message receivedMessage = Message.fromJson(newMessageReceived);
      if (receivedMessage.sender != AccountRepository.user!.id) {
        messageStoreCallback(receivedMessage);
      }
      // context.read<StatusBloc>().add(StatusChangeEvent(userId: newMessageReceived));
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

  void sendMessage(String content, String chatId, String messageType,
      String receiver, Function(Message) messageStoreCallback) {
    Message message = Message(
      sender: AccountRepository.user!.id,
      message: content,
      messageType: messageType,
      chat: chatId,
      receiver: receiver,
    );
    socket.emit('new message', message);
    sendTypingEvent(chatId);
    messageStoreCallback(message);
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
