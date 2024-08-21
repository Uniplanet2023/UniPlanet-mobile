import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/get_account_info_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/params/update_profile_picture_params.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/update_name_usecase.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/update_profile_picture_usecase.dart';

import '../../../../../core/utils/utils.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  // usecase
  final GetAccountInfoUseCase getAccountInfoUseCase;
  final UpdateNameUseCase updateNameUseCase;
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;

  AccountBloc({
    required this.getAccountInfoUseCase,
    required this.updateNameUseCase,
    required this.updateProfilePictureUseCase,
  }) : super(AccountInitial(account: AccountEntity.initialAccount())) {
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

    await updateProfilePictureUseCase(UpdateProfilePictureParams(
      image: File(event.image.path),
      userId: state.account.user.id,
      school: state.account.user.school,
    )).then((value) {
      value.fold(
        (failure) {
          emit(FailedToUpdateProfileImageState(
              message: failure.toString(), account: state.account));
        },
        (account) {
          emit(UpdatedProfileImageState(account: account));
        },
      );
    });
  }

  _updateName(UpdateNameEvent event, Emitter<AccountState> emit) async {
    emit(UpdatingNameState(account: state.account));
    await updateNameUseCase(event.name).then((result) {
      result.fold(
        (failure) {
          emit(FailedToUpdateNameState(
              message: failure.toString(), account: state.account));
        },
        (account) {
          emit(UpdatedNameState(account: account));
        },
      );
    });
  }

  _getAccountInfo(GetAccountInfoEvent event, Emitter<AccountState> emit) async {
    emit(GettingAccountInfoState(account: state.account));
    await getAccountInfoUseCase(NoParams()).then((result) {
      result.fold(
        (failure) {
          emit(FailedToGetAccountInfoState(
              message: failure.toString(), account: state.account));
        },
        (account) {
          emit(GotAccountInfoState(account: account));
        },
      );
    });
  }

  //Tracking
  @override
  void onChange(Change<AccountState> change) {
    super.onChange(change);
    log(change);
  }

  @override
  void onTransition(Transition<AccountEvent, AccountState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}
