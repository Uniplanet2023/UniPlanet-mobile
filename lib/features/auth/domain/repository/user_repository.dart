// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/entities/auth_user.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/opt_validation_params.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/sign_in_params.dart';

abstract class AuthRepository {
  static String? userId;

  Future<Either<Failure, String>> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  });

  Future<Either<Failure, AuthUserEntity>> signInUser({
    required SignInParams params,
  });

  Future<Either<Failure, bool>> logOut();

  Future<Either<Failure, String>> otpRequest({required String email});

  Future<Either<Failure, AuthUserEntity>> tokenValidation(NoParams params);

  Future<Either<Failure, bool>> resetPassword({required String email});

  Future<Either<Failure, String>> updatePassword({
    required String password,
    required String newPassword,
  });

  Future<Either<Failure, AuthUserEntity>> otpValidation({
    required OtpValidationParams params,
  });

  Future<Either<Failure, bool>> deleteUser();
}
