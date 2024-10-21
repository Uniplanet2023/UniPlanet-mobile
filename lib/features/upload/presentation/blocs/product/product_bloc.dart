import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/helper/image_upload_helper.dart';
import 'package:uniplanet/core/utils/check_blocked.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
// Models
import 'package:uniplanet/models/product.dart';
// Repository
import 'package:uniplanet/core/network/repository/product_repository/product_repo.dart';
import 'package:uuid/uuid.dart';
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
    Product product = event.product;
    User user = getIt<AccountBloc>().state.account.user;
    if (event.images != null && event.images!.isNotEmpty) {
      await ImageUploadHelper.instance.uploadImagesAtFirebase(
          images: event.images!,
          path: 'product-images/${user.school}/${product.id}');

      List<String> imageList = ImageUploadHelper.instance.getImagesUrl(
          images: event.images!,
          path: 'product-images/${user.school}/${product.id}');

      product.copyWith(images: imageList);
    }

    // After all uploads, update the product with the collected image URLs
    final updatedProduct = await _productRepository.updateProduct(
      product: product,
    );

    if (updatedProduct == null) {
      return emit(ErrorProductUploadState("Error updating product",
          productList: state.productList, page: state.page));
    }
    // Update the product in the list
    List<Product> productList = state.productList;
    int index =
        productList.indexWhere((element) => element.id == updatedProduct.id);

    if (index != -1) {
      productList[index] = updatedProduct;
    }
    emit(ProductUpdatedState(productList: productList, page: state.page));
  }

  _increaseClickProduct(IncreaseClickProductEvent event, emit) async {
    _productRepository.clickProduct(event.productId);
  }

  _uploadProduct(UploadProductEvent event, emit) async {
    bool isBlocked = checkBlockedAccount(blockType: "Post");
    if (isBlocked) {
      emit(ErrorProductUploadState("Error uploading product",
          productList: state.productList, page: state.page));
      return;
    }
    emit(ProductUploadingState(
        productList: state.productList, page: state.page));
    try {
      var uuid = Uuid(); // Initialize the UUID generator
      String randomId = uuid.v4(); // v4 generates a random UUID
      User user = getIt<AccountBloc>().state.account.user;
      List<String> imageList = ImageUploadHelper.instance.getImagesUrl(
          images: event.images,
          path:
              'product-images/${user.school}/${user.email}/${event.productName}/$randomId');
      // product upload
      Product? productData = await _productRepository.uploadProduct(
        productName: event.productName,
        category: event.category,
        status: event.status,
        description: event.description,
        price: event.price,
        seller: event.seller,
        location: event.location,
        type: event.type,
        isNegotiable: event.isNegotiable,
        stateAddress: event.stateAddress,
        city: event.city,
        address: event.address,
        zipCode: event.zipCode,
        originalPrice: event.originalPrice,
        images: imageList,
      );
      if (productData == null) {
        emit(ErrorProductUploadState("Error uploading product",
            productList: state.productList, page: state.page));
        return;
      }
      emit(ProductUploadedState(
          productList: state.productList, page: state.page));
      // product Image upload
      await ImageUploadHelper.instance.uploadImagesAtFirebase(
          images: event.images,
          path:
              'product-images/${user.school}/${user.email}/${event.productName}/$randomId');
      Product product = productData.copyWith(images: imageList);

      List<Product> productList = state.productList;
      productList.insert(0, product);

      emit(ProductUploadSuccessState(
          productList: productList,
          page: state.page,
          uploadedProduct: product));
    } on Exception catch (e) {
      emit(ErrorProductUploadState(e.toString(),
          productList: state.productList, page: state.page));
    }
  }

  _loadMoreProduct(LoadMoreProductEvent event, emit) async {
    emit(LoadingMoreProductState(
        productList: state.productList, page: state.page));
    int nextPage = state.page + 1;
    List<Product> result = [];
    try {
      result = await _productRepository.fetchProducts(page: nextPage);
    } catch (e) {
      emit(ErrorProductLoadState(e.toString(),
          productList: state.productList, page: state.page));
    }

    List<Product> productList = state.productList;
    if (result.isEmpty) {
      emit(EndedProductState(productList: productList, page: nextPage - 1));
    } else {
      productList.addAll(result);
      emit(LoadedProductState(productList: productList, page: nextPage));
    }
  }

  _loadProduct(LoadProductEvent event, emit) async {
    emit(const LoadingProductState(productList: [], page: 1));
    List<Product> result = await _productRepository.fetchProducts();
    if (result.isEmpty) {
      // result = await IsarService.instance.getProductList();
      emit(ErrorProductLoadState("Error loading product",
          productList: result, page: 1));
      return;
    }
    emit(LoadedProductState(productList: result, page: 1));
  }

  @override
  void onChange(Change<ProductState> change) {
    super.onChange(change);
    // log(change);
  }

  @override
  void onTransition(Transition<ProductEvent, ProductState> transition) {
    super.onTransition(transition);
    // log(transition);
  }
}
