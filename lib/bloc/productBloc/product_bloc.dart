import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet_mobile/bloc/productBloc/product-state/basic-state.dart';
import 'package:uniplanet_mobile/bloc/productBloc/product-state/get-product.dart';
import 'package:uniplanet_mobile/bloc/productBloc/product-state/upload-product.dart';
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/repository/product-repository/product-repo.dart';
part 'product_event.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc(this._productRepository) : super(InitProductState()) {
    on<LoadProductEvent>((event, emit) async {
      await _loadProduct(event, emit);
    });
    on<UploadProductEvent>((event, emit) async {
      await _uploadProduct(event, emit);
    });
  }
  _uploadProduct(UploadProductEvent event, emit) async {
    emit(ProductUploadingState(productList: state.productList));
    try {
      Product? productData = await _productRepository.uploadProduct(
          name: event.productName,
          category: event.category,
          status: event.status,
          description: event.description,
          price: event.price);

      if (productData != null) {
        emit(ProductUploadedState(productList: state.productList));
        Product? product =
            await _productRepository.uploadImagesAndUpdateProduct(
                images: event.images, productId: productData.id);
        if (product != null) {
          List<Product> productList = state.productList!;
          productList.add(product);
          emit(ProductImageUploadedState(productList: productList));
        } else {
          emit(const ErrorProductUploadState("Error uploading product"));
        }
      } else {
        emit(const ErrorProductUploadState("Error uploading product"));
      }
    } on Exception catch (e) {
      emit(ErrorProductUploadState(e.toString()));
    }
  }

  _loadProduct(LoadProductEvent event, emit) async {
    emit(LoadingProductState(productList: state.productList));
    List<Product> result = await _productRepository.fetchProducts();

    if (event.category != null) {
      emit(LoadedProductState(
          categoryProductList: result, productList: state.productList));
    } else {
      emit(LoadedProductState(
          productList: result, categoryProductList: state.categoryProductList));
    }
  }

  @override
  void onChange(Change<ProductState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    // print(transition);
  }
}
