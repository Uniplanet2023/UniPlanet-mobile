part of '../search_history_bloc.dart';

final class RemovingSearchHistoryState extends SearchHistoryState {
  const RemovingSearchHistoryState({required super.searchHistory});
}

final class RemovedSearchHistoryState extends SearchHistoryState {
  const RemovedSearchHistoryState({required super.searchHistory});
}

final class FailedToRemoveSearchHistoryState extends SearchHistoryState {
  final String message;
  const FailedToRemoveSearchHistoryState(
      {required this.message, required super.searchHistory});
  @override
  List<Object> get props => [message, searchHistory];
}
