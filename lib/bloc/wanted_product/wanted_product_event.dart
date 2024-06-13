part of 'wanted_product_bloc.dart';

sealed class WantedProductEvent extends Equatable {
  const WantedProductEvent();
}

class LoadWantedProductEvent extends WantedProductEvent {
  const LoadWantedProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadMoreWantedProductEvent extends WantedProductEvent {
  const LoadMoreWantedProductEvent();
  @override
  List<Object?> get props => [];
}
