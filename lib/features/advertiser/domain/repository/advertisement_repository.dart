// lib/domain/repositories/advertisement_repository.dart
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';

abstract class AdvertisementRepository {
  // Future<Either<Failure, Advertisement>> getAdvertisement(String advertiserId);
  Future<Either<Failure, List<Advertisement>>> getAdvertisements(
      String advertiserId);
  Future<Either<Failure, void>> editAdvertisement(Advertisement advertisement);
  Future<Either<Failure, void>> removeAdvertisement(String id);
  Future<Either<Failure, void>> cancelSubscription(String advertisementId);
}
