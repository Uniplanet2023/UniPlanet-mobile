part of '../search_history_bloc.dart';

final class ClearingSearchHistoryState extends SearchHistoryState {
  const ClearingSearchHistoryState({required super.searchHistory});
  @override
  List<Object> get props => [searchHistory];
}

final class ClearedSearchHistoryState extends SearchHistoryState {
  const ClearedSearchHistoryState({required super.searchHistory});
  @override
  List<Object> get props => [searchHistory];
}

final class FailedToClearSearchHistoryState extends SearchHistoryState {
  final String message;
  const FailedToClearSearchHistoryState(
      {required this.message, required super.searchHistory});
  @override
  List<Object> get props => [message, searchHistory];
}
