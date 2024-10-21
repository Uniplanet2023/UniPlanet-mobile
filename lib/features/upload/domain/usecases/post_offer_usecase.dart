import 'package:uniplanet/features/upload/domain/entities/offer.dart';
import 'package:uniplanet/features/upload/domain/repositories/offer_repository.dart';

class PostOfferUseCase {
  final OfferRepository repository;

  PostOfferUseCase(this.repository);
  Future<void> call(Offer offer) async {
    return repository.postOffer(offer);
  }
}
