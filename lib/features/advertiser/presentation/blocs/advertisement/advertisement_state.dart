// lib/presentation/blocs/advertisement_state.dart
part of 'advertisement_bloc.dart';

abstract class MyAdvertisementState extends Equatable {
  final List<Advertisement> advertisements;

  const MyAdvertisementState({required this.advertisements});

  @override
  List<Object> get props => [advertisements];
}

class AdvertisementInitial extends MyAdvertisementState {
  AdvertisementInitial() : super(advertisements: []);

  @override
  List<Object> get props => [];
}

class LoadingAdvertisementState extends MyAdvertisementState {
  const LoadingAdvertisementState({required super.advertisements});
}

class LoadedAdvertisementState extends MyAdvertisementState {
  const LoadedAdvertisementState({required super.advertisements});
}

class AdvertisementEditedState extends MyAdvertisementState {
  const AdvertisementEditedState({required super.advertisements});
}

class AdvertisementRemovedState extends MyAdvertisementState {
  const AdvertisementRemovedState({required super.advertisements});
}

class AdvertisementCanceling extends MyAdvertisementState {
  const AdvertisementCanceling({required super.advertisements});
}

class AdvertisementCancelled extends MyAdvertisementState {
  const AdvertisementCancelled({required super.advertisements});
}

class ErrorAdvertisementState extends MyAdvertisementState {
  final String message;

  const ErrorAdvertisementState({
    required this.message,
    required super.advertisements,
  });

  @override
  List<Object> get props => [advertisements, message];
}
