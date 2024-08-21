import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/params/update_profile_picture_params.dart';

abstract class AccountRepository {
  Future<Either<Failure, AccountEntity>> getAccountInfo();
  Future<Either<Failure, AccountEntity>> updateName(String name);
  Future<Either<Failure, AccountEntity>> updateProfilePicture(
      UpdateProfilePictureParams params);
}
