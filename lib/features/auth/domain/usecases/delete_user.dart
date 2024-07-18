// lib/features/auth/domain/usecases/delete_user.dart

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

class DeleteUser implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.deleteUser();
  }
}
