import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:uniplanet/features/account/data/models/account_model.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  const AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Account>> getAccountInfo() async {
    try {
      final account = await remoteDataSource.getAccountInfo();
      return right(account);
    } on ServerFailure catch (e) {
      return left(e.message);
    }
  }

  @override
  Future<Either<Failure, Account?>> updateName(String name) {
    // TODO: implement updateName
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Account?>> updateProfilePicture(File image) {
    // TODO: implement updateProfilePicture
    throw UnimplementedError();
  }
}
