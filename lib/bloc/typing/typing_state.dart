part of 'typing_bloc.dart';

sealed class TypingState extends Equatable {
  final bool typing;
  const TypingState({required this.typing});

  @override
  List<Object> get props => [];
}

final class TypingInitial extends TypingState {
  const TypingInitial() : super(typing: false);

  @override
  List<Object> get props => [];
}

final class TypingStarted extends TypingState {
  const TypingStarted() : super(typing: true);

  @override
  List<Object> get props => [];
}

final class TypingStopped extends TypingState {
  const TypingStopped() : super(typing: false);

  @override
  List<Object> get props => [];
}
