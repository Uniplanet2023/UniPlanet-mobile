import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc(this._userRepository) : super(UserInitialState()) {
    on<SignInEvent>(
      (event, emit) async {
        await _signInFunction(event, emit);
      },
    );
  }
  _signInFunction(SignInEvent event, emit) async {
    emit(LoadingUserState(user: state.user));
    try {
      User user = await _userRepository.signInUser(
          context: event.context, email: event.email, password: event.password);
      emit(LoadedUserState(user: user));
    } catch (e) {
      print(e);
      throw Exception('No user Data');
    }
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
