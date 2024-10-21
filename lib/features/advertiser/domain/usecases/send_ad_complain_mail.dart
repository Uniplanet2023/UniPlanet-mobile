// lib/domain/usecases/send_mail_usecase.dart
import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';
import 'package:uniplanet/features/advertiser/domain/repository/mail_repository.dart';

class SendAdComplainMailUseCase {
  final MailRepository mailRepository;

  SendAdComplainMailUseCase(this.mailRepository);

  Future<void> call(AdMailRequest mailRequest) async {
    await mailRepository.sendMail(mailRequest);
  }
}
