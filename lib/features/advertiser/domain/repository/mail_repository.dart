// src/domain/repositories/mail_repository.dart

import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';

abstract class MailRepository {
  Future<void> sendMail(AdMailRequest mailRequest);
}
