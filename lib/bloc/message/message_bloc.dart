import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniket/bloc/index.dart';
import 'package:uniket/common/enums/message_enum.dart';
import 'package:uniket/common/enums/message_status_enum.dart';
import 'package:uniket/global.dart';
// Models
import 'package:uniket/models/message.dart';
// Repository
import 'package:uniket/network/repository/index.dart';
import 'package:uniket/network/socket/socket_channel.dart';
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
      currentChatMessages[messageIndex] =
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
    String uniqueId = UniqueKey().toString();
    Message tempMessage = Message(
      id: uniqueId,
      chat: event.chatId,
      message: event.message,
      status: MessageStatusEnum.sending.value,
      messageType: MessageEnum.text.value,
      sender: AuthRepository.userId!,
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
      Message sentMessage = await Global.socketService
          .sendMessage(
        id: uniqueId,
        message: event.message,
        chatId: event.chatId,
        messageType: MessageEnum.text.value, // Should this be .image.value?
        receiver: event.receiverId,
        context: event.context,
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
      print(e.toString());
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
      print(e);
    }
  }

  @override
  void onChange(Change<MessageBlocState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<MessageBlocEvent, MessageBlocState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
