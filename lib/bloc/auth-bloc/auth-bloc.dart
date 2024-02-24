import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/common/widgets/bottom_bar.dart';
import 'package:uniplanet_mobile/constants/utils.dart';
import 'package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart';
import 'package:uniplanet_mobile/models/user.dart';
import 'package:uniplanet_mobile/repository/auth-repository/auth-repo.dart';

part 'auth-bloc-event.dart';
part 'auth-bloc-state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(const InitialState()) {
    on<TokenValidationEvent>((event, emit) async {
      // listen all the time
      await _tokenValidationFunction(event, emit);
    });
    on<OtpValidationEvent>((event, emit) async {
      // listen all the time
      await _otpValidationFunction(event, emit);
    });
    on<SignUpEvent>((event, emit) async {
      await _signupFunction(event, emit);
    });
    on<SignInEvent>((event, emit) async {
      // listen all the time
      await _signInFunction(event, emit);
    });
    on<LogoutEvent>((event, emit) async {
      await _logOutFunction(event, emit);
    });
  }

  _tokenValidationFunction(TokenValidationEvent event, emit) async {
    emit(const TokenValidatingState());

    await _authRepository.tokenValidation()
        ? emit(const Authorized())
        : emit(const AuthenticationDeny());
  }

  _otpValidationFunction(OtpValidationEvent event, emit) async {
    emit(const OtpValidatingState());

    await _authRepository.otpValidation(
            event.email, event.otpHash, event.otpCode)
        ? emit(const OtpValidationCompleteState())
        : emit(const ValidationFailedState());
  }

  _signupFunction(SignUpEvent event, emit) async {
    try {
      emit(const SignupState());
      String? hash = await _authRepository.signUpUser(
          email: event.email,
          password: event.password,
          name: event.name,
          school: event.school);
      if (hash != null) {
        emit(OTPValidationRequireState(hash: hash));
      } else {
        emit(const SignupFailedState());
      }
    } catch (e) {
      emit(const SignupFailedState());
    }
  }

  // _updateUserFunction(UpdateUserNotificationEvent event, emit) async {
  //   emit(const LoadedAuthState());
  // }

  // _loadingUserFunction(LoadUserDataEvent event, emit) async {
  //   emit(LoadingAuthState(user: state.user));
  //   // User user = await _authRepository.getUserData();
  //   // if (user.token != '') {
  //   //   emit(LoadedAuthState(
  //   //       user: user, unSeenMessageNum: state.unSeenMessageNum));
  //   // } else {
  //   //   emit(const ErrorAuthState('No User Data'));
  //   // }
  // }

  _signInFunction(SignInEvent event, emit) async {
    try {
      emit(const SigninState());

      await _authRepository.signInUser(
          email: event.email, password: event.password);

      emit(const Authorized());
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          SnackbarGlobal.showSnackBar(e.response!.data['msg'].toString());
        }
      }
      throw Exception('No user Data');
    }
  }

  _logOutFunction(LogoutEvent event, emit) async {
    emit(const LogOutState());
    _authRepository.logOut(event.context);
  }

  //Tracking
  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
