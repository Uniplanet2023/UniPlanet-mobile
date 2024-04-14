part of 'search_history_bloc.dart';

sealed class SearchHistoryEvent extends Equatable {
  const SearchHistoryEvent();

  @override
  List<Object> get props => [];
}

final class GetSearchHistoryEvent extends SearchHistoryEvent {
  final int page;
  const GetSearchHistoryEvent({this.page = 1});
}

final class RemoveSearchHistoryEvent extends SearchHistoryEvent {
  final String query;
  const RemoveSearchHistoryEvent({required this.query});
}

final class ClearSearchHistoryEvent extends SearchHistoryEvent {
  const ClearSearchHistoryEvent();
}
