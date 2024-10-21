// lib/data/datasources/mail_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:uniplanet/config/api/server_address.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/features/advertiser/data/models/mail_request_model.dart';
import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';

abstract class MailRemoteDataSource {
  Future<void> sendAdComplainMail(AdMailRequest mailRequest);
}

class MailRemoteDataSourceImpl implements MailRemoteDataSource {
  MailRemoteDataSourceImpl();

  @override
  Future<void> sendAdComplainMail(AdMailRequest mailRequest) async {
    final mailRequestModel = MailRequestModel.fromEntity(mailRequest);
    String description = '''
    User Email: ${mailRequestModel.advertisement.advertiser.email}
    User Name: ${mailRequestModel.advertisement.advertiser.name}
    User School: ${mailRequestModel.advertisement.advertiser.school}
    Ad Title: ${mailRequestModel.advertisement.adName}
    Ad Id: ${mailRequestModel.advertisement.id}
    
    \n Description: Ad Complaint: ${mailRequestModel.description}
    ''';
    Response response = await DioHelper.instance.dio.post(
      '$productURI/send-mail',
      data: {
        'title': 'Ad Complaint: ${mailRequestModel.title}',
        'toEmail': 'uniplanet.info@gmail.com',
        'description': description,
        'type': 'ad_complain'
      },
      options: DioHelper.instance.getDioOptions(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send mail');
    }
  }
}
