import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/initialization/init_data.dart';
import 'package:uniplanet/core/local_stoarage/local_stoarage.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/features/auth/domain/usecases/index.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/opt_validation_params.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/sign_in_params.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';

part 'auth_bloc_event.dart';
part 'auth_state/basic_state.dart';
part 'auth_state/logout_state.dart';
part 'auth_state/signin_state.dart';
part 'auth_state/signup_state.dart';
part 'auth_state/update_password_state.dart';
part 'auth_state/reset_password_state.dart';
part 'auth_state/delete_user_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUser signIn;
  final SignUpUser signUp;
  final SignOutUser signOut;
  final ResetPassword resetPassword;
  final DeleteUser deleteUser;
  final OtpValidation otpValidation;
  final OtpRequest otpRequest;
  final TokenValidation tokenValidation;
  final UpdatePassword updatePassword;
  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.resetPassword,
    required this.deleteUser,
    required this.otpValidation,
    required this.otpRequest,
    required this.tokenValidation,
    required this.updatePassword,
  }) : super(const InitialState()) {
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
    Either<Failure, bool> isDeleted = await deleteUser(NoParams());
    isDeleted.fold((l) => emit(const DeleteUserFailedState()),
        (r) => emit({const DeleteUserCompleteState()}));

    for (var element in getIt<ChatBloc>().state.chatRooms) {
      var clientId = element.buyer.id == LocalStorage().getUserData().id
          ? element.seller.id
          : element.buyer.id;
      Initialization.socketService
          .sendDeleteChatRoomEvent(element.id, clientId);
    }
  }

  _resetPasswordFunction(ResetPasswordEvent event, emit) async {
    emit(const ResetPasswordState());
    await resetPassword(EmailParams(email: event.email)).then((value) {
      value.fold(
          (l) => emit(const ResetPasswordFailedState()),
          (r) => {
                emit(const ResetPasswordCompleteState()),
                SnackbarGlobal.showSnackBar(
                  "Password reset link sent to your email",
                ),
              });
    });
    // bool isSuccess = await _authRepository.resetPassword(email: event.email);
    // if (isSuccess) {
    //   emit(const ResetPasswordCompleteState());
    // } else {
    //   emit(const ResetPasswordFailedState());
    // }
  }

  _updatePasswordFunction(UpdatePasswordEvent event, emit) async {
    emit(const UpdatePasswordState());
    await updatePassword(UpdatePasswordParams(
            password: event.password, newPassword: event.newPassword))
        .then((value) {
      value.fold(
          (l) => emit(const UpdatePasswordFailedState()),
          (r) => {
                if (r == "Password updated successfully")
                  {
                    SnackbarGlobal.showSnackBar(
                      "Password updated successfully",
                    ),
                  },
                emit(const UpdatePasswordCompleteState())
              });
    });
  }

  _otpRequestFunction(RequestOtpEvent event, emit) async {
    emit(const OTPValidationRequestState());
    await otpRequest(EmailParams(email: event.email)).then((value) {
      value.fold(
          (l) => emit(const OTPValidationRequestFailState()),
          (r) => {
                SnackbarGlobal.showSnackBar(
                  "OTP Code Sent Successfully",
                ),
                emit(OTPValidationRequireState(hash: r))
              });
    });
  }

  _tokenValidationFunction(TokenValidationEvent event, emit) async {
    emit(const TokenValidatingState());
    Either<Failure, User> result = await tokenValidation(NoParams());
    result.fold(
        (failure) => {
              emit(const AuthenticationDeny()),
            },
        (user) async => {
              emit(Authorized(user)),
              await initData(user),
            });
  }

  _otpValidationFunction(OtpValidationEvent event, emit) async {
    emit(const OtpValidatingState());
    Either<Failure, User> result = await otpValidation(OtpValidationParams(
        email: event.email, hash: event.otpHash, otpCode: event.otpCode));

    result.fold(
        (l) => emit(OtpValidationFailedState(hash: event.otpHash)),
        (user) async => {
              emit(Authorized(user)),
              await initData(user),
              SnackbarGlobal.showSnackBar(
                "OTP Verified Successfully",
              ),
            });
  }

  _signupFunction(SignUpEvent event, emit) async {
    // try {
    emit(const SignupState());
    Either<Failure, String> result = await signUp(SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
        school: event.school,
        userType: event.userType,
        phoneNumber: event.phoneNumber));

    result.fold(
        (left) => emit(const OTPValidationRequestFailState()),
        (right) => {
              emit(SignupSuccessState(hash: right)),
            });

    //   String hash = await _authRepository.signUpUser(
    //       email: event.email,
    //       password: event.password,
    //       name: event.name,
    //       school: event.school,
    //       userType: event.userType);
    //   if (hash != 'Failed') {
    //     emit(SignupSuccessState(hash: hash));
    //   } else {
    //     emit(const OTPValidationRequestFailState());
    //   }
    // } catch (e) {
    //   emit(const SignupFailedState());
    // }
  }

  _signInFunction(SignInEvent event, emit) async {
    emit(const SigninState());
    Either<Failure, User> msg = await signIn(
        SignInParams(email: event.email, password: event.password));
    msg.fold(
        (l) => {
              emit(const SigninFailedState()),
            },
        (user) async => {
              // if (r == 'Verification required')
              // emit(const UserNotVerifiedState()),

              emit(Authorized(user)),
              await initData(user),
            });
  }

  _logOutFunction(LogoutEvent event, emit) async {
    emit(const LogOutState());
    Either<Failure, bool> result = await signOut(NoParams());
    result.fold(
        (l) => emit(const LogOutFailedState()),
        (r) => {
              Initialization.socketService.disconnect(),
              emit(const LogOutCompleteState()),
            });
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
