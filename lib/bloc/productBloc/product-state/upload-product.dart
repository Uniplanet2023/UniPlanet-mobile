import 'package:uniplanet_mobile/bloc/productBloc/product-state/basic-state.dart';

final class ProductUploadingState extends ProductState {
  const ProductUploadingState({super.productList});
}

final class ProductImageUploadedState extends ProductState {
  const ProductImageUploadedState({super.productList});
}

final class ProductUploadedState extends ProductState {
  const ProductUploadedState({super.productList});
}

final class ErrorProductUploadState extends ProductState {
  final String errorMessage;
  const ErrorProductUploadState(this.errorMessage);
}
