import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/entities/user_type.dart';

abstract class AuthRemoteDataSource {
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  });

  Future<User> signInUser({
    required String email,
    required String password,
  });

  Future<bool> logOut();

  Future<String> otpRequest({required String email});

  Future<User> tokenValidation();

  Future<bool> resetPassword({required String email});

  Future<String> updatePassword({
    required String password,
    required String newPassword,
  });

  Future<User> otpValidation({
    required String email,
    required String hash,
    required String otpCode,
  });

  Future<bool> deleteUser();
}
