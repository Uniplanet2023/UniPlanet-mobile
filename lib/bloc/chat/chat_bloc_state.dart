import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room_test.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';

abstract class ChatBlocState extends Equatable {
  final List<ChatRoom> buyingChatRooms;
  final List<ChatRoom> sellingChatRooms;

  const ChatBlocState({
    this.buyingChatRooms = const [],
    this.sellingChatRooms = const [],
  });
}

class InitChatRoomState extends ChatBlocState {
  InitChatRoomState() : super(buyingChatRooms: [], sellingChatRooms: []);
  @override
  List<Object?> get props => [buyingChatRooms, sellingChatRooms];
}

//Creat ChatRoom
class CreatingChatRoomState extends ChatBlocState {
  const CreatingChatRoomState({super.buyingChatRooms, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRooms, sellingChatRooms];
}

class CreatedChatRoomState extends ChatBlocState {
  const CreatedChatRoomState({super.buyingChatRooms, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRooms, sellingChatRooms];
}

//Load ChatRoom
class LoadingChatRoomState extends ChatBlocState {
  const LoadingChatRoomState({super.buyingChatRooms, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRooms, sellingChatRooms];
}

class LoadedChatRoomState extends ChatBlocState {
  const LoadedChatRoomState({super.buyingChatRooms, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRooms, sellingChatRooms];
}

//Select ChatRoom
class SelectChatRoomState extends ChatBlocState {
  const SelectChatRoomState({super.buyingChatRooms, super.sellingChatRooms});
  @override
  List<Object?> get props => [buyingChatRooms, sellingChatRooms];
}

//Error
class ErrorChatState extends ChatBlocState {
  final String errMsg;
  const ErrorChatState(this.errMsg);

  @override
  List<Object?> get props => [];
}
