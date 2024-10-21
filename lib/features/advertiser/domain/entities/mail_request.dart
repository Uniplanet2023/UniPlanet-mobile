// src/domain/entities/mailRequest.ts

import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';

class AdMailRequest {
  final String title;
  final String description;
  final Advertisement advertisement;

  AdMailRequest({
    required this.title,
    required this.description,
    required this.advertisement,
  });
}
