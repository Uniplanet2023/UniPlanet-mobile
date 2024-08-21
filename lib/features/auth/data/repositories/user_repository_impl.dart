// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/core/helper/shared_preferences_helper.dart';
import 'package:uniplanet/core/entities/user_type.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/auth/data/datasources/user_datasource.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

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
        return Left(Failure(result));
      } else {
        return Right(result);
      }
    } catch (e) {
      log(e);
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.signInUser(
        email: email,
        password: password,
      );

      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
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
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> otpRequest({required String email}) async {
    try {
      final result = await remoteDataSource.otpRequest(email: email);
      if (result == 'Failed') {
        return Left(Failure(result));
      } else {
        return Right(result);
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> tokenValidation() async {
    try {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      var userData = prefsHelper.getString('userData');
      var userRecord = jsonDecode(userData.toString());
      var token = await DioHelper.instance.getSessionToken();
      if (token == null || userRecord == null) {
        final result = await remoteDataSource.tokenValidation();
        return Right(result);
      } else {
        var userInfo = jsonDecode(userData!);
        AuthRepository.userId = userInfo['id'];
        AuthRepository.school = userInfo['school'];
        AuthRepository.email = userInfo['email'];
        AuthRepository.type = userInfo['type'];
        return const Right(true);
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({required String email}) async {
    try {
      final result = await remoteDataSource.resetPassword(email: email);
      if (result) {
        return Right(result);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
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
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> otpValidation({
    required String email,
    required String hash,
    required String otpCode,
  }) async {
    try {
      final result = await remoteDataSource.otpValidation(
        email: email,
        hash: hash,
        otpCode: otpCode,
      );
      if (result) {
        return Right(result);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser() async {
    try {
      final result = await remoteDataSource.deleteUser();
      if (result) {
        return Right(result);
      } else {
        return Left(Failure());
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
