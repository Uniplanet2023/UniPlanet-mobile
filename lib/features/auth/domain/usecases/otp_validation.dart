import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/entities/auth_user.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/opt_validation_params.dart';

class OtpValidation implements UseCase<AuthUserEntity, OtpValidationParams> {
  final AuthRepository repository;

  OtpValidation(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity>> call(
      OtpValidationParams params) async {
    return await repository.otpValidation(
      params: params,
    );
  }
}
