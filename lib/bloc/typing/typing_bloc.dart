import 'package:equatable/equatable.dart';
import 'package:uniplanet/bloc/index.dart';

part 'typing_event.dart';
part 'typing_state.dart';

class TypingBloc extends Bloc<TypingEvent, TypingState> {
  TypingBloc() : super(const TypingInitial()) {
    on<TypingEvent>((event, emit) {
      if (event is TypingStartEvent) {
        emit(TypingStarted(chatId: event.chatId));
      } else if (event is TypingStopEvent) {
        emit(TypingStopped(chatId: event.chatId));
      }
    });
  }
  @override
  void onChange(Change<TypingState> change) {
    super.onChange(change);
    // log(change);
  }
}
