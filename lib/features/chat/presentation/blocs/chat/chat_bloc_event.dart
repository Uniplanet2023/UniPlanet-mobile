part of 'chat_bloc.dart';

sealed class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();
}

class CreateChatRoomEvent extends ChatBlocEvent {
  final User seller;
  final User buyer;
  final String productId;
  final String productName;
  final String type;
  const CreateChatRoomEvent({
    required this.seller,
    required this.buyer,
    required this.productId,
    required this.productName,
    required this.type,
  });
  @override
  List<Object> get props => [seller, buyer, productId];
}

class AddChatRoomEvent extends ChatBlocEvent {
  final ChatRoom chatRoom;
  const AddChatRoomEvent(this.chatRoom);
  @override
  List<Object> get props => [chatRoom];
}

class LoadChatRoomEvent extends ChatBlocEvent {
  const LoadChatRoomEvent();
  @override
  List<Object> get props => [];
}

class LoadMoreChatRoomEvent extends ChatBlocEvent {
  const LoadMoreChatRoomEvent();
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

class UserInfoChangeEvent extends ChatBlocEvent {
  final String userId;
  const UserInfoChangeEvent(this.userId);

  @override
  List<Object> get props => [userId];
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

// delete chat room
class DeleteChatRoomEvent extends ChatBlocEvent {
  final String chatId;
  final String clientId;
  const DeleteChatRoomEvent({required this.chatId, required this.clientId});
  @override
  List<Object?> get props => [chatId, clientId];
}

class DeletedChatByClient extends ChatBlocEvent {
  final String chatId;
  final String clientId;
  const DeletedChatByClient({required this.chatId, required this.clientId});
  @override
  List<Object?> get props => [chatId, clientId];
}
