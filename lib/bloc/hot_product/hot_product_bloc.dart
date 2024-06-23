import 'package:equatable/equatable.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/common/functions/notification_scheduling.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/api/repository/product_repository/product_repo.dart';

part 'hot_product_event.dart';
part 'hot_product_state.dart';

class HotProductBloc extends Bloc<HotProductEvent, HotProductState> {
  final ProductRepository _productRepository;
  HotProductBloc(this._productRepository) : super(const HotProductInitial()) {
    on<LoadHotProductsEvent>((event, emit) async {
      await _loadHotProducts(event, emit);
    });
    on<LoadMoreHotProductsEvent>((event, emit) async {
      await _loadMoreHotProducts(event, emit);
    });
  }

  _loadMoreHotProducts(LoadMoreHotProductsEvent event, emit) async {
    emit(LoadingMoreHotProductState(
        hotProducts: state.hotProducts, hotProductPage: state.hotProductPage));
    int nextPage = state.hotProductPage + 1;
    List<Product> result = [];
    try {
      result = await _productRepository.getHotProducts(nextPage: nextPage);
    } catch (e) {
      emit(ErrorHotProductState(message: e.toString()));
    }
    if (result.isEmpty) {
      emit(EndHotProductState(
        hotProducts: state.hotProducts,
        hotProductPage: state.hotProductPage,
      ));

      return;
    }
    state.hotProducts.addAll(result);
    emit(LoadedHotProductState(
        hotProducts: state.hotProducts, hotProductPage: nextPage));
  }

  _loadHotProducts(LoadHotProductsEvent event, emit) async {
    emit(const LoadingHotProductState(
      hotProducts: [],
      hotProductPage: 1,
    ));
    List<Product> result = [];
    try {
      result = await _productRepository.getHotProducts(nextPage: 1);
      if (result.isEmpty) {
        emit(const EndHotProductState(hotProducts: [], hotProductPage: 1));
        return;
      } else {
        notificationScheduling(result, 12);
      }
    } catch (e) {
      emit(ErrorHotProductState(message: e.toString()));
    }

    if (result.isEmpty) {
      emit(EndHotProductState(
          hotProducts: state.hotProducts, hotProductPage: 1));
      return;
    }
    emit(LoadedHotProductState(hotProducts: result, hotProductPage: 1));
  }
}
