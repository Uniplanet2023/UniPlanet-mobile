import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'typing_event.dart';
part 'typing_state.dart';

class TypingBloc extends Bloc<TypingEvent, TypingState> {
  TypingBloc() : super(const TypingInitial()) {
    on<TypingEvent>((event, emit) {
      if (event is TypingStartEvent) {
        emit(const TypingStarted());
      } else if (event is TypingStopEvent) {
        emit(const TypingStopped());
      }
    });
  }
}
