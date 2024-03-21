part of 'message_bloc.dart';

abstract class MessageBlocState extends Equatable {
  final Map<String, List<Message>> chatMessages;
  final int? page;
  const MessageBlocState({required this.chatMessages, this.page});
}

class InitMessageState extends MessageBlocState {
  InitMessageState() : super(chatMessages: {}, page: 0);
  @override
  List<Object?> get props => [chatMessages, page];
}

class LoadingMessageState extends MessageBlocState {
  const LoadingMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class LoadedMessageState extends MessageBlocState {
  const LoadedMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

//Receive Message
class ReceivingMessageState extends MessageBlocState {
  const ReceivingMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class ReceivedMessageState extends MessageBlocState {
  const ReceivedMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class EndMessageState extends MessageBlocState {
  const EndMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [chatMessages, page];
}

class UnReadMessageState extends MessageBlocState {
  const UnReadMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [];
}

class ReadMessageState extends MessageBlocState {
  const ReadMessageState({super.page, required super.chatMessages});
  @override
  List<Object?> get props => [];
}
