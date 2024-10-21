// lib/data/repositories/advertisement_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/advertiser/data/data_sources/advertisement_remote_data_source.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/repository/advertisement_repository.dart';

class AdvertisementRepositoryImpl implements AdvertisementRepository {
  final AdvertisementRemoteDataSource remoteDataSource;

  AdvertisementRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<Either<Failure, Advertisement>> getAdvertisement(String id) async {
  //   try {
  //     final result = await remoteDataSource.getAdvertisement(id);
  //     return Right(result);
  //   } catch (e) {
  //     return Left(Failure());
  //   }
  // }

  @override
  Future<Either<Failure, List<Advertisement>>> getAdvertisements(
      String advertiserId) async {
    try {
      final result = await remoteDataSource.getAdvertisements(advertiserId);
      return Right(result);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> editAdvertisement(
      Advertisement advertisement) async {
    try {
      await remoteDataSource.editAdvertisement(advertisement);
      return const Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> removeAdvertisement(String id) async {
    try {
      await remoteDataSource.removeAdvertisement(id);
      return const Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelSubscription(
      String advertisementId) async {
    return await remoteDataSource.cancelSubscription(advertisementId);
  }
}
