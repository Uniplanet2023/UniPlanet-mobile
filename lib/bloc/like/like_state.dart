part of 'like_bloc.dart';

sealed class LikeState extends Equatable {
  final List<Product> likeProduct;
  final int page;
  const LikeState({this.likeProduct = const [], this.page = 1});

  @override
  List<Object> get props => [likeProduct, page];
}

final class LikeInitial extends LikeState {
  const LikeInitial({required super.likeProduct, required super.page});
  @override
  List<Object> get props => [likeProduct, page];
}

//Like Loading
final class LikeLoading extends LikeState {
  const LikeLoading({required super.likeProduct, required super.page});
  @override
  List<Object> get props => [likeProduct, page];
}

final class LikeLoaded extends LikeState {
  const LikeLoaded({required super.likeProduct, required super.page});
  @override
  List<Object> get props => [likeProduct, page];
}

//Like Adding
final class LikeAdding extends LikeState {
  const LikeAdding({required super.likeProduct});
  @override
  List<Object> get props => [likeProduct];
}

// End Load Like
final class LikeEnd extends LikeState {
  const LikeEnd({required super.likeProduct, required super.page});
  @override
  List<Object> get props => [likeProduct, page];
}

// ignore: must_be_immutable
final class LikeAdded extends LikeState {
  Product? addedProduct;
  LikeAdded({required super.likeProduct, this.addedProduct});
  @override
  List<Object> get props => [likeProduct];
}

// Like Removing
final class LikeRemoving extends LikeState {
  const LikeRemoving({required super.likeProduct});
}

// ignore: must_be_immutable
final class LikeRemoved extends LikeState {
  Product? removedProduct;
  LikeRemoved({required super.likeProduct, this.removedProduct});
}

final class LikeError extends LikeState {
  final String message;
  const LikeError({required this.message});
}
