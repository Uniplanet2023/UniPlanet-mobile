part of 'offer_bloc.dart';

sealed class OfferState extends Equatable {
  const OfferState();

  @override
  List<Object> get props => [];
}

final class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class OfferLoaded extends OfferState {
  final List<Offer> offers;

  const OfferLoaded({required this.offers});
}

class OfferError extends OfferState {
  final String message;

  const OfferError({required this.message});
}
