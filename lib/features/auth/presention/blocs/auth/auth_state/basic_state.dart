part of '../auth_bloc.dart';

sealed class AuthState extends Equatable {
  final AuthUserEntity? user;
  const AuthState({this.user});
  @override
  List<Object?> get props => [];
}

final class InitialState extends AuthState {
  const InitialState() : super();
  @override
  List<Object?> get props => [];
}

class ErrorAuthState extends AuthState {
  final String errMsg;
  const ErrorAuthState(this.errMsg);
  @override
  List<Object?> get props => [];
}
