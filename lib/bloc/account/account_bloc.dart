import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
import 'package:uniplanet_mobile/global.dart';
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
    on<UpdateNameEvent>((event, emit) async {
      await _updateName(event, emit);
    });
    on<UpdateProfileImageEvent>((event, emit) async {
      await _updateProfileImage(event, emit);
    });
  }
  _updateProfileImage(
      UpdateProfileImageEvent event, Emitter<AccountState> emit) async {
    emit(UpdatingProfileImageState(account: state.account));
    final response = await Global.cloudinary.uploadFile(
        CloudinaryFile.fromFile(event.image.path, folder: 'product-images'));

    Account? account = await _accountRepository.updateProfileImage(
        profileImage: response.secureUrl);
    if (account != null) {
      emit(UpdatedProfileImageState(account: account));
    } else {
      emit(FailedToUpdateProfileImageState(
          message: 'Fail to update profile image', account: state.account));
    }
  }

  _updateName(UpdateNameEvent event, Emitter<AccountState> emit) async {
    emit(UpdatingNameState(account: state.account));
    Account? account = await _accountRepository.updateName(name: event.name);
    if (account != null) {
      emit(UpdatedNameState(account: account));
    } else {
      emit(FailedToUpdateNameState(
          message: 'Fail to update name', account: state.account));
    }
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
