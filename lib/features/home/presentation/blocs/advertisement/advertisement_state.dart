part of 'advertisement_bloc.dart';

sealed class AdvertisementState extends Equatable {
  final List<Advertisement> ads;
  const AdvertisementState({this.ads = const []});

  @override
  List<Object> get props => [];
}

final class AdvertisementInitial extends AdvertisementState {
  const AdvertisementInitial();

  @override
  List<Object> get props => [];
}

final class AdvertisementLoading extends AdvertisementState {
  const AdvertisementLoading();

  @override
  List<Object> get props => [];
}

final class AdvertisementLoaded extends AdvertisementState {
  const AdvertisementLoaded({required super.ads});

  @override
  List<Object> get props => [ads];
}

final class AdvertisementError extends AdvertisementState {
  final String message;
  const AdvertisementError(this.message);
}
