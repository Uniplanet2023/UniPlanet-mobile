// lib/domain/usecases/remove_advertisement.dart
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/advertiser/domain/repository/advertisement_repository.dart';
import 'package:uniplanet/features/advertiser/domain/usecases/get_advertisement.dart';

class RemoveAdvertisement implements UseCase<void, Params> {
  final AdvertisementRepository repository;

  RemoveAdvertisement(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.removeAdvertisement(params.id);
  }
}
