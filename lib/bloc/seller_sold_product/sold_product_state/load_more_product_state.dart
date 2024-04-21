part of '../sold_product_bloc.dart';

final class LoadingMoreSellerSoldProductState extends SellerSoldProductState {
  const LoadingMoreSellerSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class LoadedMoreSellerSoldProductState extends SellerSoldProductState {
  const LoadedMoreSellerSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}
