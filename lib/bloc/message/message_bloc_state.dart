part of 'message_bloc.dart';

sealed class MessageBlocState extends Equatable {
  final Map<String, List<Message>> chatMessages;
  final Map<String, List<Message>> pendingMessages;
  final int? page;
  const MessageBlocState(
      {required this.chatMessages, required this.pendingMessages, this.page});
}

class InitMessageState extends MessageBlocState {
  InitMessageState() : super(chatMessages: {}, pendingMessages: {}, page: 0);
  @override
  List<Object?> get props => [chatMessages, page];
}

class LoadingMessageState extends MessageBlocState {
  const LoadingMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class LoadedMessageState extends MessageBlocState {
  const LoadedMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

//Receive Message
class ReceivingMessageState extends MessageBlocState {
  const ReceivingMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class ReceivedMessageState extends MessageBlocState {
  const ReceivedMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class EndMessageState extends MessageBlocState {
  const EndMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class UnReadMessageState extends MessageBlocState {
  const UnReadMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class ReadMessageState extends MessageBlocState {
  const ReadMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

//Sending Image
class SendingMessageState extends MessageBlocState {
  const SendingMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});
  @override
  List<Object?> get props => [page, chatMessages, pendingMessages];
}

class PendingMessateState extends MessageBlocState {
  final Message newMessage;
  const PendingMessateState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages,
      required this.newMessage});
  @override
  List<Object?> get props => [page, chatMessages, pendingMessages, newMessage];
}

class SentMessageState extends MessageBlocState {
  const SentMessageState(
      {super.page,
      required super.chatMessages,
      required super.pendingMessages});

  @override
  List<Object?> get props => [page, chatMessages, pendingMessages];
}

//Error
class ErrorMessageState extends MessageBlocState {
  const ErrorMessageState({
    required super.chatMessages,
    required super.pendingMessages,
    required super.page,
  });
  @override
  List<Object?> get props => [chatMessages, pendingMessages, page];
}
