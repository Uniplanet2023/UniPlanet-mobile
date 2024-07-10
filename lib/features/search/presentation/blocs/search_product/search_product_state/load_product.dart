part of '../search_product_bloc.dart';

final class LoadingSearchingProductState extends SearchProductState {
  const LoadingSearchingProductState(
      {super.productList, super.page, super.query});
}

final class LoadedSearchingProductState extends SearchProductState {
  const LoadedSearchingProductState(
      {super.productList, super.page, super.query});
}
