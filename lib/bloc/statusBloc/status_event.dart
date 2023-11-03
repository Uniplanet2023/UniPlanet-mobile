part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();
}

class StatusChangeEvent extends StatusEvent {
  final String userId;
  const StatusChangeEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class StatusDisconnectEvent extends StatusEvent {
  final String userId;
  const StatusDisconnectEvent(this.userId);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
