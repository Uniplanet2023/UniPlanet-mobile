import 'package:uniplanet_mobile/bloc/auth-bloc/auth-bloc.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/basic-state.dart';

final class LogOutState extends AuthState {
  const LogOutState();
  @override
  List<Object?> get props => [];
}

final class LogOutCompleteState extends AuthState {
  const LogOutCompleteState();
  @override
  List<Object?> get props => [];
}

final class LogOutFailedState extends AuthState {
  const LogOutFailedState();
  @override
  List<Object?> get props => [];
}
