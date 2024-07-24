import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/network/storage/image_upload_service.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';
import 'package:uniplanet/config/enums/message_enum.dart';
import 'package:uniplanet/config/enums/message_status_enum.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';

import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/typing/typing_bloc.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/image_message.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';

class SocketService {
  String userId;
  static List<ImageMessage> imageMessagesToRetry = [];
  static List<Message> messagesToRetry = [];
  late final io.Socket socket;
  static String? currentChatLocation;

  SocketService(this.userId) {
    socket = io.io(
        messageURI,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setReconnectionAttempts(100)
            .setReconnectionDelay(100)
            .setQuery({"userId": userId})
            .build());
  }

  Timer? _typingTimer; // Added to keep track of the typing event timer

  void connect() {
    socket.onConnect((_) async {
      socket.clearListeners();
      removeListeners();

      socket.on('chat room created', (data) async {
        log('chat room created');
        var chat = jsonDecode(data[0]);
        bool isUserOnline = await joinChatAndCheckUserExist(
            chatId: chat['id'], targetUserId: chat['seller']['id']);
        bool existingChat = data[1];

        if (chat['seller']['id'] == userId && !existingChat) {
          // Perform a deep copy of chat
          var chatFormat = jsonDecode(jsonEncode(chat));
          chatFormat['seller'] = jsonEncode(chat['seller']);
          chatFormat['buyer'] = jsonEncode(chat['buyer']);
          ChatRoom chatRoom = ChatRoom.fromMap(chatFormat);
          getIt<ChatBloc>().add(AddChatRoomEvent(chatRoom));
        }

        if (isUserOnline) {
          getIt<StatusBloc>().add(ConnectedEvent(userId: chat['seller']['id']));
        }
      });
      socket.on('chat room deleted', (data) {
        var chat = data['chatRoom'];
        var clientId =
            data['clientId']; // Ensure you have this data passed correctly
        getIt<ChatBloc>()
            .add(DeletedChatByClient(chatId: chat, clientId: clientId));
      });
      socket.on('online user', (userId) {
        getIt<StatusBloc>().add(ConnectedEvent(userId: userId));
      });

      socket.on('offline user', (userId) {
        getIt<StatusBloc>().add(DisconnectEvent(userId: userId));
      });

      socket.on('typing', (data) {
        String chatId = data[0];
        String senderId = data[1];
        if (senderId != userId) {
          getIt<TypingBloc>().add(TypingStartEvent(chatId: chatId));
        }
      });
      socket.on('stop typing', (chatId) {
        getIt<TypingBloc>().add(TypingStopEvent(chatId: chatId));
      });
      socket.on('message received', (data) {
        Message receivedMessage =
            Message.fromMap(jsonDecode(data['messageJson']));
        User sender = User.fromMap(jsonDecode(data['senderJson']));
        receivedMessage.status = MessageStatusEnum.received.value;

        if (receivedMessage.sender != userId) {
          getIt<MessageBloc>().add(ReceiveMessageEvent(receivedMessage));
        }

        getIt<ChatBloc>().add(UpdateChatRoomLastMessageEvent(receivedMessage));
        // When the message is received, check if it's the current chat room
        // If it is, read the message
        if (currentChatLocation == receivedMessage.chat &&
            receivedMessage.receiver == userId) {
          readAllMessages(currentChatLocation!);
          // If the message is not the current chat room, update the unseen message count
        } else if (receivedMessage.receiver == userId) {
          LocalNotificationController.showNotification(
              title: sender.name,
              body: receivedMessage.message,
              bigPicture: sender.profileImage,
              notificationLayout: NotificationLayout.MessagingGroup);
          getIt<ChatBloc>()
              .add(UpdateUnseenMessageEvent(chatId: receivedMessage.chat));
        }
      });
      socket.on('read all message', (data) {
        DateTime seenTime = DateTime.parse(data['readMessageTime']);
        String chatId = data['chatId'];
        // Message msg;
        // if MessageBloc state is receivedMessage, then readAllmessage triggered

        getIt<MessageBloc>().add(ReadAllMessages(chatId, seenTime));
        if (data['sender'] == userId) {
          getIt<ChatBloc>().add(EmptyUnseenMessageEvent(chatId: chatId));
        }
      });
      if (imageMessagesToRetry.isNotEmpty) {
        // resendUnacknowledgedImageMessages();
      }
      if (messagesToRetry.isNotEmpty) {
        // resendUnacknowledgedMessages();
      }
    });
    socket.onDisconnect((data) => log('Disconnected $data'));
    socket.onConnectError((data) => log('ConnectError $data'));
    socket.onConnectTimeout((data) => log('ConnectTimeout $data'));
    socket.onReconnect((data) => log('Reconnect $data'));
    socket.onReconnectAttempt((data) => log('ReconnectAttempt $data'));
    socket.onReconnecting((data) => log('Reconnecting $data'));

    socket.connect();
  }

