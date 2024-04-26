import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/models/product.dart';
import 'package:uniplanet/network/repository/product_repository/product_repo.dart';

part 'get_product_event.dart';
part 'get_product_state.dart';

class GetProductBloc extends Bloc<GetProductEvent, GetProductState> {
  final ProductRepository _productRepository;
  GetProductBloc(this._productRepository) : super(const GetProductInitial()) {
    on<GetProductLoadEvent>((event, emit) async {
      await _getProduct(event, emit);
    });
  }
  _getProduct(GetProductLoadEvent event, Emitter<GetProductState> emit) async {
    emit(const GetProductLoading());
    Product? product =
        await _productRepository.getProduct(productId: event.productId);
    if (product == null) {
      emit(const GetProductError(error: 'Error loading product'));
      return;
    }
    emit(GetProductLoaded(product: product));
  }
}
