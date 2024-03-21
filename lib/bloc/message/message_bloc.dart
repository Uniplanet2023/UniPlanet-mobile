import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

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
    on<ReadMessageEvent>((event, emit) {
      emit(UnReadMessageState(
          chatMessages: state.chatMessages, page: state.page));
      // state.chatMessages!.last.readDate = DateTime.now();

      emit(
          ReadMessageState(chatMessages: state.chatMessages, page: state.page));
    });
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
      state.chatMessages.addAll({chatId: listMessage});
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
    emit(InitMessageState());
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
    // print(transition);
  }
}
