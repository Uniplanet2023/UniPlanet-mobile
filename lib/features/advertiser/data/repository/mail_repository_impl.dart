// lib/data/repositories/mail_repository_impl.dart
import 'package:uniplanet/features/advertiser/data/data_sources/mail_remote_data_source.dart';
import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';
import 'package:uniplanet/features/advertiser/domain/repository/mail_repository.dart';

class MailRepositoryImpl implements MailRepository {
  final MailRemoteDataSource remoteDataSource;

  MailRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendMail(AdMailRequest mailRequest) async {
    await remoteDataSource.sendAdComplainMail(mailRequest);
  }
}
