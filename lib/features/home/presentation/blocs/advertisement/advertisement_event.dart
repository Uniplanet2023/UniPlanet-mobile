part of 'advertisement_bloc.dart';

sealed class AdvertisementEvent extends Equatable {
  const AdvertisementEvent();

  @override
  List<Object> get props => [];
}

final class GetAdvertisementEvent extends AdvertisementEvent {
  final String type;
  const GetAdvertisementEvent({required this.type});
}
