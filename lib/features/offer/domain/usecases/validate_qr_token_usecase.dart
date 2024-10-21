import 'package:uniplanet/features/offer/domain/repositories/qr_repository.dart';

class ValidateQRTokenUseCase {
  final QrRepository repository;

  ValidateQRTokenUseCase(this.repository);

  Future<bool> call({required String token, required String offerId}) async {
    return await repository.validateQRToken(token, offerId);
  }
}
