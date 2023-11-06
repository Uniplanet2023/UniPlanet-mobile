import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/global_variables.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc(this._userRepository) : super(UserInitialState()) {
    on<SignInEvent>((event, emit) async {
      await _signInFunction(event, emit);
    });
    on<LogOutEvent>((event, emit) async {
      await _logOutFunction(event, emit);
    });
    on<LoadUserDataEvent>((event, emit) async {
      await _loadingUserFunction(event, emit);
    });
  }
  _loadingUserFunction(LoadUserDataEvent event, emit) async {
    emit(LoadingUserState(user: state.user));
    User user = await _userRepository.getUserData();
    if (user.token != '') {
      emit(LoadedUserState(user: user));
    } else {
      emit(const ErrorUserState('No User Data'));
    }
  }

  _signInFunction(SignInEvent event, emit) async {
    try {
      emit(LoadingUserState(user: state.user));

      User user = await _userRepository.signInUser(
          email: event.email, password: event.password);

      if (user.token != '') {
        _navigate(event);
        emit(LoadedUserState(user: user));
      } else {
        emit(const ErrorUserState('No User Data'));
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
      throw Exception('No user Data');
    }
  }

  _navigate(event) {
    Navigator.pushNamedAndRemoveUntil(
      event.context,
      BottomBar.routeName,
      (route) => false,
    );
  }

  _logOutFunction(LogOutEvent event, emit) async {
    emit(LogOutState(user: User.initialUser()));
    UserRepository().logOut();
  }

  //Tracking
  @override
  void onChange(Change<UserState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(Transition<UserEvent, UserState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
