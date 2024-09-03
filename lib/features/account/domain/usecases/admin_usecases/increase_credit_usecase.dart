import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/repository/admin_repository.dart';

class IncreaseCreditUsecase
    implements UseCase<AdvertiserEntity, IncreaseCreditParams> {
  final AdminRepository repository;

  IncreaseCreditUsecase(this.repository);

  @override
  Future<Either<Failure, AdvertiserEntity>> call(
      IncreaseCreditParams params) async {
    return await repository.increaseCredit(
      params.advertiserAccountId,
      params.freeCredit,
      params.credit,
    );
  }
}

class IncreaseCreditParams {
  final String advertiserAccountId;
  final double freeCredit;
  final double credit;

  IncreaseCreditParams({
    required this.advertiserAccountId,
    required this.freeCredit,
    required this.credit,
  });
}
