import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';

class GetAccountInfoUseCase {
  final AccountRepository repository;

  GetAccountInfoUseCase(this.repository);

  Future<Either<Failure, AccountEntity>> call() async {
    return await repository.getAccountInfo();
  }
}
