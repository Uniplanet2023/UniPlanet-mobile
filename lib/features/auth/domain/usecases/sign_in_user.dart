import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/entities/auth_user.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/sign_in_params.dart';

class SignInUser implements UseCase<AuthUserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUser(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(SignInParams params) async {
    return await repository.signInUser(params: params);
  }
}
