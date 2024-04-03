import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Models
import 'package:uniplanet_mobile/models/message.dart';
// Repository
import 'package:uniplanet_mobile/network/repository/chat_repository/chat_repo.dart';
// Part of the bloc
part 'message_bloc_event.dart';
part 'message_bloc_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final ChatRepository _chatRepository;

  MessageBloc(this._chatRepository) : super(InitMessageState()) {
    on<GetMessageEvent>((event, emit) async {
      await _loadMessages(event, emit);
    });
    on<SendMessageEvent>((event, emit) async {
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
    // on<ReadMessageEvent>((event, emit) {
    //   _readMessage(event, emit);
    // });
  }
  // _readMessage(ReadMessageEvent event, emit) {
  //   // First, create a new copy of chatMessages
  //   Map<String, List<Message>> updatedChatMessages = {};

  //   state.chatMessages.forEach((chatId, messages) {
  //     if (chatId == event.chatId) {
  //       // Create a new list of messages with updated readDate for relevant messages
  //       var updatedMessages = messages.map((message) {
  //         if (message.readDate == null &&
  //             message.receiver == AuthRepository.userId) {
  //           return message.copyWith(
  //               readDate:
  //                   event.readDate); // Assuming you have a copyWith method
  //         }
  //         return message;
  //       }).toList();
  //       updatedChatMessages[chatId] = updatedMessages;
  //     } else {
  //       updatedChatMessages[chatId] =
  //           List.from(messages); // Add other chats unchanged
  //     }
  //   });

  //   // Emit a new state with the updated map of chatMessages
  //   emit(ReadMessageState(chatMessages: updatedChatMessages, page: state.page));
  // }

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
    emit(ReadMessageState(chatMessages: updatedChatMessages, page: state.page));
  }

  _getMoreMessage(GetMoreMessageEvent event, emit) async {
    emit(LoadingMessageState(
        chatMessages: state.chatMessages, page: state.page));
    int nextPage = state.page! + 1;
    List<Message> listMessage =
        await _chatRepository.getMessages(chatId: event.chatId, page: nextPage);
    if (listMessage.isEmpty) {
      emit(EndMessageState(chatMessages: state.chatMessages, page: state.page));
    } else {
      var chatId = listMessage.first.chat;

      // Check if the chatMessages map already contains the chatId key
      if (state.chatMessages.containsKey(chatId)) {
        // If it does, append the listMessage to the existing list for that chatId
        state.chatMessages[chatId]!.addAll(listMessage);
      } else {
        // If it doesn't, add a new entry with the chatId and listMessage
        state.chatMessages[chatId] = listMessage;
      }

      emit(
          LoadedMessageState(chatMessages: state.chatMessages, page: nextPage));
    }
  }

  _receiveMessage(ReceiveMessageEvent event, emit) {
    emit(ReceivingMessageState(
        chatMessages: state.chatMessages, page: state.page));
    if (state.chatMessages[event.msg.chat] == null) {
      state.chatMessages.addAll({
        event.msg.chat: [event.msg]
      });
    } else {
      state.chatMessages[event.msg.chat]!.insertAll(0, [event.msg]);
    }
    emit(ReceivedMessageState(
        chatMessages: state.chatMessages, page: state.page));
  }

  _sendMessage(SendMessageEvent event, emit) async {
    try {
      // SocketService.socket!.emit('sendMessage', {event.msg, event.chatRoomId});
    } catch (e) {
      print(e);
      // handle errors
    }
  }

  _loadMessages(GetMessageEvent event, emit) async {
    emit(LoadingMessageState(
        chatMessages: state.chatMessages, page: state.page));
    try {
      List<Message> listMessage =
          await _chatRepository.getMessages(chatId: event.chatId, page: 0);

      if (listMessage.isEmpty) {
        emit(EndMessageState(
            chatMessages: state.chatMessages, page: state.page));
      } else {
        var chatId = listMessage.first.chat;
        state.chatMessages.addAll({chatId: listMessage});
        emit(LoadedMessageState(
            chatMessages: state.chatMessages, page: state.page));
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
    print(transition);
  }
}
