part of 'search_product_bloc.dart';

sealed class BaseSearchProductEvent extends Equatable {
  const BaseSearchProductEvent();

  @override
  List<Object> get props => [];
}

class SearchProductEvent extends BaseSearchProductEvent {
  final String productName;
  final int? page;
  const SearchProductEvent({this.page, required this.productName});
  @override
  List<Object> get props => [productName];
}

class InitalSearchProductEvent extends BaseSearchProductEvent {
  @override
  List<Object> get props => [];
}
