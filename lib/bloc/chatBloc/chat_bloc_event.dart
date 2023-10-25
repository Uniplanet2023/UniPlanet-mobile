import 'package:equatable/equatable.dart';

sealed class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();

  @override
  List<Object> get props => [];
}

class CreateChatRoomEvent extends ChatBlocEvent {
  final String receiverId;
  const CreateChatRoomEvent(this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class SelectChatRoomEvent extends ChatBlocEvent {
  final String receiverId;
  const SelectChatRoomEvent(this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class LoadChatRoomEvent extends ChatBlocEvent {
  const LoadChatRoomEvent();
  @override
  List<Object> get props => [];
}
