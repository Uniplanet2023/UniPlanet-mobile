import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-bloc.dart';

void optVerification(BuildContext context, email, otpCode) async {
  final authState = context.read<AuthBloc>().state;
  if (authState is OTPValidationRequireState) {
    if (otpCode != null) {
      context
          .read<AuthBloc>()
          .add(OtpValidationEvent(email, otpCode, authState.hash!));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Hash not found!'),
    ));
  }
}
