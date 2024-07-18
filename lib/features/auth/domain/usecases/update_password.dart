// lib/features/auth/domain/usecases/update_password.dart

import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

class UpdatePassword implements UseCase<String, UpdatePasswordParams> {
  final AuthRepository repository;

  UpdatePassword(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdatePasswordParams params) async {
    return await repository.updatePassword(
      password: params.password,
      newPassword: params.newPassword,
    );
  }
}

class UpdatePasswordParams {
  final String password;
  final String newPassword;

  UpdatePasswordParams({
    required this.password,
    required this.newPassword,
  });
}
