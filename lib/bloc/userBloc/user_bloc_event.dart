part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends UserEvent {
  final String email;
  final String password;
  final BuildContext context;

  const SignInEvent(this.email, this.password, this.context);
  @override
  List<Object> get props => [email, password, context];
}

class LogoutEvent extends UserEvent {
  final BuildContext context;
  const LogoutEvent(this.context);
  @override
  List<Object> get props => [context];
}

class LoadUserDataEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class UpdateOnlineStatusEvent extends UserEvent {
  const UpdateOnlineStatusEvent();
  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends UserEvent {
  final User user;
  const UpdateUserEvent(this.user);
  @override
  List<Object> get props => [user];
}
