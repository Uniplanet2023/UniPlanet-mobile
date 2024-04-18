part of '../auth_bloc.dart';

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

final class SignupSuccessState extends AuthState {
  final String hash;
  const SignupSuccessState({required this.hash});
  @override
  List<Object?> get props => [hash];
}

final class UserNotVerifiedState extends AuthState {
  const UserNotVerifiedState();
  @override
  List<Object?> get props => [];
}

// Opt Validation State
final class OtpValidatingState extends AuthState {
  const OtpValidatingState();
  @override
  List<Object?> get props => [];
}

final class OTPValidationRequireState extends AuthState {
  final String hash;
  const OTPValidationRequireState({required this.hash});
  @override
  List<Object?> get props => [hash];
}

// OTP Validation Request State
final class OTPValidationRequestState extends AuthState {
  const OTPValidationRequestState();
  @override
  List<Object?> get props => [];
}

final class OTPValidationRequestFailState extends AuthState {
  const OTPValidationRequestFailState();
  @override
  List<Object?> get props => [];
}

final class OTPValidationCompleteState extends AuthState {
  const OTPValidationCompleteState();
  @override
  List<Object?> get props => [];
}

// OTP Validation Failed State
final class OtpValidationFailedState extends AuthState {
  final String hash;
  const OtpValidationFailedState({required this.hash});
  @override
  List<Object?> get props => [hash];
}
