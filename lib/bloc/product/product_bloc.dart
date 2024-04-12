import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet_mobile/bloc/index.dart';
// Models
import 'package:uniplanet_mobile/models/product.dart';
import 'package:uniplanet_mobile/models/user_model.dart';
// Repository
import 'package:uniplanet_mobile/network/repository/product_repository/product_repo.dart';
// Parts
part 'product_event.dart';
part 'product_state/basic_state.dart';
part 'product_state/get_product.dart';
part 'product_state/upload_product.dart';
part 'product_state/update_product.dart';
part 'product_state/delete_product.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  ProductBloc(this._productRepository) : super(InitProductState()) {
    on<LoadProductEvent>((event, emit) async {
      await _loadProduct(event, emit);
    });
    on<LoadMoreProductEvent>((event, emit) async {
      await _loadMoreProduct(event, emit);
    });
    on<UploadProductEvent>((event, emit) async {
      await _uploadProduct(event, emit);
    });
    on<IncreaseClickProductEvent>((event, emit) async {
      _increaseClickProduct(event, emit);
    });
    on<UpdateProductEvent>((event, emit) async {
      await _updateProduct(event, emit);
    });
    on<DeleteProductEvent>((event, emit) async {
      await _deleteProduct(event, emit);
    });
  }
  _deleteProduct(DeleteProductEvent event, emit) async {
    emit(
        ProductDeletingState(productList: state.productList, page: state.page));
    String msg =
        await _productRepository.deleteProduct(productId: event.productId);
    if (msg == 'success') {
      List<Product> productList = state.productList;
      productList.removeWhere((element) => element.id == event.productId);
      emit(ProductDeletedState(productList: productList, page: state.page));
    } else {
      emit(ErrorProductUploadState("Error deleting product",
          productList: state.productList, page: state.page));
    }
  }

  _updateProduct(UpdateProductEvent event, emit) async {
    emit(
        ProductUpdatingState(productList: state.productList, page: state.page));
    Product? updatedProduct = await _productRepository.updateProduct(
      productId: event.product.id,
      productName: event.product.name,
      category: event.product.category,
      status: event.product.status,
      description: event.product.description,
      price: event.product.price,
      location: event.product.location,
    );
    if (updatedProduct == null) {
      emit(ErrorProductUploadState("Error updating product",
          productList: state.productList, page: state.page));
    } else {
      List<Product> productList = state.productList;
      int index =
          productList.indexWhere((element) => element.id == updatedProduct.id);
      if (index != -1) {
        productList[index] = updatedProduct;
        emit(ProductUpdatedState(productList: productList, page: state.page));
      } else {
        emit(ErrorProductUploadState("Error updating product",
            productList: state.productList, page: state.page));
      }
    }
  }

  _increaseClickProduct(IncreaseClickProductEvent event, emit) async {
    _productRepository.clickProduct(event.productId);
  }

  _uploadProduct(UploadProductEvent event, emit) async {
    emit(ProductUploadingState(
        productList: state.productList, page: state.page));
    try {
      Product? productData = await _productRepository.uploadProduct(
        productName: event.productName,
        category: event.category,
        status: event.status,
        description: event.description,
        price: event.price,
        seller: event.seller,
        location: event.location,
      );

      if (productData != null) {
        emit(ProductUploadedState(
            productList: state.productList, page: state.page));
        Product? product =
            await _productRepository.uploadImagesAndUpdateProduct(
                images: event.images, productId: productData.id);
        if (product != null) {
          List<Product> productList = state.productList;
          productList.insert(0, product);
          emit(ProductImageUploadedState(productList: productList));
        } else {
          emit(ErrorProductUploadState("Error uploading product",
              productList: state.productList, page: state.page));
        }
      } else {
        emit(ErrorProductUploadState("Error uploading product",
            productList: state.productList, page: state.page));
      }
    } on Exception catch (e) {
      emit(ErrorProductUploadState(e.toString(),
          productList: state.productList, page: state.page));
    }
  }

  _loadMoreProduct(LoadMoreProductEvent event, emit) async {
    emit(LoadingProductState(productList: state.productList, page: state.page));
    int nextPage = state.page + 1;
    List<Product> result =
        await _productRepository.fetchProducts(page: nextPage);
    List<Product> productList = state.productList;
    productList.addAll(result);
    emit(LoadedProductState(productList: productList, page: nextPage));
  }

  _loadProduct(LoadProductEvent event, emit) async {
    emit(LoadingProductState(productList: state.productList, page: 1));
    List<Product> result = await _productRepository.fetchProducts();
    emit(LoadedProductState(productList: result, page: 1));
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
