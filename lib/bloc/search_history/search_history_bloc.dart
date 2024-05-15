import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/network/notification/notification_handler/local_notification.dart';
import 'package:uniplanet/network/repository/account_repository/account_repo.dart';

part 'search_history_event.dart';
part 'search_history_state/search_history_basic.dart';
part 'search_history_state/search_history_get.dart';
part 'search_history_state/search_history_remove.dart';
part 'search_history_state/search_history_clear.dart';

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final AccountRepository _accountRepository;
  SearchHistoryBloc(this._accountRepository)
      : super(const SearchHistoryInitial()) {
    on<GetSearchHistoryEvent>((event, emit) async {
      await _getSearchHistory(event, emit);
    });
    on<RemoveSearchHistoryEvent>((event, emit) async {
      await _removeSearchHistory(event, emit);
    });
    on<ClearSearchHistoryEvent>((event, emit) async {
      await _clearSearchHistory(event, emit);
    });
  }
  _removeSearchHistory(
      RemoveSearchHistoryEvent event, Emitter<SearchHistoryState> emit) async {
    emit(RemovingSearchHistoryState(searchHistory: state.searchHistory));
    try {
      bool isRemoved =
          await _accountRepository.removeSearchHistory(query: event.query);
      if (isRemoved == false) {
        throw Exception('Failed to remove search history');
      }
      List<String> newSearchHistory = List.from(state.searchHistory)
        ..remove(event.query);
      emit(RemovedSearchHistoryState(searchHistory: newSearchHistory));
    } catch (e) {
      emit(FailedToRemoveSearchHistoryState(
          message: e.toString(), searchHistory: state.searchHistory));
    }
  }

  _clearSearchHistory(
      ClearSearchHistoryEvent event, Emitter<SearchHistoryState> emit) async {
    emit(ClearingSearchHistoryState(searchHistory: state.searchHistory));
    try {
      bool isCleared = await _accountRepository.clearSearchHistory();
      if (isCleared == false) {
        throw Exception('Failed to clear search history');
      }
      emit(const ClearedSearchHistoryState(searchHistory: []));
    } catch (e) {
      emit(FailedToClearSearchHistoryState(
          message: e.toString(), searchHistory: state.searchHistory));
    }
  }

  _getSearchHistory(
      GetSearchHistoryEvent event, Emitter<SearchHistoryState> emit) async {
    emit(const GettingSearchHistoryState(searchHistory: []));
    try {
      List<String>? result =
          await _accountRepository.getSearchHistory(page: event.page);
      // Create a new list instead of modifying the existing one
      if (result == null) {
        emit(const FailedToGetSearchHistoryState(
            message: "Fail to Get Search History", searchHistory: []));
        return;
      }

      emit(GotSearchHistoryState(searchHistory: result));
    } catch (e) {
      emit(FailedToGetSearchHistoryState(
          message: e.toString(), searchHistory: const []));
    }
  }
}
