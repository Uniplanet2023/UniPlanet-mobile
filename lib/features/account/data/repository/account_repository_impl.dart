import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  const AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AccountEntity>> getAccountInfo() async {
    try {
      final account = await remoteDataSource.getAccountInfo();
      return right(account);
    } on ServerFailure catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> updateName(String name) async {
    try {
      final account = await remoteDataSource.updateName(name);
      return right(account);
    } on ServerFailure catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Failure, AccountEntity>> updateProfilePicture(
      File image, String userId) async {
    try {
      final account =
          await remoteDataSource.updateProfilePicture(image, userId);
      return right(account);
    } on ServerFailure catch (e) {
      return left(e);
    }
  }
}
