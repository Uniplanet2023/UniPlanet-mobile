import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room_test.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

abstract class ChatBlocState extends Equatable {
  final List<ChatRoom> buyingChatRoom;
  final List<ChatRoom> sellingChatRooms;

  const ChatBlocState({
    this.buyingChatRoom = const [],
    this.sellingChatRooms = const [],
  });
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState() : super(buyingChatRoom: [], sellingChatRooms: []);
  @override
  List<Object?> get props => [buyingChatRoom, sellingChatRooms];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState({super.buyingChatRoom, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRoom, sellingChatRooms];
}

class CreatedChatRoomState extends ChatBlocState {
  const CreatedChatRoomState({super.buyingChatRoom, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRoom, sellingChatRooms];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState({super.buyingChatRoom, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRoom, sellingChatRooms];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState({super.buyingChatRoom, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRoom, sellingChatRooms];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState({super.buyingChatRoom, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRoom, sellingChatRooms];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
