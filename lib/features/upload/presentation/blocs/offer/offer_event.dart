part of 'offer_bloc.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object?> get props => [];
}

class PostOffer extends OfferEvent {
  final Offer offer;

  const PostOffer({required this.offer});

  @override
  List<Object?> get props => [offer];
}
