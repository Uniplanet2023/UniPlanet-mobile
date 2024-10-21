import 'package:uniplanet/features/upload/data/data_sources/offer_remote_data_source.dart';
import 'package:uniplanet/features/upload/data/models/offer_post_model.dart';
import 'package:uniplanet/features/upload/domain/entities/offer.dart';
import 'package:uniplanet/features/upload/domain/repositories/offer_repository.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remoteDataSource;

  OfferRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> postOffer(Offer offer) async {
    final offerDTO = OfferModel.fromDomain(offer);
    return await remoteDataSource.postOffer(offerDTO);
  }
}
