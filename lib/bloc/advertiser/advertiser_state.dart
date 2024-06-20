part of 'advertiser_bloc.dart';

sealed class AdvertiserState extends Equatable {
  final Advertiser advertiser;
  final AdStat adStat;
  final List<UserInteraction> userInteraction;
  const AdvertiserState(
      {required this.advertiser,
      required this.adStat,
      required this.userInteraction});

  @override
  List<Object> get props => [advertiser];
}

final class AdvertiserInitial extends AdvertiserState {
  const AdvertiserInitial(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});
}

final class GettingAdvertiserInfoState extends AdvertiserState {
  const GettingAdvertiserInfoState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});
}

final class GotAdvertiserInfoState extends AdvertiserState {
  const GotAdvertiserInfoState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});
}

final class FailedToGetAdvertiserInfoState extends AdvertiserState {
  final String message;
  const FailedToGetAdvertiserInfoState(
      {required this.message,
      required super.advertiser,
      required super.adStat,
      required super.userInteraction});

  @override
  List<Object> get props => [message];
}

final class GettingAdStatisticState extends AdvertiserState {
  const GettingAdStatisticState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});
}

final class GotAdStatisticState extends AdvertiserState {
  // final List<AdStatistic> adStatistics;
  const GotAdStatisticState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});

  @override
  List<Object> get props => [];
}

final class FailedToGetAdStatisticState extends AdvertiserState {
  final String message;
  const FailedToGetAdStatisticState(
      {required this.message,
      required super.advertiser,
      required super.adStat,
      required super.userInteraction});

  @override
  List<Object> get props => [message];
}

final class GettingUserInteractionState extends AdvertiserState {
  const GettingUserInteractionState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});
}

final class GotUserInteractionState extends AdvertiserState {
  const GotUserInteractionState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction});
}

final class FailedToGetUserInteractionState extends AdvertiserState {
  final String message;
  const FailedToGetUserInteractionState(
      {required this.message,
      required super.advertiser,
      required super.adStat,
      required super.userInteraction});

  @override
  List<Object> get props => [message];
}
