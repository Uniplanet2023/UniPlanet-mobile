import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final ChatRepository _chatRepository;
  ChatBloc(this._chatRepository) : super(InitChatRoomState()) {
    on<CreateChatRoomEvent>((event, emit) async {
      await _creatingChatRoom(event, emit);
    });
    on<LoadChatRoomEvent>((event, emit) async {
      await _loadChatRooms(event, emit);
    });
    on<SelectChatRoomEvent>((event, emit) async {
      await _selectChatRoom(event, emit);
    });
    on<ClientStatusChangeEvent>((event, emit) {
      state.client!.isOnline = true;
      emit(StatusChangingState(
          currentChatRoom: state.currentChatRoom,
          chatRoomList: state.chatRoomList,
          client: state.client));
    });
    on<ClientStatusDisconnectEvent>(((event, emit) {
      state.client!.isOnline = false;
      emit(StatusChangingState(
          currentChatRoom: state.currentChatRoom,
          chatRoomList: state.chatRoomList,
          client: state.client));
    }));
  }

  _selectChatRoom(SelectChatRoomEvent event, emit) async {
    User client = event.chatroom.buyer.id == event.userId
        ? event.chatroom.seller
        : event.chatroom.buyer;
    emit(SelectChatRoomState(
        currentChatRoom: event.chatroom,
        chatRoomList: state.chatRoomList,
        client: client));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
        currentChatRoom: ChatRoom.initialChatRoom(),
        chatRoomList: state.chatRoomList,
        client: state.client));
    try {
      List<ChatRoom> chatrooms =
          await _chatRepository.getChatRoom(event.chatRoomIds);
      emit(LoadedChatRoomState(
          currentChatRoom: state.currentChatRoom,
          chatRoomList: chatrooms,
          client: state.client));
    } catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
        currentChatRoom: state.currentChatRoom,
        chatRoomList: state.chatRoomList,
        client: state.client));
    try {
      ChatRoom? room = await _chatRepository.creatingChatRoom(
          user: event.user, receiverId: event.receiverId);
      if (room != null || state.chatRoomList != null) {
        List<ChatRoom> list = state.chatRoomList!;
        list.add(room!);
        emit(CreatedChatRoomState(
            currentChatRoom: room, chatRoomList: list, client: room.seller));
      } else {
        throw Exception('room or list is not initialized');
      }
    } catch (e) {
      throw Exception('creating chat room API error');
    }
  }

  @override
  void onChange(Change<ChatBlocState> change) {
    super.onChange(change);
    // print(change);
  }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
