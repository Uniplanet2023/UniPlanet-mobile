import 'package:uniplanet/features/auth/domain/entities/user_type.dart';

abstract class AuthRemoteDataSource {
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  });

  Future<String> signInUser({
    required String email,
    required String password,
  });

  Future<bool> logOut();

  Future<String> otpRequest({required String email});

  Future<bool> tokenValidation();

  Future<bool> resetPassword({required String email});

  Future<String> updatePassword({
    required String password,
    required String newPassword,
  });

  Future<bool> otpValidation({
    required String email,
    required String hash,
    required String otpCode,
  });

  Future<bool> deleteUser();
}
