part of '../search_history_bloc.dart';

final class GettingSearchHistoryState extends SearchHistoryState {
  const GettingSearchHistoryState({required super.searchHistory});
  @override
  List<Object> get props => [searchHistory];
}

final class GotSearchHistoryState extends SearchHistoryState {
  const GotSearchHistoryState({required super.searchHistory});
  @override
  List<Object> get props => [searchHistory];
}

final class FailedToGetSearchHistoryState extends SearchHistoryState {
  final String message;
  const FailedToGetSearchHistoryState(
      {required this.message, required super.searchHistory});
  @override
  List<Object> get props => [message, searchHistory];
}
