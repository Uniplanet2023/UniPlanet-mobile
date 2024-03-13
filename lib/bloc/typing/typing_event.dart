part of 'typing_bloc.dart';

sealed class TypingEvent extends Equatable {
  const TypingEvent();
  @override
  List<Object> get props => [];
}

final class TypingStartEvent extends TypingEvent {
  const TypingStartEvent();

  @override
  List<Object> get props => [];
}

final class TypingStopEvent extends TypingEvent {
  const TypingStopEvent();

  @override
  List<Object> get props => [];
}
