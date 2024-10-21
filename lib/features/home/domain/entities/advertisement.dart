// lib/domain/entities/banner_ad.dart
import 'package:uniplanet/core/entities/user.dart';

class Advertisement {
  final String id;
  final String adName;
  final String school;
  final List<String> images;
  final String type;
  final String? link;
  final String? description;
  final User advertiser;

  final String? location;
  final String? city;
  final String? state;
  final String? address;
  final String? zipCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Advertisement({
    required this.id,
    required this.adName,
    required this.images,
    required this.type,
    required this.school,
    required this.advertiser,
    required this.createdAt,
    required this.updatedAt,
    this.link,
    this.description,
    this.location,
    this.city,
    this.state,
    this.address,
    this.zipCode,
  });
}
