import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/params/opt_validation_params.dart';

class OtpValidation implements UseCase<User, OtpValidationParams> {
  final AuthRepository repository;

  OtpValidation(this.repository);

  @override
  Future<Either<Failure, User>> call(OtpValidationParams params) async {
    return await repository.otpValidation(
      params: params,
    );
  }
}
