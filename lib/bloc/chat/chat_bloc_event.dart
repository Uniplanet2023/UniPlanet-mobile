import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/chat_room_test.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

abstract class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();
}

class CreateChatRoomEvent extends ChatBlocEvent {
  final String sellerId;
  final String productId;
  const CreateChatRoomEvent(this.sellerId, this.productId);
  @override
  List<Object> get props => [sellerId, productId];
}

class LoadChatRoomEvent extends ChatBlocEvent {
  const LoadChatRoomEvent();
  @override
  List<Object> get props => [];
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

class EmptyUnseenMessageEvent extends ChatBlocEvent {
  final String myChatRoomId;
  const EmptyUnseenMessageEvent(this.myChatRoomId);
  @override
  List<Object?> get props => [myChatRoomId];
}
