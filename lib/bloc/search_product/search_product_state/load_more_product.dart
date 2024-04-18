part of '../search_product_bloc.dart';

final class LoadingMoreSearchingProductState extends SearchProductState {
  const LoadingMoreSearchingProductState({super.productList});
}

final class LoadedMoreSearchingProductState extends SearchProductState {
  const LoadedMoreSearchingProductState({super.productList});
}

final class LoadMoreProductErrorState extends SearchProductState {
  const LoadMoreProductErrorState({super.productList});
}
