import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_history/search_history_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_product/search_product_bloc.dart';

class SearchHistory extends StatefulWidget {
  final List<String> recentSearches;
  const SearchHistory({
    super.key,
    required this.recentSearches,
  });

  @override
  SearchHistoryList createState() => SearchHistoryList();
}

class SearchHistoryList extends State<SearchHistory> {
  void _deleteSearch(String search, int index) {
    context
        .read<SearchHistoryBloc>()
        .add(RemoveSearchHistoryEvent(query: search));
  }

  void _deleteAllSearches() {
    getIt<SearchHistoryBloc>().add(const ClearSearchHistoryEvent());
    setState(() {
      widget.recentSearches.clear();
    });
  }

  void navigateToSearchScreen(String query) {
    if (query.isNotEmpty) {
      getIt<SearchProductBloc>()
          .add(LoadSearchProductEvent(productName: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 25, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches',
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  )),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteAllSearches,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.recentSearches.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () =>
                    (navigateToSearchScreen(widget.recentSearches[index])),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(widget.recentSearches[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        _deleteSearch(widget.recentSearches[index], index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
