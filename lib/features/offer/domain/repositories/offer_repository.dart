import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/exceptions.dart';
import '../entities/offer.dart';

abstract class OfferRepository {
  Future<Either<ServerException, List<Offer>>> getOffers(int page, int limit);
  Future<void> deleteOffer(String offerId);
}
