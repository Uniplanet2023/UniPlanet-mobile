part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final User? user;
  final int? unSeenMessageNum;
  const UserState({this.user, this.unSeenMessageNum});
}

final class UserInitialState extends UserState {
  UserInitialState() : super(user: User.initialUser(), unSeenMessageNum: 0);
  @override
  List<Object?> get props => [user];
}

final class LoadingUserState extends UserState {
  const LoadingUserState({super.user, super.unSeenMessageNum});
  @override
  List<Object?> get props => [user, unSeenMessageNum];
}

final class LoadedUserState extends UserState {
  const LoadedUserState({super.user, super.unSeenMessageNum});
  @override
  List<Object?> get props => [user, unSeenMessageNum];
}

final class LogOutState extends UserState {
  const LogOutState({super.user, super.unSeenMessageNum});
  @override
  List<Object?> get props => [user, unSeenMessageNum];
}

class UpdatingOnlineState extends UserState {
  const UpdatingOnlineState({super.user, super.unSeenMessageNum});
  @override
  List<Object?> get props => [user, unSeenMessageNum];
}

class UpdatedOnlineState extends UserState {
  const UpdatedOnlineState({super.user});
  @override
  List<Object?> get props => [user];
}

class ErrorUserState extends UserState {
  final String errMsg;
  const ErrorUserState(this.errMsg);
  @override
  List<Object?> get props => [];
}
