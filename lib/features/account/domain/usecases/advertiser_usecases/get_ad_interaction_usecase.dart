import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/core/usecases/usecase.dart';
import 'package:uniplanet/features/account/domain/entities/user_interaction_entity.dart';
import 'package:uniplanet/features/account/domain/repository/advertiser_repository.dart';

class GetAdInteractionUsecase
    implements UseCase<List<UserInteractionEntity>, int> {
  final AdvertiserRepository repository;

  GetAdInteractionUsecase(this.repository);

  @override
  Future<Either<Failure, List<UserInteractionEntity>>> call(int page) async {
    return await repository.getInteraction(page);
  }
}
