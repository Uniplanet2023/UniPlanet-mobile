part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  final List<String>? userOnList;
  const StatusState({this.userOnList});
}

final class StatusInitial extends StatusState {
  StatusInitial() : super(userOnList: []);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class StatusChanging extends StatusState {
  const StatusChanging({super.userOnList});
  @override
  // TODO: implement props
  List<Object?> get props => [userOnList];
}

final class StatusChanged extends StatusState {
  const StatusChanged({super.userOnList});
  @override
  // TODO: implement props
  List<Object?> get props => [userOnList];
}
