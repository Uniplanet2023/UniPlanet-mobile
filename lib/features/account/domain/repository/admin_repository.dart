import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<AdvertiserEntity>>> getAdvertiserList(int page);
  Future<Either<Failure, AdvertiserEntity>> increaseCredit(
    String advertiserAccountId,
    double freeCredit,
    double credit,
  );
  Future<Either<Failure, AdvertiserEntity>> blockControl(
    String accountId,
    bool isPostBlock,
    bool isChatBlock,
    bool isBlock,
  );
}
