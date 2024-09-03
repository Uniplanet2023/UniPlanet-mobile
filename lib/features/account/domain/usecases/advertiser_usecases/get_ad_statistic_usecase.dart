import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/ad_stat_entity.dart';
import 'package:uniplanet/features/account/domain/repository/advertiser_repository.dart';

class GetAdStatisticUsecase implements UseCase<AdStatEntity, NoParams> {
  final AdvertiserRepository repository;

  GetAdStatisticUsecase(this.repository);

  @override
  Future<Either<Failure, AdStatEntity>> call(NoParams params) async {
    return await repository.getAdStatistics();
  }
}
