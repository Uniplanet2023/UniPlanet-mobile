import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/basic-state.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/logout-state.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/signin-state.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-state/signup-state.dart';
import 'package:uniplanet_mobile/network/api-status/signup.dart';
import 'package:uniplanet_mobile/repository/auth-repository/auth-repo.dart';

part 'auth-bloc-event.dart';

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
    on<RequestOtpEvent>((event, emit) async {
      // listen all the time
      await _otpRequestFunction(event, emit);
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
  _otpRequestFunction(RequestOtpEvent event, emit) async {
    emit(const OTPValidationRequestState());
    String hash = await _authRepository.requestOtp(email: event.email);
    if (hash != 'Failed') {
      emit(OTPValidationRequireState(hash: hash));
    } else {
      emit(const OTPValidationRequestFailState());
    }
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
        ? emit(const OTPValidationCompleteState())
        : emit(OtpValidationFailedState(hash: event.otpHash));
  }

  _signupFunction(SignUpEvent event, emit) async {
    try {
      emit(const SignupState());
      String hash = await _authRepository.signUpUser(
          email: event.email,
          password: event.password,
          name: event.name,
          school: event.school);
      if (hash != 'Failed') {
        emit(OTPValidationRequireState(hash: hash));
      } else {
        emit(const OTPValidationRequestFailState());
      }
    } catch (e) {
      emit(const SignupFailedState());
    }
  }

  _signInFunction(SignInEvent event, emit) async {
    try {
      emit(const SigninState());

      String msg = await _authRepository.signInUser(
          email: event.email, password: event.password);
      if (msg == 'success') {
        emit(const Authorized());
      } else if (msg == USER_NOT_VERIFIED) {
        emit(const UserNotVerifiedState());
      } else {
        emit(const SigninFailedState());
      }
    } catch (e) {
      throw Exception('Something Went Wrong');
    }
  }

  _logOutFunction(LogoutEvent event, emit) async {
    emit(const LogOutState());
    String message = await _authRepository.logOut();
    if (message == 'Logged Out Successfully') {
      emit(const LogOutCompleteState());
    } else {
      emit(const LogOutFailedState());
    }
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
