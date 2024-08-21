import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';
import 'package:uniplanet/features/account/domain/usecases/account_usecases/params/update_profile_picture_params.dart';

class UpdateProfilePictureUseCase
    implements UseCase<AccountEntity, UpdateProfilePictureParams> {
  final AccountRepository repository;

  UpdateProfilePictureUseCase(this.repository);

  @override
  Future<Either<Failure, AccountEntity>> call(
      UpdateProfilePictureParams params) async {
    return await repository.updateProfilePicture(params);
  }
}
