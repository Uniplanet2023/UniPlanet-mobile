import 'package:uniplanet/features/offer/data/data_sources/qr_remote_data_source.dart';
import 'package:uniplanet/features/offer/domain/repositories/qr_repository.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDataSource remoteDataSource;

  QrRepositoryImpl({required this.remoteDataSource});
  @override
  Future<bool> validateQRToken(String token, String offerId) async {
    try {
      // Validate the QR token using the remote data source
      return remoteDataSource.validateQRToken(token, offerId);
    } catch (error) {
      // If something goes wrong, return false
      return Future.value(false);
    }
  }
}
