import 'package:flutter/material.dart';

import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';

void optVerification(BuildContext context, email, otpCode) async {
  final authState = getIt<AuthBloc>().state;
  if (authState is OTPValidationRequireState) {
    if (otpCode != null) {
      getIt<AuthBloc>().add(OtpValidationEvent(email, otpCode, authState.hash));
    }
  } else if (authState is SignupSuccessState) {
    if (otpCode != null) {
      getIt<AuthBloc>().add(OtpValidationEvent(email, otpCode, authState.hash));
    }
  } else if (authState is OtpValidationFailedState) {
    if (otpCode != null) {
      getIt<AuthBloc>().add(OtpValidationEvent(email, otpCode, authState.hash));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Hash not found!'),
    ));
  }
}
