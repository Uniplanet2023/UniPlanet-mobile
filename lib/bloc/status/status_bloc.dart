import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<StatusChangeEvent>((event, emit) {
      emit(StatusChanging(online: state.online));
      state.online.replaceRange(0, state.online.length, [event.userId]);
      emit(StatusChanged(online: state.online));
    });
    on<StatusDisconnectEvent>(((event, emit) {
      emit(StatusChanging(online: state.online));
      state.online.replaceRange(0, state.online.length, [event.userId]);
      emit(StatusChanged(online: state.online));
    }));
  }
  @override
  void onChange(Change<StatusState> change) {
    super.onChange(change);
    // print(change);
  }

  @override
  void onTransition(Transition<StatusEvent, StatusState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
