// lib/data/models/advertisement_model.dart
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/advertiser/domain/entities/advertisement.dart';

class AdvertisementModel extends Advertisement {
  AdvertisementModel({
    required super.id,
    required super.adName,
    required super.school,
    required super.images,
    required super.type,
    required super.advertiser,
    required super.createdAt,
    required super.updatedAt,
    required super.impressions,
    required super.clicks,
    required super.status,
    required super.tier,
    super.link,
    super.description,
    super.location,
    super.city,
    super.state,
    super.address,
    super.zipCode,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json['_id'],
      adName: json['adName'],
      school: json['school'],
      status: json['status'],
      images: List<String>.from(json['images']),
      tier: json['tier'],
      impressions: json['impressions'],
      clicks: json['clicks'],
      type: json['type'],
      advertiser: User.fromMap(json['advertiser']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      link: json['link'],
      description: json['description'],
      location: json['location'],
      city: json['city'],
      state: json['state'],
      address: json['address'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'adName': adName,
      'school': school,
      'images': images,
      'type': type,
      'status': status,
      'impressions': impressions,
      'tier': tier,
      'clicks': clicks,
      'advertiser': advertiser.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'link': link,
      'description': description,
      'location': location,
      'city': city,
      'state': state,
      'address': address,
      'zipCode': zipCode,
    };
  }
}
