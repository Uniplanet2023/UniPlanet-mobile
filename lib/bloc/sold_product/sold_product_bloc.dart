import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/network/repository/product_repository/product_repo.dart';

part 'sold_product_event.dart';
part 'sold_product_state/basic_state.dart';
part 'sold_product_state/load_product_state.dart';
part 'sold_product_state/load_more_product_state.dart';

class SoldProductBloc extends Bloc<SoldProductEvent, SoldProductState> {
  final ProductRepository _productRepository;
  SoldProductBloc(this._productRepository)
      : super(const SoldProductInitial(soldProduct: [])) {
    on<LoadSoldProductEvent>((event, emit) async {
      await _loadSoldProduct(event, emit);
    });
    on<LoadMoreSoldProductEvent>((event, emit) async {
      await _loadMoreSoldProduct(event, emit);
    });
    on<DeleteSoldProductEvent>((event, emit) async {
      await _deleteSoldProduct(event, emit);
    });
    on<AddSoldProductEvent>((event, emit) async {
      await _addSoldProduct(event, emit);
    });
  }
  _addSoldProduct(AddSoldProductEvent event, emit) async {
    emit(LoadingSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: state.soldPage,
    ));
    List<Product> updatedSoldProduct = List<Product>.from(state.soldProduct)
      ..insert(0, event.product);
    emit(LoadedSoldProductState(
      soldProduct: updatedSoldProduct,
      soldPage: state.soldPage,
    ));
  }

  _deleteSoldProduct(DeleteSoldProductEvent event, emit) async {
    emit(LoadingSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: state.soldPage,
    ));
    state.soldProduct.remove(event.product);
    emit(LoadedSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: state.soldPage,
    ));
  }

  _loadSoldProduct(LoadSoldProductEvent event, emit) async {
    emit(const LoadingSoldProductState(soldProduct: [], soldPage: 1));

    List<Product>? myProducts = await _productRepository.getMyProduct(
        page: state.soldPage, status: 'sold', userId: event.userId);
    if (myProducts == null) {
      emit(ErrorSoldProductState("Error loading sold product",
          soldProduct: state.soldProduct, soldPage: state.soldPage));
      return;
    }
    if (myProducts.isEmpty) {
      emit(EndSoldProductState(
        soldProduct: state.soldProduct,
        soldPage: state.soldPage,
      ));
      return;
    }

    emit(LoadedSoldProductState(
      soldProduct: myProducts,
      soldPage: state.soldPage,
    ));
  }

  _loadMoreSoldProduct(LoadMoreSoldProductEvent event, emit) async {
    emit(LoadedSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: state.soldPage,
    ));
    int nextPage = state.soldPage + 1;
    List<Product>? onSaleProduct = await _productRepository.getMyProduct(
        page: nextPage, status: "sold", userId: event.userId);
    if (onSaleProduct == null) {
      emit(ErrorSoldProductState("Error loading sold product",
          soldProduct: state.soldProduct, soldPage: state.soldPage));
      return;
    }
    if (onSaleProduct.isEmpty) {
      emit(EndSoldProductState(
        soldProduct: state.soldProduct,
        soldPage: state.soldPage,
      ));
      return;
    }
    state.soldProduct.addAll(onSaleProduct);
    emit(LoadedSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: nextPage,
    ));
  }
}
