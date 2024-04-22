import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/constants/utils.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<ConnectedEvent>((event, emit) {
      if (!state.online.contains(event.userId)) {
        var updatedOnlineList = List<String>.from(state.online)
          ..add(event.userId);
        emit(StatusChanged(online: updatedOnlineList));
      }
    });
    on<DisconnectEvent>(((event, emit) {
      if (state.online.contains(event.userId)) {
        List<String> updatedList = List.from(state.online)
          ..remove(event.userId);
        emit(StatusChanged(online: updatedList));
      }
    }));
  }
  @override
  void onChange(Change<StatusState> change) {
    super.onChange(change);
    log(change);
  }

  @override
  void onTransition(Transition<StatusEvent, StatusState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}
