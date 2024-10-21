import 'package:dartz/dartz.dart'; // For handling Either
import 'package:uniplanet/core/error/exceptions.dart';
import '../../domain/entities/offer.dart';
import '../../domain/repositories/offer_repository.dart';
import '../data_sources/offer_remote_data_source.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remoteDataSource;

  OfferRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ServerException, List<Offer>>> getOffers(
      int page, int limit) async {
    try {
      // Fetch data from the remote data source
      final offers = await remoteDataSource.getOffers(page, limit);
      // Convert OfferModel to Offer (domain entity) and return it
      return Right(offers.map((offerModel) => offerModel as Offer).toList());
    } catch (error) {
      // If something goes wrong, return a failure
      return const Left(ServerException('Failed to load offers'));
    }
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    try {
      // Delete the offer from the remote data source
      await remoteDataSource.deleteOffer(offerId);
    } catch (error) {
      // If something goes wrong, throw an exception
      throw ServerException('Failed to delete offer');
    }
  }
}
