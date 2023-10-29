import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
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
  final ChatRoom chatroom;
  const SelectChatRoomEvent(this.chatroom);
  @override
  List<Object> get props => [chatroom];
}

class LoadChatRoomEvent extends ChatBlocEvent {
  final List<String> chatRoomIds;
  const LoadChatRoomEvent(this.chatRoomIds);
  @override
  List<Object> get props => [chatRoomIds];
}

class LoadMessageEvent extends ChatBlocEvent {
  @override
  List<Object> get props => [];
}

class UpdateOnlineStatusEvent extends ChatBlocEvent {
  final bool isOnline;
  const UpdateOnlineStatusEvent(this.isOnline);
  @override
  List<Object> get props => [isOnline];
}
