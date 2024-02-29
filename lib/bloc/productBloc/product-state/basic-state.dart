import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/product.dart';

abstract class ProductState extends Equatable {
  final List<Product>? productList;
  final List<Product>? categoryProductList;
  const ProductState({this.productList, this.categoryProductList});

  @override
  List<Object?> get props => [productList];
}

final class InitProductState extends ProductState {
  InitProductState() : super(productList: [], categoryProductList: []);
}

final class ErrorProductState extends ProductState {
  final String errorMessage;
  const ErrorProductState(this.errorMessage);
}
