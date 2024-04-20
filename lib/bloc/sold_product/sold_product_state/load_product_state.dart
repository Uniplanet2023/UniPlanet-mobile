part of '../sold_product_bloc.dart';

final class LoadingSoldProductState extends SoldProductState {
  const LoadingSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}

final class LoadedSoldProductState extends SoldProductState {
  const LoadedSoldProductState({super.soldProduct, super.soldPage});

  @override
  List<Object> get props => [soldProduct, soldPage];
}
