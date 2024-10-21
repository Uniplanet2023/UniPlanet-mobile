// lib/presentation/blocs/advertisement_event.dart
part of 'advertisement_bloc.dart';

abstract class AdvertisementEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAdvertisementEvent extends AdvertisementEvent {
  final String id;

  GetAdvertisementEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class EditAdvertisementEvent extends AdvertisementEvent {
  final Advertisement advertisement;

  EditAdvertisementEvent({required this.advertisement});

  @override
  List<Object> get props => [advertisement];
}

class RemoveAdvertisementEvent extends AdvertisementEvent {
  final String id;

  RemoveAdvertisementEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class CancelSubscriptionEvent extends AdvertisementEvent {
  final String advertisementId;

  CancelSubscriptionEvent({required this.advertisementId});

  @override
  List<Object> get props => [advertisementId];
}
