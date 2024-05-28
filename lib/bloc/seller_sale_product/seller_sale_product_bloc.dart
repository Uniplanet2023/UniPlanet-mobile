import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/api/repository/product_repository/product_repo.dart';

part 'seller_sale_product_event.dart';
part 'seller_sale_product_state/basic_state.dart';
part 'seller_sale_product_state/load_product_state.dart';
part 'seller_sale_product_state/load_more_product_state.dart';

class SellerSaleProductBloc
    extends Bloc<SellerSaleProductEvent, SellerSaleProductState> {
  final ProductRepository _productRepository;
  SellerSaleProductBloc(this._productRepository)
      : super(const SellerSaleProductInitial(sellerProduct: [], page: 1)) {
    on<LoadSellerSaleProductEvent>((event, emit) async {
      await _loadSellerSaleProduct(event, emit);
    });
    on<LoadMoreSellerSaleProductEvent>((event, emit) async {
      await _loadMoreSellerSaleProduct(event, emit);
    });
  }
  _loadSellerSaleProduct(LoadSellerSaleProductEvent event, emit) async {
    emit(const LoadingSellerSaleProductState(sellerProduct: [], page: 1));
    try {
      final List<Product>? products = await _productRepository.getMyProduct(
          page: state.page, status: 'on-sale', userId: event.userId);
      if (products == null) {
        emit(const ErrorSellerSaleProductState());
        return;
      } else if (products.isEmpty) {
        emit(EndSellerSaleProductState(
            sellerProduct: state.sellerProduct, page: state.page));
        return;
      }
      emit(LoadedSellerSaleProductState(
          sellerProduct: products, page: state.page));
    } catch (e) {
      emit(const ErrorSellerSaleProductState());
    }
  }

  _loadMoreSellerSaleProduct(LoadMoreSellerSaleProductEvent event, emit) async {
    emit(LoadingMoreSellerSaleProductState(
        sellerProduct: state.sellerProduct, page: state.page));
    try {
      int nextPage = state.page + 1;
      final products = await _productRepository.getMyProduct(
          page: nextPage, status: 'on-sale', userId: event.userId);
      if (products == null) {
        emit(const ErrorSellerSaleProductState());
        return;
      } else if (products.isEmpty) {
        emit(EndSellerSaleProductState(
            sellerProduct: state.sellerProduct, page: state.page));
        return;
      }
      state.sellerProduct.addAll(products);
      emit(LoadedMoreSellerSaleProductState(
          sellerProduct: state.sellerProduct, page: nextPage));
    } catch (e) {
      emit(const ErrorSellerSaleProductState());
    }
  }
}
