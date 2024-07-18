import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';

class OtpRequest implements UseCase<String, EmailParams> {
  final AuthRepository repository;

  OtpRequest(this.repository);

  @override
  Future<Either<Failure, String>> call(EmailParams params) async {
    return await repository.otpRequest(email: params.email);
  }
}

class EmailParams {
  final String email;

  EmailParams({required this.email});
}
