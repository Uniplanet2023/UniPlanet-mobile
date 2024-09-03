import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/repository/admin_repository.dart';

class GetMoreAdvertiserListUsecase
    implements UseCase<List<AdvertiserEntity>, int> {
  final AdminRepository repository;

  GetMoreAdvertiserListUsecase(this.repository);

  @override
  Future<Either<Failure, List<AdvertiserEntity>>> call(int page) async {
    return await repository.getAdvertiserList(page);
  }
}
