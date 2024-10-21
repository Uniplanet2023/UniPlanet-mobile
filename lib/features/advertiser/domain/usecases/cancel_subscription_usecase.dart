import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/advertiser/domain/repository/advertisement_repository.dart';

class CancelSubscriptionUseCase {
  final AdvertisementRepository repository;

  CancelSubscriptionUseCase(this.repository);

  Future<Either<Failure, void>> call(String advertisementId) async {
    return await repository.cancelSubscription(advertisementId);
  }
}
