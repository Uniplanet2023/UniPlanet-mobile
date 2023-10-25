import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

abstract class ChatBlocState extends Equatable {
  final ChatRoom? currentChatRoom;
  final List<ChatRoom>? chatRoomList;
  const ChatBlocState({
    this.currentChatRoom,
    this.chatRoomList,
  });
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState()
      : super(currentChatRoom: ChatRoom(receiverName: ""), chatRoomList: []);
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState({super.currentChatRoom, super.chatRoomList});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList];
}

class CreatedChatRoomState extends ChatBlocState {
  const CreatedChatRoomState({super.currentChatRoom, super.chatRoomList});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState({super.currentChatRoom, super.chatRoomList});
  @override
  // TODO: implement props
  List<Object?> get props => [currentChatRoom, chatRoomList];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState({super.currentChatRoom, super.chatRoomList});
  @override
  // TODO: implement props
  List<Object?> get props => [currentChatRoom, chatRoomList];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState({super.currentChatRoom, super.chatRoomList});
  @override
  // TODO: implement props
  List<Object?> get props => [currentChatRoom, chatRoomList];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
