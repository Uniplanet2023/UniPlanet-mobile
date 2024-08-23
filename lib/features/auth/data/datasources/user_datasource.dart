import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/features/auth/domain/entities/auth_user.dart';

abstract class AuthRemoteDataSource {
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  });

  Future<AuthUserEntity> signInUser({
    required String email,
    required String password,
  });

  Future<bool> logOut();

  Future<String> otpRequest({required String email});

  Future<AuthUserEntity> tokenValidation();

  Future<bool> resetPassword({required String email});

  Future<String> updatePassword({
    required String password,
    required String newPassword,
  });

  Future<AuthUserEntity> otpValidation({
    required String email,
    required String hash,
    required String otpCode,
  });

  Future<bool> deleteUser();
}
