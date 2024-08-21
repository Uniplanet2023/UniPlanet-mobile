import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';

class UpdateProfilePictureUseCase {
  final AccountRepository repository;

  UpdateProfilePictureUseCase(this.repository);

  Future<Either<Failure, AccountEntity>> call(File image, String userId) async {
    return await repository.updateProfilePicture(image, userId);
  }
}
