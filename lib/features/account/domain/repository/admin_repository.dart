import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<AdvertiserEntity>>> getAdvertiserList();
  Future<Either<Failure, AdvertiserEntity?>> increaseCredit();
  Future<Either<Failure, AdvertiserEntity?>> blockControl();
}
