part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  final List<Product>? productList;
  const ProductState({this.productList});

  @override
  List<Object?> get props => [productList];
}

final class InitProductState extends ProductState {
  InitProductState() : super(productList: []);
}

final class LoadingProductState extends ProductState {
  const LoadingProductState({super.productList});
}

final class LoadedProductState extends ProductState {
  const LoadedProductState({super.productList});
}

final class UploadingProduct extends ProductState {
  const UploadingProduct({super.productList});
}

final class UploadedProduct extends ProductState {
  const UploadedProduct({super.productList});
}

final class ErrorProductState extends ProductState {
  final String errorMessage;
  const ErrorProductState(this.errorMessage);
}
