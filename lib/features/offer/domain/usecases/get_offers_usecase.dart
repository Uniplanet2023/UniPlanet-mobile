import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import 'package:uniplanet/features/offer/domain/repositories/offer_repository.dart';
import '../entities/offer.dart';

class GetOffersUseCase {
  final OfferRepository offerRepository;

  GetOffersUseCase(this.offerRepository);

  Future<Either<ServerException, List<Offer>>> execute(
      int page, int limit) async {
    return await offerRepository.getOffers(page, limit);
  }
}
