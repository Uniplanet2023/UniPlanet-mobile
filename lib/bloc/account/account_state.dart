part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  final Account account;
  const AccountState({required this.account});

  @override
  List<Object> get props => [account];
}

final class AccountInitial extends AccountState {
  const AccountInitial({required super.account});
}

final class GettingAccountInfoState extends AccountState {
  const GettingAccountInfoState({required super.account});
}

final class GotAccountInfoState extends AccountState {
  const GotAccountInfoState({required super.account});
}

final class FailedToGetAccountInfoState extends AccountState {
  final String message;
  const FailedToGetAccountInfoState(
      {required this.message, required super.account});
  @override
  List<Object> get props => [message];
}

final class UpdatingNameState extends AccountState {
  const UpdatingNameState({required super.account});
}

final class UpdatedNameState extends AccountState {
  const UpdatedNameState({required super.account});
}

final class FailedToUpdateNameState extends AccountState {
  final String message;
  const FailedToUpdateNameState(
      {required this.message, required super.account});
  @override
  List<Object> get props => [message];
}

final class UpdatingProfileImageState extends AccountState {
  const UpdatingProfileImageState({required super.account});
}

final class UpdatedProfileImageState extends AccountState {
  const UpdatedProfileImageState({required super.account});
}

final class FailedToUpdateProfileImageState extends AccountState {
  final String message;
  const FailedToUpdateProfileImageState(
      {required this.message, required super.account});
  @override
  List<Object> get props => [message];
}
