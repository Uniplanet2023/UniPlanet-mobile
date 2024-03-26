part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  final List<String> online;
  const StatusState({required this.online});
}

final class StatusInitial extends StatusState {
  StatusInitial() : super(online: []);

  @override
  // TODO: implement props
  List<Object?> get props => [online];
}

final class StatusChanging extends StatusState {
  const StatusChanging({required super.online});
  @override
  // TODO: implement props
  List<Object?> get props => [online];
}

final class StatusChanged extends StatusState {
  const StatusChanged({required super.online});
  @override
  // TODO: implement props
  List<Object?> get props => [online];
}

final class StatusError extends StatusState {
  final String errMsg;
  const StatusError(this.errMsg, {required super.online});
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
