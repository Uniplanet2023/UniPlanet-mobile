import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/auth/auth_bloc.dart';

void signUpUser(BuildContext context, email, name, school, validPassword,
    password, isChecked) async {
  final bool emailValid = email.endsWith('.edu');

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
      content: Text(
          'You\'re Sign Up With Visitor, Please Contact with UniPlanet! https://uniplanet.shop/pages/contact-us'),
    ));
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
