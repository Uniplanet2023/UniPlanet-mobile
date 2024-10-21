import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';

abstract class QrRemoteDataSource {
  Future<bool> validateQRToken(String token, String offerId);
}

class QrRemoteDataSourceImpl implements QrRemoteDataSource {
  QrRemoteDataSourceImpl();
  @override
  Future<bool> validateQRToken(String token, String offerId) async {
    final response = await DioHelper.instance.dio.post(
      '$productURI/validate-qr',
      data: {'token': token, 'offerId': offerId},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to validate QR token');
    }
  }
}
