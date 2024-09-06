// lib/domain/entities/banner_ad.dart
class BannerAd {
  final String id;
  final String link;
  final String image;
  final String company;
  final int impressions;
  final int clicks;

  BannerAd({
    required this.id,
    required this.link,
    required this.image,
    required this.company,
    required this.impressions,
    required this.clicks,
  });
}
