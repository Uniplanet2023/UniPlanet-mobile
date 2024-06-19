import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/common/functions/init_data.dart';
import 'package:uniplanet/constants/utils.dart';
import 'package:uniplanet/global.dart';
import 'package:uniplanet/api/repository/auth_repository/auth_repo.dart';

part 'auth_bloc_event.dart';
part 'auth_state/basic_state.dart';
part 'auth_state/logout_state.dart';
part 'auth_state/signin_state.dart';
part 'auth_state/signup_state.dart';
part 'auth_state/update_password_state.dart';
part 'auth_state/reset_password_state.dart';
part 'auth_state/delete_user_state.dart';

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
    on<UpdatePasswordEvent>((event, emit) async {
      await _updatePasswordFunction(event, emit);
    });
    on<ResetPasswordEvent>((event, emit) async {
      await _resetPasswordFunction(event, emit);
    });
    on<DeleteUserEvent>((event, emit) async {
      await _deleteUserFunction(event, emit);
    });
  }

  _deleteUserFunction(DeleteUserEvent event, emit) async {
    emit(const DeleteUserState());
    bool isSuccess = await _authRepository.deleteUser();
    BuildContext context = SnackbarGlobal.key.currentContext!;
    if (context.mounted) {
      context.read<ChatBloc>().state.chatRooms.forEach((element) {
        var clientId = element.buyer.id == AuthRepository.userId
            ? element.seller.id
            : element.buyer.id;
        Global.socketService.sendDeleteChatRoomEvent(element.id, clientId);
      });
    }
    if (isSuccess) {
      emit(const DeleteUserCompleteState());
    } else {
      emit(const DeleteUserFailedState());
    }
  }

  _resetPasswordFunction(ResetPasswordEvent event, emit) async {
    emit(const ResetPasswordState());
    bool isSuccess = await _authRepository.resetPassword(email: event.email);
    if (isSuccess) {
      emit(const ResetPasswordCompleteState());
    } else {
      emit(const ResetPasswordFailedState());
    }
  }

  _updatePasswordFunction(UpdatePasswordEvent event, emit) async {
    emit(const UpdatePasswordState());
    String message = await _authRepository.updatePassword(
        password: event.password, newPassword: event.newPassword);
    if (message == 'Password Updated Successfully') {
      emit(const LogOutCompleteState());
    } else {
      emit(const UpdatePasswordFailedState());
    }
  }

  _otpRequestFunction(RequestOtpEvent event, emit) async {
    emit(const OTPValidationRequestState());
    String hash = await _authRepository.requestOtp(email: event.email);
    if (hash != 'Failed') {
      SnackbarGlobal.showSnackBar(
        "OTP Code Sent Successfully",
      );
      emit(OTPValidationRequireState(hash: hash));
    } else {
      emit(const OTPValidationRequestFailState());
    }
  }

  _tokenValidationFunction(TokenValidationEvent event, emit) async {
    emit(const TokenValidatingState());

    bool auth = await _authRepository.tokenValidation();
    if (auth) {
      await initData();
      emit(const Authorized());
    } else {
      emit(const AuthenticationDeny());
    }
  }

  _otpValidationFunction(OtpValidationEvent event, emit) async {
    emit(const OtpValidatingState());

    bool isVerified = await _authRepository.otpValidation(
        event.email, event.otpHash, event.otpCode);
    if (isVerified) {
      emit(const OTPValidationCompleteState());
      SnackbarGlobal.showSnackBar(
        "OTP Verified Successfully",
      );
    } else {
      emit(OtpValidationFailedState(hash: event.otpHash));
    }
  }

  _signupFunction(SignUpEvent event, emit) async {
    try {
      emit(const SignupState());
      String hash = await _authRepository.signUpUser(
          email: event.email,
          password: event.password,
          name: event.name,
          school: event.school,
          isStudent: event.isStudent);
      if (hash != 'Failed') {
        emit(SignupSuccessState(hash: hash));
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
        await initData();
        emit(const Authorized());
      } else if (msg == 'Verification required') {
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
      Global.socketService.disconnect();
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
    log(transition);
  }
}
