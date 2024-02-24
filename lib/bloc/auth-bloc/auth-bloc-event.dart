part of 'auth-bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class TokenValidationEvent extends AuthEvent {
  const TokenValidationEvent();
  @override
  List<Object> get props => [];
}

class OtpValidationEvent extends AuthEvent {
  final String email;
  final String otpCode;
  final String otpHash;
  const OtpValidationEvent(this.email, this.otpCode, this.otpHash);
  @override
  List<Object> get props => [otpCode, otpHash];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String school;
  const SignUpEvent(this.name, this.email, this.password, this.school);
  @override
  List<Object> get props => [name, email, password, school];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {
  final BuildContext context;
  const LogoutEvent(this.context);
  @override
  List<Object> get props => [context];
}

class LoadUserDataEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class UpdateOnlineStatusEvent extends AuthEvent {
  const UpdateOnlineStatusEvent();
  @override
  List<Object> get props => [];
}

class UpdateUserNotificationEvent extends AuthEvent {
  final int unSeenMessageNum;
  const UpdateUserNotificationEvent(this.unSeenMessageNum);
  @override
  List<Object> get props => [unSeenMessageNum];
}
