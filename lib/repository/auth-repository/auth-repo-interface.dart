import 'package:flutter/material.dart';

abstract class IAuthRepository {
  Future<String?> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
  });

  Future<bool> tokenValidation();

  Future<bool> signInUser({
    required String email,
    required String password,
  });

  Future<String> sendOtp({
    required BuildContext context,
    required String email,
  });

  Future<void> forgottenPassword({
    required BuildContext context,
    required String email,
  });

  Future<bool> otpValidation(String email, String hash, String otpCode);

  Future<String> logOut();
}
