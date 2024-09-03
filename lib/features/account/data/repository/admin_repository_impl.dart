import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/data/data_sources/admin_data_source.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/repository/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminDataSource dataSource;
  AdminRepositoryImpl(this.dataSource);
  @override
  Future<Either<Failure, AdvertiserEntity>> blockControl(String accountId,
      bool isPostBlock, bool isChatBlock, bool isBlock) async {
    try {
      final advertiser = await dataSource.blockControl(
          accountId, isPostBlock, isChatBlock, isBlock);
      return right(advertiser.toDomain());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<AdvertiserEntity>>> getAdvertiserList(int page) async {
    try {
      final advertisers = await dataSource.getAdvertiserList(page);
      return Right(advertisers.map((advertiser) => advertiser.toDomain()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, AdvertiserEntity>> increaseCredit(
      String advertiserAccountId, double freeCredit, double credit) async {
    try {
      final advertiser = await dataSource.increaseCredit(
          advertiserAccountId, freeCredit, credit);
      return Right(advertiser.toDomain());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
