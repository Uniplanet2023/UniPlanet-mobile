import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_history/search_history_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_product/search_product_bloc.dart';
import 'package:uniplanet/features/common/presentation/widgets/loader.dart';
import 'package:uniplanet/core/utils/constant/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:uniplanet/features/search/presentation/widget/search_history_list.dart';
import 'package:uniplanet/features/search/presentation/widget/searched_product_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchHistoryBloc>().add(const GetSearchHistoryEvent());
    context.read<SearchProductBloc>().add(
          InitalSearchProductEvent(),
        );
  }

  @override
  void dispose() {
    _searchController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  void navigateToSearchScreen(String query) {
    if (query.isNotEmpty) {
      context
          .read<SearchProductBloc>()
          .add(LoadSearchProductEvent(productName: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    SearchProductState searchState = context.watch<SearchProductBloc>().state;
    SearchHistoryState historyState = context.watch<SearchHistoryBloc>().state;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      controller: _searchController,
                      autofocus: true,
                      autocorrect: false,
                      onFieldSubmitted: (query) =>
                          navigateToSearchScreen(query),
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {
                            context.read<SearchProductBloc>().add(
                                LoadSearchProductEvent(
                                    productName: _searchController.text));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Itmes',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: searchState is LoadedSearchingProductState ||
              searchState is LoadedMoreSearchingProductState ||
              searchState is LoadingMoreSearchingProductState ||
              searchState is EndSearchingProductState
          ? SearchedProductList(
              products: searchState.productList, query: searchState.query)
          : searchState is LoadingSearchingProductState
              ? const Loader()
              : historyState is GotSearchHistoryState ||
                      historyState is RemovedSearchHistoryState ||
                      historyState is ClearedSearchHistoryState ||
                      historyState is RemovingSearchHistoryState ||
                      historyState is ClearingSearchHistoryState
                  ? SearchHistory(recentSearches: historyState.searchHistory)
                  : historyState is GettingSearchHistoryState
                      ? const Loader()
                      : const Text('failed to load history'),
    );
    //   SearchedProductList(
    //   products: searchState.productList,
    //   query: _searchController.text,
    // )
  }
}
