import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uniket/bloc/index.dart';
import 'package:uniket/common/enums/message_enum.dart';
import 'package:uniket/common/enums/message_status_enum.dart';
import 'package:uniket/constants/utils.dart';
import 'package:uniket/global.dart';
import 'package:uniket/models/chat_room.dart';
import 'package:uniket/models/image_message.dart';
import 'package:uniket/models/message.dart';
import 'package:uniket/models/user_model.dart';
import 'package:uniket/network/api_def/api_server_address.dart';
import 'package:uniket/network/notification/firebase_api.dart';
import 'package:uniket/network/notification/notification_handler/notification_service.dart';

class SocketService {
  String userId;
  static List<ImageMessage> imageMessagesToRetry = [];
  static List<Message> messagesToRetry = [];
  late final IO.Socket socket;
  static String? currentChatLocation;

  SocketService(this.userId) {
    socket = IO.io(
        messageURI,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionAttempts(1000)
            .setReconnectionDelay(100)
            .setQuery({"userId": userId})
            .build());
  }

  Timer? _typingTimer; // Added to keep track of the typing event timer

  // SocketService._internal() {

  // }
  void connect() {
    BuildContext context = SnackbarGlobal.key.currentContext!;
    socket.onConnect((_) {
      if (imageMessagesToRetry.isNotEmpty) {
        resendUnacknowledgedImageMessages();
      }
      if (messagesToRetry.isNotEmpty) {
        resendUnacknowledgedMessages();
      }
      socket.on('chat room created', (data) async {
        print('chat room created');
        var chat = jsonDecode(data);
        bool isUserOnline = await joinChatAndCheckUserExist(
            chatId: chat['id'], targetUserId: chat['seller']['id']);
        if (chat['seller']['id'] == userId) {
          await NotificationService.showNotification(
            title: chat['seller']['name'],
            body: '${chat['seller']['name']} has started a conversation',
            payload: {
              "navigate": "true",
            },
          );
        }
        ChatRoom chatRoom = ChatRoom.fromMap(chat);
        if (context.mounted) {
          context.read<ChatBloc>().add(AddChatRoomEvent(chatRoom));
        }
        if (isUserOnline) {
          if (context.mounted) {
            context
                .read<StatusBloc>()
                .add(ConnectedEvent(userId: chat['seller']['id']));
          }
        }
      });
      socket.on('chat room deleted', (data) {
        print('chat room deleted');
        var chat = jsonDecode(data);
        context.read<ChatBloc>().add(DeleteChatRoomEvent(chatId: chat['id']));
      });
      socket.on('online user', (userId) {
        if (context.mounted) {
          context.read<StatusBloc>().add(ConnectedEvent(userId: userId));
        }
      });

      socket.on('offline user', (userId) {
        if (context.mounted) {
          context.read<StatusBloc>().add(DisconnectEvent(userId: userId));
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
        receivedMessage.status = MessageStatusEnum.received.value;
        if (context.mounted) {
          if (receivedMessage.sender != userId) {
            context
                .read<MessageBloc>()
                .add(ReceiveMessageEvent(receivedMessage));
          }

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
        // Message msg;
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
      } else if (context.read<AuthBloc>().state is Authorized) {
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

  void resendUnacknowledgedImageMessages() async {
    List<Message> imageMessagesToRetried = [];
    // List<ImageMessage> test = imageMessagesToRetry;
    for (var imageMessage in imageMessagesToRetry) {
      Message sentMessage = imageMessage.message;
      try {
        CloudinaryResponse response = await Global.cloudinary
            .uploadFile(
          CloudinaryFile.fromFile(imageMessage.filePath,
              resourceType: CloudinaryResourceType.Image,
              folder: 'chat-images/${imageMessage.message.chat}'),
        )
            .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Image uploading timed out');
          },
        );

        if (response.secureUrl.isEmpty) return;

        sentMessage = await sendMessage(
          id: imageMessage.message.id,
          message: response.secureUrl,
          chatId: imageMessage.message.chat,
          messageType: MessageEnum.image.value,
          receiver: imageMessage.message.receiver,
          context: SnackbarGlobal.key.currentContext!,
        ).timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeoutException('Message sending timed out');
          },
        );
        imageMessagesToRetried.add(sentMessage);
      } catch (e) {
        // Handle the error
        print("can't upload image");
        imageMessagesToRetried.add(sentMessage);
      }
    }

    SnackbarGlobal.key.currentContext!
        .read<MessageBloc>()
        .add(RetrySendMessagesEvent(imageMessagesToRetried));
    imageMessagesToRetry.clear();
  }

  // Resend messages that were not acknowledged
  void resendUnacknowledgedMessages() async {
    // Here, iterate over the messages to retry and call sendMessage for each
    List<Message> messagesToRetried = [];
    for (var message in messagesToRetry) {
      // Modify sendMessage to accept a Message object directly, or extract necessary fields
      Message msg = message;
      msg.status = MessageStatusEnum.error.value;
      try {
        msg = await retrySendMessage(
          id: message.id,
          content: message.message,
          chatId: message.chat,
          messageType: message.messageType,
          receiver: message.receiver,
          context: SnackbarGlobal.key.currentContext!,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            return Message(
              id: message.id,
              sender: message.sender,
              message: message.message,
              messageType: message.messageType,
              chat: message.chat,
              status: MessageStatusEnum.error.value,
              receiver: message.receiver,
              createdAt: message.createdAt,
            );
          },
        );
        messagesToRetried.add(msg);
      } catch (e) {
        messagesToRetried.add(msg);
      }
    }
    SnackbarGlobal.key.currentContext!
        .read<MessageBloc>()
        .add(RetrySendMessagesEvent(messagesToRetried));
    // Clear the list once done
    messagesToRetry.clear();
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

  void sendDeleteChatRoomEvent(String chatId) {
    socket.emitWithAck('delete chat room', chatId, ack: (data) {
      print('chat room deleted');
    });
  }

  Future<bool> chatRoomCreateAndCheckUserExist({required ChatRoom chat}) async {
    final Completer<bool> completer = Completer();

    socket.emitWithAck("chat room created", chat, ack: (data) {
      bool userExist = data;
      if (userExist) {
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    });

    return completer
        .future; // This will return a Future<bool> that completes when the callback is called
  }

  Future<bool> joinChatAndCheckUserExist({
    required String chatId,
    required String targetUserId,
  }) async {
    final Completer<bool> completer = Completer();

    socket.emitWithAck(
        "join chat", {"chatRoomId": chatId, "targetUser": targetUserId},
        ack: (data) {
      bool userExist = data;
      if (userExist) {
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    });

    return completer
        .future; // This will return a Future<bool> that completes when the callback is called
  }

  Future<Message> sendMessage(
      {required String id,
      required String message,
      required String chatId,
      required String messageType,
      required String receiver,
      required BuildContext context}) async {
    // Create a Completer
    final Completer<Message> completer = Completer<Message>();

    Message msg = Message(
      id: id,
      sender: userId,
      message: message,
      messageType: messageType,
      chat: chatId,
      status: MessageStatusEnum.sending.value,
      receiver: receiver,
      createdAt: DateTime.now().toUtc(),
    );
    User sender = context.read<AccountBloc>().state.account.user;
    sendStopTypingEvent(chatId, context);
    socket.emitWithAck(
        'new message', {"messageJson": msg, "senderJson": sender}, ack: (data) {
      msg.status = MessageStatusEnum.received.value;
      return completer.complete(msg);
    });

    return completer.future;
  }

  Future<Message> retrySendMessage(
      {required String id,
      required String content,
      required String chatId,
      required String messageType,
      required String receiver,
      required BuildContext context}) async {
    // Create a Completer
    final Completer<Message> completer = Completer<Message>();

    Message message = Message(
      id: id,
      sender: userId,
      message: content,
      messageType: messageType,
      chat: chatId,
      status: MessageStatusEnum.sending.value,
      receiver: receiver,
      createdAt: DateTime.now().toUtc(),
    );
    User sender = context.read<AccountBloc>().state.account.user;
    socket.emitWithAck(
        'new message', {"messageJson": message, "senderJson": sender},
        ack: (data) {
      message.status = MessageStatusEnum.received.value;
      return completer.complete(message);
    });
    // Set a timeout for the acknowledgment

    return completer.future;
  }

  void readAllMessages(String chatId) {
    socket.emit('read all message', chatId);
  }

  void readMessage(Message msg) {
    socket.emit('read message', msg);
  }

  void disconnect() {
    print('disconnect');
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel(); // Ensure to cancel the timer on disconnect
    }
    socket.disconnect();

    if (SnackbarGlobal.key.currentContext != null) {
      SnackbarGlobal.key.currentContext!
          .read<StatusBloc>()
          .add(DisconnectEvent(userId: userId));
    }
  }
}
