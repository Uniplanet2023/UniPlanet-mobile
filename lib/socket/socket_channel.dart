import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/status/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/typing/typing_bloc.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/network/api_server_address.dart';
import 'package:uniplanet_mobile/network/dio_client.dart';
import 'package:uniplanet_mobile/repository/account_repository/account_repo.dart';
import 'package:uniplanet_mobile/repository/auth_repository/auth_repo.dart';

class SocketService {
  late String userId;
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;
  late final IO.Socket socket;

  Timer? _typingTimer; // Added to keep track of the typing event timer

  SocketService._internal() {
    userId = AuthRepository.userId!;
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

  void connect(BuildContext context, String chatRooms) {
    socket.onConnect((_) {
      print('Connected');
      socket.on('online user', (userId) {
        context.read<StatusBloc>().add(StatusChangeEvent(userId: userId));
      });

      socket.on('offline user', (userId) {
        context.read<StatusBloc>().add(StatusDisconnectEvent(userId: userId));
      });

      socket.on('typing', (chatId) {
        context.read<TypingBloc>().add(TypingStartEvent(chatId: chatId));
      });
      socket.on('stop typing', (chatId) {
        print('stop typing');
        context.read<TypingBloc>().add(TypingStopEvent(chatId: chatId));
      });
      socket.on('message received', (newMessageReceived) {
        var msg = jsonDecode(newMessageReceived);
        Message receivedMessage = Message.fromMap(msg);
        context.read<MessageBloc>().add(ReceiveMessageEvent(receivedMessage));
        context
            .read<ChatBloc>()
            .add(UpdateChatRoomLastMessageEvent(receivedMessage));
      });
    });
    socket.onDisconnect((data) => print('Disconnected $data'));
    socket.onConnectError((data) => print('ConnectError $data'));
    socket.onConnectTimeout((data) => print('ConnectTimeout $data'));
    socket.onReconnect((data) => print('Reconnect $data'));
    socket.onReconnectAttempt((data) => print('ReconnectAttempt $data'));
    socket.onReconnecting((data) => print('Reconnecting $data'));

    socket.emitWithAck("setup", chatRooms, ack: (data) {
      if (data[1]) {
        context.read<StatusBloc>().add(StatusChangeEvent(userId: data[0]));
      }
    });

    socket.connect();
  }

  void sendTypingEvent(String chatId, BuildContext context) {
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel(); // Cancel the existing timer if it's active
    }
    socket.emit('typing', chatId);
    context.read<TypingBloc>().add(TypingStartEvent(chatId: chatId));

    // Set a new timer
    _typingTimer = Timer(const Duration(seconds: 1), () {
      sendStopTypingEvent(chatId, context);
    });
  }

  void sendStopTypingEvent(String chatId, BuildContext context) {
    socket.emit('stop typing', chatId);
    context.read<TypingBloc>().add(TypingStopEvent(chatId: chatId));
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

  void disconnect() {
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel(); // Ensure to cancel the timer on disconnect
    }
    socket.disconnect();
    // StatusBloc stateBloc = context.read<StatusBloc>();
    // socket.off("disconnect");
    // socket.on('disconnect', (data) {
    //   print('disconnnect');

    //   // stateBloc.add(StatusDisconnectEvent(data['userId']));
    // });
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
