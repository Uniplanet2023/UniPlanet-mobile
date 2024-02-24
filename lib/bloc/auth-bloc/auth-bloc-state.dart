part of 'auth-bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

final class InitialState extends AuthState {
  const InitialState() : super();
  @override
  List<Object?> get props => [];
}

// Token Validation State
final class TokenValidatingState extends AuthState {
  const TokenValidatingState();
  @override
  List<Object?> get props => [];
}

final class TokenValidationCompleteState extends AuthState {
  const TokenValidationCompleteState();
  @override
  List<Object?> get props => [];
}

// Opt Validation State
final class OtpValidatingState extends AuthState {
  const OtpValidatingState();
  @override
  List<Object?> get props => [];
}

final class OtpValidationCompleteState extends AuthState {
  const OtpValidationCompleteState();
  @override
  List<Object?> get props => [];
}

// Validation Fail State
final class ValidationFailedState extends AuthState {
  const ValidationFailedState();
  @override
  List<Object?> get props => [];
}

// Sign Up State
final class SignupState extends AuthState {
  const SignupState();
  @override
  List<Object?> get props => [];
}

final class SignupFailedState extends AuthState {
  const SignupFailedState();
  @override
  List<Object?> get props => [];
}

final class OTPValidationRequireState extends AuthState {
  final String? hash;
  const OTPValidationRequireState({this.hash});
  @override
  List<Object?> get props => [hash];
}

// Sign In State
final class SigninState extends AuthState {
  const SigninState();
  @override
  List<Object?> get props => [];
}

final class SigninFailedState extends AuthState {
  const SigninFailedState();
  @override
  List<Object?> get props => [];
}

final class SigninSuccessState extends AuthState {
  const SigninSuccessState();
  @override
  List<Object?> get props => [];
}

// final class LoadingAuthState extends AuthState {
//   const LoadingAuthState();
//   @override
//   List<Object?> get props => [];
// }

// final class LoadedAuthState extends AuthState {
//   const LoadedAuthState();
//   @override
//   List<Object?> get props => [
//         ,
//       ];
// }

final class LogOutState extends AuthState {
  const LogOutState();
  @override
  List<Object?> get props => [];
}

// class UpdatingOnlineState extends AuthState {
//   const UpdatingOnlineState();
//   @override
//   List<Object?> get props => [
//         ,
//       ];
// }

// class UpdatedOnlineState extends AuthState {
//   const UpdatedOnlineState();
//   @override
//   List<Object?> get props => [];
// }

// Auth
final class Authorized extends AuthState {
  const Authorized();
  @override
  List<Object?> get props => [];
}

final class AuthenticationDeny extends AuthState {
  const AuthenticationDeny();
  @override
  List<Object?> get props => [];
}

class ErrorAuthState extends AuthState {
  final String errMsg;
  const ErrorAuthState(this.errMsg);
  @override
  List<Object?> get props => [];
}
