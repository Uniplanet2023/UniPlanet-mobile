part of 'ads_bloc.dart';

abstract class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object> get props => [];
}

class LoadInterstitialAdEvent extends AdsEvent {}

class ShowInterstitialAdEvent extends AdsEvent {}

class LoadBannerAdEvent extends AdsEvent {
  final void Function() setStateCallback;

  const LoadBannerAdEvent(this.setStateCallback);

  @override
  List<Object> get props => [setStateCallback];
}

class LoadNativeAdEvent extends AdsEvent {
  final void Function() setStateCallback;

  const LoadNativeAdEvent(this.setStateCallback);

  @override
  List<Object> get props => [setStateCallback];
}
