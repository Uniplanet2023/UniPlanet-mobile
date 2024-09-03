import 'dart:convert';

import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/features/account/domain/entities/advertiser_entity.dart';

class AdvertiserModel {
  AccountEntity account;
  int maximumPost;
  int numberOfPost;
  double costPerClick;
  double freeCreditUsed;
  double freeCredit;
  double credit;
  double creditUsed;

  AdvertiserModel({
    required this.account,
    this.maximumPost = 0,
    this.numberOfPost = 0,
    this.costPerClick = 0.4,
    this.freeCreditUsed = 0,
    this.freeCredit = 0,
    this.credit = 0,
    this.creditUsed = 0,
  });

  static initialAdvertiser() {
    return AdvertiserModel(
      account: AccountEntity.initialAccount(),
      maximumPost: 0,
      numberOfPost: 0,
      costPerClick: 0.4,
      freeCreditUsed: 0,
      freeCredit: 0,
      credit: 0,
      creditUsed: 0,
    );
  }

  // Convert from domain model to data model
  factory AdvertiserModel.fromDomain(AdvertiserEntity advertiserEntity) {
    return AdvertiserModel(
      account: advertiserEntity.account,
      maximumPost: advertiserEntity.maximumPost,
      numberOfPost: advertiserEntity.numberOfPost,
      costPerClick: advertiserEntity.costPerClick,
      freeCreditUsed: advertiserEntity.freeCreditUsed,
      freeCredit: advertiserEntity.freeCredit,
      credit: advertiserEntity.credit,
      creditUsed: advertiserEntity.creditUsed,
    );
  }

  // Convert from data model to domain model
  AdvertiserEntity toDomain() {
    return AdvertiserEntity(
      account: account,
      maximumPost: maximumPost,
      numberOfPost: numberOfPost,
      costPerClick: costPerClick,
      freeCreditUsed: freeCreditUsed,
      freeCredit: freeCredit,
      credit: credit,
      creditUsed: creditUsed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account': account.toMap(),
      'maximumPost': maximumPost,
      'numberOfPost': numberOfPost,
      'costPerClick': costPerClick,
      'freeCreditUsed': freeCreditUsed,
      'freeCredit': freeCredit,
      'credit': credit,
      'creditUsed': creditUsed,
    };
  }

  factory AdvertiserModel.fromMap(Map<String, dynamic> map) {
    return AdvertiserModel(
      account: AccountEntity.fromMap(map),
      maximumPost: map['maximumPost'] as int,
      numberOfPost: map['numberOfPost'] as int,
      costPerClick: (map['costPerClick'] as num).toDouble(),
      freeCreditUsed: (map['freeCreditUsed'] as num).toDouble(),
      freeCredit: (map['freeCredit'] as num).toDouble(),
      credit: (map['credit'] as num).toDouble(),
      creditUsed: (map['creditUsed'] as num).toDouble(),
    );
  }

  factory AdvertiserModel.fromJson(String source) =>
      AdvertiserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
