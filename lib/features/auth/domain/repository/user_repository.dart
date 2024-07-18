// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/auth/domain/entities/user_type.dart';

abstract class AuthRepository {
  static String? userId;
  static String? school;
  static String? email;
  static String? type;

  Future<Either<Failure, String>> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  });

  Future<Either<Failure, String>> signInUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, bool>> logOut();

  Future<Either<Failure, String>> otpRequest({required String email});

  Future<Either<Failure, bool>> tokenValidation();

  Future<Either<Failure, bool>> resetPassword({required String email});

  Future<Either<Failure, String>> updatePassword({
    required String password,
    required String newPassword,
  });

  Future<Either<Failure, bool>> otpValidation({
    required String email,
    required String hash,
    required String otpCode,
  });

  Future<Either<Failure, bool>> deleteUser();
}
