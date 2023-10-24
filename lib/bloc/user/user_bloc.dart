import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc(this._userRepository) : super(InitUserState()) {
    //When signIn event is happen, then call _userRepository.signIn
    on<SiginInEvent>(
      (event, emit) async {
        await _LoadUserState(event, emit);
      },
    );
  }
  _LoadUserState(SiginInEvent event, emit) async {
    emit(LoadingUserState(user: state.user));
    var result = await _userRepository.signInUser(
        context: event.context, email: event.email, password: event.password);
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

// User Event
abstract class UserEvent extends Equatable {}

class SiginInEvent extends UserEvent {
  final BuildContext context;
  final String email;
  final String password;
  SiginInEvent(this.context, this.email, this.password);
  @override
  // TODO: implement props
  List<Object?> get props => [
        {context, email, password}
      ];
}

class ClearUserEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

//State
abstract class UserState extends Equatable {
  final User? user;
  const UserState({this.user});
}

class InitUserState extends UserState {
  InitUserState()
      : super(
            user: User(
          id: '',
          name: '',
          password: '',
          email: '',
          isOnline: false,
          phoneNumber: '',
          address: '',
          type: '',
          token: '',
          like: [],
        ));

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class LoadingUserState extends UserState {
  const LoadingUserState({super.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class LoadedUserState extends UserState {
  const LoadedUserState({super.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class ErrorProductState extends UserState {
  final String errorMessage;
  const ErrorProductState(this.errorMessage);
  @override
  List<Object?> get props => [];
}
