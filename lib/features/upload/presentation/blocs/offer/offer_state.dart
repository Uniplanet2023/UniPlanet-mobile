part of 'offer_bloc.dart';

abstract class OfferState extends Equatable {
  const OfferState();

  @override
  List<Object?> get props => [];
}

class OfferInitial extends OfferState {}

class OfferPostInProgress extends OfferState {}

class OfferPostSuccess extends OfferState {}

class OfferPostFailure extends OfferState {
  final String error;

  const OfferPostFailure(this.error);

  @override
  List<Object?> get props => [error];
}
