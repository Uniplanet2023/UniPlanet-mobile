part of 'advertiser_bloc.dart';

sealed class AdvertiserState extends Equatable {
  final Advertiser advertiser;
  final AdStat adStat;
  final List<UserInteraction> userInteraction;
  final int interactionPage;
  const AdvertiserState({
    required this.advertiser,
    required this.adStat,
    required this.userInteraction,
    this.interactionPage = 1,
  });

  @override
  List<Object> get props => [advertiser];
}

final class AdvertiserInitial extends AdvertiserState {
  const AdvertiserInitial({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });
}

final class GettingAdvertiserInfoState extends AdvertiserState {
  const GettingAdvertiserInfoState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction,
      super.interactionPage});
}

final class GotAdvertiserInfoState extends AdvertiserState {
  const GotAdvertiserInfoState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction,
      super.interactionPage});
}

final class FailedToGetAdvertiserInfoState extends AdvertiserState {
  final String message;
  const FailedToGetAdvertiserInfoState(
      {required this.message,
      required super.advertiser,
      required super.adStat,
      required super.userInteraction,
      super.interactionPage});

  @override
  List<Object> get props => [message];
}

final class GettingAdStatisticState extends AdvertiserState {
  const GettingAdStatisticState(
      {required super.advertiser,
      required super.adStat,
      required super.userInteraction,
      super.interactionPage});
}

final class GotAdStatisticState extends AdvertiserState {
  // final List<AdStatistic> adStatistics;
  const GotAdStatisticState({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });

  @override
  List<Object> get props => [];
}

final class FailedToGetAdStatisticState extends AdvertiserState {
  final String message;
  const FailedToGetAdStatisticState({
    required this.message,
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });

  @override
  List<Object> get props => [message];
}

final class GettingUserInteractionState extends AdvertiserState {
  const GettingUserInteractionState({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });
}

final class GotUserInteractionState extends AdvertiserState {
  const GotUserInteractionState({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });
}

final class FailedToGetUserInteractionState extends AdvertiserState {
  final String message;
  const FailedToGetUserInteractionState({
    required this.message,
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });

  @override
  List<Object> get props => [message];
}

final class GettingMoreUserInteractionState extends AdvertiserState {
  const GettingMoreUserInteractionState({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });
}

final class GotMoreUserInteractionState extends AdvertiserState {
  const GotMoreUserInteractionState({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });
}

final class EndUserInteractionState extends AdvertiserState {
  const EndUserInteractionState({
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });
}

final class FailedToGetMoreUserInteractionState extends AdvertiserState {
  final String message;
  const FailedToGetMoreUserInteractionState({
    required this.message,
    required super.advertiser,
    required super.adStat,
    required super.userInteraction,
    super.interactionPage,
  });

  @override
  List<Object> get props => [message];
}
