import 'package:uniplanet_mobile/bloc/product/product_state/basic_state.dart';

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
