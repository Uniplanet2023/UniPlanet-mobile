import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room.dart';
import 'package:uniplanet_mobile/models/user.dart';

abstract class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();
}

class CreateChatRoomEvent extends ChatBlocEvent {
  final ChatRoom chatRoom;
  const CreateChatRoomEvent(this.chatRoom);
  @override
  List<Object> get props => [chatRoom];
}

class SelectChatRoomEvent extends ChatBlocEvent {
  final ChatRoom chatroom;
  final String userId;
  const SelectChatRoomEvent(this.chatroom, this.userId);
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

class ClientStatusChangeEvent extends ChatBlocEvent {
  final String userId;
  const ClientStatusChangeEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class ClientStatusDisconnectEvent extends ChatBlocEvent {
  final String userId;
  const ClientStatusDisconnectEvent(this.userId);

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
