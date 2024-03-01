import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
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
