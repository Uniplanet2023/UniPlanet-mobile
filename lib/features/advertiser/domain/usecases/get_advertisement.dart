// lib/domain/usecases/get_advertisement.dart
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/repository/advertisement_repository.dart';

class GetAdvertisement implements UseCase<List<Advertisement>, Params> {
  final AdvertisementRepository repository;

  GetAdvertisement(this.repository);

  @override
  Future<Either<Failure, List<Advertisement>>> call(Params params) async {
    return await repository.getAdvertisements(params.id);
  }
}

class Params {
  final String id;

  Params({required this.id});
}
