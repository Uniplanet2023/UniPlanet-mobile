import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/repository/account_repository.dart';

class UpdateNameUseCase implements UseCase<AccountEntity, String> {
  final AccountRepository repository;

  UpdateNameUseCase(this.repository);

  @override
  Future<Either<Failure, AccountEntity>> call(String name) async {
    return await repository.updateName(name);
  }
}
