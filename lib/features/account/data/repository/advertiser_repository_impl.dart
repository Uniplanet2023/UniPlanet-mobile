import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/data/data_sources/advertiser_data_source.dart';
import 'package:uniplanet/features/account/domain/entities/ad_stat_entity.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/entities/user_interaction_entity.dart';
import 'package:uniplanet/features/account/domain/repository/advertiser_repository.dart';

class AdvertiserRepositoryImpl implements AdvertiserRepository {
  final AdvertiserDataSource dataSource;
  const AdvertiserRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<UserInteractionEntity>>> getInteraction(
      int? page) async {
    try {
      final interactions = await dataSource.getInteraction(page);
      return Right(
          interactions.map((interaction) => interaction.toDomain()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AdStatEntity>> getAdStatistics() async {
    try {
      final adStat = await dataSource.getAdStatistics();
      return Right(adStat.toDomain());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AdvertiserEntity>> getAdvertiser() async {
    try {
      final advertiser = await dataSource.getAdvertiser();
      return Right(advertiser.toDomain());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
