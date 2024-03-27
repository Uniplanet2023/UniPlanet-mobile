import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/message.dart';
import 'package:uniplanet_mobile/models/user_model.dart';

abstract class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();
}

class CreateChatRoomEvent extends ChatBlocEvent {
  final User seller;
  final User buyer;
  final String productId;
  const CreateChatRoomEvent({
    required this.seller,
    required this.buyer,
    required this.productId,
  });
  @override
  List<Object> get props => [seller, buyer, productId];
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

class UpdateChatRoomLastMessageEvent extends ChatBlocEvent {
  final Message lastMessage;
  const UpdateChatRoomLastMessageEvent(this.lastMessage);
  @override
  List<Object> get props => [lastMessage];
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

//Unseen Message
class UpdateUnseenMessageEvent extends ChatBlocEvent {
  final String chatId;
  const UpdateUnseenMessageEvent({required this.chatId});
  @override
  List<Object> get props => [];
}

class EmptyUnseenMessageEvent extends ChatBlocEvent {
  final String chatId;
  const EmptyUnseenMessageEvent({required this.chatId});
  @override
  List<Object?> get props => [chatId];
}
