import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/account.dart';
import 'package:uniplanet_mobile/network/repository/account_repository/account_repo.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;
  AccountBloc(this._accountRepository)
      : super(AccountInitial(account: Account.initialAccount())) {
    on<GetAccountInfoEvent>((event, emit) async {
      await _getAccountInfo(event, emit);
    });
  }
  _getAccountInfo(GetAccountInfoEvent event, Emitter<AccountState> emit) async {
    emit(GettingAccountInfoState(account: state.account));
    try {
      Account result = await _accountRepository.getAccount();
      emit(GotAccountInfoState(account: result));
    } catch (e) {
      emit(FailedToGetAccountInfoState(
          message: e.toString(), account: state.account));
    }
  }

  //Tracking
  @override
  void onChange(Change<AccountState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<AccountEvent, AccountState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
