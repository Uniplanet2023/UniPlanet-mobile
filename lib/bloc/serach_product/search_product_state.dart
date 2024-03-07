part of 'search_product_bloc.dart';

sealed class SearchProductState extends Equatable {
  final List<Product> productList;
  const SearchProductState({this.productList = const <Product>[]});

  @override
  List<Object> get props => [productList];
}

final class SearchProductInitial extends SearchProductState {
  const SearchProductInitial({super.productList});
}

final class SearchingProductState extends SearchProductState {
  const SearchingProductState({super.productList});
}

final class SearchedProductState extends SearchProductState {
  const SearchedProductState({super.productList});
}
