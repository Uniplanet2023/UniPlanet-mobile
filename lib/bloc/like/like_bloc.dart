import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// Repositories
import 'package:uniket/network/repository/product_repository/product_repo.dart';
// Models
import 'package:uniket/models/product.dart';
import 'package:uniket/models/user_model.dart';
// Parts of the bloc
part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final ProductRepository _likeRepository;
  LikeBloc(this._likeRepository) : super(const LikeInitial(likeProduct: [])) {
    on<AddLikeEvent>((event, emit) async {
      await _addLike(event, emit);
    });
    on<RemoveLikeEvent>((event, emit) async {
      await _removeLike(event, emit);
    });
    on<LoadLikeEvent>((event, emit) async {
      await _loadLike(event, emit);
    });
  }
  _loadLike(LoadLikeEvent event, emit) async {
    emit(const LikeLoading(likeProduct: []));
    try {
      List<Product> likeProduct = await _likeRepository.getProductLikes();

      emit(LikeLoaded(likeProduct: likeProduct));
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  _addLike(AddLikeEvent event, emit) async {
    emit(LikeAdding(likeProduct: state.likeProduct));
    try {
      bool success = await _likeRepository.likeProduct(
          productId: event.product.id, user: event.user);
      if (success) {
        state.likeProduct.add(event.product);
        emit(LikeAdded(
            likeProduct: state.likeProduct, addedProduct: event.product));
      } else {
        emit(const LikeError(message: "Error liking product"));
        return;
      }
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  _removeLike(RemoveLikeEvent event, emit) async {
    emit(LikeRemoving(likeProduct: state.likeProduct));
    try {
      bool success = await _likeRepository.unlikeProduct(
          productId: event.product.id, user: event.user);
      if (!success) {
        emit(const LikeError(message: "Error unliking product"));
        return;
      }
      state.likeProduct.remove(event.product);
      // Remove like
      emit(LikeRemoved(
          likeProduct: state.likeProduct, removedProduct: event.product));
    } catch (e) {
      emit(LikeError(message: e.toString()));
    }
  }

  @override
  void onChange(Change<LikeState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
}
