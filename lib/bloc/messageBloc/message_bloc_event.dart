part of 'message_bloc.dart';

abstract class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMessageEvent extends MessageBlocEvent {
  final String myChatRoomId;
  const GetMessageEvent(this.myChatRoomId);
  @override
  List<Object> get props => [myChatRoomId];
}

class GetMoreMessageEvent extends MessageBlocEvent {
  final String myChatRoomId;
  const GetMoreMessageEvent(this.myChatRoomId);
  @override
  List<Object> get props => [myChatRoomId];
}

class SendMessageEvent extends MessageBlocEvent {
  final String msg;
  final String senderId;
  final String chatRoomId;
  const SendMessageEvent(this.chatRoomId, this.senderId, this.msg);
  @override
  List<Object> get props => [msg, chatRoomId];
}

class ReceiveMessageEvent extends MessageBlocEvent {
  final Message msg;
  const ReceiveMessageEvent(this.msg);
  @override
  List<Object> get props => [msg];
}
