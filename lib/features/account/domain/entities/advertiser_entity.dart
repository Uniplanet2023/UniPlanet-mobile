import 'package:uniplanet/features/account/domain/entities/account.dart';

class AdvertiserEntity {
  final AccountEntity account;
  final int maximumPost;
  final int numberOfPost;
  final double costPerClick;
  final double freeCreditUsed;
  final double freeCredit;
  final double credit;
  final double creditUsed;

  const AdvertiserEntity({
    required this.account,
    this.maximumPost = 0,
    this.numberOfPost = 0,
    this.costPerClick = 0.4,
    this.freeCreditUsed = 0,
    this.freeCredit = 0,
    this.credit = 0,
    this.creditUsed = 0,
  });

  // Initial advertiser entity with default values
  static AdvertiserEntity initialAdvertiser() {
    return AdvertiserEntity(
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
}
