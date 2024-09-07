// lib/data/models/banner_ad_model.dart
import '../../domain/entities/banner_ad.dart';

class BannerAdModel extends BannerAd {
  BannerAdModel({
    required super.id,
    required super.link,
    required super.image,
  });

  //from map

  factory BannerAdModel.fromMap(Map<String, dynamic> map) {
    return BannerAdModel(
      id: map['_id'],
      link: map['link'],
      image: map['images'][0],
    );
  }
  factory BannerAdModel.fromJson(Map<String, dynamic> json) {
    return BannerAdModel(
      id: json['_id'],
      link: json['link'],
      image: json['images'][0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'link': link,
      'image': image,
    };
  }
}
