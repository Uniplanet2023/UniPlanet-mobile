part of 'message_bloc.dart';

sealed class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMessageEvent extends MessageBlocEvent {
  final String chatId;
  const GetMessageEvent(this.chatId);
  @override
  List<Object> get props => [chatId];
}

class GetMoreMessageEvent extends MessageBlocEvent {
  final String chatId;
  const GetMoreMessageEvent(this.chatId);
  @override
  List<Object> get props => [chatId];
}

// Send Text Message Event
class SendingMessageEvent extends MessageBlocEvent {
  final Message tempMessage;
  const SendingMessageEvent({required this.tempMessage});
  @override
  List<Object> get props => [tempMessage];
}

// Sent Message Event
class SentMessageEvent extends MessageBlocEvent {
  final Message message;
  const SentMessageEvent(this.message);
  @override
  List<Object> get props => [message];
}

// Send Text Message Event
class SendTextMessageEvent extends MessageBlocEvent {
  final String chatId;
  final String receiverId;
  final String message;
  final BuildContext context;
  const SendTextMessageEvent({
    required this.chatId,
    required this.message,
    required this.receiverId,
    required this.context,
  });
  @override
  List<Object> get props => [chatId, message, receiverId, context];
}

class SendMediaMessageEvent extends MessageBlocEvent {
  final String chatId;
  final String receiverId;
  final List<XFile> mediaList;

  const SendMediaMessageEvent({
    required this.chatId,
    required this.mediaList,
    required this.receiverId,
  });
  @override
  List<Object> get props => [chatId, mediaList, receiverId];
}

// Retry Sending Message Event
class RetrySendMessagesEvent extends MessageBlocEvent {
  final List<Message> messages;
  const RetrySendMessagesEvent(this.messages);
  @override
  List<Object> get props => [messages];
}

class ReceiveMessageEvent extends MessageBlocEvent {
  final Message msg;
  const ReceiveMessageEvent(this.msg);
  @override
  List<Object> get props => [msg];
}

class ReadAllMessages extends MessageBlocEvent {
  final String chatId;
  final DateTime readDate;
  const ReadAllMessages(this.chatId, this.readDate);
  @override
  List<Object> get props => [chatId, readDate];
}

class ReadMessageEvent extends MessageBlocEvent {
  final String messageId;
  final String chatId;
  final DateTime readDate;
  const ReadMessageEvent(
      {required this.messageId, required this.chatId, required this.readDate});
  @override
  List<Object> get props => [chatId, readDate];
}

//Error Message
class ErrorMessageEvent extends MessageBlocEvent {
  final Message errorMessage;
  const ErrorMessageEvent(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
