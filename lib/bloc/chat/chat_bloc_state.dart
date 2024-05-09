part of 'chat_bloc.dart';

sealed class ChatBlocState extends Equatable {
  final List<ChatRoom> chatRooms;
  final int totalUnseenMessageCount;
  final int page;

  const ChatBlocState({
    this.chatRooms = const [],
    this.totalUnseenMessageCount = 0,
    this.page = 1,
  });
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState()
      : super(chatRooms: [], totalUnseenMessageCount: 0, page: 1);
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class CreatedChatRoomState extends ChatBlocState {
  final ChatRoom chatRoomCreated;
  const CreatedChatRoomState(
      {super.chatRooms,
      super.totalUnseenMessageCount,
      super.page,
      required this.chatRoomCreated});
  @override
  List<Object?> get props =>
      [chatRooms, totalUnseenMessageCount, page, chatRoomCreated];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class EndChatRoomState extends ChatBlocState {
  const EndChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

//Update LastMessage
class UpdateLastMessageState extends ChatBlocState {
  const UpdateLastMessageState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

//Update UnseenMessage
class UpdatingUnseenMessageState extends ChatBlocState {
  const UpdatingUnseenMessageState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class UpdateUnseenMessageState extends ChatBlocState {
  const UpdateUnseenMessageState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class EmptyUnseenMessageState extends ChatBlocState {
  const EmptyUnseenMessageState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

//Add ChatRoom
class AddingChatRoomState extends ChatBlocState {
  const AddingChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class AddedChatRoomState extends ChatBlocState {
  final ChatRoom chatRoomCreated;
  const AddedChatRoomState(
      {super.chatRooms,
      super.totalUnseenMessageCount,
      super.page,
      required this.chatRoomCreated});
  @override
  List<Object?> get props =>
      [chatRooms, totalUnseenMessageCount, chatRoomCreated, page];
}

// Delete chatRoom
class DeletingChatRoomState extends ChatBlocState {
  const DeletingChatRoomState(
      {super.chatRooms, super.totalUnseenMessageCount, super.page});
  @override
  List<Object?> get props => [chatRooms, totalUnseenMessageCount, page];
}

class DeletedChatRoomState extends ChatBlocState {
  final String deletedChatRoomId;
  const DeletedChatRoomState(
      {super.chatRooms,
      super.totalUnseenMessageCount,
      super.page,
      required this.deletedChatRoomId});
  @override
  List<Object?> get props =>
      [chatRooms, totalUnseenMessageCount, page, deletedChatRoomId];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
