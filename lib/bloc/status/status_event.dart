part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  final String userId;
  const StatusEvent({required this.userId});
}

class StatusChangeEvent extends StatusEvent {
  const StatusChangeEvent({required super.userId});

  @override
  List<Object> get props => [userId];
}

class StatusDisconnectEvent extends StatusEvent {
  const StatusDisconnectEvent({required super.userId});

  @override
  List<Object?> get props => [userId];
}
