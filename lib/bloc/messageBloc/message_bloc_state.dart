part of 'message_bloc.dart';

abstract class MessageBlocState extends Equatable {
  final List<Message>? msgList;
  const MessageBlocState({this.msgList});
}

class InitMessageState extends MessageBlocState {
  InitMessageState() : super(msgList: []);
  @override
  List<Object?> get props => [msgList];
}

class LoadingMessageState extends MessageBlocState {
  const LoadingMessageState({super.msgList});
  @override
  List<Object?> get props => [msgList];
}

class LoadedMessageState extends MessageBlocState {
  const LoadedMessageState({super.msgList});
  @override
  List<Object?> get props => [msgList];
}
