part of 'admin_bloc.dart';

sealed class AdminState extends Equatable {
  final List<Advertiser> advertiserList;
  final int page;
  const AdminState({required this.advertiserList, required this.page});

  @override
  List<Object> get props => [advertiserList, page];
}

final class AdminInitial extends AdminState {
  const AdminInitial({required super.advertiserList, super.page = 1});
  @override
  List<Object> get props => [advertiserList, page];
}

final class GettingAdvertiserListState extends AdminState {
  const GettingAdvertiserListState(
      {required super.advertiserList, required super.page});
}

final class GotAdvertiserListState extends AdminState {
  const GotAdvertiserListState(
      {required super.advertiserList, required super.page});
  @override
  List<Object> get props => [advertiserList, page];
}

final class FailedToGetAdvertiserListState extends AdminState {
  final String message;
  const FailedToGetAdvertiserListState(
      {required this.message,
      required super.advertiserList,
      required super.page});

  @override
  List<Object> get props => [message, advertiserList];
}

final class GettingMoreAdvertiserListState extends AdminState {
  const GettingMoreAdvertiserListState(
      {required super.advertiserList, required super.page});
  @override
  List<Object> get props => [advertiserList, page];
}

final class GotMoreAdvertiserListState extends AdminState {
  const GotMoreAdvertiserListState(
      {required super.advertiserList, required super.page});
  @override
  List<Object> get props => [advertiserList, page];
}

final class FailedToGetMoreAdvertiserListState extends AdminState {
  final String message;
  const FailedToGetMoreAdvertiserListState(
      {required this.message,
      required super.advertiserList,
      required super.page});

  @override
  List<Object> get props => [message, advertiserList];
}

final class EndAdvertiserListState extends AdminState {
  const EndAdvertiserListState(
      {required super.advertiserList, required super.page});
  @override
  List<Object> get props => [advertiserList, page];
}
