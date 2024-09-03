import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/repository/advertiser_repository.dart';

class GetAdvertiserInfoUsecase implements UseCase<AdvertiserEntity, NoParams> {
  final AdvertiserRepository repository;

  GetAdvertiserInfoUsecase(this.repository);

  @override
  Future<Either<Failure, AdvertiserEntity>> call(NoParams params) async {
    return await repository.getAdvertiser();
  }
}
