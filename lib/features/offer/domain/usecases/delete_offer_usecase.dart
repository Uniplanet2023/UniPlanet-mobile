import '../repositories/offer_repository.dart';

class DeleteOfferUseCase {
  final OfferRepository repository;

  DeleteOfferUseCase(this.repository);

  Future<void> call(String offerId) async {
    return await repository.deleteOffer(offerId);
  }
}
