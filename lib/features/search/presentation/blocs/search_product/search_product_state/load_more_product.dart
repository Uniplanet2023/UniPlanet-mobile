part of '../search_product_bloc.dart';

final class LoadingMoreSearchingProductState extends SearchProductState {
  const LoadingMoreSearchingProductState(
      {super.productList, super.page, super.query});
}

final class LoadedMoreSearchingProductState extends SearchProductState {
  const LoadedMoreSearchingProductState(
      {super.productList, super.page, super.query});
}

final class EndSearchingProductState extends SearchProductState {
  const EndSearchingProductState({super.productList, super.page, super.query});
}

final class LoadMoreProductErrorState extends SearchProductState {
  final String message;
  const LoadMoreProductErrorState(
      {super.productList, super.page, required this.message, super.query});
}
