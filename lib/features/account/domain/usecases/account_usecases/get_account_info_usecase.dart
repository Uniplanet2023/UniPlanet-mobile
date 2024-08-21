import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';

class GetAccountInfoUseCase implements UseCase<AccountEntity, NoParams> {
  final AccountRepository repository;

  GetAccountInfoUseCase(this.repository);

  @override
  Future<Either<Failure, AccountEntity>> call(NoParams params) async {
    return await repository.getAccountInfo();
  }
}
