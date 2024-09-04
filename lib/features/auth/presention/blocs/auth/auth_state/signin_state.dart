part of '../auth_bloc.dart';

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

final class Authorized extends AuthState {
  const Authorized(User user) : super(user: user);
  @override
  List<Object?> get props => [];
}

final class AuthenticationDeny extends AuthState {
  const AuthenticationDeny();
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

final class ValidationFailedState extends AuthState {
  const ValidationFailedState();
  @override
  List<Object?> get props => [];
}
