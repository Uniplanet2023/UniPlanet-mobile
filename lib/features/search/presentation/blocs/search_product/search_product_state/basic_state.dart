part of '../search_product_bloc.dart';

sealed class SearchProductState extends Equatable {
  final List<Product> productList;
  final int page;
  final String query;
  const SearchProductState(
      {this.productList = const <Product>[], this.page = 1, this.query = ''});

  @override
  List<Object> get props => [productList];
}

final class SearchProductInitial extends SearchProductState {
  const SearchProductInitial({super.productList, super.page, super.query});
}
