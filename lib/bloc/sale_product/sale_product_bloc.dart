import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/network/repository/product_repository/product_repo.dart';

part 'sale_product_event.dart';
part 'sale_product_state/basic_state.dart';
part 'sale_product_state/load_product_state.dart';
part 'sale_product_state/load_more_product_state.dart';

class OnSaleProductBloc extends Bloc<OnSaleProductEvent, OnSaleProductState> {
  final ProductRepository _productRepository;
  OnSaleProductBloc(this._productRepository)
      : super(const OnSaleProductInitial(onSaleProduct: [], onSalePage: 1)) {
    on<LoadOnSaleProductEvent>((event, emit) async {
      await _loadOnSaleProduct(event, emit);
    });
    on<LoadMoreOnSaleProductEvent>((event, emit) async {
      await _loadMoreOnSaleProduct(event, emit);
    });
    on<DeleteOnSaleProductEvent>((event, emit) async {
      await _deleteOnSaleProduct(event, emit);
    });
    on<AddOnSaleProductEvent>((event, emit) async {
      await _addOnSaleProduct(event, emit);
    });
  }

  _addOnSaleProduct(AddOnSaleProductEvent event, emit) async {
    emit(LoadingOnSaleProductState(
      onSaleProduct: state.onSaleProduct,
      onSalePage: state.onSalePage,
    ));
    List<Product> updatedOnSaleProduct = List<Product>.from(state.onSaleProduct)
      ..insert(0, event.product);

    emit(LoadedOnSaleProductState(
      onSaleProduct: updatedOnSaleProduct,
      onSalePage: state.onSalePage,
    ));
  }

  _deleteOnSaleProduct(DeleteOnSaleProductEvent event, emit) async {
    emit(LoadingOnSaleProductState(
      onSaleProduct: state.onSaleProduct,
      onSalePage: state.onSalePage,
    ));

    state.onSaleProduct.remove(event.product);
    emit(LoadedOnSaleProductState(
      onSaleProduct: state.onSaleProduct,
      onSalePage: state.onSalePage,
    ));
  }

  _loadOnSaleProduct(LoadOnSaleProductEvent event, emit) async {
    emit(const LoadingOnSaleProductState(
      onSaleProduct: [],
      onSalePage: 1,
    ));

    List<Product>? myProducts = await _productRepository.getMyProduct(
        page: state.onSalePage, status: 'on-sale', userId: event.userId);
    if (myProducts == null) {
      emit(ErrorOnSaleProductState(
        "Error loading on sale products",
        onSaleProduct: state.onSaleProduct,
        onSalePage: state.onSalePage,
      ));
      return;
    }
    if (myProducts.isEmpty) {
      emit(EndOnSaleProductState(
        onSaleProduct: state.onSaleProduct,
        onSalePage: state.onSalePage,
      ));
      return;
    }

    emit(LoadedOnSaleProductState(
      onSaleProduct: myProducts,
      onSalePage: state.onSalePage,
    ));
  }

  _loadMoreOnSaleProduct(LoadMoreOnSaleProductEvent event, emit) async {
    emit(LoadedOnSaleProductState(
      onSaleProduct: state.onSaleProduct,
      onSalePage: state.onSalePage,
    ));
    int nextPage = state.onSalePage + 1;
    List<Product>? onSaleProduct = await _productRepository.getMyProduct(
        page: nextPage, status: "on-sale", userId: event.userId);
    if (onSaleProduct == null) {
      emit(ErrorOnSaleProductState(
        "Error loading on sale products",
        onSaleProduct: state.onSaleProduct,
        onSalePage: state.onSalePage,
      ));
      return;
    }
    if (onSaleProduct.isEmpty) {
      emit(EndOnSaleProductState(
        onSaleProduct: state.onSaleProduct,
        onSalePage: state.onSalePage,
      ));
      return;
    }
    state.onSaleProduct.addAll(onSaleProduct);
    emit(LoadedOnSaleProductState(
      onSaleProduct: state.onSaleProduct,
      onSalePage: nextPage,
    ));
  }
}
