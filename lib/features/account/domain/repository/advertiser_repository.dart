import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/entities/ad_stat_entity.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/entities/user_interaction_entity.dart';

abstract class AdvertiserRepository {
  //get more user interaction & get ad interactions interact with the same data layer function
  Future<Either<Failure, List<UserInteractionEntity>>> getInteraction(
      int? page);

  Future<Either<Failure, AdStatEntity>> getAdStatistics();
  Future<Either<Failure, AdvertiserEntity>> getAdvertiser();
}
