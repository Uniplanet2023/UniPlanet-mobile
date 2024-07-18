part of 'typing_bloc.dart';

sealed class TypingState extends Equatable {
  final String chatId;
  final bool typing;
  const TypingState({required this.chatId, required this.typing});

  @override
  List<Object> get props => [];
}

final class TypingInitial extends TypingState {
  const TypingInitial() : super(typing: false, chatId: '');

  @override
  List<Object> get props => [];
}

final class TypingStarted extends TypingState {
  const TypingStarted({required super.chatId}) : super(typing: true);

  @override
  List<Object> get props => [];
}

final class TypingStopped extends TypingState {
  const TypingStopped({required super.chatId}) : super(typing: false);

  @override
  List<Object> get props => [];
}
