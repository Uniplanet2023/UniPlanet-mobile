import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/entities/auth_user.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

class TokenValidation implements UseCase<AuthUserEntity, NoParams> {
  final AuthRepository repository;

  TokenValidation(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(NoParams params) async {
    return await repository.tokenValidation(params);
  }
}
