// lib/data/models/banner_ad_model.dart
import 'package:uniplanet/core/entities/user.dart';

import '../../domain/entities/advertisement.dart';

class AdModel extends Advertisement {
  AdModel({
    required super.id,
    required super.images,
    required super.adName,
    required super.school,
    required super.type,
    required super.advertiser,
    required super.createdAt,
    required super.updatedAt,
    super.link,
    super.description,
    super.location,
    super.city,
    super.state,
    super.address,
    super.zipCode,
  });

  //from map

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['_id'],
      link: map['link'],
      images: List<String>.from(map['images'] ?? []), // Convert to List<String>
      advertiser: User.fromMap(map['advertiser']),
      adName: map['adName'],
      school: map['school'],
      type: map['type'],
      description: map['description'],
      location: map['location'],
      city: map['city'],
      state: map['state'],
      address: map['address'],
      zipCode: map['zipCode'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: DateTime.parse(map['updatedAt']).toLocal(),
    );
  }
  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['_id'],
      link: json['link'],
      images: List<String>.from(json['images'] ?? []),
      advertiser: User.fromMap(json['advertiser']),
      adName: json['adName'],
      school: json['school'],
      type: json['type'],
      description: json['description'],
      location: json['location'],
      city: json['city'],
      state: json['state'],
      address: json['address'],
      zipCode: json['zipCode'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'link': link,
      'images': images,
      'adName': adName,
      'advertiser': advertiser.toJson(),
      'school': school,
      'type': type,
      'description': description,
      'location': location,
      'city': city,
      'state': state,
      'address': address,
      'zipCode': zipCode,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }
}
