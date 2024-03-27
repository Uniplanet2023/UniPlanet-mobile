import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

abstract class ChatBlocState extends Equatable {
  final List<ChatRoom> buyingChatRooms;
  final List<ChatRoom> sellingChatRooms;
  final int totalUnseenMessageCount;

  const ChatBlocState({
    this.buyingChatRooms = const [],
    this.sellingChatRooms = const [],
    this.totalUnseenMessageCount = 0,
  });
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState()
      : super(
            buyingChatRooms: [],
            sellingChatRooms: [],
            totalUnseenMessageCount: 0);
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

class CreatedChatRoomState extends ChatBlocState {
  final ChatRoom chatRoomCreated;
  const CreatedChatRoomState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount,
      required this.chatRoomCreated});
  @override
  List<Object?> get props => [
        buyingChatRooms,
        sellingChatRooms,
        totalUnseenMessageCount,
        chatRoomCreated
      ];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

//Update LastMessage
class UpdateLastMessageState extends ChatBlocState {
  const UpdateLastMessageState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

//Update UnseenMessage
class UpdateUnseenMessageState extends ChatBlocState {
  const UpdateUnseenMessageState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

class EmptyUnseenMessageState extends ChatBlocState {
  const EmptyUnseenMessageState(
      {super.buyingChatRooms,
      super.sellingChatRooms,
      super.totalUnseenMessageCount});
  @override
  List<Object?> get props =>
      [buyingChatRooms, sellingChatRooms, totalUnseenMessageCount];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
