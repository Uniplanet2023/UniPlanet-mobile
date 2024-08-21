import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/data/data_sources/remote/account_remote_data_source.dart';
import 'package:uniplanet/features/account/data/models/account_db_model.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/params/update_profile_picture_params.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  const AccountRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AccountDBModel>> getAccountInfo() async {
    try {
      final account = await remoteDataSource.getAccountInfo();
      return right(account);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, AccountDBModel>> updateName(String name) async {
    try {
      final account = await remoteDataSource.updateName(name);
      return right(account);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Either<Failure, AccountDBModel>> updateProfilePicture(
      UpdateProfilePictureParams params) async {
    try {
      final account = await remoteDataSource.updateProfilePicture(params);
      return right(account);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
