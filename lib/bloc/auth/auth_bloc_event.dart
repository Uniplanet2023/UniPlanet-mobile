part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
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
  final bool isStudent;
  const SignUpEvent(
      this.name, this.email, this.password, this.school, this.isStudent);
  @override
  List<Object> get props => [name, email, password, school];
}

class RequestOtpEvent extends AuthEvent {
  final String email;
  const RequestOtpEvent(this.email);
  @override
  List<Object> get props => [email];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
  @override
  List<Object> get props => [];
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

class UpdatePasswordEvent extends AuthEvent {
  final String password;
  final String newPassword;
  const UpdatePasswordEvent(
      {required this.password, required this.newPassword});
  @override
  List<Object> get props => [password, newPassword];
}

final class ResetPasswordEvent extends AuthEvent {
  final String email;
  const ResetPasswordEvent({required this.email});
  @override
  List<Object> get props => [email];
}

final class DeleteUserEvent extends AuthEvent {
  const DeleteUserEvent();
  @override
  List<Object> get props => [];
}
