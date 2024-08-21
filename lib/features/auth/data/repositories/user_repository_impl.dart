// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/opt_validation_params.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/sign_in_params.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> signUpUser({
    required String email,
    required String password,
    required String name,
    required String school,
    required UserType userType,
    required String phoneNumber,
  }) async {
    try {
      final result = await remoteDataSource.signUpUser(
        name: name,
        email: email,
        password: password,
        school: school,
        userType: userType,
        phoneNumber: phoneNumber,
      );
      if (result == 'Failed') {
        return Left(ServerFailure());
      } else {
        return Right(result);
      }
    } catch (e) {
      log(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInUser(
      {required SignInParams params}) async {
    try {
      final result = await remoteDataSource.signInUser(
        email: params.email,
        password: params.password,
      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      prefsHelper.clear();
      await DioHelper.instance.init();
      final isSuccess = await remoteDataSource.logOut();
      if (isSuccess) {
        return Right(isSuccess);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> otpRequest({required String email}) async {
    try {
      final result = await remoteDataSource.otpRequest(email: email);
      if (result == 'Failed') {
        return Left(ServerFailure());
      } else {
        return Right(result);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> tokenValidation(NoParams params) async {
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      var userRecord = jsonDecode(userData.toString());
      var token = await DioHelper.instance.getSessionToken();
      if (token == null || userRecord == null) {
        final user = await remoteDataSource.tokenValidation();
        return Right(user);
      } else {
        User user = User.fromMap(userRecord);
        return Right(user);
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({required String email}) async {
    try {
      final result = await remoteDataSource.resetPassword(email: email);
      if (result) {
        return Right(result);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> updatePassword({
    required String password,
    required String newPassword,
  }) async {
    try {
      final result = await remoteDataSource.updatePassword(
        password: password,
        newPassword: newPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> otpValidation({
    required OtpValidationParams params,
  }) async {
    try {
      final result = await remoteDataSource.otpValidation(
        email: params.email,
        hash: params.hash,
        otpCode: params.otpCode,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    try {
      final result = await remoteDataSource.deleteUser();
      if (result) {
        return Right(result);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
