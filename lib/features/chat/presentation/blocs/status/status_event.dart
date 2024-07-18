part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  final String userId;
  const StatusEvent({required this.userId});
}

class ConnectedEvent extends StatusEvent {
  const ConnectedEvent({required super.userId});

  @override
  List<Object> get props => [userId];
}

class DisconnectEvent extends StatusEvent {
  const DisconnectEvent({required super.userId});

  @override
  List<Object?> get props => [userId];
}
