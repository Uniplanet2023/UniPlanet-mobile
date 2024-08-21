import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/models/advertiser.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<Advertiser>>> getAdvertiserList();
  Future<Either<Failure, Advertiser?>> increaseCredit();
  Future<Either<Failure, Advertiser?>> blockControl();
}
