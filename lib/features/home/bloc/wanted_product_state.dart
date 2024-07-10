part of 'wanted_product_bloc.dart';

sealed class WantedProductState extends Equatable {
  const WantedProductState(
      {this.page = 1, this.productList = const <Product>[]});
  final List<Product> productList;
  final int page;

  @override
  List<Object> get props => [productList, page];
}

final class WantedProductInitial extends WantedProductState {}

final class LoadingWantedProductState extends WantedProductState {
  const LoadingWantedProductState({super.productList, super.page});
}

final class LoadingMoreWantedProductState extends WantedProductState {
  const LoadingMoreWantedProductState({super.productList, super.page});
}

final class LoadedWantedProductState extends WantedProductState {
  const LoadedWantedProductState({super.productList, super.page});
}

final class EndedWantedProductState extends WantedProductState {
  const EndedWantedProductState({super.productList, super.page});
}

final class ErrorWantedProductLoadState extends WantedProductState {
  final String errorMessage;
  const ErrorWantedProductLoadState(this.errorMessage,
      {super.productList, super.page});
}
