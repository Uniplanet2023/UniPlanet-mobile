import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_event.dart';
import 'package:uniplanet_mobile/bloc/chatBloc/chat_bloc_state.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/myChatRoom.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/chat_repo.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

class ChatBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final ChatRepository _chatRepository;
  ChatBloc(this._chatRepository) : super(InitChatRoomState()) {
    on<CreateChatRoomEvent>((event, emit) async {
      await _creatingChatRoom(event, emit);
    });
    on<LoadChatRoomEvent>((event, emit) async {
      await _loadChatRooms(event, emit);
    });

    on<ClientStatusChangeEvent>((event, emit) {
      emit(StatusChangingState(
        chatRoomList: state.chatRoomList,
      ));
    });
    on<ClientStatusDisconnectEvent>(((event, emit) {
      emit(StatusChangingState(
        chatRoomList: state.chatRoomList,
      ));
    }));
  }

  _loadChatRooms(LoadChatRoomEvent event, emit) async {
    emit(LoadingChatRoomState(
      chatRoomList: state.chatRoomList,
    ));
    try {
      List<MyChatRoom> chatrooms = await _chatRepository.getChatRooms();
      emit(LoadedChatRoomState(
        chatRoomList: chatrooms,
      ));
    } catch (e) {
      print(e);
      throw Exception('Loading chat room API error');
    }
  }

  _creatingChatRoom(CreateChatRoomEvent event, emit) async {
    emit(CreatingChatRoomState(
      chatRoomList: state.chatRoomList,
    ));
    try {
      MyChatRoom myChatRoom = await _chatRepository.creatingChatRoom(
          receiverId: event.seller.id, productId: event.productId);
      SocketService.socket!
          .emit("joinChatRoom", myChatRoom.chatRoom.chatRoomId);
      state.chatRoomList!.add(myChatRoom);
      if (state.chatRoomList != null) {
        state.chatRoomList!.add(myChatRoom);
        emit(CreatedChatRoomState(
          chatRoomList: state.chatRoomList!,
        ));
      } else {
        throw Exception('room or list is not initialized');
      }
    } catch (e) {
      emit(ErrorChatState(e.toString()));
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
