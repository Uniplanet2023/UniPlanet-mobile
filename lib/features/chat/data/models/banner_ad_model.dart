// lib/data/models/banner_ad_model.dart
import '../../domain/entities/banner_ad.dart';

class BannerAdModel extends BannerAd {
  BannerAdModel({
    required super.id,
    required super.link,
    required super.image,
    required super.company,
    required super.impressions,
    required super.clicks,
  });

  //from map

  factory BannerAdModel.fromMap(Map<String, dynamic> map) {
    return BannerAdModel(
      id: map['_id'],
      link: map['link'],
      image: map['image'],
      company: map['company'],
      impressions: map['impressions'],
      clicks: map['clicks'],
    );
  }
  factory BannerAdModel.fromJson(Map<String, dynamic> json) {
    return BannerAdModel(
      id: json['_id'],
      link: json['link'],
      image: json['image'],
      company: json['company'],
      impressions: json['impressions'],
      clicks: json['clicks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'link': link,
      'image': image,
      'company': company,
      'impressions': impressions,
      'clicks': clicks,
    };
  }
}
