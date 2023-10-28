part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SignInEvent extends UserEvent {
  final BuildContext context;
  final String email;
  final String password;
  const SignInEvent(this.context, this.email, this.password);
  @override
  List<Object> get props => [context, email, password];
}

class LogOutEvent extends UserEvent {
  @override
  List<Object> get props => [];
}
