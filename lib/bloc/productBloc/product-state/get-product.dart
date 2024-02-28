import 'package:uniplanet_mobile/bloc/productBloc/product-state/basic-state.dart';

final class LoadingProductState extends ProductState {
  const LoadingProductState({super.productList, super.categoryProductList});
}

final class LoadedProductState extends ProductState {
  const LoadedProductState({super.productList, super.categoryProductList});
}

final class ErrorProductLoadState extends ProductState {
  final String errorMessage;
  const ErrorProductLoadState(this.errorMessage);
}
