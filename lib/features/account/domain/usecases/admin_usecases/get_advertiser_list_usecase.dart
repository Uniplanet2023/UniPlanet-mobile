import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/repository/admin_repository.dart';

class GetAdvertiserListUsecase
    implements UseCase<List<AdvertiserEntity>, int> {
  final AdminRepository repository;

  GetAdvertiserListUsecase(this.repository);

  @override
  Future<Either<Failure, List<AdvertiserEntity>>> call(int page) async {
    return await repository.getAdvertiserList(page);
  }
}
