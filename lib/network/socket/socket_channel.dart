import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uniplanet_mobile/bloc/account/account_bloc.dart';
import 'package:uniplanet_mobile/bloc/chat/chat_bloc.dart';
import 'package:uniplanet_mobile/bloc/message/message_bloc.dart';
import 'package:uniplanet_mobile/bloc/status/status_bloc.dart';
import 'package:uniplanet_mobile/bloc/typing/typing_bloc.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
import 'package:uniplanet_mobile/network/api_def/api_server_address.dart';
import 'package:uniplanet_mobile/network/notification/firebase_api.dart';
import 'package:uniplanet_mobile/network/repository/auth_repository/auth_repo.dart';

class SocketService {
  late String userId;
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;

  late final IO.Socket socket;
  static String? currentChatLocation;
  Timer? _typingTimer; // Added to keep track of the typing event timer

  SocketService._internal() {
    userId = AuthRepository.userId!;
    socket = IO.io(
        messageURI,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionAttempts(100)
            .setReconnectionDelay(1000)
            .setQuery({"userId": userId, "school": AuthRepository.school!})
            .build());
  }
  void connect(BuildContext context) {
    socket.onConnect((_) {
      print('Connected');
      socket.on('online user', (userId) {
        if (context.mounted) {
          context.read<StatusBloc>().add(StatusChangeEvent(userId: userId));
        }
      });

      socket.on('offline user', (userId) {
        if (context.mounted) {
          context.read<StatusBloc>().add(StatusDisconnectEvent(userId: userId));
        }
      });

      socket.on('typing', (chatId) {
        if (context.mounted) {
          context.read<TypingBloc>().add(TypingStartEvent(chatId: chatId));
        }
      });
      socket.on('stop typing', (chatId) {
        if (context.mounted) {
          context.read<TypingBloc>().add(TypingStopEvent(chatId: chatId));
        }
      });
      socket.on('message received', (newMessageReceived) {
        var msg = jsonDecode(newMessageReceived);
        Message receivedMessage = Message.fromMap(msg);
        receivedMessage.status = 'sent';
        if (context.mounted) {
          context.read<MessageBloc>().add(ReceiveMessageEvent(receivedMessage));
          context
              .read<ChatBloc>()
              .add(UpdateChatRoomLastMessageEvent(receivedMessage));
          //TODO: Decoupling? if ReadAllMessages is triggered first, and ReceiveMessageEvent is triggered after, then the message will not be marked as read
          if (currentChatLocation == receivedMessage.chat &&
              receivedMessage.receiver == userId) {
            readAllMessages(currentChatLocation!);
          } else if (receivedMessage.receiver == userId) {
            context
                .read<ChatBloc>()
                .add(UpdateUnseenMessageEvent(chatId: receivedMessage.chat));
          }
        }
      });
      socket.on('read all message', (data) {
        DateTime seenTime = DateTime.parse(data['readMessageTime']);
        String chatId = data['chatId'];
        Message msg;
        // if MessageBloc state is receivedMessage, then readAllmessage triggered
        if (context.mounted) {
          context.read<MessageBloc>().add(ReadAllMessages(chatId, seenTime));
          if (data['sender'] == userId) {
            context
                .read<ChatBloc>()
                .add(EmptyUnseenMessageEvent(chatId: chatId));
          }
        }
      });
      print('FirebaseToken: ${FirebaseApi.firebaseToken}');
      if (FirebaseApi.firebaseToken == null) {
        print('FirebaseToken is null');
      } else {
        socket.emit("setup", FirebaseApi.firebaseToken);
      }
    });
    socket.onDisconnect((data) => print('Disconnected $data'));
    socket.onConnectError((data) => print('ConnectError $data'));
    socket.onConnectTimeout((data) => print('ConnectTimeout $data'));
    socket.onReconnect((data) => print('Reconnect $data'));
    socket.onReconnectAttempt((data) => print('ReconnectAttempt $data'));
    socket.onReconnecting((data) => print('Reconnecting $data'));

    socket.connect();
  }

  //TODO: message not sent, check instant reading message
  void sendTypingEvent(String chatId, BuildContext context) {
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel(); // Cancel the existing timer if it's active
    }
    socket.emit('typing', chatId);
    if (context.mounted) {
      context.read<TypingBloc>().add(TypingStartEvent(chatId: chatId));
    }

    // Set a new timer
    _typingTimer = Timer(const Duration(seconds: 1), () {
      sendStopTypingEvent(chatId, context);
    });
  }

  void sendStopTypingEvent(String chatId, BuildContext context) {
    socket.emit('stop typing', chatId);
    if (context.mounted) {
      context.read<TypingBloc>().add(TypingStopEvent(chatId: chatId));
    }
  }

  Future<bool> joinChatAndCheckUserExist({
    required String chatId,
    required String targetUserId,
  }) async {
    final Completer<bool> completer = Completer();

    socket.emitWithAck(
        "join chat", {"room": chatId, "targetUser": targetUserId}, ack: (data) {
      if (data != null && data.length > 1 && data[1] == true) {
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    });

    return completer
        .future; // This will return a Future<bool> that completes when the callback is called
  }

  Message sendMessage(String content, String chatId, String messageType,
      String receiver, BuildContext context) {
    Message message = Message(
      sender: userId,
      message: content,
      messageType: messageType,
      chat: chatId,
      status: 'pending',
      receiver: receiver,
      createdAt: DateTime.now().toUtc(),
    );
    User sender = context.read<AccountBloc>().state.account.user;

    socket.emitWithAck(
        'new message', {"messageJson": message, "senderJson": sender},
        ack: (data) {
      print(data);
      //TODO: make message status to sent
    });
    sendStopTypingEvent(chatId, context);
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

  void readAllMessages(String chatId) {
    socket.emit('read all message', chatId);
  }

  void readMessage(Message msg) {
    socket.emit('read message', msg);
  }

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
