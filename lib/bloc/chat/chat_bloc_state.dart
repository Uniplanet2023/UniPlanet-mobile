import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room_test.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

abstract class ChatBlocState extends Equatable {
  final List<ChatRoom>? chatRoomList;

  const ChatBlocState({
    this.chatRoomList,
  });
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState()
      : super(
          chatRoomList: [],
        );
  @override
  List<Object?> get props => [chatRoomList];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState({super.chatRoomList});
  @override
  List<Object?> get props => [chatRoomList];
}

class CreatedChatRoomState extends ChatBlocState {
  const CreatedChatRoomState({super.chatRoomList});
  @override
  List<Object?> get props => [chatRoomList];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState({super.chatRoomList});
  @override
  List<Object?> get props => [chatRoomList];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState({super.chatRoomList});
  @override
  List<Object?> get props => [chatRoomList];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState({super.chatRoomList});
  @override
  List<Object?> get props => [chatRoomList];
}

//setting client
class StatusChangingState extends ChatBlocState {
  const StatusChangingState({super.chatRoomList});
  @override
  // TODO: implement props
  List<Object?> get props => [chatRoomList];
}

class StatusChangedState extends ChatBlocState {
  const StatusChangedState({super.chatRoomList});
  @override
  // TODO: implement props
  List<Object?> get props => [chatRoomList];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
