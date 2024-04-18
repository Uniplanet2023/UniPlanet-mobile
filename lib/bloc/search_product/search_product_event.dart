part of 'search_product_bloc.dart';

sealed class BaseSearchProductEvent extends Equatable {
  const BaseSearchProductEvent();

  @override
  List<Object> get props => [];
}

class LoadSearchProductEvent extends BaseSearchProductEvent {
  final String productName;
  const LoadSearchProductEvent({required this.productName});
  @override
  List<Object> get props => [productName];
}

class LoadMoreSearchProductEvent extends BaseSearchProductEvent {
  final String productName;
  const LoadMoreSearchProductEvent({required this.productName});
  @override
  List<Object> get props => [productName];
}

class InitalSearchProductEvent extends BaseSearchProductEvent {
  @override
  List<Object> get props => [];
}
