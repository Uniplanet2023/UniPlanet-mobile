import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

class OtpValidation implements UseCase<bool, OtpValidationParams> {
  final AuthRepository repository;

  OtpValidation(this.repository);

  @override
  Future<Either<Failure, bool>> call(OtpValidationParams params) async {
    return await repository.otpValidation(
      email: params.email,
      hash: params.hash,
      otpCode: params.otpCode,
    );
  }
}

class OtpValidationParams {
  final String email;
  final String hash;
  final String otpCode;

  OtpValidationParams({
    required this.email,
    required this.hash,
    required this.otpCode,
  });
}
