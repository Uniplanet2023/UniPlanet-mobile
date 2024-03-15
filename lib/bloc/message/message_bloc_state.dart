part of 'message_bloc.dart';

abstract class MessageBlocState extends Equatable {
  final List<Message> messages;
  final int? page;
  const MessageBlocState({required this.messages, this.page});
}

class InitMessageState extends MessageBlocState {
  InitMessageState() : super(messages: [], page: 0);
  @override
  List<Object?> get props => [messages, page];
}

class LoadingMessageState extends MessageBlocState {
  const LoadingMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [messages, page];
}

class LoadedMessageState extends MessageBlocState {
  const LoadedMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [messages, page];
}

//Receive Message
class ReceivingMessageState extends MessageBlocState {
  const ReceivingMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [messages, page];
}

class ReceivedMessageState extends MessageBlocState {
  const ReceivedMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [messages, page];
}

class EndMessageState extends MessageBlocState {
  const EndMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [messages, page];
}

class UnReadMessageState extends MessageBlocState {
  const UnReadMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [];
}

class ReadMessageState extends MessageBlocState {
  const ReadMessageState({required super.messages, super.page});
  @override
  List<Object?> get props => [];
}
