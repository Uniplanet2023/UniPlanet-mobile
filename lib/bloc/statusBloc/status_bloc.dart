import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/socket/socket_channel.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<StatusChangeEvent>((event, emit) {
      emit(StatusChanging(userOnList: state.userOnList));
      if (!state.userOnList!.contains(event.userId)) {
        state.userOnList!.add(event.userId);
        final List<String> list = state.userOnList!;
        emit(StatusChanged(userOnList: list));
      }
    });
    on<StatusDisconnectEvent>(((event, emit) {
      emit(StatusChanging(userOnList: state.userOnList));
      state.userOnList!.removeWhere((item) => item == event.userId);
      print("user ${event.userId} leave the app");
      final List<String> list = state.userOnList!;
      emit(StatusChanged(userOnList: list));
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
