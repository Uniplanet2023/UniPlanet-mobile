// lib/data/models/mail_request_model.dart
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';
import 'package:uniplanet/features/advertiser/domain/entities/mail_request.dart';

class MailRequestModel {
  final String title;
  final String description;
  final Advertisement advertisement;

  MailRequestModel({
    required this.title,
    required this.description,
    required this.advertisement,
  });

  factory MailRequestModel.fromEntity(AdMailRequest entity) {
    return MailRequestModel(
      title: entity.title,
      description: entity.description,
      advertisement: entity.advertisement,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'advertisement': advertisement,
    };
  }
}
