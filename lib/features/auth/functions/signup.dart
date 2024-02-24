import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet_mobile/bloc/auth-bloc/auth-bloc.dart';
import 'package:uniplanet_mobile/features/auth/screens/opt_verfiy_screen.dart';

void signUpUser(BuildContext context, email, name, school, validPassword,
    password, isChecked) async {
  final bool emailValid =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.+-]+\.com$").hasMatch(email);

  if (isChecked == false) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Agree to Terms and conditions to continue'),
    ));
    return;
  }

  if (school == null || school == "") {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please select school before continuing!'),
    ));
    return;
  }

  if (!emailValid) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:
          Text('Email format not correct, only school accounts accepted(.edu)'),
    ));
    return;
  }
  if (!validPassword) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password not in a valid format!'),
    ));
    return;
  }

  context.read<AuthBloc>().add(SignUpEvent(
        name,
        email,
        password,
        school!,
      ));
}
