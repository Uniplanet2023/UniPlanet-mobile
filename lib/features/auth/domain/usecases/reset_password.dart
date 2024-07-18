import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/auth/domain/usecases/request_otp.dart';

class ResetPassword implements UseCase<bool, EmailParams> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<Either<Failure, bool>> call(EmailParams params) async {
    return await repository.resetPassword(email: params.email);
  }
}
