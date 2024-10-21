import 'package:uniplanet/features/upload/domain/entities/offer.dart';

abstract class OfferRepository {
  Future<void> postOffer(Offer offer);
}
