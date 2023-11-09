part of 'message_bloc.dart';

abstract class MessageBlocState extends Equatable {
  final List<Message>? msgList;
  final int? page;
  const MessageBlocState({this.msgList, this.page});
}

class InitMessageState extends MessageBlocState {
  InitMessageState() : super(msgList: [], page: 0);
  @override
  List<Object?> get props => [msgList, page];
}

class LoadingMessageState extends MessageBlocState {
  const LoadingMessageState({super.msgList, super.page});
  @override
  List<Object?> get props => [msgList, page];
}

class LoadedMessageState extends MessageBlocState {
  const LoadedMessageState({super.msgList, super.page});
  @override
  List<Object?> get props => [msgList, page];
}

class EndMessageState extends MessageBlocState {
  const EndMessageState({super.msgList, super.page});
  @override
  List<Object?> get props => [msgList, page];
}
