part of 'offer_bloc.dart';

sealed class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object> get props => [];
}

class GetOffersEvent extends OfferEvent {
  final int page;
  final int limit;

  const GetOffersEvent({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}

class RemoveOfferEvent extends OfferEvent {
  final String offerId;

  const RemoveOfferEvent({required this.offerId});

  @override
  List<Object> get props => [offerId];
}
