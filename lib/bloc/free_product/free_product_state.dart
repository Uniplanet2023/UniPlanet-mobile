part of 'free_product_bloc.dart';

sealed class FreeProductState extends Equatable {
  final List<Product> productList;
  final int page;

  const FreeProductState({
    this.productList = const <Product>[],
    this.page = 1,
  });
  @override
  List<Object> get props => [productList, page];
}

final class FreeProductInitial extends FreeProductState {
  const FreeProductInitial()
      : super(
          productList: const <Product>[],
          page: 1,
        );
  @override
  List<Object> get props => [productList, page];
}

final class LoadingFreeProductState extends FreeProductState {
  const LoadingFreeProductState({
    super.productList,
    super.page,
  });
  @override
  List<Object> get props => [productList, page];
}

final class LoadingMoreFreeProductState extends FreeProductState {
  const LoadingMoreFreeProductState({
    super.productList,
    super.page,
  });
  @override
  List<Object> get props => [productList, page];
}

final class LoadedFreeProductState extends FreeProductState {
  const LoadedFreeProductState({
    super.productList,
    super.page,
  });
  @override
  List<Object> get props => [productList, page];
}

final class EndFreeProductState extends FreeProductState {
  const EndFreeProductState({
    super.productList,
    super.page,
  });
  @override
  List<Object> get props => [productList, page];
}

final class ErrorFreeProductState extends FreeProductState {
  final String errorMessage;
  const ErrorFreeProductState(this.errorMessage);
}
