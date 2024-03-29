import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        productName: event.productName,
        category: event.category,
        status: event.status,
        description: event.description,
        price: event.price,
        seller: event.seller,
      );

      if (productData != null) {
        emit(ProductUploadedState(productList: state.productList));
        Product? product =
            await _productRepository.uploadImagesAndUpdateProduct(
                images: event.images, productId: productData.id);
        if (product != null) {
          List<Product> productList = state.productList;
          productList.insert(0, product);
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
    List<Product> result =
        await _productRepository.fetchProducts(page: event.page);
    emit(LoadedProductState(productList: result));
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
