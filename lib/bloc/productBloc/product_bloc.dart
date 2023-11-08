import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/product_repo.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:uniplanet_mobile/repository/user_repo.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  final UserRepository _userRepository;
  ProductBloc(this._productRepository, this._userRepository)
      : super(InitProductState()) {
    on<LoadProductEvent>((event, emit) async {
      await _loadProduct(event, emit);
    });
    on<UploadProductEvent>((event, emit) async {
      await _uploadProduct(event, emit);
    });
  }
  _uploadProduct(UploadProductEvent event, emit) async {
    emit(UploadingProduct(productList: state.productList));
    Product product = await _userRepository.uploadProduct(
        context: event.context,
        category: event.category,
        name: event.name,
        forSale: event.forSale,
        description: event.description,
        price: event.price,
        images: event.images);
    state.productList!.add(product);
    emit(UploadedProduct(productList: state.productList));
  }

  _loadProduct(LoadProductEvent event, emit) async {
    emit(LoadingProductState(productList: state.productList));
    List<Product> result = await _productRepository.fetchAllProducts();
    emit(LoadedProductState(productList: result));
  }

  @override
  void onChange(Change<ProductState> change) {
    super.onChange(change);
    // print(change);
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
