part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final User? user;
  const UserState({this.user});
}

final class UserInitialState extends UserState {
  UserInitialState() : super(user: User.initialUser());
  @override
  List<Object?> get props => [user];
}

final class LoadingUserState extends UserState {
  const LoadingUserState({super.user});
  @override
  List<Object?> get props => [user];
}

final class LoadedUserState extends UserState {
  const LoadedUserState({super.user});
  @override
  List<Object?> get props => [user];
}

final class LogOutState extends UserState {
  const LogOutState({super.user});
  @override
  List<Object?> get props => [user];
}

class UpdatingOnlineState extends UserState {
  const UpdatingOnlineState({super.user});
  @override
  List<Object?> get props => [user];
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
