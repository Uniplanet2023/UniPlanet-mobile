import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/api/repository/product_repository/product_repo.dart';

part 'sold_product_event.dart';
part 'sold_product_state/basic_state.dart';
part 'sold_product_state/load_product_state.dart';
part 'sold_product_state/load_more_product_state.dart';

class SellerSoldProductBloc
    extends Bloc<SellerSoldProductEvent, SellerSoldProductState> {
  final ProductRepository _productRepository;
  SellerSoldProductBloc(this._productRepository)
      : super(const SellerSoldProductInitial(soldProduct: [])) {
    on<LoadSellerSoldProductEvent>((event, emit) async {
      await _loadSellerSoldProduct(event, emit);
    });
    on<LoadMoreSellerSoldProductEvent>((event, emit) async {
      await _loadMoreSellerSoldProduct(event, emit);
    });
  }

  _loadSellerSoldProduct(LoadSellerSoldProductEvent event, emit) async {
    emit(const LoadingSellerSoldProductState(soldProduct: [], soldPage: 1));

    List<Product>? myProducts = await _productRepository.getMyProduct(
        page: state.soldPage, status: 'sold', userId: event.userId);
    if (myProducts == null) {
      emit(ErrorSellerSoldProductState("Error loading sold product",
          soldProduct: state.soldProduct, soldPage: state.soldPage));
      return;
    }
    if (myProducts.isEmpty) {
      emit(EndSellerSoldProductState(
        soldProduct: state.soldProduct,
        soldPage: state.soldPage,
      ));
      return;
    }

    emit(LoadedSellerSoldProductState(
      soldProduct: myProducts,
      soldPage: state.soldPage,
    ));
  }

  _loadMoreSellerSoldProduct(LoadMoreSellerSoldProductEvent event, emit) async {
    emit(LoadingMoreSellerSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: state.soldPage,
    ));
    int nextPage = state.soldPage + 1;
    List<Product>? onSaleProduct = await _productRepository.getMyProduct(
        page: nextPage, status: "sold", userId: event.userId);
    if (onSaleProduct == null) {
      emit(ErrorSellerSoldProductState("Error loading sold product",
          soldProduct: state.soldProduct, soldPage: state.soldPage));
      return;
    }
    if (onSaleProduct.isEmpty) {
      emit(EndSellerSoldProductState(
        soldProduct: state.soldProduct,
        soldPage: state.soldPage,
      ));
      return;
    }
    state.soldProduct.addAll(onSaleProduct);
    emit(LoadedMoreSellerSoldProductState(
      soldProduct: state.soldProduct,
      soldPage: state.soldPage,
    ));
  }
}
