import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/models/Product.dart';

abstract class ProductState extends Equatable {
  final List<Product> productList;
  const ProductState({this.productList = const <Product>[]});

  @override
  List<Object?> get props => [productList];
}

final class InitProductState extends ProductState {
  InitProductState() : super(productList: []);
}

final class ErrorProductState extends ProductState {
  final String errorMessage;
  const ErrorProductState(this.errorMessage);
}
