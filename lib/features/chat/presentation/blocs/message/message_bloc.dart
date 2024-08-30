import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniplanet/core/local_stoarage/local_stoarage.dart';
import 'package:uniplanet/core/network/storage/image_upload_service.dart';
import 'package:uniplanet/config/enums/message_enum.dart';
import 'package:uniplanet/config/enums/message_status_enum.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/models/image_message.dart';
// Models
import 'package:uniplanet/features/chat/domain/entities/message.dart';
// Repository
import 'package:uniplanet/core/network/repository/index.dart';
import 'package:uniplanet/core/network/socket/socket_channel.dart';
import 'package:uuid/uuid.dart';
// Part of the bloc
part 'message_bloc_event.dart';
part 'message_bloc_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final ChatRepository _chatRepository;

  MessageBloc(this._chatRepository) : super(InitMessageState()) {
    on<GetMessageEvent>((event, emit) async {
      await _loadMessages(event, emit);
    });
    on<SendTextMessageEvent>((event, emit) async {
      await _sendMessage(event, emit);
    });
    on<SendMediaMessageEvent>((event, emit) async {
      await _sendMediaMessage(event, emit);
    });
    on<ReceiveMessageEvent>((event, emit) async {
      await _receiveMessage(event, emit);
    });
    on<GetMoreMessageEvent>((event, emit) async {
      await _getMoreMessage(event, emit);
    });
    on<ReadAllMessages>((event, emit) {
      _readAllMessages(event, emit);
    });
    on<SendingMessageEvent>((event, emit) async {
      _sendingMessage(event, emit);
    });
    on<SentMessageEvent>((event, emit) {
      _sentMessage(event, emit);
    });
    on<RetrySendMessagesEvent>((event, emit) async {
      await _retrySendMessages(event, emit);
    });
    on<ErrorMessageEvent>((event, emit) {
      _errorMessageHandler(event, emit);
    });
  }

  _errorMessageHandler(ErrorMessageEvent event, emit) {
    List<Message> currentChatMessages =
        List.from(state.chatMessages[event.errorMessage.chat]!);
    int messageIndex =
        currentChatMessages.indexWhere((m) => m.id == event.errorMessage.id);
    if (messageIndex != -1) {
      currentChatMessages[messageIndex] =
          currentChatMessages[messageIndex].copyWith(
        status: MessageStatusEnum.error.value,
      );
    }

    emit(ErrorMessageState(
      chatMessages: {
        ...state.chatMessages,
        event.errorMessage.chat: currentChatMessages
      },
      page: state.page,
      pendingMessages: state.pendingMessages,
    ));
  }

  _retrySendMessages(RetrySendMessagesEvent event, emit) async {
    // Clone the chatMessages map to ensure we're not directly mutating the state.
    // This helps with ensuring that the state changes are immutable.
    final updatedChatMessages =
        Map<String, List<Message>>.from(state.chatMessages);

    for (var message in event.messages) {
      if (updatedChatMessages[message.chat] != null) {
        // Find the index of the message to update.
        final index = updatedChatMessages[message.chat]!
            .indexWhere((element) => element.id == message.id);

        if (index != -1) {
          // Message found
          // Replace the message at the found index with a new one that has an updated status.

          if (message.messageType == MessageEnum.image.value) {
            updatedChatMessages[message.chat]![index] =
                updatedChatMessages[message.chat]![index].copyWith(
              status: message.status,
              message: message.message,
            );
          } else {
            updatedChatMessages[message.chat]![index] =
                updatedChatMessages[message.chat]![index]
                    .copyWith(status: message.status);
          }
        }
      }
    }
    if (state.chatMessages.isNotEmpty) {
      emit(SentMessageState(
        chatMessages: updatedChatMessages,
        page: state.page,
        pendingMessages: state.pendingMessages,
      ));
    }
  }

  Future<void> _sendMediaMessage(SendMediaMessageEvent event, emit) async {
    List<Message> messages = [];
    for (var media in event.mediaList) {
      String uniqueId = const Uuid().v4();
      String imagePath = File(media.path).path;
      String messageType =
          isImage(media) ? MessageEnum.image.value : MessageEnum.video.value;
      Message tempMessage = Message(
        id: uniqueId,
        chat: event.chatId,
        message: imagePath,
        status: MessageStatusEnum.sending.value,
        messageType: messageType,
        sender: LocalStorage().getUserData().id,
        receiver: event.receiverId,
        createdAt: DateTime.now(),
      );
      messages.add(tempMessage);

      add(SendingMessageEvent(tempMessage: tempMessage));
    }
    for (var tempMessage in messages) {
      try {
        if (tempMessage.messageType == MessageEnum.video.value) {
          Message? videoUploadedMessage = await _uploadVideo(tempMessage);
          if (videoUploadedMessage == null) {
            throw Exception('Video uploading failed');
          }
          Message sentMessage = await _uploadMessage(videoUploadedMessage);
          add(SentMessageEvent(sentMessage));
        } else if (tempMessage.messageType == MessageEnum.image.value) {
          Message? imageUploadedMessage = await _uploadImage(tempMessage);
          if (imageUploadedMessage == null) {
            throw Exception('Image uploading failed');
          }
          Message sentMessage = await _uploadMessage(imageUploadedMessage);
          add(SentMessageEvent(sentMessage));
        } else {
          tempMessage =
              tempMessage.copyWith(status: MessageStatusEnum.error.value);
          ImageMessage imageMessage = ImageMessage(
            filePath: tempMessage.message,
            message: tempMessage,
          );
          SocketService.imageMessagesToRetry.add(imageMessage);
          add(ErrorMessageEvent(tempMessage));
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Future<Message?> _uploadVideo(Message tempMessage) async {
    try {
      File videoFile = File(tempMessage.message);
      String? secureUrl = await MediaUploadService()
          .uploadVideo(videoFile, 'chat-videos/${tempMessage.chat}')
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Video uploading timed out');
        },
      );

      tempMessage.message = secureUrl;
      return tempMessage;
    } catch (e) {
      tempMessage = tempMessage.copyWith(status: MessageStatusEnum.error.value);
      ImageMessage imageMessage = ImageMessage(
        filePath: tempMessage.message,
        message: tempMessage,
      );
      SocketService.imageMessagesToRetry.add(imageMessage);
      add(ErrorMessageEvent(tempMessage));
      return null;
    }
  }

  Future<Message?> _uploadImage(Message tempMessage) async {
    try {
      File imageFile = File(tempMessage.message);
      String? secureUrl = await MediaUploadService()
          .uploadImage(imageFile, 'chat-images/${tempMessage.chat}')
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Image uploading timed out');
        },
      );

      tempMessage.message = secureUrl;
      return tempMessage;
    } catch (e) {
      tempMessage = tempMessage.copyWith(status: MessageStatusEnum.error.value);
      ImageMessage imageMessage = ImageMessage(
        filePath: tempMessage.message,
        message: tempMessage,
      );
      SocketService.imageMessagesToRetry.add(imageMessage);
      add(ErrorMessageEvent(tempMessage));
      return null;
    }
  }

  Future<Message> _uploadMessage(Message message) async {
    try {
      Message sentMessage = await Initialization.socketService
          .sendMessage(
        id: message.id,
        message: message.message,
        chatId: message.chat,
        messageType: message.messageType,
        receiver: message.receiver,
      )
          .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Message sending timed out');
        },
      );
      return sentMessage;
    } catch (e) {
      Message tempMessage =
          message.copyWith(status: MessageStatusEnum.error.value);
      SocketService.messagesToRetry.add(tempMessage);
      return tempMessage;
    }
  }

  _sendingMessage(SendingMessageEvent event, emit) {
    List<Message> currentChatMessages =
        List.from(state.chatMessages[event.tempMessage.chat] ?? []);
    currentChatMessages.add(event.tempMessage);

    emit(SendingMessageState(
      chatMessages: {
        ...state.chatMessages,
        event.tempMessage.chat: currentChatMessages
      },
      page: state.page,
      pendingMessages: state.pendingMessages,
    ));
  }

  _sentMessage(SentMessageEvent event, emit) {
    List<Message> currentChatMessages =
        List.from(state.chatMessages[event.message.chat]!);
    int messageIndex =
        currentChatMessages.indexWhere((m) => m.id == event.message.id);

    if (messageIndex != -1) {
      event.message.status == MessageStatusEnum.error.value
          ? currentChatMessages[messageIndex] =
              currentChatMessages[messageIndex].copyWith(
              status: MessageStatusEnum.error.value,
            )
          : currentChatMessages[messageIndex] =
              currentChatMessages[messageIndex].copyWith(
              status: MessageStatusEnum.received.value,
              message: event.message.message,
            );
    }

    emit(SentMessageState(
      chatMessages: {
        ...state.chatMessages,
        event.message.chat: currentChatMessages
      },
      page: state.page,
      pendingMessages: state.pendingMessages,
    ));
  }

  _readAllMessages(ReadAllMessages event, emit) {
    // First, create a new copy of chatMessages
    Map<String, List<Message>> updatedChatMessages = {};

    state.chatMessages.forEach((chatId, messages) {
      if (chatId == event.chatId) {
        // Create a new list of messages with updated readDate for relevant messages
        var updatedMessages = messages.map((message) {
          if (message.readDate == null) {
            return message.copyWith(
                readDate:
                    event.readDate); // Assuming you have a copyWith method
          }
          return message;
        }).toList();
        updatedChatMessages[chatId] = updatedMessages;
      } else {
        updatedChatMessages[chatId] =
            List.from(messages); // Add other chats unchanged
      }
    });

    // Emit a new state with the updated map of chatMessages
    emit(ReadMessageState(
        chatMessages: updatedChatMessages,
        page: state.page,
        pendingMessages: state.pendingMessages));
  }

  _getMoreMessage(GetMoreMessageEvent event, emit) async {
    emit(LoadingMessageState(
        chatMessages: state.chatMessages,
        page: state.page,
        pendingMessages: state.pendingMessages));
    int nextPage = state.page! + 1;
    List<Message> listMessage = await _chatRepository
        .getMessages(chatId: event.chatId, page: nextPage)
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Message loading timed out');
      },
    );
    if (listMessage.isEmpty) {
      emit(EndMessageState(
          chatMessages: state.chatMessages,
          page: state.page,
          pendingMessages: state.pendingMessages));
    } else {
      var chatId = listMessage.first.chat;

      // Check if the chatMessages map already contains the chatId key
      if (state.chatMessages.containsKey(chatId)) {
        // If it does, append the listMessage to the existing list for that chatId
        state.chatMessages[chatId]!.insertAll(0, listMessage.reversed.toList());
      } else {
        // If it doesn't, add a new entry with the chatId and listMessage
        state.chatMessages[chatId] = listMessage.reversed.toList();
      }

      emit(LoadedMessageState(
          chatMessages: state.chatMessages,
          page: nextPage,
          pendingMessages: state.pendingMessages));
    }
  }

  _receiveMessage(ReceiveMessageEvent event, emit) {
    emit(ReceivingMessageState(
        chatMessages: state.chatMessages,
        page: state.page,
        pendingMessages: state.pendingMessages));
    if (state.chatMessages[event.msg.chat] == null) {
      state.chatMessages[event.msg.chat] = [];
    }
    state.chatMessages[event.msg.chat]!.add(event.msg);

    emit(ReceivedMessageState(
        chatMessages: state.chatMessages,
        page: state.page,
        pendingMessages: state.pendingMessages));
  }

  _sendMessage(SendTextMessageEvent event, emit) async {
    String uniqueId = const Uuid().v4();
    Message tempMessage = Message(
      id: uniqueId,
      chat: event.chatId,
      message: event.message,
      status: MessageStatusEnum.sending.value,
      messageType: MessageEnum.text.value,
      sender: LocalStorage().getUserData().id,
      receiver: event.receiverId,
      readDate: null,
      createdAt: DateTime.now(),
    );

    // Ensure the chatMessages list for the specific chatId exists
    List<Message> chatMessages = state.chatMessages[event.chatId] ?? [];
    chatMessages.add(tempMessage);

    // Emitting state with the temp message added
    emit(SendingMessageState(
        chatMessages: {...state.chatMessages, event.chatId: chatMessages},
        page: state.page,
        pendingMessages: state.pendingMessages));

    try {
      Message sentMessage = await Initialization.socketService
          .sendMessage(
        id: uniqueId,
        message: event.message,
        chatId: event.chatId,
        messageType: MessageEnum.text.value, // Should this be .image.value?
        receiver: event.receiverId,
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          tempMessage =
              tempMessage.copyWith(status: MessageStatusEnum.error.value);
          SocketService.messagesToRetry.add(tempMessage);
          throw TimeoutException('Message sending timed out');
        },
      );

      // Create a new list and replace the temp message with the sent message or update its status
      List<Message> updatedMessages = chatMessages.map((message) {
        if (message.id == uniqueId) {
          // Clone with updated status, adjust according to your actual model's capabilities
          return sentMessage;
        }
        return message;
      }).toList();

      // Emit a new state with the updated messages list
      emit(SentMessageState(
          chatMessages: {...state.chatMessages, event.chatId: updatedMessages},
          page: state.page,
          pendingMessages: state.pendingMessages));
    } catch (e) {
      log(e);
      // Handle error, similar to success but marking the message as error
      List<Message> updatedMessagesWithError = chatMessages.map((message) {
        if (message.id == uniqueId) {
          return message.copyWith(status: MessageStatusEnum.error.value);
        }
        return message;
      }).toList();

      emit(ErrorMessageState(
        chatMessages: {
          ...state.chatMessages,
          event.chatId: updatedMessagesWithError
        },
        page: state.page,
        pendingMessages: state.pendingMessages,
      ));
    }
  }

  _loadMessages(GetMessageEvent event, emit) async {
    emit(LoadingMessageState(
        chatMessages: state.chatMessages,
        pendingMessages: state.pendingMessages,
        page: 1));
    try {
      List<Message> listMessage = await _chatRepository
          .getMessages(chatId: event.chatId, page: 1)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Message loading timed out');
        },
      );

      if (listMessage.isEmpty) {
        emit(EndMessageState(
            chatMessages: state.chatMessages,
            pendingMessages: state.pendingMessages,
            page: state.page));
      } else {
        var chatId = listMessage.first.chat;
        state.chatMessages.addAll({chatId: listMessage.reversed.toList()});
        emit(LoadedMessageState(
            chatMessages: state.chatMessages,
            page: state.page,
            pendingMessages: state.pendingMessages));
      }
    } catch (e) {
      log(e);
    }
  }

  @override
  void onChange(Change<MessageBlocState> change) {
    super.onChange(change);
    // log(change);
  }

  @override
  void onTransition(Transition<MessageBlocEvent, MessageBlocState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}
