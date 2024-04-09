part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

final class AccountInitialEvent extends AccountEvent {
  const AccountInitialEvent();
}

final class GetAccountInfoEvent extends AccountEvent {
  const GetAccountInfoEvent();
}

final class UpdateNameEvent extends AccountEvent {
  final String name;
  const UpdateNameEvent({required this.name});
  @override
  List<Object> get props => [name];
}
