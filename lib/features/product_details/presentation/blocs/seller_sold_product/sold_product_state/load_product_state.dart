part of '../sold_product_bloc.dart';

final class LoadingSellerSoldProductState extends SellerSoldProductState {
  const LoadingSellerSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class LoadedSellerSoldProductState extends SellerSoldProductState {
  const LoadedSellerSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}
