import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final ChatRepository _chatRepository;
  final _onlineStatusController = StreamController<bool>.broadcast();
  Stream<bool> get onlineStatusStream => _onlineStatusController.stream;

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
    on<UpdateOnlineStatusEvent>((event, emit) async {
      _updateOnlineStatus(event);
    });
  }
  void _updateOnlineStatus(UpdateOnlineStatusEvent event) {
    _onlineStatusController.sink.add(event.isOnline);
  }

  _selectChatRoom(SelectChatRoomEvent event, emit) async {
    emit(SelectChatRoomState(currentChatRoom: event.chatroom));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
        currentChatRoom: ChatRoom.initialChatRoom(),
        chatRoomList: state.chatRoomList));
    try {
      List<ChatRoom> chatrooms =
          await _chatRepository.getChatRoom(event.chatRoomIds);
      emit(LoadedChatRoomState(
          currentChatRoom: state.currentChatRoom, chatRoomList: chatrooms));
    } catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
        currentChatRoom: state.currentChatRoom,
        chatRoomList: state.chatRoomList));
    try {
      ChatRoom? room = await _chatRepository.creatingChatRoom(
          user: event.user, receiverId: event.receiverId);
      if (room != null || state.chatRoomList != null) {
        List<ChatRoom> list = state.chatRoomList!;
        list.add(room!);
        emit(CreatedChatRoomState(currentChatRoom: room, chatRoomList: list));
      } else {
        throw Exception('room or list is not initialized');
      }
    } catch (e) {
      throw Exception('creating chat room API error');
    }
  }

  @override
  Future<void> close() {
    _onlineStatusController.close();
    return super.close();
  }

  @override
  // void onChange(Change<ChatBlocState> change) {
  //   super.onChange(change);
  //   print(change);
  // }

  @override
  void onTransition(Transition<ChatBlocEvent, ChatBlocState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
