part of 'chat_bloc.dart';

sealed class ChatBlocState extends Equatable {
  final List<ChatRoom> chatRooms;
  final int totalUnseenMessageCount;

  const ChatBlocState({
    this.chatRooms = const [],
    this.totalUnseenMessageCount = 0,
  });
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState() : super(chatRooms: [], totalUnseenMessageCount: 0);
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState({super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

class CreatedChatRoomState extends ChatBlocState {
  final ChatRoom chatRoomCreated;
  const CreatedChatRoomState(
      {super.chatRooms,
      super.totalUnseenMessageCount,
      required this.chatRoomCreated});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState({super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState({super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState({super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

//Update LastMessage
class UpdateLastMessageState extends ChatBlocState {
  const UpdateLastMessageState(
      {super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

//Update UnseenMessage
class UpdateUnseenMessageState extends ChatBlocState {
  const UpdateUnseenMessageState(
      {super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

class EmptyUnseenMessageState extends ChatBlocState {
  const EmptyUnseenMessageState(
      {super.chatRooms, super.totalUnseenMessageCount});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
