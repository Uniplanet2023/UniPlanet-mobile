import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/data/data_sources/account_data_source.dart';
import 'package:uniplanet/features/account/data/models/account_db_model.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/params/update_profile_picture_params.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDataSource remoteDataSource;
  const AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AccountDBModel>> getAccountInfo() async {
    try {
      final account = await remoteDataSource.getAccountInfo();
      return right(account);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AccountDBModel>> updateName(String name) async {
    try {
      final account = await remoteDataSource.updateName(name);
      return right(account);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AccountDBModel>> updateProfilePicture(
      UpdateProfilePictureParams params) async {
    try {
      final account = await remoteDataSource.updateProfilePicture(params);
      return right(account);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } on TimeoutException catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