  void removeListeners() {
    socket.off('chat room created');
    socket.off('chat room deleted');
    socket.off('online user');
    socket.off('offline user');
    socket.off('typing');
    socket.off('stop typing');
    socket.off('message received');
    socket.off('read all message');
    // Add other events here
  }

  void resendUnacknowledgedImageMessages() async {
    List<Message> imageMessagesToRetried = [];
    // List<ImageMessage> test = imageMessagesToRetry;
    for (var imageMessage in imageMessagesToRetry) {
      Message sentMessage = imageMessage.message;
      try {
        File imageFile = File(imageMessage.filePath);
        if (!imageFile.existsSync()) {
          return;
        }
        String? secureUrl = await ImageUploadService()
            .uploadImage(imageFile, 'chat-images/${sentMessage.chat}')
            .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Image uploading timed out');
          },
        );

        sentMessage = await sendMessage(
          id: imageMessage.message.id,
          message: secureUrl,
          chatId: imageMessage.message.chat,
          messageType: MessageEnum.image.value,
          receiver: imageMessage.message.receiver,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Message sending timed out');
          },
        );
        imageMessagesToRetried.add(sentMessage);
      } catch (e) {
        // Handle the error
        log("can't upload image");
        imageMessagesToRetried.add(sentMessage);
      }
    }

    getIt<MessageBloc>().add(RetrySendMessagesEvent(imageMessagesToRetried));
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
    getIt<MessageBloc>().add(RetrySendMessagesEvent(messagesToRetried));
    // Clear the list once done
    messagesToRetry.clear();
  }

  // message not sent, check instant reading message
  void sendTypingEvent(String chatId) {
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel(); // Cancel the existing timer if it's active
    }
    socket.emit('typing', chatId);

    // Set a new timer
    _typingTimer = Timer(const Duration(seconds: 1), () {
      sendStopTypingEvent(chatId);
    });
  }

  void sendStopTypingEvent(String chatId) {
    socket.emit('stop typing', chatId);
  }

  void sendDeleteChatRoomEvent(String chatId, String clientId) {
    // Emitting the event with acknowledgement
    socket.emitWithAck(
        'chat room deleted', {'chatRoom': chatId, 'clientId': clientId},
        ack: (data) {
      log('Chat room deleted: $data'); // Use print in Dart for logging
    });
  }

  void notificationEnableEvent() {
    socket.emit("setup", NotificationController().firebaseToken);
  }

  void notificationDisableEvent() {
    socket.emit("disable notification");
  }

  Future<bool> chatRoomCreateAndCheckUserExist(
      {required ChatRoom chat, required bool existingChat}) async {
    final Completer<bool> completer = Completer();
    final chatData = chat.toJson();
    socket.emitWithAck("chat room created", [chatData, existingChat],
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

  Future<Message> sendMessage({
    required String id,
    required String message,
    required String chatId,
    required String messageType,
    required String receiver,
  }) async {
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
    User sender = getIt<AccountBloc>().state.account.user;
    sendStopTypingEvent(chatId);

    // Convert Message and User to JSON strings
    String messageJson = jsonEncode(msg.toMap());
    String senderJson = jsonEncode(sender.toMap());

    socket.emitWithAck(
      'new message',
      {"messageJson": messageJson, "senderJson": senderJson},
      ack: (data) {
        msg.status = MessageStatusEnum.received.value;
        completer.complete(msg);
      },
    );

    return completer.future;
  }

  Future<Message> retrySendMessage({
    required String id,
    required String content,
    required String chatId,
    required String messageType,
    required String receiver,
  }) async {
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
    User sender = getIt<AccountBloc>().state.account.user;
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
    log('disconnect');
    if (_typingTimer?.isActive ?? false) {
      _typingTimer?.cancel(); // Ensure to cancel the timer on disconnect
    }
    socket.disconnect();
    socket.close();
    getIt<StatusBloc>().add(DisconnectEvent(userId: userId));
  }
}
