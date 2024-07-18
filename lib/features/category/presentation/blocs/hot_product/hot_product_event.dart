part of 'hot_product_bloc.dart';

sealed class HotProductEvent extends Equatable {
  const HotProductEvent();

  @override
  List<Object> get props => [];
}

class LoadHotProductsEvent extends HotProductEvent {
  const LoadHotProductsEvent();
  @override
  List<Object> get props => [];
}

class LoadMoreHotProductsEvent extends HotProductEvent {
  const LoadMoreHotProductsEvent();
  @override
  List<Object> get props => [];
}
