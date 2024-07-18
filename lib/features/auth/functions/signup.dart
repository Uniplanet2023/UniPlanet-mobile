import 'package:flutter/material.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/auth/domain/entities/user_type.dart';
import 'package:uniplanet/features/auth/domain/usecases/sign_up_user.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';

void signUpUser(BuildContext context, email, name, school, validPassword,
    password, phoneNumber, isChecked, UserType userType) async {
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

  if (!validPassword) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password not in a valid format!'),
    ));
    return;
  }

  getIt<AuthBloc>().add(SignUpEvent(
    name,
    email,
    password,
    school!,
    userType,
    phoneNumber,
  ));
}

void studentSignUpUser(
    BuildContext context,
    String email,
    String name,
    String? school,
    bool validPassword,
    String password,
    String phoneNumber,
    bool isChecked,
    UserType userType) async {
  // Check if the user agreed to the terms and conditions
  if (!isChecked) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Agree to Terms and conditions to continue'),
    ));
    return;
  }

  // Check if the school is selected
  if (school == null || school.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please select school before continuing!'),
    ));
    return;
  }

  // Check if the password is valid
  if (!validPassword) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Password not in a valid format!'),
    ));
    return;
  }

  // Check if the email is a .edu email
  if (!email.endsWith('.edu')) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please use a .edu email address!'),
    ));
    return;
  }

  // Proceed with the sign-up event
  getIt<AuthBloc>().add(SignUpEvent(
    name,
    email,
    password,
    school,
    userType,
    phoneNumber,
  ));
}
