part of 'message_bloc.dart';

abstract class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMessageEvent extends MessageBlocEvent {
  final List<String> msgList;
  const GetMessageEvent(this.msgList);
  @override
  List<Object> get props => [msgList];
}

class SendMessageEvent extends MessageBlocEvent {
  const SendMessageEvent();
  @override
  List<Object> get props => [];
}
