import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniket/bloc/search_history/search_history_bloc.dart';
import 'package:uniket/bloc/search_product/search_product_bloc.dart';
import 'package:uniket/common/widgets/loader.dart';
import 'package:uniket/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:uniket/features/search/widget/search_history_list.dart';
import 'package:uniket/features/search/widget/searched_product_list.dart';

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
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search College Market',
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
