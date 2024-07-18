part of '../sold_product_bloc.dart';

final class LoadingMoreSoldProductState extends SoldProductState {
  const LoadingMoreSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class LoadedMoreSoldProductState extends SoldProductState {
  const LoadedMoreSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}
