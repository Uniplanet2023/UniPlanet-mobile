import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';

abstract class ChatBlocState extends Equatable {
  final ChatRoom? currentChatRoom;
  final User? client;
  final List<ChatRoom>? chatRoomList;

  const ChatBlocState({
    this.currentChatRoom,
    this.chatRoomList,
    this.client,
  });
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState()
      : super(
            currentChatRoom: ChatRoom.initialChatRoom(),
            chatRoomList: [],
            client: User.initialUser());
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

class CreatedChatRoomState extends ChatBlocState {
  const CreatedChatRoomState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

//setting client
class StatusChangingState extends ChatBlocState {
  const StatusChangingState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  // TODO: implement props
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

class StatusChangedState extends ChatBlocState {
  const StatusChangedState(
      {super.currentChatRoom, super.chatRoomList, super.client});
  @override
  // TODO: implement props
  List<Object?> get props => [currentChatRoom, chatRoomList, client];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
