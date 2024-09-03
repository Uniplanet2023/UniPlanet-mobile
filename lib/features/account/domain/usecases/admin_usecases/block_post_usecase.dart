import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';
import 'package:uniplanet/features/account/domain/repository/admin_repository.dart';

class BlockPostUsecase implements UseCase<AdvertiserEntity?, BlockPostParams> {
  final AdminRepository repository;

  BlockPostUsecase(this.repository);

  @override
  Future<Either<Failure, AdvertiserEntity>> call(BlockPostParams params) async {
    return await repository.blockControl(
      params.accountId,
      params.isPostBlock,
      params.isChatBlock,
      params.isBlock,
    );
  }
}

class BlockPostParams {
  final String accountId;
  final bool isPostBlock;
  final bool isChatBlock;
  final bool isBlock;

  BlockPostParams({
    required this.accountId,
    required this.isPostBlock,
    required this.isChatBlock,
    required this.isBlock,
  });
}
