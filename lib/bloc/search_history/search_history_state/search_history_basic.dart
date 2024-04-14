part of '../search_history_bloc.dart';

sealed class SearchHistoryState extends Equatable {
  final List<String> searchHistory;
  const SearchHistoryState({required this.searchHistory});

  @override
  List<Object> get props => [searchHistory];
}

final class SearchHistoryInitial extends SearchHistoryState {
  const SearchHistoryInitial({super.searchHistory = const []});
  @override
  List<Object> get props => [searchHistory];
}
