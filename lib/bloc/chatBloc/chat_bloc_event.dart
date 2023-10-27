import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/user.dart';

abstract class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();

  @override
  List<Object> get props => [];
}

class CreateChatRoomEvent extends ChatBlocEvent {
  final String receiverId;
  final User user;
  const CreateChatRoomEvent(this.user, this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class SelectChatRoomEvent extends ChatBlocEvent {
  final String receiverId;
  final User user;
  const SelectChatRoomEvent(this.user, this.receiverId);
  @override
  List<Object> get props => [receiverId];
}

class LoadChatRoomEvent extends ChatBlocEvent {
  final User user;
  const LoadChatRoomEvent(this.user);
  @override
  List<Object> get props => [user];
}
