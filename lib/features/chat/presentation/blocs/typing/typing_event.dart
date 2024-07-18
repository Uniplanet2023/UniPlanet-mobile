part of 'typing_bloc.dart';

sealed class TypingEvent extends Equatable {
  final String chatId;
  const TypingEvent({required this.chatId});
  @override
  List<Object> get props => [chatId];
}

final class TypingStartEvent extends TypingEvent {
  const TypingStartEvent({required super.chatId});

  @override
  List<Object> get props => [];
}

final class TypingStopEvent extends TypingEvent {
  const TypingStopEvent({required super.chatId});

  @override
  List<Object> get props => [];
}
