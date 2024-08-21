import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/models/ad_stat.dart';
import 'package:uniplanet/models/user_interaction.dart';

abstract class AdvertiserRepository {
  //get more user interaction & get ad interactions
  Future<Either<Failure, List<UserInteraction>>> getAdInteraction();

  Future<Either<Failure, AdStat?>> getAdStatistics();
  Future<Either<Failure, AdStat?>> getAdvertiser();
}
