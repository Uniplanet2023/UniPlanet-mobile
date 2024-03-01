import 'package:uniplanet_mobile/bloc/product/product-state/basic-state.dart';

final class LoadingProductState extends ProductState {
  const LoadingProductState({super.productList});
}

final class LoadedProductState extends ProductState {
  const LoadedProductState({super.productList});
}

final class ErrorProductLoadState extends ProductState {
  final String errorMessage;
  const ErrorProductLoadState(this.errorMessage);
}
